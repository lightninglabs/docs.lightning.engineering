---
description: >-
  Understand how fees are calculated in the Lightning Network and learn how to
  set them appropriately.
---

# Channel Fees

In the Lightning Network, routing nodes are able to charge a fee for forwarding payments, so-called Hash-Time-Locked-Contracts (HTLCs). This compensation is necessary to incentivize the efficient allocation of capital in the network to be able to receive and send fees inside of the network.

On the HTLC level, channel fees are the difference between the HTLC sent to the routing node, and the HTLC sent from the routing node onwards. As an example, if you are presented a 1000 satoshis invoice from a node one hop away that charges 1 satoshi, you will send an HTLC over 1001 satoshis to the routing node, which sends a 1000 satoshis HTLC to the final recipient.

As fees are included in the payment, and all HTLCs contingent on the same preimage, you can only charge fees for successful payments.

Fees are applied only once per peer and per channel. Each peer can independently set their fee policies for all their channels, which are applied to the capital in the outoing channel in the event of a forward. Meaning, as you push a payment to your neighbor node, you are able to charge a fee, and as payments are pushed to you, your neighbor charges the fee, even if the channel was created by you.

When setting your fees too high, payments might not be willing to flow through your channel. When setting fees too low, the liquidity in a channel might be depleted immediately.

There are two kinds of fees, the base fee and the fee rate. Setting the fee rate correctly can mean the difference between a node that routes and one that doesn't, and make and break your node's profitability.

Fees can be defined either as defaults in your `lnd.conf` file, at the time of channel opening with `lncli openchannel` or anytime later with `lncli updatechanpolicy`.

## Base fee

The base fee is the fee that will be charged for each forwarded HTLC, regardless of the payment size. It is denominated in milli-satoshi. It is referred to as `base_fee_msat` and `bitcoin.basefee` in LND.

Example usage:

`lncli openchannel --base_fee_msat 1000 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d --local_amt 31000000`

`lncli updatechanpolicy --base_fee_msat 1000 55d9c8e11e6a926e3929a9584298278e6297b75b75f4f8c751f6b00da05ffe72:1`

lnd.conf:

`bitcoin.basefee=1000`

## Fee rate

The fee rate is a proportional fee charged based on the value of each forwarded HTLC. It is typically denominated in parts per million, although the flag `--fee_rate` uses decimal places. The command `lncli feereport` will return both the decimal value (`fee_rate`) and the amount per million (`fee_per_mil`) for your convenience.

`lncli openchannel --fee_rate_ppm 300 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d --local_amt 31000000`

`lncli updatechanpolicy --fee_rate_ppm 0.000300 55d9c8e11e6a926e3929a9584298278e6297b75b75f4f8c751f6b00da05ffe72:1`

lnd.conf:

`bitcoin.feerate=300`

Read more: [How to identify good peers](../../the-lightning-network/the-gossip-network/identify-good-peers.md)

## Fee report <a href="#docs-internal-guid-95e1a19b-7fff-a79e-ea52-a3f2c8791a5f" id="docs-internal-guid-95e1a19b-7fff-a79e-ea52-a3f2c8791a5f"></a>

The command `lncli feereport` will output a list of all your channels and your fee policies. It will also give you a summary of how many fees you have earned routing per day, week and month.

`lncli feereport`

&#x20;       `{`\
&#x20;           `"chan_id": "743145615608774656",`\
&#x20;           `"channel_point": "2b91c69a05082d05d7135b41806cc34303837ea10383d1ac3eef77969f98d16e:0",`\
&#x20;           `"base_fee_msat": "1000",`\
&#x20;           `"fee_per_mil": "500",`\
&#x20;           `"fee_rate": 0.0005`\
&#x20;       `}`

The output above means that for each payment you are pushing through this channel, you are charging 1000 milli-satoshis (1 satoshi) plus 500 satoshis per million. A 1 milllion satoshis large HTLC for example would yield you 501 satoshi.

To see the fees of individual channels, and to see how much fees the other side charges for fees in your channel, you can use the query `lncli getchaninfo`,&#x20;

Example usage:

`lncli getchaninfo 743145615608774656`

`{`\
&#x20;   `"channel_id": "743145615608774656",`\
&#x20;   `"chan_point": "2b91c69a05082d05d7135b41806cc34303837ea10383d1ac3eef77969f98d16e:0",`\
&#x20;   `"last_update": 1616482074,`\
&#x20;   `"node1_pub": "021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d",`\
&#x20;   `"node2_pub": "032d5a4b5a6a344ca15f6284e3e149f4716a1af782ffbb0194e0dadc077051acf0",`\
&#x20;   `"capacity": "16777215",`\
&#x20;   `"node1_policy": {`\
&#x20;       `"time_lock_delta": 40,`\
&#x20;       `"min_htlc": "1000",`\
&#x20;       `"fee_base_msat": "1000",`\
&#x20;       `"fee_rate_milli_msat": "500",`\
&#x20;       `"disabled": false,`\
&#x20;       `"max_htlc_msat": "16609443000",`\
&#x20;       `"last_update": 1616480497`\
&#x20;   `},`\
&#x20; `"node2_policy": {`\
&#x20;       `"time_lock_delta": 40,`\
&#x20;       `"min_htlc": "1000",`\
&#x20;       `"fee_base_msat": "1000",`\
&#x20;       `"fee_rate_milli_msat": "1000",`\
&#x20;       `"disabled": false,`\
&#x20;       `"max_htlc_msat": "16609443000",`\
&#x20;       `"last_update": 1616482074`\
&#x20;   `}`\
`}`

The output above tells you that while both sides of this channel charge 1000 milli-satoshis per forwarded payment, the fee rate of node 1 is only half of that of node 2. The smallest payment this channel can route in either way is 1000 milli-satoshis, and each HTLC has to be claimed within 40 blocks before it has to be settled on chain.

Alternatively you can probe the entire graph with the command `lncli describegraph`. This will return all channels and their policies across the entire network.

## Set channel policies <a href="#docs-internal-guid-d3266f42-7fff-ae19-59a6-27c12edb78ea" id="docs-internal-guid-d3266f42-7fff-ae19-59a6-27c12edb78ea"></a>

Starting from LND 0.16, you can set a channel’s fees at the time of the channel opening. This helps you avoid seeing your channel capacity drain before the fee can be adjusted otherwise.

`lncli openchannel --base_fee_msat 1000 --fee_rate_ppm 100 --min_htlc_msat 1000 --node_key 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d --local_amt 21000000`

## Update channel policies

You can update your channel policies anytime using the command line. Generally, it is not recommended to update your fees frequently, as this might make you appear less of a reliable routing node. Your peers might have opened a channel with you in the expectation of a certain fee level, and at a new fee level they might not be willing to maintain their connections.

`lncli updatechanpolicy --base_fee_msat 1000 --fee_rate 0.000001 --time_lock_delta 500 --min_htlc_msat 1000 --chan_point 55d9c8e11e6a926e3929a9584298278e6297b75b75f4f8c751f6b00da05ffe72:1`\


You can also set your default channel policies in your LND configuration file.

lnd.conf:

`bitcoin.basefee=1000 # (in milli-satoshi)`\
`bitcoin.feerate=1 # (in parts per million)`

If you amend the above lines to your configuration file for the first time, it will update the channel policies for all existing channels, except for those for which the channel policies have been updated manually before. If you only want to change the fee policies of new channels, you may first apply the command `lncli updatechanpolicy` with the existing parameters to all channels before amending the configuration file and restarting lnd.

`lncli updatechanpolicy --base_fee_msat 1000 --fee_rate 0.000001`

## Autofees

Lightning Terminal allows you to programmatically change your channel fees every three days based on past earnings.

[Learn more about Autofees](../lightning-terminal/autofees.md)
