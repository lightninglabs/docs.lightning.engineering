---
description: >-
  The RPC middleware interceptor allows interception and modification of any RPC
  call made to LND.
---

# RPC Middleware Interceptor

The RPC middleware interceptor is a powerful feature of LND. Once enabled, it intercepts all incoming RPC requests to LND and forwards them, allowing these requests to be inspected, validated and modified before they are sent back to LND for execution.

This interceptor is used by Lightning Terminal to enable the Accounts feature, which allows a node operator to virtually segregate funds in their Lightning Network node between multiple accounts, enforced by Macaroons.

{% embed url="https://lightning.engineering/api-docs/api/lnd/lightning/register-r-p-c-middleware" %}
Read the API documentation: Middleware
{% endembed %}

## Enable the RPC Middleware Interceptor <a href="#docs-internal-guid-d79ffd2d-7fff-6190-94eb-52e66e386fae" id="docs-internal-guid-d79ffd2d-7fff-6190-94eb-52e66e386fae"></a>

To enable the interceptor, add this line to your lnd.conf file and restart your node.

`rpcmiddleware.enable=true`

Any software attempting to inspect, validate or even modify is required to authenticate itself to LND with a custom macaroon indicating which caveats it wants to be responsible for. Only requests pertaining to these specific caveats will then be forwarded to the middleware.

Multiple connections to the RPC Middleware are possible, though when replacing calls, each interceptor should be limited to their exclusive caveats only, as each call can only be replaced once.

## Code examples:

### Lightning Terminal

[https://github.com/lightninglabs/lightning-terminal/blob/master/accounts/interceptor.go#L45](https://github.com/lightninglabs/lightning-terminal/blob/master/accounts/interceptor.go#L45)

```go
// Intercept processes an RPC middleware interception request and returns the
// interception result which either accepts or rejects the intercepted message.
func (s *InterceptorService) Intercept(ctx context.Context,
	req *lnrpc.RPCMiddlewareRequest) (*lnrpc.RPCMiddlewareResponse, error) {

	// We only allow a single request or response to be handled at the same
	// time. This should already be serialized by the RPC stream itself, but
	// with the lock we prevent a new request to be handled before we finish
	// handling the previous one.
	s.requestMtx.Lock()
	defer s.requestMtx.Unlock()

	mac := &macaroon.Macaroon{}
	err := mac.UnmarshalBinary(req.RawMacaroon)
	if err != nil {
		return mid.RPCErrString(req, "error parsing macaroon: %v", err)
	}

	acctID, err := accountFromMacaroon(mac)
	if err != nil {
		return mid.RPCErrString(
			req, "error parsing account from macaroon: %v", err,
		)
	}

	// No account lock in the macaroon, something's weird. The interceptor
	// wouldn't have been triggered if there was no caveat, so we do expect
	// a macaroon here.
	if acctID == nil {
		return mid.RPCErrString(req, "expected account ID in "+
			"macaroon caveat")
	}

	acct, err := s.Account(*acctID)
	if err != nil {
		return mid.RPCErrString(
			req, "error getting account %x: %v", acctID[:], err,
		)
	}

	log.Debugf("Account auth intercepted, ID=%x, balance_sat=%d, "+
		"expired=%v", acct.ID[:], acct.CurrentBalanceSats(),
		acct.HasExpired())

	if acct.HasExpired() {
		return mid.RPCErrString(
			req, "account %x has expired", acct.ID[:],
		)
	}

	// We now add the account to the incoming context to give each checker
	// access to it if required.
	ctxAccount := AddToContext(ctx, KeyAccount, acct)

	switch r := req.InterceptType.(type) {
	// In the authentication phase we just check that the account hasn't
	// expired yet (which we already did). This is only be used for
	// establishing streams, so we don't see a request yet.
	case *lnrpc.RPCMiddlewareRequest_StreamAuth:
		return mid.RPCOk(req)

	// Parse incoming requests and act on them.
	case *lnrpc.RPCMiddlewareRequest_Request:
		msg, err := parseRPCMessage(r.Request)
		if err != nil {
			return mid.RPCErr(req, err)
		}

		return mid.RPCErr(req, s.checkers.checkIncomingRequest(
			ctxAccount, r.Request.MethodFullUri, msg,
		))

	// Parse and possibly manipulate outgoing responses.
	case *lnrpc.RPCMiddlewareRequest_Response:
		msg, err := parseRPCMessage(r.Response)
		if err != nil {
			return mid.RPCErr(req, err)
		}

		replacement, err := s.checkers.replaceOutgoingResponse(
			ctxAccount, r.Response.MethodFullUri, msg,
		)
		if err != nil {
			return mid.RPCErr(req, err)
		}

		// No error occurred but the response should be replaced with
		// the given custom response. Wrap it in the correct RPC
		// response of the interceptor now.
		if replacement != nil {
			return mid.RPCReplacement(req, replacement)
		}

		// No error and no replacement, just return an empty response of
		// the correct type.
		return mid.RPCOk(req)

	default:
		return mid.RPCErrString(req, "invalid intercept type: %v", r)
	}
}
```

### lndclient:

[https://github.com/lightninglabs/lndclient/blob/master/lightning\_client.go#L256](https://github.com/lightninglabs/lndclient/blob/master/lightning\_client.go#L256)

```go
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
