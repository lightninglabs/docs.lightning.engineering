---
description: >-
  AutoOpen helps node runners by opening new channels. It takes into account a
  variety of factors to improve the node’s position in the graph.
---

# AutoOpen

AutoOpen and [Autofees](autofees.md) are available as part of Lightning Terminal’s Autopilot feature. When enabled, AutoOpen lets a node runner assign a budget, specify their time preference as well as define a minimum and maximum channel size. There is also the option to pass node pubkeys of preferred peers. It will then target a suitable point in time to batch open channels to save on fees.

New channels are selected to improve the node’s reach into the Lightning Network. To measure this reach, AutoOpen uses betweenness centrality, which calculates how many paths between any two other nodes in the network go through the node in question.



<figure><img src="../../.gitbook/assets/Screenshot from 2024-03-28 10-49-07.png" alt=""><figcaption><p>Overview over the AutoOpen budget options</p></figcaption></figure>

To use AutoOpen, [connect to Lightning Terminal](connect.md) and navigate to Autopilot under the Loop menu. This will let you enable AutoOpen, as well as set a budget, define the minimum and maximum channel sizes and specify preferred peers. The “speed” selector defines how sensitive AutoOpen should be to high onchain fees.

When enabling AutoOpen, you are sharing your node’s public key as well as your current and past channels. This allows AutoOpen to determine your position in the graph, as well as avoid peering you with nodes you previously had channels with, especially if these channels had to be force closed or still have enough liquidity.

When choosing channels, AutoOpen will look at your node’s channel size distribution and whether it overlaps with the channel size distribution of the new peer. As a small, not yet well connected node you may see channels being opened to well-connected nodes, while large nodes may see new peers that are smaller and less well connected. The channel size is determined using your node’s channel size, your peer’s channel sizes as well as your specified limits.

AutoOpen will look out for low fee next block targets (compared to long term block fee history)  to decide when to open new channels. How sensitive you are to onchain fees can be set through the UI via the time preference configuration.

The new Autopilot feature will also set your initial channel fees for you. Using the fee rates of the new peer, AutoOpen will set the new adequate outbound fees for the new channel.

AutoOpen does not close channels. When broadly used, it is expected to further decentralize the Lightning Network graph by avoiding all nodes to be connected to the same large hubs at the center of the network, and instead increase betweenness-centrality by connecting nodes that do not yet share common peers.
