---
description: >-
  Taproot Assets is a new Taproot-powered protocol for issuing assets on the
  bitcoin blockchain.
---

# Taproot Assets

Taproot Assets (formerly Taro) is a new Taproot-powered protocol for issuing assets on the bitcoin blockchain that can be transferred over the Lightning Network for instant, high volume, low fee transactions. At its core, Taproot Assets taps into the security and stability of the bitcoin network and the speed, scalability, and low fees of Lightning.

Taproot Assets relies on Taproot, bitcoin’s most recent upgrade, for a new tree structure that allows developers to embed arbitrary asset metadata within an existing output. It uses Schnorr signatures for improved simplicity and scalability, and, importantly, works with multi-hop transactions over Lightning.

Throughout Bitcoin's history, there have been a number of proposals with regard to bringing assets to the Bitcoin blockchain. Taproot Assets advances those ideas by focusing on what Taproot enables in that realm. With a Taproot-centered design, Taproot Assets can deliver assets on Bitcoin and Lightning in a more private and scalable manner. Assets issued on Taproot Assets can be deposited into Lightning Network channels, where nodes can offer atomic conversions from Bitcoin to Taproot Assets. This allows Taproot Assets to be interoperable with the broader Lightning Network, benefiting from its reach and strengthening its network effects.

Taproot Assets uses a Sparse-Merkle Tree to enable fast, efficient, private retrieval and updates to the witness/transaction data and a Merkle-Sum Tree to prove valid conservation/non-inflation. Assets can be transferred through on-chain transactions, or over the Lightning Network when deposited into a channel.

Participants in Taproot Assets transfer bear the costs of verification and storage by storing Taproot Assets witness data off-chain in local data stores or with information repositories termed "Universes" (akin to a git repository). To check an asset's validity, its lineage since its genesis output is verified. This is achieved by receiving a verification file of transaction data through the Taproot Assets gossip layer. Clients can cross-check with their copy of the blockchain and amend with their own proofs as they pass on the asset.

Summary:

1. Allows assets to be issued on the bitcoin blockchain
2. Leverages taproot for privacy and scalability
3. Assets can be deposited into Lightning channels
4. Assets can be transferred over the existing Lightning Network

[Read more: Taproot Assets announcement presentation slides April 2022](https://docs.google.com/presentation/d/1YgMG4MOjs5dHhlf77Zh0WOENXqB0JTV8ZarVjS8slyk)

[Watch: Taproot Assets: A new protocol for multi-asset Bitcoin and Lightning](https://www.youtube.com/watch?v=-yiTtO\_p3Cw)

{% content-ref url="taproot-assets-protocol.md" %}
[taproot-assets-protocol.md](taproot-assets-protocol.md)
{% endcontent-ref %}

{% content-ref url="taproot-assets-on-lightning.md" %}
[taproot-assets-on-lightning.md](taproot-assets-on-lightning.md)
{% endcontent-ref %}

## Features & Limitations <a href="#docs-internal-guid-9b2bf3f9-7fff-60c9-5880-bd52d991db46" id="docs-internal-guid-9b2bf3f9-7fff-60c9-5880-bd52d991db46"></a>

Taproot Assets allows for a long list of features that make the protocol scalable, robust, and friendly for low-powered mobile devices in situations of limited bandwidth.

* Taproot Assets is light client-friendly: has low verification costs and needs only access to untrusted bitcoin transactions. Taproot Assets does not require knowledge of the entire blockchain.
* Taproot Assets allows for atomic swaps between assets and BTC
* Taproot Assets can handle both unique and non-unique assets as well as collections.
* Taproot Assets allows for creative multi-signature and co-signatory arrangements.
* Taproot Assets channels can be created alongside BTC channels in the same utxo, allowing Taproot Assets to exist in the Lightning Network without consuming additional resources. For instance, Alice can create two channels with Bob in a single Bitcoin transaction, one containing an asset, the other BTC
* Future features may include confidential transactions and zero-knowledge proofs as part of Taproot Asset transfers.

{% content-ref url="taproot-assets-protocol.md" %}
[taproot-assets-protocol.md](taproot-assets-protocol.md)
{% endcontent-ref %}

{% content-ref url="taproot-assets-on-lightning.md" %}
[taproot-assets-on-lightning.md](taproot-assets-on-lightning.md)
{% endcontent-ref %}

{% content-ref url="faq.md" %}
[faq.md](faq.md)
{% endcontent-ref %}

To learn more about the implementation of the Taproot Assets Protocol, follow this [link to the `tapd` client](../../lightning-network-tools/taproot-assets/).

Further reading:

* [Taproot Assets Q\&A with Ryan Gentry - LNMarkets](https://lnmarkets.substack.com/p/51-ryan-gentry-on-taro-massive-stress)
