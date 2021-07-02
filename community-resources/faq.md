---
description: Frequently Asked Questions about the Lightning Network
---

# FAQ

## **What is the Lightning Network?**

The Lightning Network is a payment protocol for utxo-based cryptocurrencies, such as Bitcoin or Litecoin. As a “second layer” protocol it uses the base layer only for dispute resolution or to deploy capital into channels. Through the Lightning Network, users are able to make instant payments at a low fee without consuming the scarce resources of the underlying blockchain. The Lightning Network helps achieve the promise of efficient payments without compromising on the security model of the base layer.

## What token does the Lightning Network use?

The Lightning Network does not have its own token. Instead, the Lightning Network uses the token of the underlying network/blockchain. The Bitcoin Lightning Network is the most well known. It uses bitcoin and its smaller denomination satoshis. There is also a Litecoin Lightning Network and theoretically other Lightning Networks could exist

## Is the Lightning Network centralized?

The Lightning Network is made up of Lightning nodes. Anybody can run a Lightning Node and join the network anonymously. There is no central entity controlling the network or denying users access to it. Payments in the Lightning Network are encrypted to make it difficult to enumerate payee or payer and censor transactions.

## Is the Lightning Network custodial?

In cryptocurrency, non-custodial systems allow the user to take full control of their funds. This comes at the benefit of having full ownership, but requires the user to manage their own keys \(i.e. the saying Not your keys, Not your coins\). Each peer in the Lightning Network holds the keys to their own funds in channels together with their peer in an arrangement called multi-signature. Safeguard mechanisms ensure that funds are not lost if the peer goes offline and that each change in balances requires cooperation from both nodes. Payments are routed atomically, meaning they either fail in full or succeed. Thus, no trust or preexisting relationship is needed between nodes. Given that, the Lightning Network is considered non-custodial.

## What is a node?

Like other networks the Lightning Network is made up of nodes and routes \(e.g. channels\) connecting these nodes. Individuals run compatible software, Lightning Network nodes, that communicate with each other and facilitate the basic functions of the network, such as opening and closing channels, making, receiving and routing payments.

## What is a payment channel?

Two nodes can open a payment channel with each other, which will require at least one of them to commit capital in an on-chain transaction. The initially committed capital defines the capacity of the channel over its lifetime. Once the channel has been created, it can be used by the two parties to transact with each other and as part of a route for others to transact through it.

## What is a route?

While a Lightning Network node may have multiple peers, it is infeasible for everyone on the network to be connected to everyone else. Instead, payments on the Lightning Network are routed through multiple nodes to their final destination. In this arrangement, the intermediaries are considered routing nodes and can collect a fee.

## Does the Lightning Network cost money?

To join the Lightning Network, it is required for either you or your peer to make at least one on-chain transaction, which incurs the regular transaction fees of the underlying blockchain. The two parties can then transact infinitely with each other at no cost. For a peer to route payments onwards to their peers, however, the peer typically charges a small fee. For a payment that traverses multiple hops, this fee is levied multiple times by each router. Fees are known in advance of attempting the payment, and, as the payer chooses the route also based on fees, competition ensures the network remains cost competitive.

## Do I need to run a node to use the Lightning Network?

A Lightning Network node is required to send and receive payments in the Lightning Network. However, these nodes do not need to be online permanently. They may be turned on and off at will. Such clients typically use private channels not announced to the larger network. And, they cannot route payments themselves. They can be downloaded as apps or be bundled with other applications.

## Can I make money on the Lightning Network?

On the Lightning Network, nodes that are able to efficiently route payments to their destination are rewarded with a fee. With care and diligence it is possible to earn a small return on the deployed capital. Unlike other mechanisms this returns comes without counterparty risk, but it is not risk-free.

## What risks are there in the Lightning Network?

Most software deployed in the Lightning Network is still considered beta software, meaning it may contain bugs that could lead to irrevocable loss of funds. For most operators, the biggest risks are data loss from power outages, hardware failures and bugs.

## Are Lightning Network payments anonymous?

Lightning Network payments have a different privacy model than on-chain payments. They are not announced to the entire network and even the intermediaries routing the payment network should not be able to infer the origin and destination of funds. Nonetheless, there are still several weak points that could allow an adversary to identify how money flows around the network and who is paying who.

## What is the market capitalization of the Lightning Network?

As the Lightning Network does not have its own token, it does not have a market capitalization. But, we do know the total number of public channels, as well as their total capacity. We can do this on our own machine or use a public Lightning Network explorer. However, we do not know how much funds are held in private channels in the Lightning Network, for example in mobile wallets or nodes exclusively used for sending payments.

## How can I observe the Lightning Network?

You can observe the Lightning Network graph from your own node. This will give you an idea of how many nodes and channels there are, what fees are being charged and how many Bitcoin are locked up in it. Some of this information is made available through [Lightning Network explorers](resource-list.md#explorers).

## Can I receive payments while being offline?

To perform a Lightning Network transaction, both peers as well as all routing nodes in between need to be online. For mobile wallets, this often requires keeping the wallet running until the payment is settled, after which the application or device can be turned off. From a safety perspective it is not important to keep a Lightning wallet permanently connected to the internet.

## Unanswered questions?

Still have questions? [You may submit your questions about the Lightning Network here](https://docs.google.com/forms/d/e/1FAIpQLSf1NQWyP_S_KjAHXQbRjVKPHwPm87xp1Ds94scjOhBYy_MJmA/viewform).

