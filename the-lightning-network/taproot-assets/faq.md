---
description: Frequently asked questions about the Taproot Assets Protocol.
---

# FAQ

## Taproot Assets <a href="#docs-internal-guid-ae4b02ad-7fff-4740-c7fd-34f471681055" id="docs-internal-guid-ae4b02ad-7fff-4740-c7fd-34f471681055"></a>

### What is Taproot Assets? <a href="#docs-internal-guid-ae4b02ad-7fff-4740-c7fd-34f471681055" id="docs-internal-guid-ae4b02ad-7fff-4740-c7fd-34f471681055"></a>

Taproot Assets is a novel Taproot-based protocol that defines how assets can be issued/used on the bitcoin blockchain. Assets issued with the Taproot Assets protocol are held in bitcoin utxos and are transferred as part of regular bitcoin transactions.

### What can I do with Taproot Assets?

Taproot Assets lets you issue all kinds of assets on bitcoin, both collectible and fungible (often called _normal_). There are no technical limits to what these assets can represent, including stablecoins, shares, tickets, ownership rights or art. Assets can be programmed using Taproot Asset scripts, allowing for a broad range of functionality similar to bitcoin transactions. From an initial protocol design and prioritization perspective, Lightning Labs is focused on stablecoins’ use cases first.&#x20;

### How does Taproot Assets work?

Taproot Assets uses Merkle trees known as a ‘Merkle Sum, Sparse Merkle Tree (MS-SMT)’ and Taptweak to commit to information defining an asset’s creation and ownership.

### What does Taproot Assets have to do with Taproot?

Taproot Assets requires Taproot to function efficiently, as Taptweak makes it possible to commit to arbitrary data without additional overhead on the blockchain. Taproot allows Taproot Assets to be scalable, economical, and privacy enhancing.

### Where can I buy Taproot Assets tokens?

Taproot Assets is a protocol. The Taproot Assets Protocol is released under the BSD-2-Clause license, also known as the “simplified BSD license,” making it free to use and build upon. The best way to invest in Taproot Assets is to build on top of it.

## Taproot Assets on-chain

### Does Taproot Assets scale? <a href="#docs-internal-guid-ecae09ba-7fff-98fc-8581-c0543aaa5874" id="docs-internal-guid-ecae09ba-7fff-98fc-8581-c0543aaa5874"></a>

Taproot Assets minimizes its on-chain footprint by storing all necessary metadata off-chain. It further optimizes how UTXOs are used by allowing multiple assets to be controlled by the same output, and aggregate multiple transactions into a single UTXO. Taproot Assets on the Lightning Network vastly improves on the scalability of other on-chain or sharded off-chain protocols while allowing for the highest degree of self-sovereignty.

### How do I find out what assets have been issued?

Once the protocol is released, information about asset issuance may be obtained either directly from an issuer, through a Taproot Assets universe or from Lightning Labs’s products.

### What is a universe?

A Taproot Assets universe is a repository of assets and their proofs. A universe may serve information about a single or multiple asset types (e.g. a specific stablecoin or all stablecoins). It may hold information about which assets have been issued, their quantity, and rules as well as hold proofs about recent transfers. The criteria for releasing this information is up to a universe or universe operator.

### What is a pocket universe?

A pocket universe is a way to collectively store Taproot Assets and use the protocol without giving up ownership of assets. This pocket universe is a single party (or federation) maintaining a Taproot Assets commitment that includes assets that they can't unilaterally move themselves. A pocket universe controls the Taproot key to a UTXO, but not the keys to the (possibly multiple) Taproot Assets held in that UTXO. Asset holders can use the pocket universe to batch their transactions in an efficient manner.

### Do I need the full blockchain to issue or transact assets with Taproot Assets? <a href="#docs-internal-guid-995924ec-7fff-bf47-4b88-25b6658d8c66" id="docs-internal-guid-995924ec-7fff-bf47-4b88-25b6658d8c66"></a>

Taproot Assets does not require you to keep or scan the entire blockchain. Similar to running a Lightning Network node, your Taproot Assets client only requires proofs about the existence of specific transactions relating to its assets, which can be obtained in ‘Neutrino’ mode, also known as BIP157.

### Do I need bitcoin to issue assets with Taproot Assets?

To issue and transact Taproot Assets, bitcoin transactions need to be made, which generally require transaction fees paid in BTC. Each output also needs to carry with it a small number of satoshis to be valid.

### How do I issue assets with Taproot Assets?

Using the initial implementation, anyone is be able to issue assets with Taproot Assets using `tapd` on Bitcoin. Once the asset has been issued and its genesis transaction is confirmed on the blockchain, your asset is live and can be transferred. In the future it will be possible to also deploy this asset into a Lightning Network channel.

### Do all assets have a limited supply?

When minting a Taproot Asset asset, you define its rules. It is possible to limit the total supply of your asset or to leave it uncapped to create additional assets later. These supply controls are enforced through cryptographic means in the Taproot Assets client.

### How do I hold assets in my wallet?

Your Taproot Assets wallet will need to store Taproot keys as well as Taproot Assets keys, plus the knowledge of which assets were held in which UTXOs. How such data is stored and backed up will be up to the wallet developer.  If a user loses their asset proof information, it’s possible for a Universe to serve the proof back to the user.&#x20;

### How do I send assets on-chain? <a href="#docs-internal-guid-157496c4-7fff-e705-7be6-06f7c05e7cd4" id="docs-internal-guid-157496c4-7fff-e705-7be6-06f7c05e7cd4"></a>

To send Taproot Assets to somebody else, they will need to first provide you their Taproot Assets address. This address contains information about the asset and public keys necessary for holding the asset, as well as the requested amount. The address format is designed to help prevent Taproot Assets from being lost or unrecoverable.

### What fees do I have to pay?

Typically, a Taproot Assets transaction will carry on-chain fees, which are paid to bitcoin miners similar to a regular bitcoin transaction. When transacting Taproot Assets off-chain, you may pay routing fees to Lightning Network nodes instead. When using a pocket universe, grouped transactions can share on-chain fees.

## Taproot Assets on the Lightning Network

### How do I send Taproot Assets over the Lightning Network?

Taproot Assets can be deployed into a Lightning Network channel in a similar manner as bitcoin. When a route denominated in the relevant asset exists, the asset can be routed through it, otherwise it can be trustlessly swapped for BTC and its value is routed to the destination, where it may be swapped back or into a different asset. Ultimately, the majority of this process will be obfuscated to the end user and handled by nodes and wallets.

### What is edge liquidity? <a href="#docs-internal-guid-db923dbf-7fff-0947-dc8c-ded0b5d02196" id="docs-internal-guid-db923dbf-7fff-0947-dc8c-ded0b5d02196"></a>

Edge liquidity describes the concept that some Lightning Network nodes, with which you have Taproot Assets channels, may be willing to swap their value to BTC and back, allowing you to use your Taproot Assets to pay for any Lightning Network invoice, or receive any asset by issuing a standard Lightning invoice.

### How does Taproot Assets know how much an asset is worth?

The Taproot Assets Protocol does not prescribe how edge nodes and Taproot Asset holders agree on a price -- though a few options can be supported. As long as both agree on a rate, any Taproot Assets can be swapped for BTC and its value transmitted through the broader Lightning Network.

### How does Taproot Assets deal with the “optionality” challenges?

Edge nodes’ liquidity has some optionality properties, but this optionality will be priced by the market. Nodes, which offer this optionality, can decline to facilitate the quoted swap and users can avoid nodes which don’t perform adequately.  Ergo, Taproot Assets doesn’t have a “free option problem” which can exist in cross-chain atomic swaps.

### Do you need an equivalent amount of bitcoin to move Taproot Assets between channels?

The owner of an asset does not need to own an equivalent amount of bitcoin to be able to send or receive amounts denominated in their asset. However, a route must exist between the sender and receiver with sufficient liquidity -- either in bitcoin or the asset.

### Custody and redeemability in the Taproot Assets protocol

| <p><br></p>           | <p><br></p> | User holds the keys to the taproot UTXO | <p><br></p>                         |
| --------------------- | ----------- | --------------------------------------- | ----------------------------------- |
| <p><br></p>           | <p><br></p> | 🔑Yes                                   | 🚫No                                |
| User holds asset keys | 🔑Yes       | Full self-custody                       | User is **using** a pocket universe |
| <p><br></p>           | 🚫No        | User is **operating** a pocket universe | Entirely custodial relationship     |
