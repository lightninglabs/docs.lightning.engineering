---
description: Use an external signing device to protect your private keys.
---

# Minting Assets With an External Signer

The Taproot Assets protocol allows for great flexibility regarding the security of an asset. Keys exist on multiple layers, each of which may be distributed between users and services, hot (internet-connected) and cold (air-gapped) machines or specialized external signing devices.

## Asset issuance

There are three keys relevant to issuance of a Taproot Asset.

1. The Bitcoin key controlling the UTXO anchoring the Taproot Asset on the Bitcoin level.
2. The Asset Script key controlling the spending of the vUTXO on the Taproot Asset level.
3. The Group key that identifies a grouped asset and allows for the expansion of the asset supply.

Each of these keys may be held separately, with the group key being the most sensitive, as it can be used to reissue the asset and expand its supply without limits. The group key cannot be cycled and must be safe for the entire life-cycle of the asset. Keeping this key safe is paramount.

As of now, only this group key can be held on an external device. The group key is defined by a custom derivation path of a standard master key, generated using a general seed phrase. This seed phrase can act as a backup of the key, while the signing device is used to authorize initial and further issuance of the asset.

[Read: Generating the group key on an air-gapped machine using Chantools](https://github.com/lightninglabs/taproot-assets/blob/nums-non-spend-leaves/docs/external-group-key.md)

[Read: Generating the group key on a specialized signing device](https://github.com/lightninglabs/taproot-assets/blob/main/docs/external-group-key-ledger.md)

To also hold the Bitcoin key in a hardware wallet, additional work needs to be done to allow for signing of generic Taproot PSBTs.

Similarly, while the Asset Script key could be held by a hardware wallet, the hardware wallet would need some understanding of what it is signing, ideally information of the vPSBT and Bitcoin PSBT.

## Asset transfer

There are multiple keys relevant to transfer Taproot Assets.

1. The Bitcoin key controlling the UTXO anchoring the Taproot Asset is held by LND. However, LND cannot spend this UTXO alone, not even by accident.
2. To spend the UTXO, and with it the Taproot Asset, the taptweak held by \`tapd\` is needed.
3. The Asset Script key spending the vUTXO on the Taproot Asset level.

While it is technically possible to keep either the Bitcoin key or the Asset Script key on a dedicated air-gapped or signing device, there is currently no mechanism equipped for that.

A special case is that of pocket universes, where the Bitcoin key is held by a service, while the Asset Script key is held by the user. This allows for the efficient batching of potentially millions of asset transfers in a single Bitcoin transaction. The service does however not control the assets of the users and cannot move them independently.

[FAQ: What is a pocket universe](../../the-lightning-network/taproot-assets/faq.md)
