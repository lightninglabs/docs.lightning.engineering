---
description: Splitting a payment into smaller parts and route each part separately.
---

# Multipath Payments \(MPP\)

`lnd` v0.10 introduced multi-path payments to the Lightning Network. The payments in prior examples succeeded with exactly one successful HTLC. However, if a sender has enough liquidity in total to fulfill a payment, but split across multiple channels such that no single channel has the required liquidity, no single HTLC can succeed.

![Example multi-path payment](https://lightning.engineering/static/d02b076fcf61c80bef6b0be8a60f47ba/4fc58/2020-05-06-mpp-outbound.png)

A multi-path payment \(MPP\) can solve this problem by sending the payment in two parts. The first payment part consumes 20k sats in one channel and the second part uses 10k sats in the other channel. The highest payment amount is now defined by the sum of all channel balances rather than the maximum.

When the recipient receives the first part, they won’t immediately settle the HTLC. Instead the HTLC is accepted and held, similar to how [hodl invoice](https://lightningwiki.net/index.php/HODL_Invoice) payments are accepted. They could settle because the preimage is known, but that wouldn’t be a rational thing to do. Settling right away would return the proof of payment to the sender while the full amount may never arrive. With the proof of payment, the sender could claim that the payment was made in full. Because all parts use the same payment hash, another possibility that may be even worse is that an intermediate node uses the now public preimage to settle the second HTLC without forwarding at all. So the recipient waits for the second HTLC to arrive. They then conclude that the full amount has arrived and will at that point settle both HTLCs.

