---
description: Learn how to best select other Lightning Nodes for opening channels.
---

# Identifying Good Peers on the Lightning Network

## Introduction <a id="docs-internal-guid-07d5a242-7fff-f4c0-4d5d-a5bb7ea75316"></a>

Whether you’re primarily using the Lightning Network to send or receive payments, or if you yourself are looking to run a routing node, identifying good peers is crucial to using the Lightning Network. By connecting with good peers, you become a good peer yourself, allowing the network to grow without choke points or centralization worries.

This is not always easy. As the network grows and changes, the flow of money will inevitably change as payment demand evolves over time. Ultimately there are many factors that might be used to identify good peers. Here are just a few one might consider:

* How well connected is the node?
* Is the node sufficiently capitalized?
* Does the node offer competitive fees for the service it provides?
* Has the peer been stable and active for a long period of time?
* Would creating a new channel to the node be mutually beneficial?
* Does the peer support newly available features?

Let’s take a closer look at each of these in turn.

## Node Connectedness <a id="docs-internal-guid-f79e7e08-7fff-1df3-19d8-28a63f971eca"></a>

A good peer is well connected to the network. That means they themselves have channels with other good peers, and so on. As such, the total channel count is much less important than the channel count to good peers.

Opening a channel with a well connected peer increases your chance of being able to successfully route payments in the Lightning Network.

## Node Capitalization <a id="docs-internal-guid-457f2ec7-7fff-2e93-13ca-327574b152ed"></a>

A good peer is well capitalized, meaning its channels have sufficient capacity to fulfill your payment needs. Generally, fewer channels with higher capacity will increase your routing chances over more channels with lower capacity.

Your own node’s capitalization depends on your personal needs. If you primarily use the Lightning Network to make payments, your node needs to be sufficiently capitalized for these payments. This capital should be in channels to good and stable peers.

To receive payments over the Lightning Network, your node does not need to carry much of its own capital. It does however need to have enough inbound liquidity to receive payments from the network.

The overall capacity of a node is easy to assess, the quality of that capacity however is not. It is also not easy to tell whether this capital is held in the form of incoming or outgoing capacity.

You can use the command `lncli getnodeinfo <node public key>` to probe a node’s capacity and number of channels or inspect a node on the web.

## Competitive Fees

Good peers offer competitive fees and more importantly, keep these fees stable over time. You can probe a channel’s fees with the command `lncli getchaninfo --chan_id <8-byte compact channel id>`

`lncli getchaninfo 743145615608774656  
{  
    "channel_id": "743145615608774656",  
    "chan_point": "2b91c69a05082d05d7135b41806cc34303837ea10383d1ac3eef77969f98d16e:0",  
    "last_update": 1616482074,  
    "node1_pub": "021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d",`       `"node2_pub": "032d5a4b5a6a344ca15f6284e3e149f4716a1af782ffbb0194e0dadc077051acf0",  
    "capacity": "16777215",  
    "node1_policy": {  
    "time_lock_delta": 40,  
    "min_htlc": "1000",  
    "fee_base_msat": "1000",  
    "fee_rate_milli_msat": "500",  
    "disabled": false,  
    "max_htlc_msat": "16609443000",  
    "last_update": 1616480497  
    },  
    "node2_policy": {  
    "time_lock_delta": 40,  
    "min_htlc": "1000",  
    "fee_base_msat": "1000",  
    "fee_rate_milli_msat": "1000",  
    "disabled": false,  
    "max_htlc_msat": "16609443000",  
    "last_update": 1616482074  
     }  
}`

Alternatively you can probe the entire graph with the command `lncli describegraph`. This will return all channels and their policies across the entire network.

\[The full guide to channel fees\]

## Node Stability <a id="docs-internal-guid-0d5861ce-7fff-d8b3-0ee2-1a9c063ca4d5"></a>

A peer’s stability is an important piece of what makes them a good peer. This is measured by their uptime, but also includes measurements like the age of their channels. A node with high uptime and old channels makes a stable peer.

Older channels are likely channels that have proven to be profitable for the operator, and are worth the capital it took to create them. Older channels signal that other channels, too will be around for a while, saving their peers on on-chain fees and providing them with a source of reliable routing income.

\[Also see: How to use Faraday to monitor channel activity.\]

## Routing needs

A good peer will have a need for you to peer with them. This could be because they route payments themselves. In this case, two nodes that have a well capitalized, active channel to each other will make for worse peers than two nodes that are not connected directly.

This however could also be a new node with few channels that has a need for inbound capacity. By peering with such a node, for example a merchant, you might be able to reliably earn routing fees to this peer, despite this node not appearing on lists of ‘good peers.’

## Supported Features

A good peer will also have important features enabled that will make maintaining your channels easier. This might include payment-addresses, multi-path payments or wumbo channels.

## Monitor your peers and channels <a id="docs-internal-guid-e3f29caf-7fff-7b50-ad01-9092f3afc634"></a>

Once you have found good peers, you will need to monitor these connections and make judgements for which channels to keep and which to close. Frequently opening and closing channels might make you a poor peer in the eyes of some, but closing inactive channels or channels with unreliable peers might be important to be known as a reliable router, and generally contributes to efficient capital allocation.

Some nodes might want to open private channels with you for the purpose of making payments. Such peers may generate stable income through routing fees, but as they make payments through you, your incoming capacity with these peers will shrink, binding your capital in a node that cannot route and may be offline most of the time. If these private peers have a way of regularly refilling their channels they can make for a good peer even if you aren’t able to route payments through them.

