---
description: >-
  To secure your Taproot Assets you may distribute your keys across segregated
  devices and security zones.
---

# Multisignature

Taproot Assets and their balances are recorded offchain in Taproot outputs. Analogous to Bitcoin, Taproot Assets are held in outputs, which are locked through scripts, called Taproot Asset Outputs. The Bitcoin-level UTXO commits to this merkle tree, effectively anchoring the assets to a Bitcoin UTXO.

To spend a Taproot Asset vUTXO, two conditions need to be met.

1. The Taproot Assets-level vUTXO script needs to be satisfied. In practice, that means the signature(s) to the Taproot Asset need to be valid and an eventual timelock needs to be satisfied.
2. The Bitcoin-level-UTXO script needs to be satisfied. In case of a single signer or cooperative signatories, this is a valid Schnorr signature. Additionally, Taproot transactions allow for multiple alternative spending conditions.

## Multisignature approaches <a href="#docs-internal-guid-15bd47a3-7fff-3a7a-57b3-0f934afbda5e" id="docs-internal-guid-15bd47a3-7fff-3a7a-57b3-0f934afbda5e"></a>

The nature of the Taproot Assets protocol allows for multiple methods to securing Taproot Assets through multiple keys.

### At the Taproot Asset level

Each individual Taproot Asset can be secured with multisig, either on the vUTXO level through Schnorr signatures (MuSig2, e.g. N-of-N) or on the script level. Given that MuSig2 signature can only be N-of-N, If a K-of-N multisignature contract is required, a tree of MuSig2 can be used to produce the various key combinations to fulfill the K-of-N requirement. To prevent the internal Taproot key from being used, the key is set to the NUMS key: A deterministic public key for which it can be proven that no private key exists.

Multisig at the tapleaf layer level enables the owner of the Taproot Asset is not in control of the internal Taproot key, e.g. a pocket universe.

[Also see: Multisignature itest in tapd](https://github.com/lightninglabs/taproot-assets/blob/main/itest/multisig.go)

### AT the internal Taproot key

All Taproot Assets are held by a Taproot UTXO, allowing use of Taproot’s native MuSig2 feature to require multiple parties to sign off on every transaction. These arrangements are limited to n-of-n MuSig2.

### At the Bitcoin-level script

To implement n-of-m multisignature schemes we have to make use of Bitcoin script, similar to how multisignature schemes work in Segwit addresses. This mechanism can be used in addition to MuSig2, for example to perform key recovery or instead of it, for example to introduce additional restrictions such as timelocks.

### The asset group key

Grouped assets do not have a fixed supply, and new assets can be issued anytime using the asset group key. As an asset issuer, maintaining the integrity of the asset group key is crucial. This key is a 32 byte Schnorr key, similar to those used for the internal key of a Taproot transaction.. This allows for N-of-N MuSig2 using the same tools and mechanisms used to secure the internal Taproot key.
