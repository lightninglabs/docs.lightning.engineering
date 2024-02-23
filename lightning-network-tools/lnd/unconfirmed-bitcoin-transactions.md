---
description: >-
  Learn how to bump transaction fees using replace-by-fee (RBF) and
  child-pays-for-parent (CPFP) transactions.
---

# Unconfirmed Bitcoin Transactions

Bitcoin transactions are broadcast to the peer-to-peer network and first stored in memory of participating Bitcoin nodes. Before such a transaction is considered settled, or irreversible, we require it to be included in a Bitcoin block. New blocks are created on average every ten minutes, by Bitcoin miners, who earn the transaction fee attached to the transaction.

Bitcoin miners can only include a limited number of transactions into a block, and they have an economical incentive to include, or confirm, the transactions with the highest fees.

The number of blocks mined in a day can fluctuate, depending on luck and the amount of hash power deployed on the network. The amount of transactions also fluctuates. As a result, transaction fees can fluctuate widely.

LND typically measures transaction fees in satoshis per virtual byte.

The fee market, which aims to efficiently allocate the space in a block to transactions, functions like a bidding process. We may attach a fee to our transactions and submit them to the mempool, from where miners will typically pick those most profitable to them.

Depending on our preferences and requirements, we may choose a lower fee or higher fee, but there never is a guarantee as to when when our transaction might get confirmed. For example, we might submit a transaction with a high fee, but due to bad luck no blocks are mined for some time, while others submit transactions with even higher fees, resulting in our transaction remaining unconfirmed.

There are multiple mechanisms through which we can increase the fee of our transaction and jump ahead of the queue. This might be necessary when making payments that require a confirmation to be considered settled, or to safely regard an incoming transaction as final.

**Channel openings need to be confirmed within two weeks of their initiation**, otherwise your peer may disregard the new channel, and you will have to perform a unilateral close to recover your funds.

## On-chain transactions <a href="#docs-internal-guid-831ef4d5-7fff-f468-7a2f-a4204595b0ed" id="docs-internal-guid-831ef4d5-7fff-f468-7a2f-a4204595b0ed"></a>

**Outgoing transactions**

For regular on-chain transactions made from our LND, increasing the fee of our transaction is relatively straight forward. Such on-chain transactions opt into a scheme called ‘replace-by-fee,’ which allows us to create a new transaction with a higher fee and publish this to the mempool. Miners now have an incentive to pick that new transaction over the old one, and they cannot pick both.

We can use the command `lncli wallet bumpfee` to increase the fees of pending transactions. To see which transactions this may apply to, we can use `lncli listchaintxns`. To narrow down the list of transactions to unconfirmed only you can use the flags `--start_height` (and the current block height) and `--end_height -1`. Take note that the transaction id and output specified in this command relate to an input used in the transaction that you want to be confirmed, not the transaction itself.

When using the `--force` flag, an input is included even if sweeping this input costs more than it is worth.&#x20;

Example usage:\
`lncli listchaintxns --start_height 818181 --end_height -1`\
`lncli wallet bumpfee --conf_target 6 --force 38a64ad629960b0100e6954801a035c484df64f6efa783c33508054d8f2cfe95:0`

**Incoming transactions**

A Bitcoin transaction is only considered irreversible once it is confirmed in a block. In case we receive a transaction with a low fee, we might want to speed up the confirmation time to consider them settled.

For incoming transactions we aren’t able to increase the fee of the transactions ourselves, but we can create a new transaction that takes the unconfirmed incoming transaction as an input, and spend it back to ourselves with a higher fee. Miners who want to earn the transaction fee of this second, profitable transaction will also need to confirm the first transaction. This is known as child-pays-for-parent (CPFP)

We can use `lncli wallet bumpfee` in the same way as above to create such a CPFP transaction, specifying the unconfirmed, incoming transaction and the output belonging to our wallet. This new CPFP transaction is a regular on-chain transaction, which we can again bump by repeating the same command with a new fee.

Alternatively, we can send these bitcoin to a new address, for example one obtained with the command `lncli newaddress p2wkh` and use the `lncli sendcoins` command with the `--min_confs 0` flag. As we cannot specify from which output we want to make our transaction, we will have to spend nearly close to our entire balance.

`lncli sendcoins --addr bc1q8wymjatcv5xpfm4uav2pwtw534t4u0tfup2xgg --min_confs 0 --amt 2000000 --sat_per_vbyte 40`

In case we have to, we may also use the `lncli wallet bumpfee` command to increase the fee of this transaction.

If we want to eventually open a channel, we may also use the `lncli openchannel` command right away together with the `--psbt` flag to specify an output.

## Channel opening <a href="#docs-internal-guid-d7a5497d-7fff-d4c9-e294-cb0cec6c9e86" id="docs-internal-guid-d7a5497d-7fff-d4c9-e294-cb0cec6c9e86"></a>

As a channel is negotiated between two parties and dependent on its opening transaction, we may not increase the fee of its funding transaction with another, and thus cannot ‘bump’ the fee.

Instead, we have to create a CPFP transaction that takes our channel opening transaction as an input, and spends it to ourselves with a higher fee. We can do this with the `lncli wallet bumpfee` command using the transaction id of the channel that we are waiting to be opened. This only works if the channel opening had a change output, and we will need to identify this output:

1. Find the transaction ID of your channel opening. You can use the command `lncli pendingchannels`.
2. The channel\_point value will give you the transaction ID and output index, which is either `0` or `1`.
3. The output you will want to make a CPFP transaction for will then have the same transaction ID, but a different output index. So if your `channel_point` has the output index `0`, your change value will have the output index `1`. And vice versa.
4. You can double-check the transaction ID using a blockchain explorer. In the event that your channel opening transaction does not have a change output, e.g. it only has one output, you will not be able to make a CPFP transaction and cannot bump the fee.

When you specify the feerate and not a certain confirmation target (`--sat_per_byte` or `--sat_per_vbyte` instead of `--conf_target`), LND will automatically calculate a feerate for the CPFP transaction which is high enough so the effective feerate for both, parent and child transaction, matches the feerate specified in the command.

Channels need to be confirmed within two weeks after they were initiated, or else they will not become active and will have to be force closed.

`lncli wallet bumpfee --sat_per_vbyte 40 5f97234af4df23881ca5e994bf42956c9af53bf83cb63687d1d0adfcd3ece18a:0`

As of now, there is no way for you to increase the confirmation time of a channel that was opened to your node.

In case the above fails, (e.g. `the passed output does not belong to the wallet`), you may have to restart LND or retrieve the channel opening transaction from your wallet using `lncli listchaintxns`. In case the transaction fails to broadcast, observe your logs at startup and refer to the section "[rebroadcast transactions](unconfirmed-bitcoin-transactions.md#rebroadcast-transactions)" below.

## Channel closing <a href="#docs-internal-guid-5647dd03-7fff-dc71-47cf-5f7e2155a44d" id="docs-internal-guid-5647dd03-7fff-dc71-47cf-5f7e2155a44d"></a>

When closing channels, we differentiate between cooperative closes of active channels, and unilateral closes, or force closes, of inactive channels.

For **cooperative closures**, we can use the `lncli wallet bumpfee` command in a similar way as above. We will need to identify the output of the closing transaction that belongs to our wallet using a block explorer. This means the command can only be run if you had at least some balance in this channel.

In the case of a **force close**, we can use the command `lncli wallet bumpclosefee` to create a CPFP transaction that spends the outputs of our channel closure transaction. You will only be able to make use of this command if it was created as an anchor channel. To run the command successfully, you will need to specify the [channel point](../../community-resources/glossary.md#channel-point) of the channel that is being force closed.

## Rebroadcast transactions

In some instances, especially during onchain fee spikes, your transactions might not be broadcast properly to mempools of miners and explorers or be dropped entirely.

Restarting LND will automatically broadcast all unconfirmed transactions.

All transactions to and from your node's onchain wallet can be retrieved with the command `lncli listchaintxns --end_height -1`. This includes regular Bitcoin transactions, channel opens and cooperative closures as well as most [sweeps](../../the-lightning-network/payment-channels/understanding-sweeping.md). You can use the `raw_tx_hex`  and pass it to your local Bitcoin node with `bitcoin-cli sendrawtransaction "hexstring"` to publish it again. Many block explorers also allow you to publish transactions using their node [through an online interface](https://mempool.space/tx/push).

For force close transactions and some sweeps, you may attempt to retrieve the transaction from your local mempool if the transaction id is known: `bitcoin-cli getrawtransaction "txid"`

If you are unable to broadcast a transaction or finding it in the local mempool despite a recent restart, you may have to temporarily increase the size of your local mempool. This can be done through the `bitcoin.conf` file using the parameter `maxmempool`. For instance, setting `maxmempool=600` will double the size of your local mempool from the default.

Upon restarting Bitcoin Core and LND, you should find the transaction in your local mempool, from where it ideally propagates to the entire network.

## Out of band channel fees <a href="#docs-internal-guid-46b36a38-7fff-bb45-b47f-0a85542b4ba9" id="docs-internal-guid-46b36a38-7fff-bb45-b47f-0a85542b4ba9"></a>

Some providers will promise to accelerate the confirmation time of your transaction by letting you pay miners out of band directly. While this is generally possible, there often is no way to prove that the provider really has the ability to do so, e.g. is mining bitcoin themselves or connected to miners who do.
