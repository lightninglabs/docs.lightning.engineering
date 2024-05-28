---
description: >-
  "Sweep" is an LND subservice that handles funds sent from dispute resolution
  contracts to the internal wallet.
---

# Sweeper

Sweep is an LND subservice that handles funds sent from dispute resolution contracts to the internal wallet.

The Sweeper has undergone major adjustments in LND 0.18. Use this document to understand how the sweeper functions and how to best configure your node.

When Lightning Network channels are unilaterally closed, funds are not directly settled into LND’s internal wallet, but rather into specific contracts that specify who can settle their funds when, and under what conditions. This also applies to both incoming and outgoing HTLCs, which also have to be swept.

Not all sweeps are of equal importance. Some sweeps are time-sensitive and have to be confirmed within a predefined number of blocks, while others are primarily done for the convenience of being able to restore as much of the onchain funds as possible using LND’s internal wallet alone. Other sweeps, such as those picking up [anchors](https://docs.lightning.engineering/the-lightning-network/taproot-assets/glossary#docs-internal-guid-85ae5d8e-7fff-f351-537f-243d2bc233ca), are needed to bump the transaction fee of the parent transaction.

The Sweeper takes the recovered amount and urgency into account when deciding on appropriate onchain fees for its sweeps. It achieves this by requiring a budget and deadline for each sweep. This budget can either be defined in the node’s configuration file, or passed on a case-by-case basis through the RPC. Inputs with the same deadline are batched into a single sweeping transaction.

As the transaction is pending confirmation, the Sweeper may decide to bump the transaction using RBF, until the transaction is either confirmed or the budget is exhausted. The Bumper will monitor the status of the transaction, and for every new block increase the fee rate slightly. Due to RBF rules, not all of these bump transactions are actually published.

## Fee calculation <a href="#docs-internal-guid-8bb56e57-7fff-76e2-85d5-d3e537c4f876" id="docs-internal-guid-8bb56e57-7fff-76e2-85d5-d3e537c4f876"></a>

Fees are calculated using the formula  (`ending_fee_rate - starting_fee_rate) / deadline`, where the starting fee is the result of the fee estimate from the Bitcoin backend (`estimatesmartfee` in `bitcoind`, `estimatefee` in `btcd`, `feeurl` or manual specification through `--sat_per_vbyte`), and the ending fee is calculated by dividing the budget by the size of the sweeping transactions, capped at `--sweeper.maxfeerate`. The ending fee rate can also be manually overridden by defining `--budget` in `lncli wallet bumpfee`.

In the example below, `lnd` is using `bitcoind` as its fee estimator, and an input with a deadline of `1000 blocks` and a budget of `200,000 satoshis` is being swept in a transaction that has a size of 500 vbytes. The fee function will be initialized with:

* a starting fee rate of 10 sat/vB, which is the result from calling `estimatesmartfee 1000`
* an ending fee rate of 400 sat/vB, which is the result of `200,000/500 = 400`
* a fee rate delta of 390 sat/kvB, which is the result of `(400 - 10) / 1000 * 1000`
* `((budget / transaction_size)- starting_fee_rate ) / deadline * 1000`

## Force closure transactions <a href="#docs-internal-guid-820be7f3-7fff-4168-7f1a-05cc7de8d03a" id="docs-internal-guid-820be7f3-7fff-4168-7f1a-05cc7de8d03a"></a>

Force closure transactions contain the local and remote output, the anchors, and, eventually, HTLCs.

**Sweeping Commit Outputs**

The `to_local` output can only be spent with our signature, so there is no time pressure to sweep it. By default, the sweeper will use a deadline of 1008 blocks as the confirmation target for non-time-sensitive outputs. To overwrite the default, users can specify a value using the config `--sweeper.nodeadlineconftarget`.

To specify the budget, users can use `--sweeper.budget.tolocal` to set the max allowed fees in sats, or use `--sweeper.budget.tolocalratio` to set a proportion of the `to_local` value to be used as the budget.

**Sweeping HTLC Outputs**

When facing a local force close transaction, HTLCs are spent in two stages. The first stage is to spend the outputs using pre-signed HTLC success/timeout transactions, the second stage is to spend the outputs from these success/timeout transactions. All these outputs are automatically handled by LND. Specifically:

* For an incoming HTLC in stage one, the deadline is specified using its CLTV from the timeout path. This output is time-sensitive.
* For an outgoing HTLC in stage one, the deadline is derived from its corresponding incoming HTLC’s CLTV. This output is time-sensitive.
* For both incoming and outgoing HTLCs in stage two, because they can only be spent by us, there is no time pressure to confirm them under a deadline.

When facing a remote force close transaction, HTLCs can be directly spent from the commitment transaction, and both incoming and outgoing HTLCs are time-sensitive.

By default, lnd will use 50% of the HTLC value as its budget. To customize it, you may specify `--sweeper.budget.deadlinehtlc` and `--sweeper.budget.deadlinehtlcratio` for time-sensitive HTLCs, and `--sweeper.budget.nodeadlinehtlc` and `--sweeper.budget.nodeadlinehtlcratio` for non-time-sensitive sweeps.

**Sweeping Anchor Outputs**

An anchor output is a special output that can be used as an input to a Child-pays-for-parent (CPFP) transaction. This is useful as it allows us to create commitment transactions with low fees, and then bump them as needed by spending the anchor with a higher fee.

If the force close transaction doesn't contain any HTLCs, the anchor output is generally uneconomical to sweep and will be ignored. However, if the force close transaction does contain time-sensitive outputs (HTLCs), the anchor output will be swept to CPFP the transaction and accelerate the force close process.

For CPFP-purpose anchor sweeping, the deadline is the closest deadline value of all the HTLCs on the force close transaction. The budget, however, cannot be a ratio of the anchor output because the value is too small to contribute meaningful fees (330 sats). Since its purpose is to accelerate the force close transaction so the time-sensitive outputs can be swept, the budget is actually drawn from what we call “value under protection”, which is the sum of all HTLC outputs minus the sum of their budgets. By default, 50% of this value is used as the budget, to customize it, use `--sweeper.budget.anchorcpfp` to specify satoshis, or use `--sweeper.budget.anchorcpfpratio` to specify a ratio.

To sweep an anchor as quickly as possible, the `--immediate` flag of `lncli wallet bumpfee` and `lncli wallet bumpclosefee` may be used.
