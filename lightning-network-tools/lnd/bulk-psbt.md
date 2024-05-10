---
description: >-
  PSBTs can be used to batch custom onchain transactions for maximum cost
  efficiency, for example to open multiple channels or send to multiple
  destinations in one transaction.
---

# Bulk onchain actions with PSBTs

Partially Signed Bitcoin Transactions (PSBTs) are a standardized format to create, edit, amend, and sign Bitcoin transactions. This is useful when creating custom transactions, for example by specifying which inputs to consume, or including non-standard outputs.

An introductory guide to PSBTs and LND [can be found here](psbt.md).

## Bulk channel opens

PSBTs can be used to open multiple channels in a single onchain transaction, similar to lncli batchopenchannel.

To begin, a channel open is initiated using the [OpenChan API](https://lightning.engineering/api-docs/api/lnd/lightning/open-channel-sync#code-samples), specifically the lnrpc.OpenChannelRequest. We specify all the parameters we need for the channel open, such as the channel size (local\_funding\_amount), the peer pubkey (node\_pubkey) and whether the channel shall be announced (private).

For funding\_shim we use lnrpc.PsbtShim and an empty base\_pbst. We must not forget to set no\_publish to true as well.

This will return a PSBT (psbt\_fund.psbt). We repeat the above for the channel parameters of the second channel. This round, we pass the returned PSBT as the base\_psbt, instead of an empty value.

We can repeat this as often as we need. For the final round, we will set no\_publish to false.

To finalize the PSBT, we can use the [FundPsbt](https://lightning.engineering/api-docs/api/lnd/wallet-kit/fund-psbt) call. If you want to use funds held in another application or device, remember to make sure that the wallet’s xpubs have been [imported to LND](https://docs.lightning.engineering/lightning-network-tools/lnd/key\_import).

To sign the transaction, we will have to pass the PSBT either to LND using the [signPsbt](https://lightning.engineering/api-docs/api/lnd/wallet-kit/sign-psbt) RPC call. Alternatively, the PSBT will have to be signed by the external application or wallet.

Now we need the [fundingStateStep](https://lightning.engineering/api-docs/api/lnd/lightning/funding-state-step) API to verify the PSBT using the psbt\_verify call with skip\_finalize set to true for all channels except the last one (1 to n-1). The correct pending\_chan\_id has to be specified each time. This verifies that the transaction contains the correct outputs to fund the channel. These outputs have to be used to create the correct commitment transactions.

Only for the last channel do we repeat the above step with the latest pending\_chan\_id with skip\_finalize set to false.

Finally, we repeat the above step one last time for the first channel, using the latest PSBT, the latest pending\_chan\_id and psbt\_finalize set to true.

## Bulk onchain transactions

The [SendMany](https://lightning.engineering/api-docs/api/lnd/lightning/send-many) API lets you send an onchain transaction with multiple outputs, but it does not let you select specific inputs, and cannot be combined with a channel open.

We begin by calling the [FundPsbt](https://lightning.engineering/api-docs/api/lnd/wallet-kit/fund-psbt) API. We can specify our raw inputs and outputs as part of the raw field. If we want to send this transaction from an external wallet, or have multiple onchain accounts imported to LND, we will also need to specify the account.

Using the PSBT returned in the above step, we call the [FinalizePsbt](https://lightning.engineering/api-docs/api/lnd/wallet-kit/finalize-psbt) API.

The resulting PSBT only needs to be signed. This is done with the [signPsbt](https://lightning.engineering/api-docs/api/lnd/wallet-kit/sign-psbt) RPC call.

Finally, the PSBT needs to be published, which is done with the raw transaction and [PublishTransaction](https://lightning.engineering/api-docs/api/lnd/wallet-kit/publish-transaction).
