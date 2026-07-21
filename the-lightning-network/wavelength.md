---
description: A short overview over the principles that make Wavelength work.
---

# Wavelength

Wavelength is an ark-like settlement layer on Bitcoin. Each participant fully owns their own funds in the form of unpublished Bitcoin transactions (Virtual Transaction Outputs, VTXO). During regular operations, these vtxos do not have to be published to the Bitcoin blockchain, giving the impression that multiple individuals share a single Bitcoin utxo (Unspent Transaction Output), which minimizes onchain transaction fees.

Only when the operator is unavailable does it become necessary for the participants to publish their VTXOs and settle them onchain, allowing them to claim their funds. This incurs onchain fees but can be initiated at any time by any participant.

## Lightning Network

Wavelength is meant to be fully interoperable with the Lightning Network from the start. All users of Wavelength can receive and send funds over the Lightning Network without additional configuration or software. Eventual internal payments are also conducted through Lightning Network invoices, establishing the Lightning invoice as the conductive tissue between Wavelength and merchants, exchanges and other wallets, including among two participants of Wavelength.

## Lightweight and Ready to Go

Wavelength is designed as a lightweight daemon running on a server, desktop, mobile device or inside of a browser tab. It does not have to be continuously running to provide the user a good experience, and the user does not have to manage their own liquidity, but can always receive or send offchain or onchain.

## Boarding

Upon downloading and initializing Wavelength, the user may generate a Lightning Network invoice. This invoice pays to a [virtual HTLC (vHTLC)](multihop-payments/hash-time-lock-contract-htlc.md) and that only the user holds the preimage to. Once the vHTLC has been created in the fraction of a second, the user’s wallet claims their VTXO using the preimage, and the Lightning Network payment is settled.

Similarly, the user may generate a Bitcoin address, using their own key, the server’s key and a timeout. Any confirmed transactions to this address can then be swapped for a VTXO inside of Wavelength.

## VTXO

Virtual Transaction Outputs are spendable either cooperatively by the user and the server, or unilaterally by the user using a pre-signed transaction the user holds in memory. This allows VTXOs to be passed instantly without waiting to be included in blocks on the Bitcoin blockchain.

VTXOs may be split into change VTXOs, allowing arbitrary amounts to be settled. They may also be consolidated by swapping multiple small VTXOs for a larger one.

Unlike regular onchain transaction outputs, VTXOs expire after a pre-defined number of blocks. They have to regularly be rolled into new VTXOs, or else they are forfeited.

## Fees

Onchain fees occur when an onchain boarding transaction is swept or when at outgoing payment is made. They are generally passed on to the user. Unilateral exists also incur such onchain fees which have to be paid by the user. A new UTXO from an external wallet is typically required to pay such fees.

Lightning Network fees are relevant for all outgoing Lightning payments and are passed on to the user.
