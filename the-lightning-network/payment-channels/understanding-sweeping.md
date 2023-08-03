---
description: >-
  Sweeps are transactions from specialized scripts back into your main wallet.
  They are used in various contexts throughout the Lightning Network.
---

# Understanding Sweeping

In the context of running a Lightning Network node, the term Sweeping refers to transferring Bitcoin from specialized scripts into the node’s main on-chain wallet.

The primary need for sweeping arises from timeouts in scripts used in the Lightning Network. Funds have to be moved within a certain amount of time, or else they may be sweeped by the channel peer.

Additionally there is also the limitation that not all addresses are hierarchically generated, meaning not all addresses can be recovered using the node’s seed phrase alone. To prevent funds from being unrecoverable in the event of data loss, they are swept to an address that can be recovered purely from the seed phrase.

## Types of funds that need to be swept <a href="#docs-internal-guid-8a56d3d1-7fff-ef1d-33fd-b5cf028282ef" id="docs-internal-guid-8a56d3d1-7fff-ef1d-33fd-b5cf028282ef"></a>

There are several distinct situations in which funds have to be swept.

### Local force closure <a href="#docs-internal-guid-06d33779-7fff-30d2-fe8c-3b51c8d3e0e6" id="docs-internal-guid-06d33779-7fff-30d2-fe8c-3b51c8d3e0e6"></a>

When your node publishes the commitment transaction for a channel, the local balance is sent to an arbitration contract, from where your node is able to sweep the funds after a minimum amount of time has passed.

This sweep requires your node’s signature.

[Read also: Timelocks](../multihop-payments/timelocks.md)

### Remote force closure <a href="#docs-internal-guid-5639eda7-7fff-d40a-5194-c42c6b9957b1" id="docs-internal-guid-5639eda7-7fff-d40a-5194-c42c6b9957b1"></a>

When a peer force closes on you, your funds can be swept after the force closure transaction is included in a block.

This sweep requires your node’s signature.

In the event in which your peer publishes an invalid commitment transaction, you are able to sweep their balance into your wallet within the pre-defined arbitration period using a revocation key.

This sweep requires your node’s signature and the revocation key.

### Anchors

When an anchor channel is force-closed, two anchors of 330 satoshis each are created. These anchors can be swept within 16 blocks by you, or by anyone else after to prevent the UTXO set from bloating. The main purpose of these anchors is to give either party an opportunity to increase the fee of the commitment transaction using CPFP (Child Pays for Parent).

Before 16 blocks, this sweep requires your node’s signature. After 16 blocks, the sweep does not require any signature, meaning others can sweep your anchors, too.

### Incoming HTLCs

When your peer force closes your channel, and this closure transaction contains an HTLC paid to you for which you have the preimage, you will need to claim these funds by sweeping the HTLC within a predefined arbitration period.

This sweep requires your node’s signature and the preimage of the HTLC.

[Read also: Hashed Timelock Contracts](../multihop-payments/hash-time-lock-contract-htlc.md)

### Outgoing HTLCs <a href="#docs-internal-guid-7b41dfd0-7fff-b912-6295-40b3c9915918" id="docs-internal-guid-7b41dfd0-7fff-b912-6295-40b3c9915918"></a>

If your node closes a channel by publishing a commitment transaction that contains an outgoing HTLC, your peer has the opportunity to claim this HTLC using the preimage.

If the peer does not possess the preimage, or does not respond within the CLTV time limit, your node uses a pre-signed transaction to move HTLC into another address, from where your peer gets the opportunity to claim the funds using the revocation key in case your node is publishing a breaching force closure transaction.

After this “second stage” (CSV) expires, your node can finally sweep the funds back into its main wallet.

This sweep requires your node’s signature.

### Loop In

If a Loop In were to fail, for example because the off-chain funds couldn’t be delivered to the destination node, the funds have to be swept back into your on-chain wallet after a timeout.

This sweep requires your node’s signature.

### Loop Out

When performing a Loop Out, meaning to swap off-chain funds into your on-chain wallet, the swap contract has to be swept by the recipient of the on-chain funds using the preimage of the off-chain payment.

This sweep requires your node’s signature and the preimage of the offchain payment.

[Read also: Understanding Submarine swaps](../multihop-payments/understanding-submarine-swaps.md)

## Batch sweeping <a href="#docs-internal-guid-fc8a7dce-7fff-508f-ae91-e6f659f04954" id="docs-internal-guid-fc8a7dce-7fff-508f-ae91-e6f659f04954"></a>

Sweeps can be batched to save on on-chain fees. If your node needs to frequently perform sweeps you may increase the following setting to something higher, for instance an hour.

`sweeper.batchwindowduration=10m`

## LNCLI

Pending sweeps can be inspected with the command:

`lncli wallet pendingsweeps`

All performed sweeps can be inspected with:

`lncli wallet listsweeps`

Not all sweeps are economical. In cases where the sweep amount is smaller than the sweep fees, LND will not attempt the sweep right away, and instead wait for fees to go down.
