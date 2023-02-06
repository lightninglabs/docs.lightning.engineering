---
description: >-
  A Lightning Service Provider (LSP) deploys liquidity in the Lightning Network
  on behalf of others.
---

# Lightning Service Provider

A Lightning Service Provider (LSP) is an entity providing liquidity services on the Lightning Network on behalf of others. Channels in the Lightning Network are naturally constrained by their size, and capacity is further limited by local and remote balances.

Lightning Service Providers typically help manage a user’s liquidity by performing one of two tasks

* Swapping on-chain funds for off-chain funds or vice versa
* Opening channels to increase a user’s [inbound capacity](how-to-get-inbound-capacity-on-the-lightning-network.md) or improve their [position in the graph](../pathfinding/finding-routes-in-the-lightning-network.md)

Ideally, a Lightning Service Provider interacts with their clients in a purely non-custodial way. Swaps can be constructed as [Submarine Swaps](../multihop-payments/understanding-submarine-swaps.md) to guarantee that the service provider cannot abscond with funds at any time. When opening channels to peers, the LSP retains custody over their side of the channel and earns routing fees as they forward payments.

Today, LSPs are most commonly known for providing liquidity to users of non-custodial wallets in the form of channels. This lets users immediately receive Lightning payments to their wallets without requiring active channel management or ownership over a UTXO. The LSP typically charges an upfront payment to compensate for mining fees and capital costs.

These fees are often deducted directly from an incoming payment, but could also be charged upfront. It may be difficult for the LSP to assess how large a new channel to a user should be.

An LSP may borrow bitcoin for this task, or deploy their own funds. It is also possible for an LSP to buy such channels on the open market, such as [Lightning Pool](../../lightning-network-tools/pool/) using sidecar channels, instead of opening them themselves.
