---
description: >-
  Timelocks allow for limits on when bitcoin can be spent. There are absolute
  and relative timelocks, existing on the transactional and UTXO level.
---

# Timelocks

A time-locked Bitcoin transaction is one that is only valid after a certain period of time. Such timelocks are used extensively in the Lightning Network and broadly fall under two categories, absolute timelocks and relative timelocks.

| <p><br></p>       | Absolute Timelock   | Relative Timelock   |
| ----------------- | ------------------- | ------------------- |
| Transaction Level | nLockTime           | nSequence           |
| UTXO Level        | CheckLockTimeVerify | CheckSequenceVerify |

## Absolute timelocks <a href="#docs-internal-guid-0d5e29e5-7fff-99b6-bc86-be913c8afa87" id="docs-internal-guid-0d5e29e5-7fff-99b6-bc86-be913c8afa87"></a>

Absolute timelocks restrict a transaction to only be valid after a certain point in time, for instance a time stamp or a block height. Today, block height is primarily used.

### nLocktime

The most commonly used timelock, nLocktime, has been a feature of bitcoin since its inception. Each bitcoin transaction specifies a nLocktime close to the most recently mined bitcoin block, meaning a miner can not include this transaction as part of a block reorg concerning previous blocks. It only began to be widely used around 2016, when it was included in Bitcoin Core 0.11.

### Check-locktime verify (CLTV) <a href="#docs-internal-guid-0730def9-7fff-d01f-706d-cd4c3af5f3e0" id="docs-internal-guid-0730def9-7fff-d01f-706d-cd4c3af5f3e0"></a>

Check-locktime verify (CLTV) is the timelock used in Hash Timelock Contracts (HTLC), which make up an important part of the mechanism behind Lightning Network transactions. CLTV is an absolute timelock that uses block height to determine when transactions become valid.

Differences between timelocks of incoming and outgoing HTLCs, called CLTV deltas, ensure that an incoming HTLC that is resolved on-chain can also be resolved in time in the outgoing channel.

CLTV differs from nLocktime in that it enforces the timelock on the script level, while the nLocktime timelock is enforced at the time of the signature. So while it is possible to add nLocktime when spending any coin, a CLTV condition has to be defined at the time the address is created, and the owner cannot alter it anymore.

CLTV was introduced with [BIP65](https://github.com/bitcoin/bips/blob/master/bip-0065.mediawiki) and activated through a soft fork in 2015. In addition to block height, the protocol also allows CLTVs to use timestamps to define the validity of transactions.

There’s no limit to how far in the future a CLTV transaction can be locked.

[Read more about HTLCs](hash-time-lock-contract-htlc.md)

## Relative timelocks (CSV) <a href="#docs-internal-guid-f1bf5aca-7fff-5e2d-1681-8a05f839466a" id="docs-internal-guid-f1bf5aca-7fff-5e2d-1681-8a05f839466a"></a>

A relative timelock describes a period after which a transaction becomes valid, rather than a fixed timestamp of block height. This period refers to the number of blocks or seconds between inputs being confirmed on the blockchain, and the outputs being valid.

### nSequence

Analogous to nLocktime, nSequence is enforced at the transaction level, rather than the script level. That difference means that you can add information about the minimum number of blocks that need to have passed since its input was confirmed when signing the transaction that spends it.

### Check Sequence Verify (CSV)

The main timelock in use today is Check Sequence Verify (CSV), which was activated in 2016 as [BIP68](https://github.com/bitcoin/bips/blob/master/bip-0068.mediawiki), [BIP112](https://github.com/bitcoin/bips/blob/master/bip-0112.mediawiki) and [BIP113](https://github.com/bitcoin/bips/blob/master/bip-0113.mediawiki). It defines the sequence delay as part of the script, meaning it cannot be changed when the coins are spent.

CSV plays an important role in [commitment transactions](https://docs.lightning.engineering/the-lightning-network/payment-channels/lifecycle-of-a-payment-channel) in the Lightning Network, ensuring that the funds from a non-cooperative closure can only be recovered a certain number of blocks after the force closure has been initiated. CSV is the key component of allowing Lightning Network channels to exist indefinitely, rather than for a limited time.

The “CSV Delay”, defined at a channels’ creation, is dependent on its size. It can also be configured manually with the –max\_local\_csv flag of lncli openchannel. It expresses the number of blocks that need to pass before the initiator of a force close can spend their side of the balance, while the other party can always spend their funds immediately.

Relative timelocks can also be used to prevent transactions having unconfirmed parents, or pinning attacks, in which a transaction is prevented from being confirmed by submitting large, low-paying descendants.

Unlike CLTV, CSV can only be defined for up to 65535 blocks (about 15 months).

No timelocks exist that make a transaction invalid after a certain time. This follows a design principle of bitcoin that transactions can only become more permissible over time, not more restrictive. This principle is supposed to prevent funds being destroyed by becoming locked forever.
