---
description: >-
  The channel acceptor API allows you to enforce custom logic on whether an
  incoming channel should be accepted or not.
---

# Channel acceptor

LND’s channel acceptor is a mechanism which you can use to define custom logic with regard to whether an incoming channel should be accepted or not.

This may be useful when restricting channel opens from nodes that meet certain criteria. For example, some nodes may want to restrict channel opens to a desired list of nodes or a specifically defined size. It can also be used to accept channels with a remote channel reserve of zero or to accept zero-confirmation channels.

The channel acceptor is used in Pool to ensure that channels opened through the marketplace have the desired attributes.

[API documentation: Channel acceptor](https://lightning.engineering/api-docs/api/lnd/lightning/channel-acceptor)

In principle, the channel acceptor is relatively simple and does not need to be specifically enabled. When the API endpoints are called (either RPC or REST), a bi-directional channel between LND and the client is established, through which all incoming channel requests are sent.

The client can then respond with either TRUE or FALSE regarding whether the channel should be accepted or not. They can also send a 500 character custom error message to the initiator to inform them about why the channel was denied.

When using the channel acceptor to accept zero-confirmation channels, please note that both the initiator and the respondent must have the following set in their lnd.conf:

`protocol.option-scid-alias=true`\
`protocol.zero-conf=true`

## Code examples:

### Pool:

{% embed url="https://github.com/lightninglabs/pool/blob/master/channel_acceptor.go#L115" %}
How the channel acceptor is used in Pool
{% endembed %}

```go
// acceptChannel is the callback that is invoked each time a new incoming
// channel message is received in lnd. We inspect it here and if it corresponds
// to a pending channel ID that we have an expectation for, we check whether the
// self chan balance (=push amount) is correct.
func (s *ChannelAcceptor) acceptChannel(_ context.Context,
	req *lndclient.AcceptorRequest) (*lndclient.AcceptorResponse, error) {

	s.expectedChansMtx.Lock()
	defer s.expectedChansMtx.Unlock()

	expectedChanBid, ok := s.expectedChans[req.PendingChanID]

	// It's not a channel we've registered within the funding manager so we
	// just accept it to not interfere with the normal node operation.
	if !ok {
		return &lndclient.AcceptorResponse{Accept: true}, nil
	}

	// The push amount in the acceptor request is in milli sats, we need to
	// convert it first.
	pushAmtSat := lnwire.MilliSatoshi(req.PushAmt).ToSatoshis()

	// Push amount must be exactly what we expect. Otherwise the asker could
	// be trying to cheat.
	if expectedChanBid.SelfChanBalance != pushAmtSat {
		return &lndclient.AcceptorResponse{
			Accept: false,
			Error: fmt.Sprintf("invalid push amount %v",
				req.PushAmt),
		}, nil
	}

	switch expectedChanBid.ChannelType {
	// The bid doesn't have specific requirements for the channel type.
	case order.ChannelTypePeerDependent:
		break

	// The bid expects a channel type that enforces the channel lease
	// maturity in its output scripts.
	case order.ChannelTypeScriptEnforced:
		if req.CommitmentType == nil {
			return &lndclient.AcceptorResponse{
				Accept: false,
				Error:  "expected explicit channel negotiation",
			}, nil
		}

		switch *req.CommitmentType {
		case lnwallet.CommitmentTypeScriptEnforcedLease:
		default:
			return &lndclient.AcceptorResponse{
				Accept: false,
				Error: "expected script enforced channel " +
					"lease commitment type",
			}, nil
		}

	default:
		log.Warnf("Unhandled channel type %v for bid %v",
			expectedChanBid.ChannelType, expectedChanBid.Nonce())
		return &lndclient.AcceptorResponse{
			Accept: false,
			Error:  "internal error",
		}, nil
	}

	fundingFlags := lnwire.FundingFlag(req.ChannelFlags)
	isPrivateChan := fundingFlags&lnwire.FFAnnounceChannel == 0

	// Check that the new channel is announced/unannounced as expected.
	if isPrivateChan != expectedChanBid.UnannouncedChannel {
		var errMsg string
		errTemplate := "expected an %s channel but received an %s one"

		if expectedChanBid.UnannouncedChannel {
			errMsg = fmt.Sprintf(errTemplate, "unannounced",
				"announced")
		} else {
			errMsg = fmt.Sprintf(errTemplate, "announced",
				"unannounced")
		}

		return &lndclient.AcceptorResponse{
			Accept: false,
			Error:  errMsg,
		}, nil
	}

	// Check that the channel is a zero conf channel if we were expecting
	// one.
	if expectedChanBid.ZeroConfChannel {
		if !req.WantsZeroConf {
			return &lndclient.AcceptorResponse{
				Accept: false,
				Error:  "expected zero conf channel",
			}, nil
		}
		return &lndclient.AcceptorResponse{
			Accept:         true,
			MinAcceptDepth: 0,
			ZeroConf:       true,
		}, nil
	}

	return &lndclient.AcceptorResponse{
		Accept: true,
	}, nil
}
```

### lndclient:

{% embed url="https://github.com/lightninglabs/lndclient/blob/master/lightning_client.go#L230" %}
How the channel acceptor is used in lndclient
{% endembed %}

```go
	// ChannelAcceptor create a channel acceptor using the accept function
	// passed in. The timeout provided will be used to timeout the passed
	// accept closure when it exceeds the amount of time we allow. Note that
	// this amount should be strictly less than lnd's chanacceptor timeout
	// parameter.
	ChannelAcceptor(ctx context.Context, timeout time.Duration,
		accept AcceptorFunction) (chan error, error)

	// FundingStateStep is a funding related call that allows the execution
	// of some preparatory steps for a funding workflow or manual
	// progression of a funding workflow.
	FundingStateStep(ctx context.Context, req *lnrpc.FundingTransitionMsg) (
		*lnrpc.FundingStateStepResp, error)

	// QueryRoutes can query LND to return a route (with fees) between two
	// vertices.
	QueryRoutes(ctx context.Context, req QueryRoutesRequest) (
		*QueryRoutesResponse, error)

	// CheckMacaroonPermissions allows a client to check the validity of a
	// macaroon.
	CheckMacaroonPermissions(ctx context.Context, macaroon []byte,
		permissions []MacaroonPermission, fullMethod string) (bool,
		error)

	// RegisterRPCMiddleware adds a new gRPC middleware to the interceptor
	// chain. A gRPC middleware is software component external to lnd that
	// aims to add additional business logic to lnd by observing/
	// intercepting/validating incoming gRPC client requests and (if needed)
	// replacing/overwriting outgoing messages before they're sent to the
	// client.
	RegisterRPCMiddleware(ctx context.Context, middlewareName,
		customCaveatName string, readOnly bool, timeout time.Duration,
		intercept InterceptFunction) (chan error, error)

	// SendCustomMessage sends a custom message to a peer.
	SendCustomMessage(ctx context.Context, msg CustomMessage) error

	// SubscribeCustomMessages creates a subscription to custom messages
	// received from our peers.
	SubscribeCustomMessages(ctx context.Context) (<-chan CustomMessage,
		<-chan error, error)
}
```
