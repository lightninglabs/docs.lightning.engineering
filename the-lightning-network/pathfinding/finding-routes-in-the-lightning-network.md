# Finding routes in the Lightning Network

In the Lightning Network, the sender decides on the payment route to the recipient. To do this, they need to know about all public nodes and channels, known as the graph.

To compute the most efficient path through a network of nodes is a well studied problem in mathematics known as graph theory, or knot theory.

Pathfinding algorithms typically treat the graph like a map, with each route between nodes having a unique cost, instead of a distance.

In addition to two separate fee structures for each channel (base fee and fee rate), pathfinding in the Lightning Network is further complicated by the channels’ capacity and their liquidity.

In practice, this means your Lightning node will create multiple possible paths to its destination, and try them successively.

LND’s routing algorithm is largely based on Dijkstra's algorithm. LND also ranks nodes it has successfully sent payments through to improve its pathfinding.

[Read more: Configure pathfinding in LND](../../lightning-network-tools/lnd/pathfinding.md)
