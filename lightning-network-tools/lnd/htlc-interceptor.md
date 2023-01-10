---
description: >-
  The HTLC Interceptor allows you to reject, resume and settle HTLCs flowing
  through your node.
---

# HTLC Interceptor

The HTLC Interceptor is a service in LND that allows you to inspect, approve, deny or settle all [HTLCs](../../the-lightning-network/multihop-payments/hash-time-lock-contract-htlc.md) passing through your node. HTLCs terminating at this node, meaning payments made to the node, are not affected. Once the HTLC interceptor is registered, LND will forward information about every passing HTLC to the interceptor, which can reply with either Settle, Fail or Resume.

The HTLC Interceptor can be used in many ways. For instance, it is useful in a high-performance cluster of multiple LND nodes, where multiple LND instances are used to generate invoices, but only one node is used to receive the payments.

In such an arrangement the invoicing virtual nodes, each with their own public key but without public channels, would include a hop hint from the settlement node into their invoices. The interceptor would resume all HTLCs not passing through to the invoicing nodes, and settle HTLCs by providing the preimage obtained from the invoicing nodes.

When failing HTLCs, the interceptor may respond with the appropriate error message, as if it were the recipient of the HTLC.

{% embed url="https://lightning.engineering/api-docs/api/lnd/router/htlc-interceptor" %}
API Documentation
{% endembed %}

## Code examples: <a href="#docs-internal-guid-46e36e21-7fff-4fa3-8776-4fd97a996a10" id="docs-internal-guid-46e36e21-7fff-4fa3-8776-4fd97a996a10"></a>

### Lightning Multiplexer:

[https://github.com/bottlepay/lnmux/blob/master/interceptor.go\
](https://github.com/bottlepay/lnmux/blob/master/interceptor.go)

```go
package lnmux

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/bottlepay/lnmux/common"
	"github.com/bottlepay/lnmux/lnd"
	"github.com/bottlepay/lnmux/types"
	"github.com/lightningnetwork/lnd/lnrpc/routerrpc"
	"github.com/lightningnetwork/lnd/lntypes"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"go.uber.org/zap"
)

const (
	resolutionQueueSize = 100
)

// disconnectedNodesGaugeMetric tracks the number of configured lnd nodes to
// which we do not have a connection.
var disconnectedNodesGaugeMetric = promauto.NewGauge(
	prometheus.GaugeOpts{
		Name: "lnmux_disconnected_nodes",
	},
)

type preSendCallbackFunc func(context.Context, common.PubKey, queuedReply) error

type interceptor struct {
	lnd             lnd.LndClient
	logger          *zap.SugaredLogger
	pubKey          common.PubKey
	htlcChan        chan *interceptedHtlc
	heightChan      chan int
	preSendCallback preSendCallbackFunc
}

func newInterceptor(lnd lnd.LndClient, logger *zap.SugaredLogger,
	htlcChan chan *interceptedHtlc, heightChan chan int,
	preSendCallback preSendCallbackFunc) *interceptor {

	pubKey := lnd.PubKey()
	logger = logger.With("node", pubKey)

	return &interceptor{
		lnd:             lnd,
		logger:          logger,
		pubKey:          pubKey,
		htlcChan:        htlcChan,
		heightChan:      heightChan,
		preSendCallback: preSendCallback,
	}
}

func (i *interceptor) run(ctx context.Context) {
	defer i.logger.Debugw("Exiting interceptor loop")

	// Start in the disconnected state. We are not supposed to exit this
	// function unless the process is shutting down. Do not decrement the
	// counter, so that we never falsely report that there are no disconnected
	// node.
	disconnectedNodesGaugeMetric.Inc()

	for {
		err := i.start(ctx)
		if err == nil || err == context.Canceled {
			return
		}

		i.logger.Infow("Htlc interceptor error",
			"err", err)

		select {
		// Retry delay.
		case <-time.After(time.Second):

		case <-ctx.Done():
			return
		}
	}
}

type queuedReply struct {
	incomingKey types.CircuitKey
	hash        lntypes.Hash
	resp        *interceptedHtlcResponse
}

func (i *interceptor) start(ctx context.Context) error {
	var wg sync.WaitGroup
	defer wg.Wait()

	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	send, recv, err := i.lnd.HtlcInterceptor(ctx)
	if err != nil {
		return err
	}

	i.logger.Debugw("Starting htlc interception")

	// Register for block notifications.
	blockChan, blockErrChan, err := i.lnd.RegisterBlockEpochNtfn(ctx)
	if err != nil {
		return err
	}

	// The block stream immediately sends the current block. Read that to
	// set our initial height.
	const initialBlockTimeout = 10 * time.Second

	select {
	case block := <-blockChan:
		i.logger.Debugw("Initial block height", "height", block.Height)
		i.heightChan <- int(block.Height)

	case err := <-blockErrChan:
		return err

	case <-time.After(initialBlockTimeout):
		return errors.New("initial block height not received")

	case <-ctx.Done():
		return ctx.Err()
	}

	var (
		errChan   = make(chan error, 1)
		replyChan = make(chan queuedReply, resolutionQueueSize)
	)

	wg.Add(1)
	go func(ctx context.Context) {
		defer wg.Done()

		err := i.htlcReceiveLoop(ctx, recv, replyChan)
		if err != nil {
			errChan <- err
		}
	}(ctx)

	// We consider ourselves connected now.
	disconnectedNodesGaugeMetric.Dec()
	defer disconnectedNodesGaugeMetric.Inc()

	for {
		select {
		case err := <-errChan:
			return fmt.Errorf("stream error: %w", err)

		case block := <-blockChan:
			select {
			case i.heightChan <- int(block.Height):

			case <-ctx.Done():
				return ctx.Err()
			}

		case item, ok := <-replyChan:
			if !ok {
				return errors.New("reply channel full")
			}

			if err := i.preSendCallback(ctx, i.pubKey, item); err != nil {
				return fmt.Errorf("pre-send callback failed: %w", err)
			}

			rpcResp := &routerrpc.ForwardHtlcInterceptResponse{
				IncomingCircuitKey: &routerrpc.CircuitKey{
					ChanId: item.incomingKey.ChanID,
					HtlcId: item.incomingKey.HtlcID,
				},
				Action:         item.resp.action,
				Preimage:       item.resp.preimage[:],
				FailureMessage: item.resp.failureMessage,
				FailureCode:    item.resp.failureCode,
			}

			if err := send(rpcResp); err != nil {
				return fmt.Errorf("cannot send: %w", err)
			}

		case err := <-blockErrChan:
			return fmt.Errorf("block error: %w", err)

		case <-ctx.Done():
			return ctx.Err()
		}
	}
}

func (i *interceptor) htlcReceiveLoop(ctx context.Context,
	recv func() (*routerrpc.ForwardHtlcInterceptRequest, error),
	replyChan chan queuedReply) error {

	var replyChanClosed bool

	for {
		htlc, err := recv()
		if err != nil {
			return err
		}

		hash, err := lntypes.MakeHash(htlc.PaymentHash)
		if err != nil {
			return err
		}

		reply := func(resp *interceptedHtlcResponse) error {
			// Don't try to write if the channel is closed. This
			// callback does not need to be thread-safe.
			if replyChanClosed {
				return errors.New("reply channel closed")
			}

			reply := queuedReply{
				resp: resp,
				hash: hash,
				incomingKey: types.CircuitKey{
					ChanID: htlc.IncomingCircuitKey.ChanId,
					HtlcID: htlc.IncomingCircuitKey.HtlcId,
				},
			}

			select {
			case replyChan <- reply:
				return nil

			// When the update channel is full, terminate the subscriber
			// to prevent blocking multiplexer.
			default:
				close(replyChan)
				replyChanClosed = true

				return errors.New("reply channel full")
			}
		}

		circuitKey := newCircuitKeyFromRPC(htlc.IncomingCircuitKey)

		select {
		case i.htlcChan <- &interceptedHtlc{
			circuitKey:         circuitKey,
			hash:               hash,
			onionBlob:          htlc.OnionBlob,
			incomingAmountMsat: htlc.IncomingAmountMsat,
			outgoingAmountMsat: htlc.OutgoingAmountMsat,
			incomingExpiry:     htlc.IncomingExpiry,
			outgoingExpiry:     htlc.OutgoingExpiry,
			outgoingChanID:     htlc.OutgoingRequestedChanId,
			reply:              reply,
		}:

		case <-ctx.Done():
			return ctx.Err()
		}
	}
}go
```

### lndclient: <a href="#docs-internal-guid-2da6c1a6-7fff-42f2-0550-ed59e63444dd" id="docs-internal-guid-2da6c1a6-7fff-42f2-0550-ed59e63444dd"></a>

[https://github.com/lightninglabs/lndclient/blob/master/router\_client.go#L58](https://github.com/lightninglabs/lndclient/blob/master/router\_client.go#L58)

```go
// InterceptedHtlc contains information about a htlc that was intercepted in
// lnd's switch.
type InterceptedHtlc struct {
	// IncomingCircuitKey is lnd's unique identfier for the incoming htlc.
	IncomingCircuitKey channeldb.CircuitKey

	// Hash is the payment hash for the htlc. This may not be unique for
	// MPP htlcs.
	Hash lntypes.Hash

	// AmountInMsat is the incoming htlc amount.
	AmountInMsat lnwire.MilliSatoshi

	// AmountOutMsat is the outgoing htlc amount.
	AmountOutMsat lnwire.MilliSatoshi

	// IncomingExpiryHeight is the expiry height of the incoming htlc.
	IncomingExpiryHeight uint32

	// OutgoingExpiryHeight is the expiry height of the outgoing htlcs.
	OutgoingExpiryHeight uint32

	// OutgoingChannelID is the outgoing channel id proposed by the sender.
	// Since lnd has non-strict forwarding, this may not be the channel that
	// the htlc ends up being forwarded on.
	OutgoingChannelID lnwire.ShortChannelID
}

// HtlcInterceptHandler is a function signature for handling code for htlc
// interception.
type HtlcInterceptHandler func(context.Context,
	InterceptedHtlc) (*InterceptedHtlcResponse, error)

// InterceptorAction represents the different actions we can take for an
// intercepted htlc.
type InterceptorAction uint8

const (
	// InterceptorActionSettle indicates that an intercepted htlc should
	// be settled.
	InterceptorActionSettle InterceptorAction = iota

	// InterceptorActionFail indicates that an intercepted htlc should be
	// failed.
	InterceptorActionFail

	// InterceptorActionResume indicates that an intercepted hltc should be
	// resumed as normal.
	InterceptorActionResume
)

// InterceptedHtlcResponse contains the actions that must be taken for an
// intercepted htlc.
type InterceptedHtlcResponse struct {
	// Preimage is the preimage to settle a htlc with, this value must be
	// set if the interceptor action is to settle.
	Preimage *lntypes.Preimage

	// Action is the action that should be taken for the htlc that is
	// intercepted.
	Action InterceptorAction
}
```
