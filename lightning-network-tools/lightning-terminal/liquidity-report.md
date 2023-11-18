---
description: >-
  Lightning Terminal Liquidity reports provide node operators with a quick view
  over their inbound capacity
---

# Liquidity Report

Inbound liquidity, or inbound capacity, refers to the ability of a node to receive Lightning payments. This inbound liquidity comes at a cost, charged to the payer in the form of a fee rate. As inbound liquidity depletes, peers raise their fees, and finding a path becomes more difficult as the payer has to attempt more routes before their payment succeeds.

[Read more: Understanding Liquidity](../../the-lightning-network/liquidity/understanding-liquidity.md)

As a merchant, plentiful and economical inbound capacity is an important key to successfully accepting Lightning payments. For routing nodes too, inbound capacity is a determining factor in your ability to route payments

In [Lightning Terminal](./), navigate to “Loop” and click on “Liquidity Report” on the top right side to view your node’s liquidity report. For various simulated payment sizes, you can see the estimated fee somebody paying to your node would have to pay.

The “Routable Liquidity” graph shows how many channels you can get paid through at several fee levels. It can be displayed as an ordinary or cumulative histogram.

[Read more: How to get Inbound Capacity](../../the-lightning-network/liquidity/how-to-get-inbound-capacity-on-the-lightning-network.md)

The “Routable Inbound” graph places your channels into various fee buckets, and shows for each fee bucket how many channels have liquidity available.



<figure><img src="../../.gitbook/assets/Screenshot from 2023-11-17 21-28-57.png" alt=""><figcaption><p>Sample liquidity report</p></figcaption></figure>

Don’t rely on other participants of the Lightning Network to remotely detect your liquidity needs. Monitor your node’s inbound capacity and fees and actively manage your node’s liquidity. Attempt to free up additional capacity first, for instance through [Lightning Loop](../loop/), and only close channels that can’t be empty otherwise. Maximize your percentage of channels that have inbound capacity, rather than maximize the number of your channels. Keep channels open and allow their cost to be amortized over multiple cycles, rather than closing them after their liquidity has been depleted.

Needs Attention: Some fee ranges may be marked in red, indicating that no channels in that fee range have sufficient inbound capacity left. You may empty these channels by pushing satoshis out, for example into cold storage using Lightning Loop, or alternatively close them.

[Read more: Liquidity Management for Lightning Merchants](../../the-lightning-network/liquidity/liquidity-management-for-lightning-merchants.md)

Lightning Terminal’s Liquidity Report for now only takes into account local information, that is information gathered directly from your node. It visualizes available inbound capacity ordered by their remote fee, but does not take into account the quality of the inbound capacity. Channels might not always be useful for routing or receiving payments, for example in cases where the peer themselves lacks inbound capacity.
