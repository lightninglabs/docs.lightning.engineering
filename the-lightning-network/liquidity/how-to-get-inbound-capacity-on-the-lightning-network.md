---
description: >-
  To receive payments on the Lightning Network, you need inbound capacity. This
  article explains capacity and how you can acquire it.
---

# How to get inbound capacity on the Lightning Network

The ability to send and receive transactions on the Lightning Network depends on the existence of channels, as well as their capacity. Understanding channel mechanisms in detail is no longer a requirement to make use of the network to send and receive payments through specialized wallets, but it remains essential to effectively operate your own full node.

## Capacity on the Lightning Network

Bitcoin exists in the form of UTXOs, meaning unspent transaction outputs. Each of these UTXOs has an amount, typically expressed in BTC, bitcoin, SAT or satoshi. 100 million satoshis \(SAT\) equals 1 bitcoin \(BTC\).

When making a Bitcoin transaction, you can only spend up to the total sum of all UTXOs for which you have the key, but there are no limitations on how many UTXOs you can receive. Each UTXO you receive can be as large as needed and as small as the minimum relay size, called the Dust Limit.

On the Lightning Network, each channel is such a UTXO held in a 2-of-2 multi-signature contract between two parties. The value of the UTXO defines the channel capacity, the largest possible payment that can be handled by this channel.

The capacity of the channel not only limits the size of each payment through the channel, but also the balance held by either party in the channel.

When a channel is opened, the party opening the channel typically defines its overall capacity and initially contributes this capacity as their own capital to the channel. However, the other party may communicate limits, such as a minimum channel size, before the channel is opened.

### Total, inbound, and outbound capacity

Let’s consider Alice, who has 1 million satoshis in her wallet. She wants to open a channel with Bob. Using the command `lncli openchannel 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d 1000000` she opens a channel with Bob for her entire balance.

The overall capacity of this channel is now 1 million satoshis, which all belong to Alice, for the time being. Her sending or outbound capacity is now 1 million satoshis, as sending more than 1 million satoshis would exceed her balance. Alice can send her balance out in one transaction or in up to 1 million transactions.

Alice’s inbound or receiving capacity is zero, as receiving just a single satoshi would push her balance over the total capacity of the channel. Conversely, the inbound capacity for Bob is 1 million satoshis.

Alice makes a payment of 300,000 satoshis to Bob. Her balance is now 700,000 satoshis, but the total capacity of the channel remains unchanged. That means Alice can now receive up to 300,000 satoshis in payments until the 1M channel capacity is exhausted. We refer to these 300,000 satoshis as Alice’s inbound capacity.

On the contrary, Bob’s inbound capacity has shrunk to 700,000 while his outbound capacity has increased to 300,000 satoshis. The total capacity of the channel will not change unless another on-chain transaction is made \(only the inbound and outbound capacity are shifting\).

Alice’s inbound capacity = Bob’s outbound capacity  
Alice’s outbound capacity = Bob's inbound capacity

## Acquiring outbound capacity

We start with a node that has zero channels. To acquire outbound liquidity, we require Bitcoin, more precisely, a UTXO, which we use to open a channel with a good peer on the network. Ideally, this peer has perfect uptime, good connections and a good amount of capital.

\[[Guide: How to identify good peers on the Lightning Network.](../routing/identify-good-peers.md)\]

We can open a channel with the command `lncli openchannel [node key] local-amt`. Optionally, we can set a target for how quick we want the channel to be ready by specifying `--conf_target` or set the fee manually with `--sat_per_byte`.

If our node is purely for making and receiving payments, we could prefer not to route the payments of others. Thus, we may want to keep our node and its channels secret. We can do so by opening our channel with the `--private option`.

\[[Guide: How to use PBST to open a channel directly from an external wallet](../../lightning-network-tools/lnd/psbt.md)\]

Now, we have outbound capacity that can be spent and transferred through the Lightning Network. A channel typically requires the funding transaction to have three confirmations on the Blockchain to become active.

## Acquiring inbound capacity

We obtain outbound capacity by opening a channel with peers on the Lightning Network, a relatively straightforward process that allows us to send Lightning payments.

To be able to also receive Lightning transactions, however, we need to acquire inbound capacity. There are multiple options to do that:

1. **Spend satoshis**

The easiest and most obvious way to acquire inbound capacity is to spend our channel balance. We can use it to pay for things or exchange it for cash at an exchange that supports Lightning deposits.

Any lightning payment out of our channel will translate to the equivalent in inbound capacity. That means for every satoshi we spend, we gain one satoshi in inbound capacity, until our channel is empty and the total capacity of the channel is inbound capacity.

If you are using Lightning to send and receive payments, this single channel might be all you need to participate on the Lightning Network. But, your Lightning channel balance will not be able to exceed the capacity of your channel. If you want to receive more satoshis, you will have to increase your inbound capacity further.

2. \*\*\*\*[**Loop Out**](https://lightning.engineering/loop)\*\*\*\*

Using [Loop Out](https://lightning.engineering/loop), you can easily increase the inbound capacity of your node beyond your initial capital. [Lightning Loop](https://lightning.engineering/loop) is a marketplace that allows users to engage in Submarine Swaps. Generally, Submarine Swaps allow the exchange of two assets in a way that makes two transactions conditional on each other. Transaction A and B will either execute together, or not execute at all. This allows for two transactions to be swapped in a trustless way, reducing due diligence costs and removing the need for external enforcement of contracts.

In the context of acquiring inbound capacity, we will be performing a swap between an outbound Lightning transaction and an inbound on-chain transaction. Our existing channel balance will limit the size of the [Lightning Loop](https://lightning.engineering/loop) transaction. As each channel needs to maintain a small reserve, we might decide on spending about 80-90% of our channel balance on this Submarine Swap.

Once we have made our Lightning transaction to [Lightning Loop](https://lightning.engineering/loop), we should receive our balance back in the form of an on-chain transaction minus fees. We can use this new UTXO to open a second channel with a different node in the network.

As a result, we still have our original capital \(minus fees\), but about 80-90% more total capacity between our two channels. And, about 40-45% of our total channel capacity is now available for receiving Lightning payments.

3. **Buy a channel on** [**Lightning Pool**](https://lightning.engineering/pool)\*\*\*\*

We can also acquire inbound capacity by signaling a need for it and incentivizing others to open channels with us using their capital. [Lightning Pool](https://lightning.engineering/pool), a marketplace where bidders can pay well capitalized and connected nodes to open channels with them, allows us to do that. These nodes are compensated for opening these channels and commit to maintaining these channels for a specified period of time.

[Lightning Pool](https://lightning.engineering/pool) is a convenient way of acquiring large amounts of inbound liquidity quickly. It is the option of choice for node operators that depend on being able to receive Lightning transactions seamlessly, especially from a large group of users that might make deposits or payments.

## Channel fees

There are various kinds of transaction fees on the Bitcoin Blockchain and the Lightning Network. To open a channel requires the initiator to pay a transaction fee to Bitcoin miners, while a Lightning transaction pays fees to routing nodes that forward the payment to their final destination.

To account for the fees incurred in closing a channel, a small amount of the channel capacity will be reserved. As such it may not be possible to completely empty a Lightning channel using a Lightning transaction, and the channel balance may appear slightly smaller than the overall channel capacity.

