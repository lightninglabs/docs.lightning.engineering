---
description: >-
  Understand how channels might differ from each other and how we describe their
  characteristics.
---

# Etymology

The Lightning Network is a network of payment channels. While all these channels share the same core characteristics, there may be subtle differences in how these channels are created, announced, treated or closed.

In this article, we explain these differences for various types of channels.

## Payment channel <a href="#docs-internal-guid-def45c7d-7fff-45bc-4e4e-ad87940fad49" id="docs-internal-guid-def45c7d-7fff-45bc-4e4e-ad87940fad49"></a>

All channels in the Lightning Network are payment channels. A payment channel is a 2-of-2 multisignature account with a balance on the bitcoin blockchain. This balance is held cumulatively by both parties, making up the capacity of the channel. The channel also has two internal balances, which are known only to the two signatories of the channel. This internal balance can be settled on the blockchain either cooperatively by both signatories signing a closing transaction, or unilaterally, by broadcasting a pre-negotiated force close transaction.

## Anchor channel

Anchor channels are an optional feature (feature bits `20`, `21`, `22` & `23`) for Lightning nodes such as LND. When unilaterally an anchor channel it is possible to increase the fees of this closure transaction according to market requirements by joining an extra UTXO. When enabling anchor channels in LND, it is required to keep at least 10k satoshis per channel with a maximum of 100k satoshis in the on-chain wallet.

## Channel capacity

Your channel’s total capacity is the amount of bitcoin you can send through it at once. Inbound capacity describes the amount you can receive from your peer at the other end of your channel, limited by that party's local or outbound capacity. Similarly, outbound capacity describes how many satoshis you can send through that channel to your peer. Your inbound and outbound capacity adds up to the channel's total capacity, as defined by the channel creation.

Read more: [Understanding liquidity in the Lightning Network](https://docs.lightning.engineering/the-lightning-network/liquidity/understanding-liquidity)

## Channel factories

Channel factories are a proposed mechanism to open multiple channels with a single UTXO. Instead of 2-of-2 multisignature addresses, channel factories allow a number of users to maintain a single UTXO through a n-of-n multisignature account, from which they can open and close channels with each other without having to make additional transactions. The only case where they would need to make an on-chain transaction would be if they want to remove their capital from the channel factory, for example to put it into cold-storage or join a different channel factory.

## Commitment fee

A commitment transaction needs to include an adequate network fee to ensure it gets confirmed when the channel is unilaterally closed. This fee is typically paid by the initiator of the transaction. Anchor channels allow for this commitment fee to be very small, as it can be increased at a later point using additional UTXOs.

## Commitment transaction

A commitment transaction ensures that either party of a channel is able to redeem their funds, even if the other party is no longer responsive or cooperative. A commitment transaction is a regular Bitcoin transaction that spends the funds in a channel to its peers. It is created before a channel is funded as part of the channel opening negotiation. Every time a payment is made inside the channel, a new commitment transaction is created, and its predecessor invalidated. The commitment transaction is at the core of the mechanisms that keep channel peers honest.

## Force Close

A force close is a unilateral close in which one participant can close a channel without the cooperation of the other participant. A force close is performed by broadcasting a "commitment transaction", a transaction that commits to a previous channel state that the channel participants have agreed upon. A force close is an important tool to allow Lightning Network participants to operate their nodes without relying on trusting their channel peers.

## Hosted channel (Custodial channel, virtual channel)

A hosted channel, also called custodial channel, is a channel that has not been committed on the blockchain. Its funds are not secured by the blockchain, but instead held in custody by a third party. Creating or closing these channels does not carry a cost, but instead requires trust in the host not to misappropriate the funds. Depending on the implementation, a hosted channel can be converted into a regular channel or UTXO in the event the custodian is not responsive.

## Inbound/outbound channel

The term inbound channel refers to [inbound and outbound liquidity](https://docs.lightning.engineering/the-lightning-network/liquidity/how-to-get-inbound-capacity-on-the-lightning-network), although in some contexts inbound channel might refer to a channel opened by another node to you, as opposed to a channel opened by you. Which side opens a channel carries little significance in the Lightning Network and is unobservable for a third party.

## Private channel

A private channel is a channel that is not announced to the Lightning Network, and, as a result, is not included in the network graph. Therefore, a private channel cannot be used for routing payments and should be the default channel type for all nodes that are not configured for routing payments, such as mobile wallets or wallets primarily used for personal spending and receiving. To receive payments into a private channel, the channel’s existence and policies are revealed to the payer through routing hints embedded in the invoice. For third-party observers, there may be other opportunities to reveal the existence of private channels, such as on-chain heuristics and coin tracing.

## Public channel

A public channel, as opposed to a private channel, is a channel announced together with its policies and peers to the wider network as part of the network graph.

## Sidecar channels

Lightning [Pool](../../lightning-network-tools/pool/) is a marketplace for liquidity in the Lightning Network. Participants can place their bids to buy and provision channels to other peers, including third parties not directly engaged on the parties. A sidecar channel is a channel opened by party A on behalf of party B to party C. This is useful for services that want to seamlessly onboard users and merchants onto the Lightning Network without providing capital themselves. It also helps decentralize the network, as the clients of such a service are getting connected to the network through a broader range of peers. Sidecar channels may also be deployed as [Turbo channels](etymology.md#turbo-channels-zero-conf-channels).

## Taproot channels

Taproot channels are channels anchored in a Taproot output, rather than a Segwit output. This allows for [Taproot Assets](../taproot-assets/) to be deposited into Lightning Network channels, and eventually becomes a prerequisite for Point Time Locked Contracts (PTLCs). Taproot channels are more private and more efficient when closed cooperatively than existing channels, but require a new gossip protocol to be announced to the graph. Unannounced ("private") Taproot channels are available in LND from version 0.17..

## Turbo channels (Zero-conf channels)

A turbo channel is a channel that is accepted without confirmations on the bitcoin blockchain. This requires trust in the party opening the channel to not double-spend the channel opening transaction. This trust may be gained by opening the channel from a 2-of-2 multisignature address held by the opening party and a co-signer trusted with not signing a double-spend transaction. Turbo channels are commonly used in mobile wallets and merchant services to allow users to immediately receive and send funds over the Lightning Network without having to wait for a channel to confirm on the blockchain.

## Zombie channels

A zombie channel is a channel that is not expected to be active again, for example because the peer has suffered from a failure or is no longer active. As zombie channels bind capital and cannot be used for routing, they [should be closed](../../lightning-network-tools/lnd/recovery-planning-for-failure.md) once it becomes unlikely the channel becomes active again. It may be difficult to assess whether a peer is only temporarily offline, especially when the peer in question is only coming online for sporadically receiving and sending payments.

## Wumbo channel

In the early days of the Lightning Network, nodes accepted only channels of at most 16,777,215 (2^24 -1) satoshis (0.168 BTC). Later, implementations gave users the option to accept channels of up to 10 BTC. These large channels are called Wumbo channels, in reference to a popular Spongebob Squarepants episode.

Also read:\
[Channel lifecycle](lifecycle-of-a-payment-channel.md)\
[Channel fees](../../lightning-network-tools/lnd/channel-fees.md)
