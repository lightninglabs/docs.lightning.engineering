---
description: >-
  Instant submarine swaps are a form of atomic swap that makes onchain funds
  immediately available without needing to wait for block confirmations.
---

# Instant Submarine Swaps

A submarine swap is a type of atomic swap that describes the trustless interchange of onchain and offchain funds. The swap either completes in full, or fails.

[Read more: Understanding submarine swaps](understanding-submarine-swaps.md)

Traditional submarine swaps, such as those used by Loop, require the recipient of the onchain funds to wait for block confirmations before they can take control over their funds.

Instant submarine swaps are more chain efficient and make funds available immediately once the Lightning payment has been completed and the preimage obtained. This can be still be accomplished without introducing trust into the procedure.

This is done by making a reservation ahead of time of the desired amount to be swapped. This gives the submarine swap provider more time to batch reservations and get the transaction confirmed at a lower fee. Each reservation is an output similar to an ordinary submarine HTLC.

The provider is able to retrieve their funds after a certain timeout has been reached, limiting their risk to the costs of the onchain transaction and the opportunity costs of funds locked.

The user is able to retrieve their funds using the preimage, which they can obtain through an invoice created at the time of the Instant Loop Out.

To make the process more efficient, the output of the reservation can be made spendable with a two-of-two MuSig2 schnorr signature. Both the provider and the user originally hold their own unique keys. Upon successful completion of the swap, the provider can co-sign transactions initiated by  the user, allowing the user to spend their funds without publicly revealing the preimage or paying more than the minimal onchain fees.

[Learn: How to make Instant Loop Outs](../../lightning-network-tools/loop/instant-loop-outs.md)
