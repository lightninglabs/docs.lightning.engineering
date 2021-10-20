---
description: >-
  Understand how fees are calculated in the Lightning Network and learn how to
  set them appropriately.
---

# Channel Fees

In the Lightning Network, routing nodes are able to charge a fee for forwarding payments, so-called Hash-Time-Locked-Contracts (HTLCs). This compensation is necessary to incentivize the efficient allocation of capital in the network to be able to receive and send fees inside of the network.

On the HTLC level, channel fees are the difference between the HTLC sent to the routing node, and the HTLC sent from the routing node onwards. As an example, if you are presented a 1000 satoshis invoice from a node one hop away that charges 1 satoshi, you will send an HTLC over 1001 satoshis to the routing node, which sends a 1000 satoshis HTLC to the final recipient.

As fees are included in the payment, and all HTLCs contingent on the same preimage, you can only charge fees for successful payments.

Fees are applied only once per channel by the party which is forwarding the fee. Meaning, as you push a payment to your neighbor node, you are able to charge a fee, and as payments are pushed to you, your neighbor charges the fee, even if the channel was created by you.

There are two kinds of fees, the base fee and the fee rate.

## Base fee

The base fee is the fee that will be charged for each forwarded HTLC, regardless of the payment size. It is typically denominated in milli-satoshi. It is referred to as `base_fee`, `base_fee_msat` and `bitcoin.basefee` in LND.

Example usage:

`lncli updatechanpolicy --base_fee_msat 1000 55d9c8e11e6a926e3929a9584298278e6297b75b75f4f8c751f6b00da05ffe72:1`

lnd.conf:

`bitcoin.basefee=1000`

## Fee rate

The fee rate is a proportional fee charged based on the value of each forwarded HTLC. It is typically denominated in parts per million, although the command `lncli updatechanpolicy` uses decimal places. The command `lncli feereport` will return both the decimal value (`fee_rate`) and the amount per million (`fee_per_mil`) for your convenience.

`lncli updatechanpolicy --fee_rate 0.000001 55d9c8e11e6a926e3929a9584298278e6297b75b75f4f8c751f6b00da05ffe72:1`

lnd.conf:

`bitcoin.feerate=1`

\[[How to identify good peers](../../the-lightning-network/routing/identify-good-peers.md)]

## Fee report <a href="docs-internal-guid-95e1a19b-7fff-a79e-ea52-a3f2c8791a5f" id="docs-internal-guid-95e1a19b-7fff-a79e-ea52-a3f2c8791a5f"></a>

The command `lncli feereport` will output a list of all your channels and your fee policies. It will also give you a summary of how many fees you have earned routing per day, week and month.

`lncli feereport`

`        {`\
`            "chan_id": "743145615608774656",`\
`            "channel_point": "2b91c69a05082d05d7135b41806cc34303837ea10383d1ac3eef77969f98d16e:0",`\
`            "base_fee_msat": "1000",`\
`            "fee_per_mil": "500",`\
`            "fee_rate": 0.000001`\
`        }`

The output above means that for each payment you are pushing through this channel, you are charging 1000 milli-satoshis (1 satoshi) plus 500 milli-satoshis per million. A 1 milllion satoshis large HTLC for example would yield you 1500 milli-satoshis, or 1.5 satoshi.

To see the fees of individual channels, and to see how much fees the other side charges for fees in your channel, you can use the query `lncli getchaninfo`,&#x20;

Example usage:

`lncli getchaninfo 743145615608774656`

`{`\
`    "channel_id": "743145615608774656",`\
`    "chan_point": "2b91c69a05082d05d7135b41806cc34303837ea10383d1ac3eef77969f98d16e:0",`\
`    "last_update": 1616482074,`\
`    "node1_pub": "021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d",`\
`    "node2_pub": "032d5a4b5a6a344ca15f6284e3e149f4716a1af782ffbb0194e0dadc077051acf0",`\
`    "capacity": "16777215",`\
`    "node1_policy": {`\
`        "time_lock_delta": 40,`\
`        "min_htlc": "1000",`\
`        "fee_base_msat": "1000",`\
`        "fee_rate_milli_msat": "500",`\
`        "disabled": false,`\
`        "max_htlc_msat": "16609443000",`\
`        "last_update": 1616480497`\
`    },`\
`  "node2_policy": {`\
`        "time_lock_delta": 40,`\
`        "min_htlc": "1000",`\
`        "fee_base_msat": "1000",`\
`        "fee_rate_milli_msat": "1000",`\
`        "disabled": false,`\
`        "max_htlc_msat": "16609443000",`\
`        "last_update": 1616482074`\
`    }`\
`}`

The output above tells you that while both sides of this channel charge 1000 milli-satoshis per forwarded payment, the fee rate of node 1 is only half of that of node 2. The smallest payment this channel can route in either way is 1000 milli-satoshis, and each HTLC has to be claimed within 40 blocks before it has to be settled on chain.

Alternatively you can probe the entire graph with the command `lncli describegraph`. This will return all channels and their policies across the entire network.

## Update channel policies

You can update your channel policies anytime using the command line. Generally, it is not recommended to update your fees frequently, as this might make you appear less of a reliable routing node. Your peers might have opened a channel with you in the expectation of a certain fee level, and at a new fee level they might not be willing to maintain their connections.

`lncli updatechanpolicy --base_fee_msat 1000 --fee_rate 0.000001 --time_lock_delta 500 --min_htlc_msat 1000 --chan_point 55d9c8e11e6a926e3929a9584298278e6297b75b75f4f8c751f6b00da05ffe72:1`\


You can also set your default channel policies in your LND configuration file.

lnd.conf:

`bitcoin.basefee=1000 # (in milli-satoshi)`\
`bitcoin.feerate=1 # (in parts per million)`

If you amend the above lines to your configuration file for the first time, it will update the channel policies for all existing channels, except for those for which the channel policies have been updated manually before. If you only want to change the fee policies of new channels, you may first apply the command `lncli updatechanpolicy` with the existing parameters to all channels before amending the configuration file and restarting lnd.

`lncli updatechanpolicy --base_fee_msat 1000 --fee_rate 0.000001`
