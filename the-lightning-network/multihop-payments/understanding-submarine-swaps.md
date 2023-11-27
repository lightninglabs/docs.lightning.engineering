---
description: >-
  Submarine swaps allow to exchange off-chain and on-chain Bitcoin safely
  without counterparty risk.
---

# Understanding Submarine Swaps

## Three steps of a Submarine swap

A submarine swap is a trade between on-chain and off-chain digital assets (i.e.between Bitcoin held on-chain and Bitcoin on the Lightning network). Submarine swaps are a specific kind of atomic swap that can be performed without custody or counterparty risk.

Without counterparty risk, submarine swaps can be performed without additional barriers such as background checks or contractual arrangements. Either, the two parties successfully swap their assets or the swap fails. But, at no point, is either side able to walk away with the other party’s funds.

To achieve these trustless properties, the on-chain transaction makes use of the same hash time-locked contracts (HTLC) as the Lightning Network. Before on-chain BTC are transferred, the recipient of the Lightning transaction generates a preimage, a random 32-byte secret. This preimage is hashed and used to construct the HTLCs for both on- and off-chain payments.

### **1. Generate a bitcoin smart contract**

The sender of the on-chain payment knows the hash of this preimage and after an exchange of public keys with the receiver. The sender can generate a Bitcoin address with the following properties: For a limited time, the funds held in that contract can be swept knowing the preimage and a valid signature from the receiver. After that, they can be claimed using just the signature of the sender.

Both the sender of the on-chain transaction and the recipient are able to generate and verify this script. The sender can now safely move BTC to this contract, knowing they will either receive satoshis off-chain, or, if it fails, be able to claim their BTC back. Depending on the exact arrangement, the sender might also ask for a non-refundable Lightning payment upfront, which can be used to cover the transaction fees from entering and exiting the smart contract, as well as compensate for the opportunity cost of funds being locked up for some time period.

Example of a typical bitcoin smart contract used in Loop:\


`OP_SIZE 32 OP_EQUAL`\
`OP_IF`\
`OP_HASH160 <ripemd160(swapHash)> OP_EQUALVERIFY`\
`    <receiverHtlcKey>`\
`OP_ELSE`\
`    OP_DROP`\
`    <cltv timeout> OP_CHECKLOCKTIMEVERIFY OP_DROP`\
`    <senderHtlcKey>`\
`OP_ENDIF`\
`OP_CHECKSIG`

### **2. Generate and pay a Lightning invoice**

In the next step, the sender of the on-chain funds will generate a Lightning Network invoice using the same preimage from the smart contract in step 1. The exact amount of the invoice might be equal to the BTC sent, or it might include/deduct a fee. Ultimately, this depends on the arrangement of the two parties and should be agreed on in advance.

To reduce the likelihood of the transaction failing, the Lightning invoice might also be presented in advance, so that the recipient of the on-chain funds is able to determine whether they are capable of sending the payment, and at what cost.

After funds have been confirmed to be settled in the smart contract, it is safe to pay the Lightning invoice. To claim this Lightning payment, the sender of the on-chain funds has to publicize the preimage, which the recipient can now use to claim the funds from the bitcoin smart contract.

### **3. Claim bitcoin from the smart contract**

The off-chain funds are now in the Lightning wallet of the sender of the on-chain payments, while the on-chain funds are still held in the smart contract. Using their signature and the preimage obtained from the Lightning payment, the on-chain funds can be claimed. They will need to be confirmed before the HTLC expires, or else there is the risk the sender can claim their funds back as well. Generally, replace-by-fee can be used to attempt to sweep the funds at a low fee in the beginning, while the fee is gradually increased as the deadline gets closer.

## What are Submarine swaps good for?

Submarine swaps make it easier to manage the [liquidity of your Lightning Node](https://docs.lightning.engineering/the-lightning-network/liquidity/manage-liquidity), It might help with getting inbound liquidity or empty out your day’s earnings into cold storage. It can also be used to refill your channels if their capacity is exhausted.

## Use Submarine swaps in Loop

[Loop](https://github.com/lightninglabs/loop) is our liquidity service that makes it easy to swap off-chain satoshis for an on-chain payment (Loop Out), or vice versa (Loop In). This can be useful to get inbound liquidity, or make on-chain payments from your Lightning node without closing a channel.

\[[Make your first Submarine swap in Loop.](../../lightning-network-tools/loop/)]

\[[Watch Alex Bosworth explain Submarine swaps at London Bitcoin Devs.](https://www.youtube.com/watch?v=eB\_HkYb7Y2M)]
