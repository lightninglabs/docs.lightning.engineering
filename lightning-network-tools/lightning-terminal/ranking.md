---
description: >-
  Lightning Terminal lets you explore Lightning Network nodes. All nodes are
  ranked by their performance, as observed by publicly available information.
---

# Rankings

Important criteria include a node’s position in the network graph, its capacity and the quality of its peers.

## Health Checks

For a node to be considered for the Lightning Terminal ranking, it needs to pass [six health checks](https://docs.lightning.engineering/lightning-network-tools/lightning-terminal/health-checks). Ensure your node’s availability, open new channels and manage your liquidity to pass the health checks and improve your position in the ranking.

## Peers

For a peer to be considered to be a good peer, their channel must have sufficient liquidity to route payments. Use [Loop](https://docs.lightning.engineering/lightning-network-tools/lightning-terminal/loop) to manage your channels’ liquidity or rebalance your channels to improve the number of your good peers.

## Centrality

The concept of “In-betweenness Centrality” measures how many hypothetical routes pass through your node. The nodes are sorted by how many routes pass through them, the results are displayed by percentile. Being in the 75th percentile for example means that your node has more routes passing through&#x20;

## Inbound

[Inbound liquidity](../../the-lightning-network/liquidity/understanding-liquidity.md) describes your ability to receive payments through the Lightning Network. It’s a novel concept that can be hard to quantify, as each channel has its own fees and quality. For top nodes, Lightning Terminal classifies inbound efficiency, which expresses how easily a node can be reached in terms of cost and time by potential payers.

A node with [good inbound](../../the-lightning-network/liquidity/how-to-get-inbound-capacity-on-the-lightning-network.md) is reachable at low cost and in a timely manner. Good inbound liquidity is necessary to reliably receive payments, avoid routing failures, and high fees. Nodes with poor inbound liquidity may experience missed payments, user frustration, and costs that are hard to detect.

The classification result is displayed by percentile. Being in the 10th percentile means that 9 out of 10 nodes have better inbound capacity. Terminal also signals confidence about the results. When inbound quality is displayed in bright colors, Terminal is confident about the results. Grayed out results indicate low confidence.

**Hard to Reach (lowest 15 percentile):**

* This node cannot be paid easily. Routes take time to find or are expensive
* It might be profitable to open a channel to this node
* If this is your node: You might benefit from reducing your channel balance by making payments, using Loop Out or acquiring additional inbound capacity. To keep inbound fees low, free up liquidity regularly so that existing channels can be reused

**Reachable (15 - 60 percentile):**

* This node can be reached in a reasonable amount of time and cost

**Easy to Reach (highest 60 percentile):**

* This node can easily receive payments at low cost
* Consider acquiring inbound capacity from this node to improve your own liquidity

## Capacity

The capacity of your node is calculated by summing up the size of all your node’s public channels. To increase your node’s capacity, [open new channels](opening-channels.md) or acquire them on [Lightning Pool](../pool/).

## Age

Your node’s age is determined through the oldest still active public channel of your node. Keep your channels alive by managing their liquidity instead of closing them. Keeping channels active longer allows their opening cost to amortize over a longer period, which may lower the routing fees you and your peers have to pay.
