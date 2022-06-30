# The Gossip Network

Lightning Network nodes announce themselves and their public channels to the broader network using a peer-to-peer gossip network. The gossip network also carries information on how to reach specific nodes and what fees they expect to forward funds.

To learn about the existence of other nodes and their channels, the Lightning Network maintains its own gossip network. The messages passed through the gossip network also include information about a peer’s alias, features they support and how to reach them.

The network also contains information about each channel, how it can be verified on the blockchain, and what fees its peers charge. Your node will use the gossip network to assemble the network graph.

This graph is necessary to calculate routes for payments. A pure routing node may not need this information, for example. You can query this information using your own node with the command:

`lncli describegraph`

There is no consensus over what the graph looks like. A new node might not hear about an older node’s update that has since dropped off the network, while another node might still have its information. A node may also remove channels from the graph if it believes its peers are no longer available, or haven’t been heard of in a while.

Peers often update their fees frequently, and each update has to be announced through the gossip network. This can make the gossip network appear very noisy and resource consuming.

Using the information gathered in the graph, we can calculate basic statistics, such as the total number of public nodes, their channels and capacity.

`lncli getnetworkinfo`

We can also perform calculations over the graph, such as each node’s centrality. Centrality is a measure of how many random routes in the network pass through a given node. The more central a node, the more hypothetical routes pass through it. While good routing nodes are often centrally located in the graph, optimizing your node for centrality is often not considered an ideal strategy as it is not a perfect proxy for routing fees.

Your node will calculate centrality scores for other nodes in the graph. You can obtain these scores with the command `lncli getnodemetrics`

To protect against spam attacks, Lightning nodes will only relay gossip messages from nodes that have at least one public channel, meaning you need to own up bitcoin and pay on-chain transaction fees.

## Notable components <a href="#docs-internal-guid-872d0d3b-7fff-33cd-80e6-5a95b1f8e587" id="docs-internal-guid-872d0d3b-7fff-33cd-80e6-5a95b1f8e587"></a>

There are three notable types of announcements made by nodes. These announcements are signed and forwarded to the announcer’s peers, validated, and passed on until they reach the entire network.

**`channel_announcement`**\
**``**The initial channel announcement is made cooperatively by both peers. This announcement proves that the channel exists on the blockchain and establishes which nodes it belongs to.

**`channel_update`**\
Once a channel has been announced cooperatively, it can be updated unilaterally by each party. This allows the parties to adjust terms with minimal effort, or to disable a channel when its peer is offline. Information relayed in this channel update includes fees and HTLC rules.

**`node_announcement`**\
Node announcements can only be made by nodes that have previously announced a channel. The node announcement will include information such as its alias, how to reach it and what features it supports.

[Read the Specs: BOLT 7 - P2P Node and Channel Discovery](https://github.com/lightning/bolts/blob/master/07-routing-gossip.md)

{% content-ref url="identify-good-peers.md" %}
[identify-good-peers.md](identify-good-peers.md)
{% endcontent-ref %}
