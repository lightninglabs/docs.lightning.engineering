---
description: Determine your Lightning Network routing fees before making a payment.
---

# Probing with EstimateRouteFee

Lightning Network routing fees can be difficult to estimate in advance. Probing describes a technique that explores viable routes before making the payment itself, making it possible to anticipate fees. This can be useful especially for wallets, exchanges and everyone that passes routing fees to end users.

The [EstimateRouteFee API](https://lightning.engineering/api-docs/api/lnd/router/estimate-route-fee/) sends an HTLC with a random payment hash the destination can never settle. When this HTLC reaches its destination, the error message INCORRECT\_PAYMENT\_DETAILS indicates a successful probe. We are then able to use the probed fee and timelock as the estimate. A real payment over that same route would very likely cost exactly that fee.

### lncli estimateroutefee

For nodes with public channels, EstimateRouteFee works using only the destination’s public key and an amount. For nodes with private channels, a Bol11 invoice is required.

`lncli estimateroutefee --dest 03864ef025fde8fb587d989186ce6a4a186895ee44a926bfc370e2c366597a3f8f --amt 50000`

`lncli estimateroutefee --pay_req lnbc500u1p... --timeout 30s`

```json
{
    "routing_fee_msat": "1000",
    "time_lock_delay": "144",
    "failure_reason": "FAILURE_REASON_NONE"
}
```

When failure\_reason is anything other than FAILURE\_REASON\_NONE, no usable route was found within the timeout. The fee fields are zero and should be ignored.

The `--timeout` flag determines how long LND keeps trying to find a route before giving up. The default is 60 seconds. For interactive UIs where users are waiting, 15–30 seconds is a reasonable trade-off. If an in-flight HTLC gets stuck, it may take longer than the timeout to resolve. Cancelling the RPC call does not cancel the probe.

The `routing_fee_msat` is a lower bound and may increase if channel policies or liquidity conditions change between the probe and the actual payment.

### Common Failure Codes

Commonly encountered codes include:

`FAILURE_REASON_NONE`: Probe succeeded\
`FAILURE_REASON_NO_ROUTE`:  No path found, likely due to insufficient liquidity or unknown route\
`FAILURE_REASON_TIMEOUT`: The probe timed out before finding a route`FAILURE_REASON_INSUFFICIENT_BALANCE`: Your node doesn't have enough balance to probe

### Permissions

EstimateRouteFee requires only the `offchain:read` macaroon permission. It does not require `offchain:write` because while it does send HTLCs onto the network those HTLCs cannot be settled and do not result in actual fund transfers.

To generate a macaroon specifically used for probing, run:

`lncli bakemacaroon offchain:read`
