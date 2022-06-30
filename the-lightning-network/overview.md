---
description: >-
  Learn how the Lightning Network functions. Get comfortable with its topology,
  channels, invoices and routing.
---

# Overview

The Lightning Network is a peer-to-peer payment network. It leverages payment channels anchored on the Bitcoin blockchain to enable near instant and low-cost settlement of bitcoin between participants. Multiple such payment channels are chained together to deliver payments to anyone in the network without requiring trust in participants.

To understand the Lightning Network in its entirety, one should begin by learning about payment channels.

Next, Lightning Network invoices are used by the recipient of a payment to specify amounts, features and the recipient’s location in the network.

The entirety of all payment channels forms the Lightning Network. Information about channels and participants is relayed through a gossip network between peers.

When making payments over the Lightning Network, the sender has to find a route from their node through routing nodes to the recipient. Nodes and their channels are known, but whether an individual node is available and has the liquidity to route the payment is not. In practice, that means constructing multiple theoretical routes and attempting them one by one.

Each Lightning payment is atomic, meaning it is either completed or failed in full. This is achieved through Hash Time-lock Contracts (HTLC), which allow for individual payments to be settled on-chain in situations where a routing node were to become unresponsive or acts maliciously.

Lightning Network nodes and channels are constrained by the capital they hold. To understand the Lightning Network, we must also understand how the concept of liquidity affects the reliability of payments, and how a routing node operator can earn fees by effectively deploying capital where it is most needed.

The following guides assume basic knowledge of Bitcoin, specifically the UTXO model, unconfirmed transactions and their confirmation on the Blockchain.

{% content-ref url="payment-channels/" %}
[payment-channels](payment-channels/)
{% endcontent-ref %}

{% content-ref url="the-gossip-network/the-gossip-network.md" %}
[the-gossip-network.md](the-gossip-network/the-gossip-network.md)
{% endcontent-ref %}

{% content-ref url="pathfinding/" %}
[pathfinding](pathfinding/)
{% endcontent-ref %}

{% content-ref url="payment-lifecycle/" %}
[payment-lifecycle](payment-lifecycle/)
{% endcontent-ref %}

{% content-ref url="multihop-payments/" %}
[multihop-payments](multihop-payments/)
{% endcontent-ref %}

{% content-ref url="liquidity/" %}
[liquidity](liquidity/)
{% endcontent-ref %}

{% content-ref url="lsat/" %}
[lsat](lsat/)
{% endcontent-ref %}

{% content-ref url="taro.md" %}
[taro.md](taro.md)
{% endcontent-ref %}
