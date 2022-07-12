---
description: >-
  Assets issued on Taro can be deposited into Lightning Network channels and
  transacted instantly.
---

# Taro on Lightning

Taro is a protocol that describes how assets can be issued on the bitcoin blockchain. These assets can be deposited into [Lightning Network payment channels](https://docs.lightning.engineering/the-lightning-network/payment-channels/lifecycle-of-a-payment-channel) and transacted instantly.

This principle allows Lightning Network users to hold a balance in their wallet different from BTC: for instance, a stablecoin. They can receive payments denominated in that stablecoin, and use their stablecoin balance to pay for goods and services over the Lightning Network.

Bitcoin remains as the backbone of the Lightning Network, and payments through Taro assets can be routed over the existing Bitcoin Lightning Network, without the need to upgrade or opt in. With Bitcoin providing the liquidity for these payments denominated in other assets, Taro asset routing can deliver more routing fees paid in satoshis for routing node operators.

## Taro-enabled channels <a href="#docs-internal-guid-8073d85d-7fff-f958-e660-b596e6d08d6d" id="docs-internal-guid-8073d85d-7fff-f958-e660-b596e6d08d6d"></a>

Taro asset channels can be created similar to the way that Bitcoin channels are currently created in the Lightning Network. [HTLCs](../multihop-payments/hash-time-lock-contract-htlc.md) can be constructed for transfers in these Taro-aware payment channels similarly to how bitcoin is transferred.

\
Assets are transacted by creating nested HTLC which, if needed, can be claimed by the recipient by revealing a [preimage](../../community-resources/glossary.md#preimage), or by the sender after a timeout period.  These transactions are Taro’s equivalent of Lightning Network transactions.

### Multi-hop Taro transfers

Historically, payment networks struggle with a bootstrapping problem -- any time a new asset is created, an entirely new payment network needs to be created to serve that specific asset's payment demand.  Taro enables a payment-routing paradigm in which the LN is able to handle channels with any asset, but with the ability to find routes across different assets. Taro assets in LN channels can be transferred over the general Lightning Network, For example, in a situation in which all participants along a route have liquidity with each other, they can opt to charge fees in BTC or the transferred Taro asset.

Even if no Taro route exists, a BTC route can take its place as long as the first node is willing to forward the Taro value in satoshis. This can also allow the LN to facilitate exchange between bitcoin and Taro assets over the Lightning Network. This also allows the recipient of a payment to opt into receiving a Taro asset instead of BTC. In the example below, Bob and Carol both act as edge nodes and swap payments L-USD and BTC.

![An example of a Taro payment made to the wider Lightning Network](<../../.gitbook/assets/Group 3881(1).png>)

This makes it possible to receive a Taro asset but present the corresponding invoice to any other Lightning wallet - even those that do not opt into the Taro protocol - which could pay the invoice using BTC.

This maintains the Lightning invoice as the standard scheme for invoices. An invoice ultimately settled in Taro can be paid by BTC or any other Taro asset, and anyone with a Taro balance can pay any Lightning invoice.

![An example of a Taro payment in which the receiver opts to receive the same asset type.](<../../.gitbook/assets/Group 3882(2).png>)



### Exchange rates <a href="#docs-internal-guid-08fce969-7fff-c159-5dda-e3434119debb" id="docs-internal-guid-08fce969-7fff-c159-5dda-e3434119debb"></a>

The Taro protocol itself gives integrators optionality with regard to how to handle exchange rates. Each peer in a channel performing swaps is responsible for determining their own exchange rate. They might use reference rates from liquid exchanges, or determine their own. It is important to note that when receiving a payment the recipient generates the invoice themselves, thus ensuring that the recipient receives the proper amount denominated in their desired asset.&#x20;

Any Lightning Network node aware of Taro channels can potentially act as an edge node. They compete with each other over fees they collect from forwards and swaps. These fees include the routing fee, a swap fee or alternatively a spread

When creating an invoice, the recipient (e.g. Zane in the example below) and their peer (e.g. Yana) agree on a rate before the generation of the invoice. They use this agreed price to generate a general Lightning Network invoice, including the hop hints and the channel policies and pass it on to the payer.

As the payer passes the payment through their constructed route to Zane, it passes Yana, who forwards L-EUR. Before releasing the preimage, Zane’s wallet can check whether it received the exact expected amount of L-EUR.

When paying a satoshi-denominated invoice through L-USD, Alice has to agree with Bob over the latest rates and fees. She can confirm the payment, passing the required amount of L-USD plus fees, and the recipient will only release the preimage if they receive the amount of satoshis they expected.

![Sender and recipient do not need to transact in the same asset type.](<../../.gitbook/assets/Group 3881(2).png>)

Edge nodes may have other tools at their disposal if they fear abuse of their forwards, such as closing a channel, reducing the validity of invoices or increasing spreads.

The Taro protocol does not regulate or set rates, but only provides for the mechanisms of a functional market with low technical barriers to entry and the tools that allow for automated, atomic and instant forwards.
