---
description: The guide to Lightning Loop
---

# Loop

[Lightning Loop](https://lightning.engineering/posts/2020-02-05-loop-beta/) is a service that allows users to make a Lightning transaction to an on-chain Bitcoin address \(Loop Out\), or send on-chain Bitcoin directly into a Lightning channel \(Loop In\). Loop can help manage channel liquidity, for example, by emptying out a channel and [acquiring inbound capacity](../../the-lightning-network/liquidity/how-to-get-inbound-capacity-on-the-lightning-network.md) \(or refilling a depleted channel\).

Lightning Loop uses submarine swaps to transact non-custodially, meaning that Loop is trustless. Loop Out transactions are batched to save on transaction fees.

Loop uses [LSATs](https://lsat.tech/) for authentication.

