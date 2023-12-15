---
description: >-
  Taproot Assets make use of several novel concepts, all of which we attempt to
  briefly define here.
---

# Glossary

## Anchor <a href="#docs-internal-guid-85ae5d8e-7fff-f351-537f-243d2bc233ca" id="docs-internal-guid-85ae5d8e-7fff-f351-537f-243d2bc233ca"></a>

The anchor transaction is the Bitcoin transaction that mints or transfers a Taproot Asset.

## Asset group

An asset group describes a series of assets, as identified by their asset ID, for which new assets can be added by the issuer.

[Read more: Minting asset groups](../../lightning-network-tools/taproot-assets/first-steps.md#docs-internal-guid-326a3acb-7fff-c694-2400-496ff7278e63)

## Asset ID

The asset ID is used to identify an asset. It is the hash of the [genesis outpoint](glossary.md#genesis-point), the [asset tag](glossary.md#asset-tag) and the [asset meta](glossary.md#meta-data) data. It is a globally unique identifier. If an asset is [grouped](glossary.md#group-key), each minted series contains its own asset ID.

## Asset tag

&#x20;The asset tag is equivalent to the name of an asset. Other information is collected as part of the [meta data](glossary.md#meta-data).

## Batch

A batch is a set of Taproot Asset mints or transfers that are contained in a single Bitcoin-level UTXO.

## Burn

Burning an asset means irrevocably removing it from the circulating supply.

[Read more: Burn assets](../../lightning-network-tools/taproot-assets/first-steps.md#burning-assets)

## Collectibles

A collectible, unique or non-fungible asset, unlike a normal asset, cannot be divided or aggregated, as there are no other units of its kind. It can however be put into a collection with other similar collectibles.

[Read more: Collectibles](../../lightning-network-tools/taproot-assets/collectibles.md)

## Collections

A collection is a [group](glossary.md#group-key) of collectibles. While every item in the collection is unique, they can still be identified as part of the same collection using the group key.

## Commitment

A commitment is typically the hash of data that is to be permanently recorded to have existed at a certain point in time, and in a certain utxo.

## Fungible tokens

See also [normal assets](glossary.md#normal-asset).

## Genesis point

The genesis point is the first input of the transaction that mints a Taproot Asset.

## Group key

The group key identifies normal and collectible assets that do not have a fixed supply. When new assets of this group are minted, a signature using this key must be present.

## Internal key

The internal key is the key that is able to spend the Taproot Bitcoin UTXO.

## Issuer

The issuer of an asset is whoever creates and publishes the mint transaction. The issuer of a grouped asset is identified using the group key.

## Leaf

A leaf is the lowest level in a -> merkle tree. They typically contain the data that the merkle tree commits to.

## Lightning Polar

Lightning Polar is software that helps you simulate a regtest Lightning environment in which you can easily add multiple nodes. It can also be used to test Taproot Assets mints and transactions.

[Read more: Lightning Polar and Taproot Assets](../../lightning-network-tools/taproot-assets/polar.md)

## Merkle root

The merkle root is the hash at the very top of the merkle tree. If a single value in the merkle tree changes, the root also changes.

## Merkle sum tree

A merkle sum tree is a merkle tree that for each leaf contains a numerical value, which is sumed up in each node. The sum at the -> merkle root is equal to the sum of values at the leafs.

## Merkle tree

In a merkle tree a pair of items is hashed, the pair then hashed with other pairs until only a single hash is left, the -> merkle root. This helps to cheaply commit to large amounts of arbitrary data and check whether anything has changed.

## Meta data

The asset meta data can be used to commit to any arbitrary data. Most commonly it describes the asset and its terms or represents the asset itself.

## Mint

The action of issuing an asset. Also see -> issuer.

## Non-fungible token

Also see -> collectibles

## Normal asset

A normal or fungible asset is one that is divisible into a predefined set of units. Each unit is expected to be valued the same as any other unit of the same asset. Normal assets can be fixed in total supply, or be part of an -> asset group.

## Proof file

The proof file contains information about the asset, when and how it was minted as well as previous transfers. it is needed to verify ownership over an asset.

## PSBT

A partially signed Bitcoin transaction is a file format that lets two wallets communicate only specific details about a new transaction, for example only its inputs, or only its outputs. These PSBTs can be used to sign transactions with external signing devices, or allow multiple parties to contribute inputs to one transaction.

## Sparse merkle tree

A sparse merkle tree is a merkle tree over all numbers of a given space. A sparse merkle tree over 2^256 for example theoretically contains 2^256 leafs. It can be computed because by default all leafs are empty. Sparse merkle trees help with exclusion proofs, e.g. proving something is not present in a merkle tree.

[Read more: Sparse merkle trees in Taproot Assets](taproot-assets-protocol.md#docs-internal-guid-5a068ff4-7fff-ecac-596d-f7631d0a2edd)

## Supply

The supply of an asset is the total amount of units of that asset in circulation. For -> grouped assets, this supply can be increased later. For all assets, it can be reduced by -> burning a portion of the supply.

## Tapd

Taproot Assets Protocol Daemon is the reference implementation for Taproot Assets.

[Read more: Install tapd](../../lightning-network-tools/taproot-assets/get-tapd.md)

## Taproot

Taproot is a Bitcoin transaction type. Bitcoin sent to taproot scripts can be unlocked either using the -> internal key or a predefined set of conditions, the -> tapscript.

## Taproot Asset address

A Taproot Assets address is created by the recipient of an asset to be able to receive an asset. Such addresses are specific to an asset and an amount and should not be reused.

[Read more: Generate Taproot Asset addresses](../../lightning-network-tools/taproot-assets/first-steps.md#docs-internal-guid-2d861222-7fff-ef76-60b9-65367a4fd1b7)

## Taproot Assets

Taproot Assets leverages Taproot transactions to commit to newly created assets and their transfers in an efficient and scalable manner.

[Read more: Taproot Assets protocol](taproot-assets-protocol.md)

## Taproot Assets Channel

Taproot Assets can be deposited into Lightning channels. These channels are referred to as Taproot Asset Channels.

[Read more: Taproot Assets on Lightning](taproot-assets-on-lightning.md)

## Tapscript

Tapscript is a feature of -> Taproot transactions that allows to create various conditional spending conditions. Taproot Assets and their merkle trees are stored in the Tapscript.

## Tapscript sibling

The Tapscript sibling is the hash in the leaf next to the data in question. The sibling is needed to compute the -> merkle root.

## Unique asset

See also -> Collectibles

## Universe

A universe is a server that serves information about assets and their transfers. Universes can also be used to transfer proof files between users.

## vPSBT

Virtual partially signed Bitcoin transactions achieve what -> PSBTs achieve, but on the Taproot Assets layer. Using vPSBTs, it becomes easier to batch Taproot Asset transactions, use external signing devices or assemble transactions between the Taproot asset and Bitcoin layer.

## vUTXO

A vUTXO is a Taproot Assets utxo. As the Taproot Assets themselves are not perfectly synonymous with the Bitcoin UTXO that they are anchored in, vUTXOs are used to reference them.
