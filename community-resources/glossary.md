---
description: All your Lightning Network terms explained in one place.
---

# Glossary

## 9735 <a href="#docs-internal-guid-6e782ac0-7fff-815e-819f-b586cb362c5b" id="docs-internal-guid-6e782ac0-7fff-815e-819f-b586cb362c5b"></a>

The default port used by Lightning nodes to advertise incoming [peer-to-peer](glossary.md#peer-to-peer) connections.

## Aezeed

Aezeed is the mechanism through which the private keys of a [LND](glossary.md#the-lightning-network-daemon) node are derived from a [seed phrase](glossary.md#seed-phrase). Unlike other popular seed phrase formats, it allows for versioning and wallet birth dates.

## Anchor channel

Anchor channels include up to two special outputs called anchors which are used for timely [CPFP](glossary.md#cpfp) fee-bumping of [force-closed](glossary.md#force-close) channels.

## Aperture

Aperture is an implementation of a [LSAT](glossary.md#lsat) proxy server developed by [Lightning Labs](glossary.md#lightning-labs).

## Asset merge <a href="#docs-internal-guid-8c122d13-7fff-d2e4-025f-f17b4d82dff3" id="docs-internal-guid-8c122d13-7fff-d2e4-025f-f17b4d82dff3"></a>

If two assets of the same kind are combined, this is called an asset merge.

## Asset split <a href="#docs-internal-guid-43338575-7fff-10ef-e93b-ebf564e1a8a2" id="docs-internal-guid-43338575-7fff-10ef-e93b-ebf564e1a8a2"></a>

If an asset is divided into two parts, it is split.

## Atomic

Atomic refers to an action that is either completed in its entirety, or not at all. Lightning payments are atomic across routes, in that they either reach their destination or never leave their origin. [Submarine swaps](glossary.md#submarine-swap) are atomic, in that either the swap succeeds or funds never leave their origin, and [AMPs](glossary.md#atomic-multi-path-payments) are atomic in that either all [shards](glossary.md#shard) arrive at the destination, or none.

## Atomic Multi-path Payments

Atomic Multi-path Payments (AMP) is a payment standard that allows a payment to be made over multiple channels. Unlike [MPP](glossary.md#multi-path-payments) each individual [shard](glossary.md#shard) has its own [payment hash](glossary.md#payment-hash), which allows for payments being made [atomically](glossary.md#atomic). AMP also allows for static invoices and to send funds solely using the recipient's public key, as well as attaching messages to these payments.

[-> Further reading: Atomic Multi-path Payments explained](../lightning-network-tools/lnd/amp.md)

## Autoloop

Autoloop is a mechanism of [Loop](glossary.md#loop) to automatically perform [Loop In](glossary.md#loop-in) and [Out](glossary.md#loop-out) based on predefined thresholds. It is used for [liquidity management](glossary.md#liquidity-management).

## Base fee

A Lightning node can charge a fee for each forwarded payment. This fee includes the base fee, which is a constant amount charged for each forward, typically 1 [satoshi](glossary.md#satoshi).

## Base58

An encoding scheme for Bitcoin addresses conceived by [Satoshi Nakamoto](glossary.md#satoshi-nakamoto), consisting of both uppercase and lowercase letters and numbers. An example of a Base58 encoded address: 1JqDybm2nWTENrHvMyafbSXXtTk5Uv5QAn

[-> Further reading: Base58 in the Bitcoin source code](https://github.com/bitcoin/bitcoin/blob/master/src/base58.cpp)

## Basics of Lightning Technology

Basics of Lightning Technology (BOLT) is the name of the Lightning Network protocol standard. A given implementation of the Lightning Network needs to follow all rules laid out by the BOLT standard to be considered a full Lightning Node.

[-> Further reading: BOLT](https://github.com/lightning/bolts)

## Bech32

An encoding scheme for Bitcoin addresses and Lightning [invoices](glossary.md#invoice), recognizable by either being all uppercase or lowercase. Example of a bech32 address: bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4

[-> Further reading: Bech32 in the Bitcoin source code](https://github.com/bitcoin/bitcoin/blob/master/src/bech32.cpp)

## BIP157

BIP 157 is a standard that allows full Bitcoin nodes to serve Lightning Network light clients. It is often referred to as [Neutrino](glossary.md#neutrino).

[-> Further reading: BIP157 full text](https://github.com/bitcoin/bips/blob/master/bip-0157.mediawiki)

[-> Further reading: Enable Neutrino mode in Bitcoin Core](../lightning-network-tools/lnd/enable-neutrino-mode-in-bitcoin-core.md)

## Bitcoin

Bitcoin is a network established in 2009 by [Satoshi Nakamoto](glossary.md#satoshi-nakamoto). It introduces the bitcoin currency, which is used in the Lightning Network for fast and cheap payments.

## Bitcoin Core

Popular software used as a backend for [LND](glossary.md#the-lightning-network-daemon) to look up [on-chain](glossary.md#on-chain) balances and verify [channel](glossary.md#payment-channel) states. See also [bitcoind](glossary.md#bitcoind).

[Further reading: Bitcoin Core project website](https://bitcoincore.org/)

## bitcoind

The Bitcoin Daemon (bitcoind) is the most popular software used to connect to the Bitcoin network, verify and broadcast payments. It commonly serves as a backend for [LND](glossary.md#the-lightning-network-daemon). See also [Bitcoin Core](glossary.md#bitcoin-core).

[Further reading: Bitcoind source repository](https://github.com/bitcoin/bitcoin/)

## BoS

Balance of Satoshis (BoS) is software developed by Alex Bosworth to assist a [node](glossary.md#lightning-network-node) operator with setting [fees](glossary.md#fee) or [circular rebalancing](glossary.md#circular-rebalance).

[Further reading: BoS source repository](https://github.com/alexbosworth/balanceofsatoshis)

## btcd

BTCD is an implementation of the Bitcoin protocol written in go. It is a popular alternative to [bitcoind](glossary.md#bitcoind) for [LND](glossary.md#the-lightning-network-daemon) [node](glossary.md#lightning-network-node) operators

[Further reading: Btcd source repository](https://github.com/btcsuite/btcd)

## Chain

The Bitcoin Blockchain contains all transactions ever made in Bitcoin. A [LND](glossary.md#the-lightning-network-daemon) node uses [bitcoind](glossary.md#bitcoind) or [btcd](glossary.md#btcd) to inspect the chain and verify payment channels, as well as payments that were sent and received [on-chain](glossary.md#on-chain).

## Channel

See [Payment channel](glossary.md#payment-channel).

## Channel breach

When a [peer](glossary.md#peer) publishes an invalid [commitment transaction](glossary.md#commitment-transaction) in an attempt to steal funds, this is considered a channel breach. Such breaches need to be detected within the [time lock](glossary.md#time-lock-delta) either by the node or a [watchtower](glossary.md#watchtower) to be successfully contested.

## Channel point

The channel point is the [transaction ID](glossary.md#transaction-id) and [output ID](glossary.md#output-id) that establishes a Lightning channel. It is typically expressed by `<txid>:<output>`.

## Channel stability

A channel that is always online and able to route payments in both directions is considered stable. To be stable, a channel needs to have two stable [peers](glossary.md#peer) that carefully [manage their liquidity](glossary.md#liquidity-management).

[Read more: Lightning Terminal health checks](../lightning-network-tools/lightning-terminal/health-checks.md)

## Chantools

Chantools is a channel and fund recovery tool for -> Lightning nodes written by Oliver Gugger.

[Further reading: Chantools source repository](https://github.com/guggero/chantools)&#x20;

## Circular Rebalance

A circular rebalance is a payment from a node to itself through an external path, often used to shift balances from one channel to another.

## C-Lightning

C-Lightning is an implementation of a [Lightning Network node](glossary.md#lightning-network-node) written in C by Blockstream.

## CLTV

Check Lock-time Verify is a functionality in Bitcoin that allows us to lock Bitcoin for a period of time. It is an important part of the mechanism of a [commitment transaction](glossary.md#commitment-transaction). Defined in BIP 65.

[Further reading: BIP 65 full text](https://github.com/bitcoin/bips/blob/master/bip-0065.mediawiki)

## Clustering

Clustering allows us to use multiple [LND](glossary.md#the-lightning-network-daemon) nodes to form a cluster, in which we can delegate specific tasks such as managing invoices or maintaining channels for performance or security purposes.

[Read more: LND clustering](../docs/lnd/leader\_election.md)

## Commitment <a href="#docs-internal-guid-fc7665f8-7fff-4804-37ba-3f6dc9d9d776" id="docs-internal-guid-fc7665f8-7fff-4804-37ba-3f6dc9d9d776"></a>

In the context of cryptography, committing refers to the act of proving that certain data exists at a point in time, without necessarily revealing the data. Typically, this is done with a hash of the data. Only an entity that knows about the full data would have been able to produce a hash of it, thus, proving its existence.

## Commitment fee

The commitment fee is the fee a [commitment transaction](glossary.md#commitment-transaction) pays to the Bitcoin miner. Since the commitment fee needs to be calculated well in advance, it can sometimes be larger than necessary. [Anchor channels](glossary.md#anchor-channel) help alleviate this problem and better calculate this fee.

## Commitment transaction

The commitment transaction refunds you the balance in your [Lightning channel](glossary.md#channel) in the event that your [peer](glossary.md#peer) goes offline or becomes uncooperative. Also see [force closure](glossary.md#force-close).

## Check Sequence Verify

Check Sequence Verify is a functionality in Bitcoin that allows us to lock Bitcoin relative to its input transaction. It is an important part of the mechanism of a [sweep transaction](glossary.md#sweep). Defined in BIP 112.

[Further reading: BIP 112 full text](https://github.com/bitcoin/bips/blob/master/bip-0112.mediawiki)

## CPFP

Child Pays For Parent is a method of effectively increasing the fee of an unconfirmed [on-chain](glossary.md#on-chain) transaction (parent) by spending one of its [outputs](glossary.md#transaction-id) with a fee high enough to cover both the parent and the child transaction. To collect the high fee of the child transaction, a miner now has to include both the child and the parent transaction into a block. Unlike [RBF](glossary.md#rbf) this mechanism can also be used by the recipient of a transaction.

[Read more: Unconfirmed Bitcoin transactions](../lightning-network-tools/lnd/unconfirmed-bitcoin-transactions.md)

## Custodial Channel

A custodial channel is a channel that is not committed on the Bitcoin [blockchain](glossary.md#on-chain). As such, all funds in it are in the custody of one party.

## Eclair

Eclair is an implementation of a [Lightning Network node](glossary.md#lightning-network-node) written in Scala by ACINQ.

## Electrum

Electrum is a popular Bitcoin wallet written in Python originally by Thomas Voegtlin. It features a [Lightning Network node](glossary.md#lightning-network-node) implementation.

## Eltoo

Eltoo (from L2) is a proposed upgrade to the Lightning Network, enabling new functionalities.

## Explorer

An explorer is software or a service that lets you inspect transactions, nodes, and network metrics. There are explorers focusing mainly on on-chain data as well as Lightning Network explorers.

[Read more: Community Resources](broken-reference)

## Faraday

Faraday is analytics software developed by Lightning Labs that can help identify [liquidity needs](glossary.md#liquidity-management) and profitable channels in a [Lightning node](glossary.md#lightning-network-node).

[Read more: Faraday Guides](glossary.md#faraday)

## Fee

Fees might occur as part of [on-chain](glossary.md#on-chain) fees, which are paid to miners, or [off-chain](glossary.md#off-chain) fees, which are paid to [peers](glossary.md#peer) in the part of [base fees](glossary.md#base-fee) and the [fee rate](glossary.md#fee-rate).

[Read more: Channel fees](../lightning-network-tools/lnd/channel-fees.md)

## Fee rate

The fee rate is part of the [fee](glossary.md#fee) that each forwarded payment is charged by a node. The fee rate is measured in parts per million (ppm) of the forwarded payment, unlike the [base fee](glossary.md#base-fee).

## Force close

When a channel peer is unreachable, or when there is a fundamental disagreement over the state of a channel, the channel needs to be force closed by either party. A force close broadcasts the [commitment transaction](glossary.md#commitment-transaction).

## Fuzzing

Fuzz testing is the methodology of feeding invalid data to software with the intention of finding bugs and vulnerabilities.

[Read more: Fuzzing LND](../lightning-network-tools/lnd/fuzz.md)

## Gossip network

The Lightning gossip network is used to broadcast information about channels and peers.

## Graph

The Lightning Network graph contains information about all peers and their public channels, including [fees](glossary.md#fee) and [channel points](glossary.md#channel-point).

## gRPC

gRPC is a Remote Procedure Call tool developed by Google, used in [LND](glossary.md#the-lightning-network-daemon) for remote calls.

[Read more: LND API reference](https://api.lightning.community/)

## Hash Time-lock Contract

A Hash Time-lock Contract (HTLC) is a Bitcoin transaction that either pays to a peer revealing a [preimage](glossary.md#preimage) secret or allows the sender to claim the funds back after a [CSV](glossary.md#check-sequence-verify) certain period. The Lightning Network uses HTLCs to guarantee payments between peers.

[Read more: Hash Time-lock Contracts explained](glossary.md#hash-time-lock-contract)

## Hidden Service

See also [Onion Service](glossary.md#onion-service).

## Hodl invoice

A hodl invoice (also: hold invoice) is a regular [Lightning invoice](glossary.md#invoice), but the recipient will "hold" the [preimage](glossary.md#preimage). Hodl invoices are used for refundable deposits, for example in auctions.

## Inbound capacity

Inbound capacity is the amount of satoshis a node is able to receive through a given channel or all channels together. A channel's inbound capacity and [outbound capacity](glossary.md#outbound-capacity) together define a channel's total capacity, as defined at its creation.

[Read more: How to get inbound capacity](../the-lightning-network/liquidity/how-to-get-inbound-capacity-on-the-lightning-network.md)

## Invoice

To receive Lightning payments, the recipient typically issues an invoice containing information such as [public key](glossary.md#public-key), [payment hash](glossary.md#payment-hash) or an invoice amount and label. Invoices are defined in BOLT 11.

[Read more: Understanding Lightning invoices](../the-lightning-network/payment-lifecycle/understanding-lightning-invoices.md)

## Keysend

Keysend allows users of the Lightning Network to send funds to a node's public key.

[Read more: Send messages with keysend](../lightning-network-tools/lnd/send-messages-with-keysend.md)

## Leaf <a href="#docs-internal-guid-008d8ad9-7fff-b03b-3f77-c851c431877d" id="docs-internal-guid-008d8ad9-7fff-b03b-3f77-c851c431877d"></a>

A leaf is the part of a [Merkle tree](glossary.md#docs-internal-guid-43b3bcf6-7fff-bef3-8e7d-b1830f39b88b) that carries the data that the tree attests to.

## Lightning Labs

A private company helping to maintain [LND](glossary.md#the-lightning-network-daemon). Lightning Labs also develops tools like [Lightning Loop](glossary.md#loop), [Pool](glossary.md#pool), [Faraday](glossary.md#faraday), [Lightning Terminal](glossary.md#lightning-terminal), and more.

[Read more: Lightning Labs home page](https://lightning.engineering/)

## Lightning Network

The Lightning Network is a payment network built on top of Bitcoin. It uses [Lightning Channels](glossary.md#payment-channel) to route payments secured by [HTLCs](glossary.md#hash-time-lock-contract) backed on the Bitcoin Blockchain.

## Lightning Network node

A Lightning Network node is software that allows you to join the Lightning Network, make, receive and route payments. The full specification of a Lightning Node is laid out in [BOLT](glossary.md#basics-of-lightning-technology).

[Read more: Get started with LND](../lightning-network-tools/lnd/run-lnd.md)

## Lightning Node Connect

Lightning Node Connect (LNC) is a protocol to connect remotely to your [Lightning node](glossary.md#lightning-network-node) through a proxy.

[Read more: Lightning Node Connect under the hood](../lightning-network-tools/lightning-terminal/lightning-node-connect.md)

## The Lightning Network Daemon

The Lightning Network Daemon (LND) is a popular implementation of the Lightning Network written in Go and developed by [Lightning Labs](glossary.md#lightning-labs).

[Further reading: The LND source repository](https://github.com/lightningnetwork/lnd)

## Lightning Service Provider

A Lightning Service Provider (LSP) provides commercial [liquidity ](glossary.md#liquidity-management)and routing services on the Lightning Network. For example, a LSP might provide funds for automatic channel opening, inbound liquidity or routing information.

[Further reading: Lightning Service Providers](../the-lightning-network/liquidity/lightning-service-provider.md)

## Lightning Terminal

A web-based graphical interface and utility tool for [Lightning nodes](glossary.md#lightning-network-node). Runs [litd](glossary.md#litd) and uses [Lightning Node Connect](glossary.md#lightning-node-connect).

## Liquidity management

Liquidity management is the process of allocating funds to where they are needed or most productive. Liquidity management includes opening and closing channels, [circular rebalances](glossary.md#circular-rebalance) as well as transactions on [Lightning Loop](glossary.md#loop) and [Pool](glossary.md#pool).

[Read more: Understanding liquidity in the Lightning Network](../the-lightning-network/liquidity/understanding-liquidity.md)

## litd

The Lightning Terminal Daemon (litd) bundles [Lightning Loop](glossary.md#loop), [Lightning Pool](glossary.md#pool) and [Faraday](glossary.md#faraday) in a UI. It is run locally and allows for remote access to [Lightning Terminal](glossary.md#lightning-terminal) via [Lightning Node Connect](glossary.md#lightning-node-connect).

[Read more: Get litd](../lightning-network-tools/lightning-terminal/get-lit.md)

## LNCLI

The Lightning Node Command Line Interface (LNCLI) is part of the [Lightning Network Daemon (LND)](glossary.md#the-lightning-network-daemon). It is used to maintain a [Lightning Node](glossary.md#lightning-network-node) with [RPC](glossary.md#rpc) calls.

## LNURL

A Lightning Node URL is a URL encoded in [bech32](glossary.md#bech32) with the prefix `lnurl`. It is commonly used to make payments, withdrawals and even authentication.

[Further reading: LNURL specification](https://github.com/fiatjaf/awesome-lnurl)

## Loop

Loop is a non-custodial service by [Lightning Labs](glossary.md#lightning-labs) to perform [Submarine Swaps](glossary.md#submarine-swap) between [on-chain](glossary.md#on-chain) and [off-chain](glossary.md#off-chain) bitcoin.

[Read more: Loop](https://docs.lightning.engineering/lightning-network-tools/loop)

## Loop In

Loop In is the process of sending on-chain bitcoin and receiving the equivalent (minus fees) in your Lightning [channel](glossary.md#payment-channel) using [Lightning Loop](glossary.md#loop).

## Loop Out

Loop Out is the process of making a Lightning payment and receiving an equivalent amount (minus fees) in your [on-chain](glossary.md#on-chain) Bitcoin wallet using [Lightning Loop](glossary.md#loop).

## LSAT

The Lightning Service Authentication Token (LSAT) combines [Macaroons](glossary.md#macaroon) with [preimages](glossary.md#preimage) as proof of payment to create tickets for paid APIs or other services that require authentication and payment.

[Read more: LSAT](../the-lightning-network/l402/)

## Macaroon

Macaroons are bearer credentials that allow for detailed attenuation as well as delegation.

[Read more: Macaroons explained](../the-lightning-network/l402/macaroons.md)

## Merkle Sum Tree <a href="#docs-internal-guid-da9e136d-7fff-c284-15eb-82132eee8d94" id="docs-internal-guid-da9e136d-7fff-c284-15eb-82132eee8d94"></a>

A Merkle Sum tree is a type of [Merkle tree](glossary.md#docs-internal-guid-43b3bcf6-7fff-bef3-8e7d-b1830f39b88b-1) in which each [node](glossary.md#docs-internal-guid-21c32320-7fff-b611-c280-9057de469d80) not only carries the hash of the nodes or [leaves](glossary.md#docs-internal-guid-008d8ad9-7fff-b03b-3f77-c851c431877d) underneath, but also the sum of their values. In such a tree, the [Merkle tree root](glossary.md#docs-internal-guid-e842530e-7fff-01a9-e250-7c8de9edba95) will carry the total sum of all values in the Merkle tree.

## Merkle tree <a href="#docs-internal-guid-43b3bcf6-7fff-bef3-8e7d-b1830f39b88b" id="docs-internal-guid-43b3bcf6-7fff-bef3-8e7d-b1830f39b88b"></a>

A Merkle tree is a data structure that commits to multiple sets of data using a single identifying hash, the -> Merkle tree root. The data that the tree commits to lies at the [leaves](glossary.md#docs-internal-guid-008d8ad9-7fff-b03b-3f77-c851c431877d). Two leaves are hashed into a node, two nodes are hashed into a higher level node. The top node makes up the root.

## Merkle tree node <a href="#docs-internal-guid-21c32320-7fff-b611-c280-9057de469d80" id="docs-internal-guid-21c32320-7fff-b611-c280-9057de469d80"></a>

A Merkle tree node is a hash of either two [leaves](glossary.md#docs-internal-guid-008d8ad9-7fff-b03b-3f77-c851c431877d), or two nodes of a lower level.

## Merkle tree root <a href="#docs-internal-guid-e842530e-7fff-01a9-e250-7c8de9edba95" id="docs-internal-guid-e842530e-7fff-01a9-e250-7c8de9edba95"></a>

The Merkle tree root is a single hash that identifies all data in a [Merkle tree](glossary.md#docs-internal-guid-43b3bcf6-7fff-bef3-8e7d-b1830f39b88b). If a single bit in the tree changes, the root changes too.

## Millibitcoin

A millibitcoin is a thousandth of a bitcoin, or 0.001 BTC.

## Millisatoshi

A millisatoshi is a thousandth of a [satoshi](glossary.md#satoshi), or a 100 billionth of a bitcoin.

## Multi-path Payments

A Multi-path Payment is a Lightning payment that reaches its destination through multiple routes in parallel. MPP and [AMP](glossary.md#atomic-multi-path-payments) are both an implementation of this idea.

[Read more: Multi-path Payments](https://docs.lightning.engineering/the-lightning-network/multihop-payments/multipath-payments-mpp)

## Multisignature address

A multisignature bitcoin address is an address from which bitcoin can only be spent with multiple signatures. A multisignature address can be m of n, meaning that n keys exist, and m signatures need to be present. Lightning [channels](glossary.md#payment-channel) use 2-of-2 multisignature accounts.

## NAT

Network Address Translation is used to operate multiple networked devices behind a single IP address, for instance at home behind a router. NAT can pose a challenge to running [Lightning nodes](glossary.md#lightning-network-node) at home, requiring instead tools such as [Tor](glossary.md#tor) and [LNC](glossary.md#lightning-node-connect).

## Neutrino

Neutrino is a technology that allows a [LND](glossary.md#the-lightning-network-daemon) node to use a remote [Bitcoin](glossary.md#bitcoind) node as a back end, making it possible to run a Lightning node on a low-powered device such as a phone. See also [BIP 157](glossary.md#bip157).

## Noise

Noise is the encryption protocol used to establish and authenticate communications between Lightning nodes.

[Further reading: Noise protocol](http://noiseprotocol.org/)

## np2wkh

A 'nested pay to witness key hash' is a segwit address encoded similarly to a legacy address in [Base58](glossary.md#base58). They begin with '3'.

## Off-chain

Off-chain is any transfer or action taken on the Lightning Network. Such transactions are not settled directly on the Bitcoin blockchain.

## On-chain

On-chain transactions and actions are those settled directly on the Bitcoin blockchain, for instance a traditional Bitcoin transaction made to a Bitcoin address.

## Onion address

An onion address is an identifier, similar to a url, pointing to a -> onion service. It usually comes in the form of a long, all-lowercase string ending in .onion.

## Onion routing

Onion routing describes the methodology of encrypting messages inside of encrypted messages, which are passed from hop to hop. Each hop is only able to decipher messages intended for itself, not any predecessor or successor. Onion routing is used to transfer data in the [Tor Network](glossary.md#tor) as well as to pass on payments and messages in the Lightning Network using [Sphinx](glossary.md#sphinx).

## Onion Service

An Onion Service is a HTTP endpoint available only through the [Tor Network](glossary.md#tor). Lightning Nodes often use Onion Services to hide their location or make themselves available behind a [NAT](glossary.md#nat). Onion Services typically end in .onion.

[Further reading: Onion Services explained](https://community.torproject.org/onion-services/overview/)

## Outbound capacity

Outbound capacity describes the amount of satoshi a node is able to send through a single channel, or all channels together.

[Read more: Managing liquidity on the Lightning Network](../the-lightning-network/liquidity/manage-liquidity.md)

## Output ID

See - [Transaction ID](glossary.md#transaction-id)

## p2wkh

Pay to witness key hash is a Bitcoin address format. They are encoded with [Bech32](glossary.md#bech32), start with bc1q and are also referred to as "native segwit" addresses.

## Pairing phrase

A pairing phrase looks similar to a [seed phrase](glossary.md#seed-phrase) and is used in [Lightning Node Connect](glossary.md#lightning-node-connect) to authenticate and secure a remote connection.

[Read more: Connect to Lightning Terminal](../lightning-network-tools/lightning-terminal/connect.md)

## Partially Signed Bitcoin Transactions

Partially signed Bitcoin transactions (PSBT) are a standard on how to pass incomplete, or partially signed transactions between wallets. This can be useful for multi-signature wallets and complex scripts and is used in LND to handle [watch-only wallets](glossary.md#watch-only-wallet).

[Read more: Partially signed bitcoin transactions](../lightning-network-tools/lnd/psbt.md)

## Pathfinding

The process of finding a [route](glossary.md#route) for a payment. This is typically done by the payer, who might have to compute and try multiple routes before the payment succeeds.

## Payment channel

Payments channels are 2-of-2 multisignature accounts held cooperatively by two peers, secured by [commitment transactions](glossary.md#commitment-transaction). Payment channels make up the Lightning Network.

## Payment hash

A payment hash is the hash of the [preimage](glossary.md#preimage). A Lightning payment is made to this hash and can be claimed once the preimage is revealed.

## Peer

In the Lightning Network, a peer is another node you connect to, possibly open a [channel](glossary.md#payment-channel) and routing payments through them. Anyone can start a node and become a peer, making Lightning a [peer-to-peer network](glossary.md#peer-to-peer).

[Read more: Identifying good peers in the Lightning Network](../the-lightning-network/the-gossip-network/identify-good-peers.md)

## Peer-to-peer

A peer-to-peer network is any system not relying on a leader, in which connections are made directly between peers without intermediaries.

## Polar

Polar makes it easy to locally simulate the Lightning Network for testing purposes. Developed by Jamal James.

[Further reading: Polar website](https://lightningpolar.com/)

## Pool

Lightning Pool is a marketplace for channel liquidity run by [Lightning Labs](glossary.md#lightning-labs). Through auctions, participants can signal a need for liquidity or offer to open channels to others for a fee.

[Read more: Pool](../lightning-network-tools/pool/)

## Preimage

A preimage is a random number generated by the payee, hashed and passed to the payer as part of the [invoice](glossary.md#invoice). The preimage is revealed upon successful receipt of the payment, allowing each participant along the [route](glossary.md#route) to claim their funds as part of the [HTLCs](glossary.md#hash-time-lock-contract).

## Private Channel

A private channel is a channel that is not announced to the network. As such it cannot be used for routing, and when receiving payments through a private channel its information needs to be included in the [invoice](glossary.md#invoice).

## Probing

Probing is the act of attempting payments through the Lightning Network without settling them in an attempt to discover routes or reveal channel capacity.

## PTLC <a href="#docs-internal-guid-f7f705f0-7fff-5ce7-0536-1425d31c86d4" id="docs-internal-guid-f7f705f0-7fff-5ce7-0536-1425d31c86d4"></a>

Point Time-locked Contracts (PTLCs) are a proposed improvement on [HTLCs](glossary.md#hash-time-lock-contract). It uses homomorphic one-way functions instead of hashes. When using PTLCs, there is no single [preimage](glossary.md#preimage) across a [payment route](glossary.md#route), but instead each hop calculates its own secret.  Using unique secrets per hop reduces the ability of an intermediary to trace the route a payment takes in the Lightning Network.

## Public key

In cryptography, a public key can be used to verify signed data, as well as encrypt data for a recipient. In the Lightning Network each [node](glossary.md#lightning-network-node) is identified by its public key. This key is used to handle [Onion](glossary.md#onion-routing) routing, [keysend](glossary.md#keysend) messages, peer-to-peer communications and other data.

## RBF

Replace by Fee is a mechanism that allows the sender of an unconfirmed [on-chain](glossary.md#on-chain) Bitcoin transaction to replace the transaction with a higher fee transaction in the hope of getting it included into a block sooner.

[Read more: Unconfirmed Bitcoin transactions](../lightning-network-tools/lnd/unconfirmed-bitcoin-transactions.md)

## REST

"Representational State Transfer" or REST is a software architecture style developed for the world wide web. [LND](glossary.md#the-lightning-network-daemon) offers a RESTful API, which follows the constraints set out in that standard.

## RevokeAndAck

RevokeAndAck is the process of revoking a previous [commitment transaction](glossary.md#commitment-transaction) and acknowledging a new state in a channel. It's a fundamental piece of how payments are forwarded and canceled in the Lightning Network.

## Route

The path a Lightning payment is taking from payer to payee. In the Lightning Network, the payer [chooses the route](glossary.md#pathfinding), [encrypts](glossary.md#sphinx) it and passes the payment on to the first [peer](glossary.md#peer), who passes it onto the [next peer](glossary.md#peer-to-peer).

## RPC

Remote Procedure Calls are a popular way of interfacing with [LND](glossary.md#the-lightning-network-daemon). Specifically, LND supports the [gRPC](glossary.md#grpc) interface.

## Satoshi

A satoshi is 1/100 millionth of a Bitcoin. In the Lightning Network a satoshi is further divisible into 1000 pieces ([millisatoshi](glossary.md#millisatoshi)). It is named after Bitcoin's creator, [Satoshi Nakamoto](glossary.md#satoshi-nakamoto).

## Satoshi Nakamoto

Satoshi Nakamoto is the pseudonym behind the creator(s) of Bitcoin.

## SCB

Static channel backups (SCB) contain information about each channel peer and how to reach them. They are encrypted with a node's public key and can be used to request a remote [force closure](glossary.md#force-close) of a channel in the event of a catastrophic failure.

[Read more: Planning for failure](../lightning-network-tools/lnd/recovery-planning-for-failure.md)

## Seed phrase

A seed phrase is a collection of typically 12 to 24 words from which cryptographic keys are derived. This makes it possible to back up a series of private keys, for instance for multiple bitcoin addresses in a wallet with a single piece of static information. [LND](glossary.md#the-lightning-network-daemon) uses [aezeed](glossary.md#aezeed) to derive private keys from a seed phrase.

## Shard

A shard is a splinter of glass. In the context of the Lightning Network, a shard is a part of a [Multi-path payment](glossary.md#multi-path-payments), such as MPP or [AMP](glossary.md#atomic-multi-path-payments).

## Sidecar channel

A sidecar channel refers to a channel purchased on [Lightning Pool](glossary.md#pool) for a third party. Sidecar channels allow an auction participant to buy channels for others, for example mobile wallets that are not participating in the auction process directly.

[Read more: Sidecar channels](../lightning-network-tools/pool/sidecar\_channels.md)

## Sidecar ticket

A sidecar ticket allows the recipient of a [Sidecar channel](glossary.md#sidecar-channel) purchased on [Pool](glossary.md#pool) to redeem the channel. The seller will then open the channel to the ticket holder.

## Sparse Merkle Sum Tree <a href="#docs-internal-guid-9206b97f-7fff-0188-662e-146ccef6354a" id="docs-internal-guid-9206b97f-7fff-0188-662e-146ccef6354a"></a>

A Sparse Merkle Sum tree (SMST) combines the properties of a -> Sparse Merkle tree and a [Merkle Sum tree](glossary.md#docs-internal-guid-da9e136d-7fff-c284-15eb-82132eee8d94).

## Sparse Merkle Tree <a href="#docs-internal-guid-3885545f-7fff-a51b-405a-54b62b6131d5" id="docs-internal-guid-3885545f-7fff-a51b-405a-54b62b6131d5"></a>

A Sparse Merkle Tree (SMT) is a data structure that, in addition to a normal [Merkle-tree's](glossary.md#docs-internal-guid-43b3bcf6-7fff-bef3-8e7d-b1830f39b88b) ability to produce inclusion proofs, is able to provide non-inclusion proofs. This is achieved by placing an object at a [leaf](glossary.md#docs-internal-guid-008d8ad9-7fff-b03b-3f77-c851c431877d) location defined by the binary expression of the SHA256 digest of that data.  Each bit, of the digest, expresses the left-right traversal in a binary tree to locate the object.  When the contents of many of the leaves are empty, many of the branches are null, leading to efficient computation during SMT generation and modification.

## Sphinx

Sphinx is the name of the protocol by which the Lightning Network implements [onion routing](glossary.md#onion-routing).

[Further reading: Sphinx research paper](https://www.researchgate.net/publication/336890138\_Sphinx\_A\_Transport\_Protocol\_for\_High-Speed\_and\_Lossy\_Mobile\_Networks)

## Submarine swap

A submarine swap is a type of [atomic](glossary.md#atomic) swap in which -> on-chain bitcoin are swapped for off-chain bitcoin without either party assuming custody of the other's funds.

[Read more: Understanding Submarine swaps](../the-lightning-network/multihop-payments/understanding-submarine-swaps.md)

## Sweep

Funds held in some types of addresses have to be sweeped, meaning they have to be spent as soon as possible and sent to the user's main wallet. Mainly, this is done because they might otherwise not be recoverable in the event of data loss.

## Taproot

Taproot is a bitcoin transaction type introduced in November 2021 that allows for more advanced scripts, with major efficiency improvements relevant for the Lightning Network.

[Further reading: Taproot BIP 341 full text](https://github.com/bitcoin/bips/blob/master/bip-0341.mediawiki)

## Taproot Assets <a href="#docs-internal-guid-7cc2614e-7fff-6a58-76d9-4f295cc1a60e" id="docs-internal-guid-7cc2614e-7fff-6a58-76d9-4f295cc1a60e"></a>

Taproot Assets is a protocol for issuing assets on Bitcoin. It uses [Merkle Sum trees](glossary.md#docs-internal-guid-da9e136d-7fff-c284-15eb-82132eee8d94) and [Sparse Merkle trees](glossary.md#docs-internal-guid-3885545f-7fff-a51b-405a-54b62b6131d5) to commit assets to the Bitcoin Blockchain. Assets can be committed to [Lightning channels](glossary.md#channel) to instant transfers.

[Read more: Understanding Taproot Assets](../the-lightning-network/taproot-assets/)

## Time Lock Delta

Time lock deltas such as [CSV](glossary.md#check-sequence-verify) and [CLTV](glossary.md#cltv) are used in the Lightning Network to lock funds for a period of time, for example for arbitration purposes.

## Tor

The Onion Router (Tor) is a public relay network primarily built to hide the origin and destination of packets on the internet. It is popular among [Lightning Node](glossary.md#lightning-network-node) operators to make their nodes accessible through Tor to avoid [NAT](glossary.md#nat) barriers.

[Further reading: Tor project](https://www.torproject.org/)

## Transaction ID

The transaction ID (txid) is the hash of a bitcoin transaction. Channels are identified by the transaction id of their funding transaction, see [channel point](glossary.md#channel-point).

## Turbo channel

A Turbo channel is a channel accepted as valid with zero confirmations on the Bitcoin blockchain. It requires some trust in the initiator.

## Tweak <a href="#docs-internal-guid-c9ffc355-7fff-c791-8019-07b5dc545907" id="docs-internal-guid-c9ffc355-7fff-c791-8019-07b5dc545907"></a>

In the context of [Taproot](glossary.md#taproot), to tweak refers to the possibility of adding any data to the public key, in a way that anyone with the public key is able to verify the existence of this data. This is useful when [committing](glossary.md#docs-internal-guid-fc7665f8-7fff-4804-37ba-3f6dc9d9d776) to data, such as a [Merkle tree root](glossary.md#docs-internal-guid-e842530e-7fff-01a9-e250-7c8de9edba95).

## Unique assets <a href="#docs-internal-guid-7d0c14d2-7fff-73d5-eda7-4a5036028cbc" id="docs-internal-guid-7d0c14d2-7fff-73d5-eda7-4a5036028cbc"></a>

A unique asset is an asset that is not divisible, and cannot be exchanged for another asset of the same kind. This is contrary to fungible assets, such as money.

## Universe <a href="#docs-internal-guid-ed1dfbe4-7fff-b3c7-6199-85713fa053a6" id="docs-internal-guid-ed1dfbe4-7fff-b3c7-6199-85713fa053a6"></a>

A universe is a repository for [Taro](glossary.md#docs-internal-guid-7cc2614e-7fff-6a58-76d9-4f295cc1a60e) assets. It serves information such as metadata and proofs to prospective and existing users and holders of such assets.

## Unspent Transaction Outputs

Unspent transaction outputs (unspent utxos) are funds available [on-chain](glossary.md#on-chain), for example to make on-chain payments or to open [Lightning channels](glossary.md#payment-channel).

## Watch-only wallet

A wallet that is aware of balances and transactions, but does not possess the keys necessary to spend them. A watch-only wallet can create unsigned [PSBTs](glossary.md#partially-signed-bitcoin-transactions) which are then signed by the wallet holding the keys.

[Read more: Key import](../docs/lnd/key\_import.md)

## Watchtower

A watchtower consists of a client and a server. The client will share information relevant to [channel breaches](glossary.md#channel-breach) with the server, which will intervene in case they observe a breach on-chain. Watchtowers are needed in case the client is offline and unable to observe the breach themselves.

[Read more: Configuring Watchtowers](../lightning-network-tools/lnd/watchtower.md)

## Wumbo channel

In the early days of the Lightning Network, most clients would not allow opening channels larger than 16,777,215 (2^24 -1). Today, channels exceeding this limit are called Wumbo channels.

## Zero-confirmation channel

See also [Turbo channel](glossary.md#turbo-channel).

## ZMQ

ZeroMQ is a messaging library used by [Bitcoin Core](glossary.md#bitcoin-core) to inform other software, for example [LND](glossary.md#the-lightning-network-daemon) of new blocks and transactions.

## Zombie channel

A zombie channel is a channel that still exists on-chain and in the graph, but hasn't been active in a while and is unlikely to become active again. It is recommended to close such channels.
