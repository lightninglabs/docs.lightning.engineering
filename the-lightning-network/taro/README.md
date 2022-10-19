---
description: >-
  Taro is a new Taproot-powered protocol for issuing assets on the bitcoin
  blockchain.
---

# Taro

Taro is a new Taproot-powered protocol for issuing assets on the bitcoin blockchain that can be transferred over the Lightning Network for instant, high volume, low fee transactions. At its core, Taro taps into the security and stability of the bitcoin network and the speed, scalability, and low fees of Lightning.

Taro relies on Taproot, bitcoin’s most recent upgrade, for a new tree structure that allows developers to embed arbitrary asset metadata within an existing output. It uses Schnorr signatures for improved simplicity and scalability, and, importantly, works with multi-hop transactions over Lightning.

Throughout Bitcoin's history, there have been a number of proposals with regard to bringing assets to the Bitcoin blockchain. Taro advances those ideas by focusing on what Taproot enables in that realm. With a Taproot-centered design, Taro can deliver assets on Bitcoin and Lightning in a more private and scalable manner. Assets issued on Taro can be deposited into Lightning Network channels, where nodes can offer atomic conversions from Bitcoin to Taro assets. This allows Taro assets to be interoperable with the broader Lightning Network, benefiting from its reach and strengthening its network effects.

Taro uses a Sparse-Merkle Tree to enable fast, efficient, private retrieval and updates to the witness/transaction data and a Merkle-Sum Tree to prove valid conservation/non-inflation. Assets can be transferred through on-chain transactions, or over the Lightning Network when deposited into a channel.

Participants in Taro transfer bear the costs of verification and storage by storing Taro witness data off-chain in local data stores or with information repositories termed "Universes" (akin to a git repository). To check a Taro asset's validity, its lineage since its genesis output is verified. This is achieved by receiving a verification file of transaction data through the Taro gossip layer. Clients can cross-check with their copy of the blockchain and amend with their own proofs as they pass on the asset.

{% embed url="https://docs.google.com/presentation/d/1YgMG4MOjs5dHhlf77Zh0WOENXqB0JTV8ZarVjS8slyk" %}
Read more: Taro announcement presentation slides April 2022
{% endembed %}

Summary:

1. Allows assets to be issued on the bitcoin blockchain
2. Leverages taproot for privacy and scalability
3. Assets can be deposited into Lightning channels
4. Assets can be transfered over the existing Lightning Network

{% embed url="https://www.youtube.com/watch?v=-yiTtO_p3Cw" %}
Video: Taro, a New Protocol for Multi-Asset Bitcoin and Lightning
{% endembed %}

{% content-ref url="taro-protocol.md" %}
[taro-protocol.md](taro-protocol.md)
{% endcontent-ref %}

{% content-ref url="taro-on-lightning.md" %}
[taro-on-lightning.md](taro-on-lightning.md)
{% endcontent-ref %}

## Features & Limitations <a href="#docs-internal-guid-9b2bf3f9-7fff-60c9-5880-bd52d991db46" id="docs-internal-guid-9b2bf3f9-7fff-60c9-5880-bd52d991db46"></a>

Taro allows for a long list of features that make the protocol scalable, robust, and friendly for low-powered mobile devices in situations of limited bandwidth.

* Taro is light client-friendly: has low verification costs and needs only access to untrusted bitcoin transactions. Taro does not require knowledge of the entire blockchain.
* Taro allows for atomic swaps between Taro assets and BTC
* Taro can handle both unique and non-unique assets as well as collections.
* Taro allows for creative multi-signature and co-signatory arrangements.
* Taro channels can be created alongside BTC channels in the same utxo, allowing Taro to exist in the Lightning Network without consuming additional resources. For instance, Alice can create two channels with Bob in a single Bitcoin transaction, one containing a Taro asset, the other BTC
* Future features may include confidential transactions and zero-knowledge proofs as part of Taro transfers.

{% content-ref url="taro-protocol.md" %}
[taro-protocol.md](taro-protocol.md)
{% endcontent-ref %}

{% content-ref url="taro-on-lightning.md" %}
[taro-on-lightning.md](taro-on-lightning.md)
{% endcontent-ref %}

{% content-ref url="faq.md" %}
[faq.md](faq.md)
{% endcontent-ref %}

To learn more about the implementation of the Taro protocol, follow [this link to the `tarod` client](../../lightning-network-tools/taro/).

Further reading:

* [Taro Q\&A with Ryan Gentry - LNMarkets](https://lnmarkets.substack.com/p/51-ryan-gentry-on-taro-massive-stress)
