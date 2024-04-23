---
description: >-
  An Edge Node is a Taproot Assets-aware Lightning Node that routes payments
  between Taproot Assets channels and Bitcoin channels.
---

# Edge Nodes

Taproot Assets can be deposited into Lightning Network channels. Such Taproot Asset channels are not announced to the network, but are available as “private” channels to both channel partners.

Typically, these unannounced channels are between a client (the wallet of an end-user, running on a mobile device or personal computer) and a service provider (a routing node operating on a server). The service provider is always available and well connected to the larger network through public channels, while the client only comes only sporadically to make or receive a payment.

In the context of Taproot Assets, an Edge node is a service provider with multiple public Bitcoin channels to the Lightning Network, and unannounced Taproot Assets channels with their clients. They may have multiple channels per client, for example to facilitate the transfer of multiple asset types.

What makes an Edge node different to an ordinary routing node or Lightning Service Provider is the ability to swap the Taproot Asset into BTC or vice versa, and route the value of the payment over the greater Lightning Network.

This enables a Taproot Assets-aware Lightning wallet to hold a Taproot Asset, but pay to any Bolt 11/12 Lightning invoice, LNURL or Lightning address. It also allows this wallet to receive Taproot Assets for any payment made by any existing Lightning wallet.

Through Edge Nodes, Taproot Assets-enabled wallets are able to plug into the existing network effects of the Lightning Network, and are able to interact with services and users that are not aware of Taproot Assets.

As Edge nodes swap Taproot Assets to BTC through traditional [HTLCs](../../the-lightning-network/multihop-payments/hash-time-lock-contract-htlc.md), they do not hold client assets or require custodial arrangements of any other kind.

## What does an Edge node do <a href="#docs-internal-guid-9848fd86-7fff-5305-d8ad-ff2ea6ce4686" id="docs-internal-guid-9848fd86-7fff-5305-d8ad-ff2ea6ce4686"></a>

* **Open channels**

Similar to a Lightning Service Provider, an Edge node might be expected to open Taproot Asset channels to clients on demand. It might charge a fee for this service, or operate under the expectation of generating revenue through future routing activity

* **Quote swap rates**

Before the client performs a swap from Taproot Assets to Bitcoin, it will expect to get a quote from the Edge node. As Lightning invoices are denominated in Bitcoin, this quote is necessary for the client to know how much of their Taproot Assets they are expected to pay: “This invoice is over 10,000 satoshis, how many Taproot-USD will this cost me?”\
Conversely, when generating a Lightning invoice, a quote is necessary for the client to generate the invoice: “I would like to receive 10 Taproot-USD, what amount of satoshis should I make this invoice out to?”\
\
As Bitcoin’s exchange rate is volatile, spreads offered by Edge providers may differ based on how long they are valid for. When paying an invoice quotes only need to be valid for a few seconds, while invoices require quotes for the period of their validity.\
\
Existing mechanisms like LNURL-pay may help create static, reusable and dollar-denominated payment requests that do not require extensively valid swap quotes. A user may have channels to multiple Edge nodes and choose the most attractive quote.

* **Route payments**

An Edge node is expected to route payments to and from their clients and the larger network. They earn fees for routing payments, as any other routing node would. Payments are routed atomically through HTLCs.

* **Hedge**

As an Edge node performs swaps between Taproot Assets and Bitcoin, they might choose to hedge their trades on an exchange, but they may also be used by others as a hedging mechanism, for example by allowing for circular routes that let a client swap from and to a Taproot Asset.

## How to find an Edge node <a href="#docs-internal-guid-af7e0901-7fff-8577-4dae-2106e2d2e783" id="docs-internal-guid-af7e0901-7fff-8577-4dae-2106e2d2e783"></a>

The mechanisms of how Edge nodes become discoverable are not fully determined and ultimately up to the market. Edge nodes may be popularly known, affiliated with wallets, exchanges or brokers.

Eventually, Edge nodes may offer their liquidity services through a marketplace like [Pool](../pool/).

## How to run an Edge node

To run an Edge node, we recommend getting started with [a regular LND routing node](../lnd/run-lnd.md). By running [litd](https://docs.lightning.engineering/lightning-network-tools/lightning-terminal/get-lit) in integrated mode, the node benefits from having access to Loop, Pool and Taproot Assets from the very beginning.

In addition to Bitcoin, the Edge node will need to get access to the Taproot Assets they want to offer to their clients, as well as implement their custom logic for providing quotes and hedging their trades.
