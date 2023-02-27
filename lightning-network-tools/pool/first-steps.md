---
description: Open a Pool account and buy your first channel using the command line.
---

# First Steps

This article discusses how to get started with Pool using the command line. To learn how to use Pool as part of the Lightning Pool user interface, [follow this link](../lightning-terminal/pool.md).

## Start pool <a href="#docs-internal-guid-4a7e3792-7fff-cd7d-0f60-db28b3c8f380" id="docs-internal-guid-4a7e3792-7fff-cd7d-0f60-db28b3c8f380"></a>

We can start the Pool daemon with the command `poold`

Depending on your LND installation, you may have to specify its RPC port, Macaroon, and TLS path.

You will need some funds in your LND’s on-chain wallet and at least one channel with enough outgoing capacity to pay 1000 satoshis for API access to Pool.

## Open an account <a href="#docs-internal-guid-5f99c63f-7fff-04b7-b3e5-340e97c8e5c6" id="docs-internal-guid-5f99c63f-7fff-04b7-b3e5-340e97c8e5c6"></a>

Once the Pool daemon is running, we can create a new account with the command `pool accounts new <amount in satoshis>`. We can also define when this account should expire, either by using an absolute block height or a period expressed in blocks. Please note that orders typically can no longer be matched 144 blocks before its expiration time.

`pool accounts new 5000000 --expiry_blocks 12960 --conf_target 12`

Once executed, you will be asked to confirm the opening of your account, including the amount and the miner fee. Upon confirmation, you will receive your trader key and transaction ID.

We can now inspect the status of the account with pool accounts list. This will inform us about the available balance, the account expiration, the utxo that the funds are currently held in and the state that the account is in. We will have to wait for two confirmations for the account to be open.

```json
{
    "accounts": [
   	 {
   		 "trader_key": "0389f9aad3e08ae5065985049428eb8d862455060b429e2ad42fda52830673e3c1",
   		 "outpoint": "76718c68111911e98100e88da62ccf4c0ba84569219f279b47cdfd4bcfb8b880:0",
   		 "value": 500000,
   		 "available_balance": 500000,
   		 "expiration_height": 787738,
   		 "state": "PENDING_OPEN",
   		 "latest_txid": "76718c68111911e98100e88da62ccf4c0ba84569219f279b47cdfd4bcfb8b880",
   		 "version": "ACCOUNT_VERSION_TAPROOT"
   	 }
    ]
}
```

## Buy incoming liquidity <a href="#docs-internal-guid-7fed671e-7fff-dbf3-7140-81970044ec23" id="docs-internal-guid-7fed671e-7fff-dbf3-7140-81970044ec23"></a>

We can now buy an incoming channel through Pool. This gives us the opportunity to receive satoshis over the Lightning Network and can help us bootstrap a routing node.

To buy an incoming channel, we will submit a bid. We will have to specify the desired channel size (amount), our account key (as obtained above), and a rate we are willing to pay, in percent.

`pool orders submit bid –amt 100000 –acct_key 0389f9aad3e08ae5065985049428eb8d862455060b429e2ad42fda52830673e3c1 --interest_rate_percent 2 --max_batch_fee_rate 7 --lease_duration_blocks 2016`

Additionally, we may find it useful to define whether the channel should be announced to the network or not, for example if we are not interested in routing payments. The self-channel balance flag can be used to create balanced channels. This balance will have to come out of our pool account too.

`--self_chan_balance`\
`--unannounced_channel`

## Add funds <a href="#docs-internal-guid-eec3bee9-7fff-690e-a766-23b33faa7a5b" id="docs-internal-guid-eec3bee9-7fff-690e-a766-23b33faa7a5b"></a>

We can add funds at any time using the command below. This gives us also the opportunity to extend the validity of our account.

`pool accounts deposit –amt 100000 –trader_key 0389f9aad3e08ae5065985049428eb8d862455060b429e2ad42fda52830673e3c1 --sat_per_vbyte 7 --expiry_height 774774`

Similarly, we can withdraw from our pool account whenever we need them.

`pool accounts withdraw –amt 100000 –acct_key 0389f9aad3e08ae5065985049428eb8d862455060b429e2ad42fda52830673e3c1 --addr bc1qlrz7ehzn4fad3hhdzku6ucauzks8d0sa2ksmtl`

## Close an account

We can close our pool account at any time with the command below. If we do not specify an address, the funds are returned to our internal LND wallet.

`pool accounts close –trader_key 0389f9aad3e08ae5065985049428eb8d862455060b429e2ad42fda52830673e3c1 --sat_per_vbyte 7`
