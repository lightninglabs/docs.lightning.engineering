---
description: >-
  Learn how to fund your wallet, open your first channel and make your first
  payments with LND.
---

# First Steps With LND

To begin using LND, we first need to make sure it is running and fully synced to the chain and graph. We can use the command `lncli getinfo` to get this information. If your node is not yet synced to the chain or graph, we will need to wait. If the command fails entirely, LND may not be running.

Once your LND node is running and fully synced, we can begin using it to open channels and make payments. Depending on what we want to achieve, the flow might differ, but the following guide should provide a good representation of a typical [payment channel lifecycle](../../the-lightning-network/payment-channels/lifecycle-of-a-payment-channel.md).

## Deposit bitcoin <a href="#docs-internal-guid-8b3e92ed-7fff-7a3c-bb3f-c59cbd3f45db" id="docs-internal-guid-8b3e92ed-7fff-7a3c-bb3f-c59cbd3f45db"></a>

The first step to getting started is to deposit bitcoin into our Lightning Node with an on-chain transaction. We can generate a taproot address with the command `lncli newaddress p2tr`. If our existing wallet or exchange does not support sending to taproot addresses, we can also replace `p2tr` with legacy segwit (`np2whk`) or native segwit (`p2whk`) to generate the respective address formats.

Once our bitcoin transaction is waiting to be confirmed, we can use the command `lncli walletbalance` to see the new unconfirmed balance of our wallet.

## Open a channel <a href="#docs-internal-guid-cc7ef0e6-7fff-09d1-5425-d232ccb1735f" id="docs-internal-guid-cc7ef0e6-7fff-09d1-5425-d232ccb1735f"></a>

To open a channel, we will first need to decide on a peer. You can use [Lightning Terminal](https://terminal.lightning.engineering/#/) or a [Lightning Network explorer](broken-reference) to find a peer.

[Read more: Identifying Good Peers in the Lightning Network](../../the-lightning-network/the-gossip-network/identify-good-peers.md)

To open a channel, we need to know our peer’s public key and their IP or onion address. We’ll also need to decide on a channel capacity. We should also note that we might not be able to open a channel of the full amount that we have in our wallet, due to on-chain fees and anchor reserves (for each channel our node needs to keep 10,000 satoshis in on-chain balance, up to a total balance of 100,000 satoshis). Additionally, it’s important to note that some peers might also impose minimum channel sizes. You can try to triangulate the minimum channel size for certain peers by looking at an explorer. But, regardless, you will be notified of the minimum channel size when you try to open a channel.

We can use a command like the following to open our first channel. It specified the peer’s node key, their onion address and port, the channel size and the fees we are willing to pay for this transaction. Your channel will have to be confirmed on the blockchain within two weeks, or your peer might forget about it! If our wallet balance is still unconfirmed, we can only use it to open a channel with it by specifying `min_confs` to be zero.

`lncli openchannel --node_key 026165850492521f4ac8abd9bd8088123446d126f648ca35e60f88177dc149ceb2 --connect d7kak4gpnbamm3b4ufq54aatgm3alhx3jwmu6kyy2bgjaauinkipz3id.onion:9735 --local_amt 1000000 --sat_per_vbyte 1 --min_confs 0`

Typically, our channel will take three confirmations to be considered open and usable.

## Make a payment <a href="#docs-internal-guid-e03619d4-7fff-26a0-cb13-e562cd8da765" id="docs-internal-guid-e03619d4-7fff-26a0-cb13-e562cd8da765"></a>

Once our channel is active, we can use it to make outgoing payments. Grab a Lightning invoice from a mobile wallet or online shop. Then, pay the invoice with the command line!

`lncli payinvoice lnbc10u1p30rpd4pp5zuewvg8ltvet6exlm7r6jv3tqrgw4t6hqfvuxzr8yak80lpz2kfqdp9gf6kjmryv4ew9qyewvsywatfv3jjq5n0vd4hxcqzpgxqyz5vqsp5xznzm7hyrezws4djjw375axnpexzparf8vgcuv2gu8md0ma7frsq9qyyssq2p4kgmerjz9c220gkkf7fwcdcrs0ux3ghy5mgryzws0tk9pq5uv3kqzfdztjxt6qe0zsgqe3u53ckfh3k2z2fvznu8tlfd92cs9a3egputr0mg`

In your Terminal, you will see what route the payment is taking and what fee it is paying.

## Get inbound capacity <a href="#docs-internal-guid-5a0824e8-7fff-a856-9465-b08602b91d82" id="docs-internal-guid-5a0824e8-7fff-a856-9465-b08602b91d82"></a>

Before we can receive payments, we will need to get some inbound capacity. We can achieve this in multiple ways:

* Make many outgoing payments
* [Loop Out](../loop/)
* Ask a friend to open a channel, or buy a channel using [Lightning Pool](../pool/)

[Read more: How to get inbound capacity on the Lightning Network](../../the-lightning-network/liquidity/how-to-get-inbound-capacity-on-the-lightning-network.md)

We can see the remote and local balance for all our channels with the command `lncli listchannels`

## Receive payments <a href="#docs-internal-guid-1693cc0e-7fff-f30d-d593-c7a25d4bc7b4" id="docs-internal-guid-1693cc0e-7fff-f30d-d593-c7a25d4bc7b4"></a>

Once we have inbound capacity, we can begin receiving payments over the Lightning network.

We can create a blank invoice with the command `lncli addinvoice` and pass it to a mobile wallet or whoever owes us money.

We can also specify parameters to create a more specific invoice, for example, by including an amount or a note. Popular options include:

`--memo` A memo, such as “for dinner yesterday”

`--amt` An amount in satoshis

`--expiry` An expiry time in seconds. The default is 3600 seconds (1h)

`--amp` Generates an AMP invoice which can be paid multiple times

[Read more: Generating and understanding AMP invoices](amp.md)

## Connect to Terminal <a href="#docs-internal-guid-85a3818d-7fff-f840-65d7-583eae5a2936" id="docs-internal-guid-85a3818d-7fff-f840-65d7-583eae5a2936"></a>

For easy access to a graphical user interface showing your peers, your most recent forwards and Lightning Lab’s liquidity products try out Lightning Terminal, which you can [learn how to setup here](../lightning-terminal/get-lit.md).
