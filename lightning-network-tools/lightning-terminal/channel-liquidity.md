---
description: >-
  To run a profitable routing node, you will need to efficiently manage your
  channel liquidity.
---

# Managing Channel Liquidity

Liquidity management is an essential part of operating a node on the Lightning Network. This article explains why certain nodes might want to direct their liquidity in specific ways, and how Lightning Terminal integrates with Lightning Loop and Pool to give node operators a faster and simpler way to manage their liquidity.

## Inbound and outbound liquidity on the Lightning Network

Payments on the Lightning Network are sent through the channels that connect different nodes. For a node to route a payment across the network, it must have channels with both inbound and outbound liquidity.

Inbound liquidity refers to your ability to receive payments, while outbound liquidity refers to your ability to send payments. Together, inbound and outbound liquidity will always equal the total capacity of your Lightning Network node.

With each payment your node sends or receives, your inbound and outbound balances will shift between channels. Over time, you may need to add incoming liquidity to the channels you are routing payments from, and outgoing liquidity to the channels you are routing payments to.&#x20;

This is known as rebalancing your channels.

For example, if you open and fund a 1,000,000 sat channel with Node A, your new channel will start with 1,000,000 sats of outbound liquidity available to send.

If you then send a direct payment of 100,000 sats to Node A, your outbound liquidity will drop to 900,000 sats, and your inbound liquidity will rise from 0 to 100,000 sats.&#x20;

To effectively operate your own node, you will need to monitor and manage your liquidity in different ways depending on your needs.&#x20;

Users making payments on the Lightning Network will need to regularly replenish their outbound liquidity, while merchants receiving payments for goods or services will need to regularly replenish their inbound liquidity.

Those looking to route payments will need liquidity available on both sides of their channels as balances shift over time.&#x20;

On Terminal, users have even faster access to liquidity management tools like Lightning Loop and Lightning Pool for deploying capital where it is needed the most.

## Lightning Loop

[Lightning Loop](loop.md) is a non-custodial service that allows node operators to manage their liquidity in a single click. As a trustless system for moving Bitcoin between on-chain and off-chain, Loop makes it easy to move Bitcoin between your open channels (on the Lightning Network) and the Bitcoin blockchain.

Loop has two actions, Loop In and Loop Out. Loop In is for moving Bitcoin from an on-chain address into Lightning channels while Loop Out is for moving Bitcoin out of Lightning channels back onto the Bitcoin blockchain.

Users that are making payments on the Lightning Network typically use Loop In to add funds to their channels. As they make payments, their outbound liquidity can be depleted, so they use Loop In to replenish that outbound liquidity. On the other hand, merchants that are receiving payments on the Lightning Network may use Loop Out to move their earnings back to the Bitcoin blockchain.

Routing nodes may regularly use both Loop In and Loop Out as their channel balances shift over time, and can access Loop from Terminal for one-click liquidity management.

## Lightning Pool

Lightning Pool is a non-custodial, peer-to-peer marketplace for Lightning node operators to buy and sell inbound channel liquidity.&#x20;

When first setting up and funding Lightning channels, a common problem new node operators face is a lack of inbound liquidity. Without it, it is impossible to receive Lightning payments or to route payments across the network.&#x20;

Pool lets new users purchase inbound liquidity on demand rather than obtaining it slowly otherwise. In exchange, node operators with excess liquidity can use Pool to provide those liquidity leases and earn a yield on their Bitcoin in addition to routing network fees.

Therefore, Lightning Pool allows participants on the network to set pricing signals to determine where liquidity in the network is most demanded, and allocate capital to improve overall network efficiency.\
