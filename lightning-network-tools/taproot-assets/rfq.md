---
description: >-
  Request For Quote (RFQ) is a mechanism that simplifies sending Taproot Assets
  over Lightning Network channels.
---

# RFQ

When sending Taproot Assets over the Lightning Network, an Edge Node is needed. This Edge Node receives the Taproot Asset in the channel with the direct user and swaps it for bitcoin. As the swap rate between Taproot Assets and bitcoin likely fluctuates, the user may make a Request for Quote to the Edge Node before generating a Lightning Network invoice or initiating a payment.

[Learn more: Edge Nodes](../../the-lightning-network/taproot-assets/edge-nodes.md)

The Request for Quote contains a rate and an expiration time, which allows the sender to decide whether they want to complete the payment and craft a route to the intended recipient.

Similarly when receiving Taproot Assets over the Lightning Network, RFQ is used by the recipient to generate a satoshi-denominated Lightning invoice.

## Testing configuration

For testing purposes, tapd includes a mock oracle. This oracle allows the tester to set up a static exchange rate between Taproot Assets and bitcoin. When added to `lit.conf`, all Taproot Assets configuration options have to be pre-fixed with `taproot-assets.`

`taproot-assets.experimental.rfq.priceoracleaddress=use_mock_price_oracle_service_promise_to_not_use_on_mainnet`

You may set a fixed swap rate directly in the `tapd.conf` file as well in Taproot Assets units per bitcoin to avoid building your own custom price oracle. To trade one unit per satoshi for example, set the value to 1:

`taproot-assets.experimental.rfq.mockoraclesatsperasset=1`

Alternatively, you can also set a price of asset per Bitcoin. Remember that if your asset has decimal places, enter the full precision. So if your asset carries two decimal places, add two zeroes. In the below example, we define the price of our asset as one asset per satoshi, without decimal places:

`taproot-assets.experimental.rfq.mockoracleassetsperbtc=100000000`

Both peers of a Taproot Assets channel may set up an RFQ oracle. Alternatively, one of the nodes may chose to operate without an oracle, simply accepting all quotes from the Edge Node:

`taproot-assets.experimental.rfq.skipacceptquotepricecheck=true`
