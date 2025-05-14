---
description: From routing node to Edge node
---

# Become an Edge Node

An Edge node routes payments between Taproot Asset channels and the larger Lightning Network. Parts marked in violet are provided by litd

## Existing routing node

{% hint style="success" %}
This functionality is provided by LND
{% endhint %}

Building an Edge node requires both outgoing and incoming liquidity with the greater Lightning Network. This implies a mighty routing node, but might also be achieved with a few girthy channels to routing nodes.

[Read more: Understanding Liquidity](../../the-lightning-network/liquidity/understanding-liquidity.md)

## Assets

{% hint style="success" %}
This functionality is provided by tapd
{% endhint %}

The decision of what assets an Edge node is willing to route depends on the asset’s acceptance, liquidity and spreads. An Edge node could be affiliated directly with an issuer, but mostly likely acquires the assets on the open market.

[Read more: Minting and sending Taproot Assets onchain](../pool/first-steps.md)

## Taproot Asset channels

{% hint style="success" %}
This functionality is provided by LND, tapd and litd
{% endhint %}

An Edge node may both open Taproot Asset channels and accept them. It will advertise which assets it accepts channels for. It may restrict the channels it accepts by their minimum or maximum size, as it would for regular Bitcoin channels.

[Read more: Opening Taproot Asset channels](taproot-assets-channels.md)

## RFQ

{% hint style="success" %}
All litd nodes are able to use RFQ to communicate rates
{% endhint %}

Rates are communicated to peers directly via a process called “Request for Quote (RFQ)”. The gRPC API allows any Taproot Assets node to request quotes and use them when constructing payment routes. The RFQ process is typically between the user and a price oracle.

## The Oracle

{% hint style="warning" %}
This functionality  requires external software
{% endhint %}

In the same way a routing node will set the rates at which it is willing to forward payments, an Edge node will set rates for each asset. These rates however may change far more frequently and are not broadcast as part of regular gossip announcements.

The oracle is software that aggregates or determines the rates, either based on an order book, reference rates or public order books. The oracle may determine a single rate on top of which the Edge node charges a fee, or separate bid and ask rates, separated by a spread.

[Read more: RFQ](become-an-edge-node.md#rfq)

## Hedging mechanisms

{% hint style="warning" %}
This functionality requires external services
{% endhint %}

Every forward shifts the balance of satoshis and assets in the Edge node. A sophisticated operator might want to hedge against price fluctuations, for example on a spot exchange. It is also conceivable that smaller Edge nodes use larger Edge nodes to hedge directly through Taproot Asset channels.
