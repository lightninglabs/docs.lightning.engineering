---
description: >-
  To successfully route bitcoin in the Lightning Network, a node needs to
  provide five basic functions.
---

# What makes a good routing node

The Lightning Network is a network of payment channels, each secured on the Bitcoin Blockchain with [2-of-2 multisignature addresses](../payment-channels.md). These payment channels connect two parties and allow them to update their channel balances in tiny increments as frequently as they need.

To allow a large number of participants to transact through payment channels, transactions need to be sent through a large network of these channels. Each participant between a payer and a payee is considered a router. Ideally, there are many possible routes between any two network participants, though they might differ in length, fee and reliability.

These routing nodes need to fulfill their role in passing on payments from their peers. Routing nodes require specific hardware, skills, and capital, and thus, they are rewarded for their efforts and investment with routing fees.

Every channel in the network has a total capacity, limited by the amount of bitcoin committed at its creation. This balance can be held by either side of the channel, impacting its ability to pass on payments.

As a result, a route that worked for one payment might not work for the next, and the path a satoshi takes through the network might seem unpredictable. Additionally, the network is constantly changing, as balances shift, new channels are opened and old channels are closed.

Operating a good routing node does not require a highly specialized set of skills. You do not need to be a programmer, understand the details of cryptography or complex financial markets. Your Lightning routing node, however, will require plenty of close attention. While more and more software becomes available to help you gain insights into how capital is deployed and moves inside your node, a basic understanding of the command line is useful.

## Criteria of a good routing node <a id="docs-internal-guid-dd2a34c7-7fff-95b2-e67c-77c25612a06d"></a>

A good routing node needs to fulfill a wide range of requirements.

1. Availability: A routing node needs to be available. That means it needs to be running and maintain active channels with the network. If you want to let others open channels with you, you will also need to allow for [incoming connections](https://docs.google.com/document/d/1jworM1AIA9dLvpZvrdujVHyWVIAV6PJXoQ78aZZHVfA/edit#heading=h.g8vrxgu64v6c).
2. Reliability: To ensure reliable routing, the node needs to have enough channels to other good routing nodes in the network. Private channels are not announced to the network and therefore not counted. Private channels  can present additional opportunities for routing when others open channels with them, creating what is referred to as a Gateway node.
3. Active: Ideally, all of these channels are available and not disabled. Avoid peering publicly with non-routing nodes.
4. Capitalization: Channels need to be well capitalized in order to efficiently route payments. That means they need to have sufficient capacity, with enough incoming and outgoing liquidity.
5. Buffer: Each channel needs to maintain some buffer capital, meaning a minimum balance of outgoing and incoming capacity. This is to ensure the channel is able to route at all times, as other nodes may no longer choose you as a hop if they experience routing failures due to low buffer capital.

## Allocating capital <a id="docs-internal-guid-7be79f26-7fff-950d-8c15-8319b41bb0d4"></a>

Generally, large channels are better for routing, but concentrating all capital into two or three large channels might be less desirable than having a greater number of small channels with the broader network.

How to allocate your capital most efficiently is one of the biggest challenges of not just a routing node, but any business. Additionally, you will need to incentivize others, either by payment or other means, to allocate capital towards your node, and not to close channels that you created with them.

\[[Also read: Managing liquidity on the Lightning Network](manage-liquidity.md)\]

Routing nodes are providing a service to those sending and receiving payments. Node operators compete with each other over the payment channels that they create, but also over the fees they demand.

\[Also read: How to identify good peers\]

While it is possible to score nodes, it is incredibly difficult to create a score that accurately reflects a node’s ability to effectively route payments in the Lightning Network. If such criteria was transparent and easily replicable, nodes would strive to converge to it, leaving the network homogeneous and possibly unable to function.

As you build your routing node you will experiment with a wide range of tools and tactics, differentiate yourself from other nodes, and develop various strategies to attract others to peer with you and commit capital.

