---
description: >-
  Request For Quote (RFQ) is a mechanism that simplifies sending Taproot Assets
  over Lightning Network channels.
---

# RFQ

When sending Taproot Assets over the Lightning Network, an Edge Node is needed. This Edge Node receives the Taproot Asset in the channel with the direct user and swaps it for bitcoin. As the swap rate between Taproot Assets and bitcoin likely fluctuates, the user may make a Request for Quote (RFQ) to the Edge Node before generating a Lightning Network invoice or initiating a payment.

This request is made using [BOLT 01](https://github.com/lightning/bolts/blob/master/01-messaging.md) messages over an existing encrypted and authenticated [BOLT 08](https://github.com/lightning/bolts/blob/master/08-transport.md) connection. They are encoded as TLV records and delivered over LND's custom message channel. The message type namespace starts at `MsgTypeOffset` (which is `CustomTypeStart + 20116`, where `20116` encodes "tap". The connection already exists because it is used for establishing and coordinating the Taproot Asset Channel in a way very similar to normal Lightning channels. For more information about connection and messaging, see the [Last Mile Routing](https://github.com/Roasbeef/blips/blob/tap-blip/blip-tap.md#last-mile-routing) section of [Taproot Asset Channels BLIP](https://github.com/Roasbeef/blips/blob/tap-blip/blip-tap.md).

[Learn more: Edge Nodes](../../the-lightning-network/taproot-assets/edge-nodes.md)

{% embed url="https://www.youtube.com/watch?v=m0BSUqNZT_U" %}
Video: Running a Taproot Assets Price Oracle
{% endembed %}

The Request for Quote contains a rate and an expiration time, which allows the sender to decide whether they want to complete the payment and craft a route to the intended recipient.

Similarly when receiving Taproot Assets over the Lightning Network, RFQ is used by the recipient to generate a satoshi-denominated Lightning invoice.

### Message Types

There are three message types, each available in buy and sell variants:

**Request** (`MsgTypeRequest`): Initiates negotiation. The user tells the edge node what asset and amounts are involved, and optionally proposes a rate hint.

**Accept** (`MsgTypeAccept`): The edge node agrees to the proposed terms at a specific rate. The accept is Schnorr-signed over the message fields so neither party can modify the agreed rate later.

**Reject** (`MsgTypeReject`): The edge node declines, with a machine-readable error code and human-readable message.

## The Mock Oracle

For testing purposes, tapd includes a mock oracle. This oracle allows the tester to set up a static exchange rate between Taproot Assets and bitcoin. When added to `lit.conf`, all Taproot Assets configuration options have to be pre-fixed with `taproot-assets.`

`taproot-assets.experimental.rfq.priceoracleaddress=use_mock_price_oracle_service_promise_to_not_use_on_mainnet`

You may set a fixed swap rate directly in the `tapd.conf` file as well in Taproot Assets units per bitcoin to avoid building your own custom price oracle. To trade one unit per satoshi for example, set the value to 1:

`taproot-assets.experimental.rfq.mockoraclesatsperasset=1`

Alternatively, you can also set a price of asset per Bitcoin. Remember that if your asset has decimal places, enter the full precision. So if your asset carries two decimal places, add two zeroes. In the below example, we define the price of our asset as one asset per satoshi, without decimal places:

`taproot-assets.experimental.rfq.mockoracleassetsperbtc=100000000`

Both peers of a Taproot Assets channel may set up an RFQ oracle. Alternatively, one of the nodes may chose to operate without an oracle, simply accepting all quotes from the Edge Node:

`taproot-assets.experimental.rfq.skipacceptquotepricecheck=true`

## Sample Oracle

For signet, a sample oracle is deployed at `tassandra.laisee.org` for asset group key `02db9c81b87830b73331e0f1f69271791f13a24848ceec9bd38e32383e384cc468`

It can be configured by adding only the following to your `lit.conf` (the sample oracle is not compatible with that of the mock oracle):

`taproot-assets.experimental.rfq.priceoracleaddress=rfqrpc://tassandra.laisee.org:20590`

For regtest, signet and testnet you may also deploy your own instance of [Tassandra](https://github.com/liongrass/tassandra).

### Further reading

For more information, find the following guides in the `taproot-assets/docs` repository:

{% embed url="https://github.com/lightninglabs/taproot-assets/blob/main/docs/rfq.md" %}

{% embed url="https://github.com/lightninglabs/taproot-assets/blob/main/docs/rfq-and-decimal-display.md" %}

{% embed url="https://github.com/lightninglabs/taproot-assets/blob/main/docs/rfq_architecture.md" %}
