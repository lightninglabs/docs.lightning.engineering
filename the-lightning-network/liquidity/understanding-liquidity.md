---
description: >-
  Liquidity in the Lightning Network is highly contextual. Learn what this means
  and how you can optimize your node's liquidity.
---

# Understanding Liquidity

In the context of the Lightning Network, liquidity refers to the ability to move funds between participants on the network. Correctly defining and [managing liquidity](manage-liquidity.md) can be complex on the Lightning Network, but this complexity is rewarded by the more fluid movement of value in comparison to other systems or networks.

The same satoshis held in our node may both provide liquidity to us while simultaneously consuming the liquidity of others \(or vice versa\). In general, we should expect to be compensated for providing liquidity while paying others to provide us with liquidity. Such arrangements should be mutually beneficial. But, one of the biggest challenges of the Lightning Network is appropriately pricing liquidity and building a reliable and efficient market around it.

## On-chain liquidity

The liquidity of on-chain bitcoin is likely the easiest to understand. An on-chain bitcoin transaction can be moved at any time for a predictable, but varying fee. This proposed fee does not guarantee the inclusion in a block, but rather represents a bid in a perpetual auctioning process in which miners pick the highest fee paying ~2MB worth of transactions from the mempool. They are included in a block, which are created on average every 10 minutes.

Some on-chain transactions, such as unilateral channel closures \(also called force closes\), have their own unique liquidity properties. Typically, the party initiating the force close will have to wait to spend their bitcoin, while the other side can spend their funds immediately. The length of the waiting period is defined when the channel is opened. It can range from just a day to a few weeks.

Such force closes may be the only way to retrieve funds from an “illiquid” channel if a peer hasn’t been online for a while. They could also be requested by the peer in case of data loss \([see static channel backup]()\) or they may be the result of a HTLC that has to be settled on-chain.

## Different nodes for different purposes

Depending on our primary use case for the Lightning Network, we may optimize our node differently. We might want to use it primarily to make payments, receive payments, or earn fees by routing payments for other users.

Based on that decision, our liquidity needs will differ. In some ways, the concept of capacity may overlap, but the quality of channels and whether they are private or public also plays a role.

### Payments

For someone primarily using the Lightning Network to make payments, liquidity is largely a matter of whether funds are held in well-connected channels. Depending on the nature of those payments, it might make sense to open a channel with the entity you are most frequently transacting with or to [identify a good routing node](../routing/identify-good-peers.md) that can reach those counterparties.

It might also make sense to only open fewer, larger channels rather than spreading your funds across multiple smaller peers. But, on the other hand, if you concentrate all funds in a single channel, your satoshis could be at risk of temporarily becoming illiquid if your peer goes offline or a channel is closed.

For a node that is solely used for making payments, it may be appropriate to open private channels, e.g. channels that are not announced to the network and therefore cannot be used for routing.

At times, your channels will need to be replenished. It might be most cost effective to fill your channels directly via the Lightning Network, for example by earning satoshis or withdrawing BTC from exchanges using Lightning.

Alternatively, [Lightning Loop](https://lightning.engineering/loop/) is a service that allows you to send on-chain Bitcoin directly into a Lightning channel \(Loop In\). [Loop](../../lightning-network-tools/loop/) can help manage channel liquidity for those using Lightning for payments by allowing them to stay connected to the network, instead of requiring them to open new channels.

### Receiving funds

If you are using the Lightning Network mainly to receive funds, the term liquidity is synonymous with inbound capacity. You will need to maintain channels with well connected peers, but keep your balance in those channels to a minimum.

This might require you to incentivize others to open channels with you. The easiest way to do so is to buy inbound capacity through [Lightning Pool](https://lightning.engineering/pool/), a non-custodial marketplace where users can purchase inbound liquidity from node operators.

In addition to Lightning Pool, you can [acquire inbound capacity](how-to-get-inbound-capacity-on-the-lightning-network.md) by making payments, using Lightning Loop, or by advertising your need for incoming capacity.

Similar to above, it may be advantageous to empty out existing channels rather than opening new ones. And, as long as the node is not used for routing payments, channels may be private.

### Routing liquidity

A routing node is providing liquidity to others and, as such, is required to have both inbound and outbound capacity. In the context of a routing node, the concept of liquidity can be difficult to assess.

Ideally, each channel will have some inbound and some outbound capacity with each large enough for a reasonably large payment. This means each channel should have a minimal inbound and outbound capacity in order to be able to route payments at any time.

There needs to be some mechanisms, automated or manual, to analyze the capacity of the channels, assess the traffic to each channel, and rebalance these channels. This will require you to set appropriate fees that make this rebalancing worthwhile.

Private channels are another consideration. A routing node will primarily have public channels that can be used for routing payments, but it may also accept private channels from others who primarily use the Lightning Network to make and receive payments.

Satoshis held in such private channels with mobile nodes are liquid from the perspective of the private node as it can come online to send or receive payments. The routing node, however, will find its satoshis highly illiquid inside of these private channels, and satoshis held in these channels should not be counted towards the sending and receiving capacity of a node. It only has the option to force-close the channel or wait until the peer comes online for a cooperative close.

Such private channels however can be a great source of routing income, especially when the peer both spends and receives regularly.

There are other cases where a routing node provides liquidity to others by locking up or committing its funds in channels with others.

A node set up primarily to receive payments might have to keep its balance low for operational reasons, and any funds forwarded into this channel might be quickly “pushed back” by the recipient \(i.e. to an exchange or to pay suppliers\).

While such a channel might appear to be unbalanced and consume significant amounts of capital, it might function as intended by providing the routing node with stable income from routing fees. Depending on the traffic to such a merchant, it may be appropriate to replace the channel with a larger or smaller one to more efficiently deploy capital.

## Identify the needs of your own node and that of your peers

The concept of liquidity is highly contextual on the Lightning Network. To ensure your node functions properly with regard to your context, its channels and peers need to be carefully managed. In addition to understanding the liquidity needs of your own node, it is also important to understand the needs of your peers, such as whether they are primarily spending, receiving or routing funds.

