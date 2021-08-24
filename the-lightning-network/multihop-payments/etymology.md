---
description: Learn the essentials of payments in the Lightning Network.
---

# Etymology

The Lightning Network is primarily a payment network. Peers connect with each other and establish [payment channels](../payment-channels/) to transfer bitcoin between each other, either as recipients, senders or routers. 

Cryptography ensures that payments are made atomically, meaning they either fail completely or succeed, without a third party taking custody of the payment.

## Atomic Multi-path Payments \(AMP\)

Atomic Multi-path payments is an implementation of multi-path payments, which allows for a single payment to be routed in shards along different routes. AMP ensures that each payment shard cannot be claimed individually by the recipient, but rather only the whole payment \(all of the shards combined\) can be claimed. Additionally, AMP implements keysend, which allows sending funds solely by specifying a recipient's public key, without a Lightning invoice. AMP also allows the creation of static invoices, which can safely be paid multiple times.

[Also read: The guide to AMP](../../lightning-network-tools/lnd/amp.md)  
[Watch: Get AMPed: Making Atomic Multi-Path Payments](https://www.youtube.com/watch?v=PNSPXRflCSc)

## Hash Time-lock Contract \(HTLC\)

A Hash Time-lock Contract \(also sometimes Hashed Time-lock Contract\) is central to the mechanism of a Lightning payment. A HTLC is a bitcoin transaction that can either be redeemed by producing a secret preimage represented by a hash or by waiting for a predefined period of time. Lightning payments are made to this hash of the preimage, which has to be revealed by the recipient to claim the payment. If the payee does not reveal the preimage, the payment can be claimed back by the sender after a timeout period. When sending a payment along a payment route, each hop will make a payment to the same preimage, ensuring that the payment can either be claimed in its entirety or fail.

## Keysend

Keysend is the mechanism to make a Lightning payment knowing only the recipient’s public key. This enables streaming payments, donations and removes the requirement of prior interaction between payee and payer. Keysend is also the name of an implementation of this idea, today the concept of keysend is implemented as part of AMP.

## Lightning address

A Lightning address is a standard to look up LNURL pay requests on a http server. This allows us to associate email addresses with LNURL pay requests and make Lightning payments to usernames.

## Lightning invoice

A Lightning invoice is a bech32 encoded string containing all vital information to make a Lightning payment, such as the amount, recipient, features and payment hints in the case of a private node.

Also read: [Understanding Lightning invoices](https://docs.lightning.engineering/the-lightning-network/lightning-overview/understanding-lightning-invoices)

## LNURL

A Lightning Network URL is a bech32 encoded url, through which a Lightning wallet can interact with a server in an automated way. LNURLs can be an alternative to static invoices, allow for the withdrawal or redemption of funds, open channels or even authenticate users.

## Multi-path Payments \(MPP\)

Multi-path payments is the idea to route a payment along multiple routes to its destination. This can make it easier to route larger payments, but also help with costs and privacy. MPP is also the name of an implementation of this idea, today superseded by [AMP](../../lightning-network-tools/lnd/amp.md).

## Payment route

A payment route is the path a payment takes from the payer to the payee. Unless there exists a direct channel with sufficient capacity between the two, payments need to be routed through the network. This can be done along multiple routing nodes with the use of HTLCs. A single payment can not only be routed through multiple channels in serial, but also in parallel, using AMP.

## Static invoices

A static invoice is an invoice that does not expire and can be safely paid multiple times. AMP allows for the creation of static invoices, as do other proposals.

Also read:  
[Payment lifecycle](../lightning-overview/payment-lifecycle.md)

