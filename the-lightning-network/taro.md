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

## Concepts and topography

To understand Taro, we will need to make ourselves familiar with several concepts, some of which are novel, in the context of the bitcoin blockchain.

Learn about the basic concepts here:\
[Public-key cryptography](https://www.cloudflare.com/en-ca/learning/ssl/how-does-public-key-encryption-work/)\
[Cryptographic Hashes](https://resources.infosecinstitute.com/topic/introduction-to-hash-functions/)\
[Merkle trees](https://nakamoto.com/merkle-trees/)\
[Bitcoin UTXO](https://mirror.xyz/0xaFaBa30769374EA0F971300dE79c62Bf94B464d5/Yetu-6pZkbQCOpsBxswn\_7dGUZDxoBU8NrOQIZScwpg)

### Taproot transactions <a href="#docs-internal-guid-4d5379eb-7fff-d82b-c5fe-6c905a4ecb5e" id="docs-internal-guid-4d5379eb-7fff-d82b-c5fe-6c905a4ecb5e"></a>

Taproot is a new transaction type defined in [BIP 341](https://github.com/bitcoin/bips/blob/master/bip-0341.mediawiki) and fully functional on Bitcoin mainnet as of November 2021. The main difference of Taproot transactions to conventional Bitcoin transactions is that scripts controlling coins are contained within a tree structure called the 'tapScript branch' which is privately committed into the transaction. These scripts don’t need to be revealed if the KeySpend path is used to move the coins.

While a conventional transaction requires the entire script to be revealed, a Taproot transaction can be spent with a key to abstain from revealing the scripts and if the keyspend path is infeasible, only the executed portion of the script is revealed on the blockchain. All other script paths can remain private, or be selectively revealed off-chain.

This makes it possible to create more complicated scripts without the added cost of submitting extra data to the blockchain in the keySpend path, and efficient verification of a pruned script data. In the context of Taro, it allows us to provably attach arbitrary data to a transaction without revealing this data on-chain.

### Commiting to a hash: Taptweak

We refer to a transaction that includes such arbitrary data as a commitment. Once the transaction has been included in a block, we have committed to this data and can no longer change or amend it.

To commit to data, we tweak the public key of our Taproot spending key using a trick known as “Taptweak.” It allows us to selectively reveal the data without revealing the private key, or to spend the output without revealing the commitment.

This technique is used in Taproot transactions to commit to the Taproot script tree, and can be used to commit to any arbitrary data.

`Q= P+H(P|c)G`\
Q = the final Taproot public key\
P = the internal public key\
H(P|c) = A hash of the internal public key and the commitment

To sign a transaction with our private key, the private key needs to be tweaked with the same hash of the public key and commitment, H(P|c).

[Read: Taproot Is Coming: What It Is, and How It Will Benefit Bitcoin](https://bitcoinmagazine.com/technical/taproot-coming-what-it-and-how-it-will-benefit-bitcoin)\
[Watch: Bitcoin Optech Schnorr Taproot Seminar](https://bitcoinops.org/en/schorr-taproot-workshop/)

### Sparse Merkle trees <a href="#docs-internal-guid-5a068ff4-7fff-ecac-596d-f7631d0a2edd" id="docs-internal-guid-5a068ff4-7fff-ecac-596d-f7631d0a2edd"></a>

A Sparse (meaning ‘thinly scattered’) Merkle tree is a data structure in which it can be proven that specific data doesn't exist within a merkle tree. An SMT is an authenticated key-value store, meaning that the key, or location, of a leaf and the content of the leaf are bound to each other.

To achieve this property, the contents of the leaf are hashed and a merkle tree is created in which the leaf's position corresponds to the bitmap of the hash digest. By necessity, this requires a tree of 256 levels and 2^256 leaves. Generation of the tree is efficient--despite the apparently large size--because the overwhelming majority of the branches contain empty leaves and can be represented with nil hashes.

![Constructing a Sparse Merkle tre](<../.gitbook/assets/Merkle tree introduction B1.png>)

For example, we may create a Sparse Merkle tree using a fictitious hashing function of sha002, which results in a number between 0 and 3. We generate a Sparse Merkle tree with 4 leaves: 0, 1, 2 and 3. Only leaf 2 is populated, all other leaves are empty. To find leaf 2 (written 10 in binary), we go left at the first branch (1), then right at the second branch (0).

![Identifying leaves in a Sparse Merkle tree](<../.gitbook/assets/Merkle tree introduction B3.png>)

To verify leaf 2, we now only need to reveal the value at this leaf, plus the hash of leaf 3 and the hash of branch 0.

In Sparse Merkle trees, every leaf can be described as a guide to itself through a map when expressed in binary form. The map is the Sparse Merkle tree itself, and the guide is represented by instructions on whether to turn left or right at each fork. The 9th leaf in a 2^4 large Sparke Merkle tree for example is expressed in binary as 1001, meaning we find the appropriate leaf by turning left, then right, right and finally left.

This property is extremely useful for constructing and reconstructing the Sparse Merkle tree, as it describes precisely which parts of the Sparse Merkle tree we have to reconstruct. More importantly, the data in each leaf can now be described by their location in the tree.

Using the Sparse Merkle tree, we can associate data with public keys, and prove that we have deleted this data in an easily verifiable way without having to reveal the entire tree.

![](<../.gitbook/assets/Merkle tree introduction B5.png>)

Because every item has its predetermined location, the tree’s root hash is not dependent on the order in which items are inserted.

[See also: Plasma Cash](https://ethresear.ch/t/plasma-cash-plasma-with-much-less-per-user-data-checking/1298)

### Merkle sum trees

Merkle sum trees are a type of merkle tree that contains numeric values at each leaf, and each node also carries the sum of the values below it. At the root of the Merkle sum tree is the sum of total values in the tree.

Merkle Sum trees allow efficient verification of conservation (non-inflation) by committing to quantities associated with leaves.

[See also: Using Merkle sum trees for liability proof](https://blog.bitmex.com/addressing-the-privacy-gap-in-proof-of-liability-protocols/)

### Combining taproot, taptweak, sparse Merkle trees and Merkle sum trees <a href="#docs-internal-guid-562ab959-7fff-e882-7df8-7c4d7189830f" id="docs-internal-guid-562ab959-7fff-e882-7df8-7c4d7189830f"></a>

Taro makes use of a combination of the concepts above to allow for the issuance of Bitcoin-native assets. Sparse Merkle trees and Merkle sum trees are combined into sparse Merkle sum trees.

The root of this tree is added to a taproot tapscript, and together a taproot address is created.

Instead of its own blockchain, Taro issuers store sparse Merkle sum trees off-chain and issue proofs to asset holders out of band. The owners of such assets can independently verify that their account is included in the tree, is filled with the appropriate amount and the corresponding taproot transaction exists and is confirmed on the Bitcoin blockchain.

[Read the BIPs: Merkle Sum Sparse Merkle Trees](https://github.com/Roasbeef/bips/blob/bip-taro/bip-taro-ms-smt.mediawiki)

## Issuing assets

### Asset ID

To issue a Taro asset , we must first create its identifier. We create a 32-byte asset ID which is produced by hashing three elements: the outpoint being spent to mint the asset, an asset tag of the minter’s choice (e.g. a hash of a brand name) and meta information associated with the asset--such as links, images or documents.

`asset_id = sha256(genesis_outpoint || asset_tag || asset_meta)`

### Asset Script <a href="#docs-internal-guid-926da57d-7fff-edec-b9e3-ed00906dcf69" id="docs-internal-guid-926da57d-7fff-edec-b9e3-ed00906dcf69"></a>

The asset script can have inputs and outputs, similar to a Bitcoin transaction. A newly created asset does not contain any Taro inputs, while an asset transfer does.

The output of the asset script defines who the newly created assets are issued to. More precisely, this is done through a sparse Merkle sum tree, in which each account is identified by its 256-bit key, and each leaf corresponding to this key contains information about the amount the account holds.

It is possible to issue multiple assets in one transaction, but each asset will have its own asset script and within it, sparse Merkle tree. Assets can be unique or non-unique.

[Read the BIPs: Taro Asset Script](https://github.com/Roasbeef/bips/blob/bip-taro/bip-taro-vm.mediawiki)

### Asset leaves

Each leaf contains a TLV (type, length, value) blob, akin to the TLV used in the Lightning Network. It contains information such as versions, asset id, amount, as well as data pertaining to previous transfers of this asset, such as signatures.

### Commit to tree root

Once we have generated the sparse Merkle sum tree and asset script, we can tweak our internal public key and obtain the contract’s address and finalize the transaction.

### Publish transaction

Once we publish this transaction and have it confirmed on the bitcoin blockchain, we have irreversibly created the asset. To an observer, this transaction will look like any other standard taproot transactions.

### Asset proof

The asset issuer can now selectively reveal what assets were created and to whom they were allotted. Most importantly, the issuer can prove to the recipient that an asset has been transfered to them, by revealing a specific asset proof, which contains the asset script as well as the path of the sparse Merkle sum tree with the recipient’s account as the key.

The recipient can verify the partial sparse Merkle sum tree to recreate the script, tweak the issuer’s public key and verify that the genesis transaction exists on the blockchain, while the partial Merkle tree gives them assurance over the assets issued to them, as well as the total number of assets issued.

![Proving non-inclusion in a Sparse Merkle tree](<../.gitbook/assets/Merkle tree introduction B6.png>)

## Transferring assets <a href="#docs-internal-guid-ae0229ef-7fff-480d-ba27-14c268d89d16" id="docs-internal-guid-ae0229ef-7fff-480d-ba27-14c268d89d16"></a>

Taro assets can be transferred on-chain, or they can be used to open Lightning Network channels. In this chapter, we will discuss on-chain transactions only.

Exactly how individual account holders interact with each other is not prescribed by Taro, but can be application specific. Issuers are given flexibility in how they define their assets, or how they intend to restrict these assets.

The Asset Root Commitment commits to all assets held inside of the tree as well as their sum. The asset\_id is globally unique as it depends on the identifier of its genesis output. The overall root can comprise multiple asset\_ids whose conservation of funds is provided by verifying the asset\_tree\_root.

`asset_tree_root = sha256(asset_id || left_hash || right_hash || sum_value)`

### Taro Addresses <a href="#docs-internal-guid-9dd22c77-7fff-d40d-b240-51c0f6f07a08" id="docs-internal-guid-9dd22c77-7fff-d40d-b240-51c0f6f07a08"></a>

Taro addresses are bech32 encoded identifiers of the asset ID, the asset script hash, the internal key of the sparse Merkle sum tree and an amount, prefixed with Taro or Tarot (testnet).

`bech32(hrp=TaroHrp, asset_id || asset_script_hash || internal_key || amt)`

The issuer or asset holder can use the information in your Taro address to create or modify the sparse Merkle sum tree as explained below. This address format can also be used to request a specific proof over the amounts held by the address.

[Read the BIPs: Taro On Chain Addresses](https://github.com/Roasbeef/bips/blob/bip-taro/bip-taro-addr.mediawiki)

### Move assets inside the tree

To transfer Taro assets, the recipient communicates their address to the current holder, who can initiate the transfer. The exact interaction between account holders and issuers is not strictly defined at this time. It could be left up to each application or even asset issuer to specify.

The sender of the funds will need to generate a new sparse Merkle sum tree reflecting the new balances. This is done by reducing the balances of certain leafs and increasing the balances of other leafs. The sparse Merkle sum tree guarantees that no new assets are created in such a transaction and that the previous claims to the assets are fully relinquished.

![Identifying Accounts](<../.gitbook/assets/Merkle tree introduction C5.png>)

Creating assets requires a single on-chain taproot transaction, in which there is no limit on how many assets can be minted or how many accounts can hold these assets. To transfer assets, as explained above, requires reorganizing the Merkle tree and publishing a new on-chain transaction. There is no limit to how many internal Taro transactions are reflected in this single on-chain transaction.

Using this methodology, funds are allocated to account holders, represented as leafs in the sparse Merkle sum tree, but the ability to make such internal transfers is limited to the owner of the internal taproot private key(s).

### The Universe <a href="#docs-internal-guid-81622115-7fff-548d-5594-a7c4b43b97b3" id="docs-internal-guid-81622115-7fff-548d-5594-a7c4b43b97b3"></a>

A Universe is a service that provides information about assets as well as proofs for asset holders. It acts similarly to a bitcoin block explorer, but showcases Taro transaction data which is stored off-chain with Taro clients. The main difference is that, as most information related to Taro assets is off-chain, it is easier to conceal.

A Universe may be run by the asset issuer themselves or may be appointed by an issuer. It is also conceivable that community-run Universes aggregate information submitted by asset holders.

Given a known asset ID, the Universe for example may provide information about its Genesis output, as well as current meta information such as documentation, asset scripts or total coins in circulation. A service may also know about multiple assets (Multiverse) or only about a single output (Pocket Universe).

A Universe has no privileges within the Taro protocol. It produces transaction data validated against the bitcoin blockchain. An adversarial Universe could only refrain from returning data requested by clients. Taro transaction data isn’t bound to a Universe. The data availability offerings provided by a Universe is motivated by entities who wish to have fast, cheap verification of their Taro assets.

[Read the BIPs: Taro Asset Universes](https://github.com/Roasbeef/bips/blob/bip-taro/bip-taro-universe.mediawiki)

### Asset merge or split

Assets may be transferred internally within the assets’ sparse Merkle tree, as described above, or they may be sent to another taproot key holder. This is referred to as an asset split.

In an asset split, the sender will again first need to update the sparse Merkle sum tree of their own taproot output, adjusting the balance(s) and recalculating the Merkle root. In the case of a merge, the root sum will also change.

Additionally, there will be a second sparse Merkle sum tree committed to a new taproot output. This second Merkle tree is calculated by the recipient of the assets, who acts similarly to an issuer in the example above, with the difference that these assets aren’t created from nothing, but rather are split from a previous output, for example the asset’s genesis output.

### Asset proof <a href="#docs-internal-guid-c07ae888-7fff-b8c7-0394-06c7498c1d43" id="docs-internal-guid-c07ae888-7fff-b8c7-0394-06c7498c1d43"></a>

To be able to verify that the asset split has taken place, the operator of the new Universe needs proof that

* assets were created at transaction zero (t0)
* assets existed on a leaf in the original Merkle tree at t0
* the balance of this leaf was set to zero at t1
* the assets existed on a leaf of the new Merkle tree at t1

Once assets are split, the owner of the asset is able to perform internal transactions in the same way as the issuer. Each proof before the split will always need to include the Issuance proof for provenance verification.

Asset proofs grow linearly with each new on-chain transaction. Every asset transaction needs to be audited back to its Genesis output. An asset proof is only valid as long as the output it references is unspent on the blockchain.

### Invalidating assets

An asset is considered invalid as soon as its output has been spent without committing to a new sparse merkle sum tree. This is not obvious for a third party observer, and in some instances it may be preferable to spend outputs to a new empty merkle tree to prove that assets were destroyed, invalidated, or “burned”.

[Read the BIPs: Taro Flat File Proof Format](https://github.com/Roasbeef/bips/blob/bip-taro/bip-taro-proof-file.mediawiki)

## Taro-enabled channels <a href="#docs-internal-guid-8073d85d-7fff-f958-e660-b596e6d08d6d" id="docs-internal-guid-8073d85d-7fff-f958-e660-b596e6d08d6d"></a>

Taro assets can be deposited into regular taproot Lightning Network channels in addition to the bitcoin in the channel. HTLCs and PTLCs can be constructed for transfers in these Taro-aware payment channels similarly to how bitcoin is transferred.

Assets are transacted by creating nested HTLC/PTLCs which, if needed, can be claimed by the recipient by revealing a preimage, or by the sender after a timeout period. These transactions are Taro’s equivalent of Lightning Network transactions.

### Multi-hop Taro transfers

Historically, payment networks struggle with a bootstrapping problem -- any time a new asset is created, an entirely new payment network needs to be created to serve that specific asset's payment demand. Taro enables a payment-routing paradigm in which the LN is able to handle channels with any asset but with the ability to find routes across different assets. Taro assets in LN channels can be transferred over the general Lightning Network, for example in a situation in which all participants along a route have liquidity with each other. They can opt to charge fees in BTC or the transferred Taro asset.

Without a Taro route being needed, a BTC route can take its place as long as the first node is willing to forward the Taro value in satoshis. This can also allow the LN to facilitate exchange between bitcoin and Taro assets over the Lightning Network. This also allows the recipient of a payment to opt into receiving a Taro asset instead of BTC. In the example below, Bob and Carol both act as edge nodes and swap payments L-USD and BTC.

![An example of a Taro payment made to the wider Lightning Network](<../.gitbook/assets/Group 3881(1).png>)

This makes it feasible to receive a Taro asset but present the corresponding invoice to any other Lightning wallet - even those that do not opt into the Taro protocol - which pays it using BTC or any other Taro asset.

This maintains the Lightning invoice as the standard scheme for invoices. An invoice ultimately settled in Taro can be paid by BTC or any other Taro asset, and anyone with a Taro balance can pay any Lightning invoice.

![An example of a Taro payment in which the receiver opts to receive the same asset type.](<../.gitbook/assets/Group 3882(2).png>)

### Exchange rates <a href="#docs-internal-guid-08fce969-7fff-c159-5dda-e3434119debb" id="docs-internal-guid-08fce969-7fff-c159-5dda-e3434119debb"></a>

The Taro protocol itself does not define how to handle exchange rates. Each node performing swaps is responsible for determining its own exchange rate. They might use reference rates from liquid exchanges, or determine their own. It is important to note that when receiving a payment the recipient generates the invoice themselves, thus ensuring that the recipient receives the proper amount denominated in their desired asset.

Any Lightning Network node aware of Taro channels can potentially act as an edge node. They compete with each other over fees they collect from forwards and swaps. These fees include the routing fee, a swap fee or alternatively a spread.

When creating an invoice, the recipient (e.g. Zane in the example below) will ping their peer (e.g. Yana) for their current reference price. They use this reference price to generate a general Lightning Network invoice denominated in satoshis, including the hop hints and the channel policies and pass it on to the payer.

As the payer passes the payment through their constructed route to Zane, it passes Yana, who forwards L-EUR. Before releasing the preimage, Zane’s wallet can check whether it received the exact expected amount of L-EUR.

Due to fluctuations in conversion rates between Taro assets and Bitcoin, edge nodes may only guarantee rates for a limited amount of time when issuing invoices. When paying invoices, they may provide live quotes adjusted every second, locked for a limited time when a payment is attempted.

When paying a satoshi-denominated invoice through L-USD, Alice can ping Bob for his latest rates and fees. She can confirm the payment, passing the required amount of L-USD plus fees, and the recipient will only release the preimage if they receive the amount of satoshis they expected.

![Sender and recipient do not need to transact in the same asset type.](<../.gitbook/assets/Group 3881(2).png>)

Edge nodes may have other tools at their disposal if they fear abuse of their quoted forwards, such as closing a channel, reducing the validity of invoices or increasing spreads.

The Taro protocol does not regulate or set rates, but only provides for the mechanisms of a functional market with low technical barriers to entry and the tools that allow for automated, atomic, and instant forwards.

## Features & Limitations <a href="#docs-internal-guid-9b2bf3f9-7fff-60c9-5880-bd52d991db46" id="docs-internal-guid-9b2bf3f9-7fff-60c9-5880-bd52d991db46"></a>

Taro allows for a long list of features that make the protocol scalable, robust, and friendly for low-powered mobile devices in situations of limited bandwidth.

* Taro is light client-friendly: has low verification costs and needs only access to untrusted bitcoin transactions. Taro does not require knowledge of the entire blockchain.
* Taro allows for atomic swaps between Taro assets and BTC
* Taro can handle both unique and non-unique assets as well as collections.
* Taro allows for creative multi-signature and co-signatory arrangements.
* Taro channels can be created alongside BTC channels in the same utxo, allowing Taro to exist in the Lightning Network without consuming additional resources. For instance, Alice can create two channels with Bob in a single Bitcoin transaction, one containing a Taro asset, the other BTC
* Future features may include confidential transactions and zero-knowledge proofs as part of Taro transfers.

Further reading:

* [Taro Q\&A with Ryan Gentry - LNMarkets](https://lnmarkets.substack.com/p/51-ryan-gentry-on-taro-massive-stress)
