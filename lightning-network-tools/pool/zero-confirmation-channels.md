---
description: >-
  Zero-confirmation channels are channels that are active without being
  confirmed on the bitcoin blockchain.
---

# Zero-confirmation channels

A zero-confirmation channel (or “zero-conf” channel) is a Lightning Network payment channel that can send/receive immediately after the channel opening transaction is published, before the funding transaction is included in a block.

When opening channels in the Lightning Network, funds are deposited into the channel by the initiator and locked in a 2-of-2 multisignature contract controlled by both channel peers that can be settled on-chain at any time. Before this funding transaction is included in a block, it is vulnerable to being replaced by another transaction spending the funds back to the initiator. Hence, typically, we are required to wait for a funding transaction to be included in a block before the channel can be used.

When a node accepts an incoming channel without confirmation, it trusts that the channel will eventually confirm and not be double-spent. This trust can be minimized by opening the channel from a 2-of-2 multisignature contract between the initiator of the channel open and a known third party that can credibly assure not to collude with the initiator: Lightning Pool.

* The initiator is unable to double-spend the channel as they lack the second key to spend their UTXO
* Lightning Pool is unable to take funds for themselves, as they lack the first key to spend the UTXO
* The recipient only accepts channels co-signed by Pool
* Pool is incentivized to not collude with initiators against recipients
* Breaches of this assurance are inevitably publicly known and verifiable

## Use cases <a href="#docs-internal-guid-9715397d-7fff-bd10-2183-cc103aa325a7" id="docs-internal-guid-9715397d-7fff-bd10-2183-cc103aa325a7"></a>

Zero-conf channels are valuable for users or Lightning Service Providers (LSP) who want to immediately send and receive funds on the Lightning Network, such as merchants or users who lack sufficient inbound capacity to receive payments. They can request a new incoming channel and immediately receive and spend funds without waiting for confirmation times or relying on a trusted counterparty.

Another user may want to spend funds held in their Pool account or deploy it on the Lightning Network. They can open a channel directly from their pool account to a node supporting zero-conf channels and spend their funds right away, or earn fees through routing.

## Enable zero-confirmation channels

Zero-confirmation channels need to be explicitly enabled on your node. For your node to be able to handle such channels, short channel ID aliases must be set as well. To enable this functionality, you should amend the following in your `lnd.conf` file:

`protocol.option-scid-alias=true`\
`protocol.zero-conf=true`

Enabling zero-confirmation channels with this setting will not set your node to accept all incoming zero-confirmation channels. Only channels co-signed by Lightning Pool will be accepted.

You will need to run Pool or Lightning Terminal to accept such channels or build your own tooling to selectively accept incoming zero-conf channels opened outside of Pool.

## Get zero-confirmation outbound through Pool <a href="#docs-internal-guid-4d3649d6-7fff-38b0-21f8-a127b95d15fc" id="docs-internal-guid-4d3649d6-7fff-38b0-21f8-a127b95d15fc"></a>

The novel auction type “outbound” can be used to open outbound zero-confirmation channels. You can interact with this market using the following command:

`pool orders submit bid --amt 100000 --self_chan_balance 100000 --interest_rate_percent 0.1 --auction_type outbound --zero_conf_channel --lease_duration_blocks 2016 --channel_type script-enforced --acct_key <your account key>`

Your trader key (`--acct_key`) can be obtained with the command `pool accounts list`

Once the submitted bid is matched with an appropriate ask your new peer will open a channel to you with the requested balance on your side.

&#x20;   `"bids": [`\
&#x20;      `{`\
&#x20;          `"details": {`\
&#x20;              `"trader_key": 03d0043f745e7994bd335b81bdc7c2bd8431e5a2ebf1ad78d7b73c73ea29d9e917",`\
&#x20;              `"rate_fixed": 4960,`\
&#x20;              `"amt": "100000",`\
&#x20;              `"max_batch_fee_rate_sat_per_kw": "25000",`\
&#x20;              `"order_nonce": "6e12d00a6c23d97b017d1acf1c3a0f00866684e52787273294e2cae9b241a4ca",`\
&#x20;              `"state": "ORDER_SUBMITTED",`\
&#x20;              `"units": 1,`\
&#x20;              `"units_unfulfilled": 1,`\
&#x20;              `"reserved_value_sat": "118525",`\
&#x20;              `"creation_timestamp_ns": "1668110217242286068",`\
&#x20;              `"events": [`\
&#x20;              `],`\
&#x20;              `"min_units_match": 1,`\
&#x20;              `"channel_type": "ORDER_CHANNEL_TYPE_SCRIPT_ENFORCED",`\
&#x20;              `"allowed_node_ids": [`\
&#x20;              `],`\
&#x20;              `"not_allowed_node_ids": [`\
&#x20;              `],`\
&#x20;              `"auction_type": "AUCTION_TYPE_BTC_OUTBOUND_LIQUIDITY",`\
&#x20;              `"is_public": true`\
&#x20;          `},`\
&#x20;          `"lease_duration_blocks": 2016,`\
&#x20;          `"version": 5,`\
&#x20;          `"min_node_tier": "TIER_1",`\
&#x20;          `"self_chan_balance": "100000",`\
&#x20;          `"sidecar_ticket": "",`\
&#x20;          `"unannounced_channel": false,`\
&#x20;          `"zero_conf_channel": true`\
&#x20;      `}`\
&#x20;   `]`

## Sell zero-confirmation channels through Pool

> Reminder: `poold` can be run as a standalone daemon or bundled with `litd`. To interact with `poold`, you can use its RPC interface or the `pool` command line interface. Depending on your setup, you may have to specify the location of your `tls.cert` and the RPC port to make sure the pool CLI talks to the intended daemon.\
> \
> Examples:
>
> litd: `pool --rpcserver=localhost:8443 --tlscertpath ~/.lit/tls.cert`
>
> poold: `pool --rpcserver=localhost:12010 --tlscertpath ~/.pool/mainnet/tls.cert`

To sell zero-confirmation channels through Pool, you may submit a ask through the command line interface `pool`. The channel type must be set to “script-enforced”, as zero-confirmation channels are only available as anchor channels.

`pool orders submit ask --amt 21000000 --interest_rate_percent 0.5 --channel_type script-enforced --announcement_constraints 0 --acct_key <your trader key>`

When submitting your ask, you may specify whether you have a preference regarding selling zero-confirmation channels with the `--announcement_constraints` flag.

| 1 | only announced channels   |
| - | ------------------------- |
| 2 | only unannounced channels |
| 0 | no preference             |

Once your ask is submitted, it is ready to be matched with a corresponding bid.

## Buy zero-confirmation channels through Pool <a href="#docs-internal-guid-313e3948-7fff-2c2e-a0a6-097ba7bc6be8" id="docs-internal-guid-313e3948-7fff-2c2e-a0a6-097ba7bc6be8"></a>

Pool can be used to buy zero-confirmation channels. This is the fastest way for your node to get inbound liquidity that can be used immediately.

`pool orders submit bid --amt 1000000 --interest_rate_percent 0.5 --zero_conf_channel --channel_type script-enforced --acct_key --acct_key <your trader key>`

Executing this command will place a bid for a channel in the Pool marketplace. Once it is matched with an ask your new peer will open the channel to you.

`-- Order Details --`\
`Bid Amount: 0.01 BTC`\
`Bid Duration: 2016`\
`Total Premium (paid to maker): 0.00000999 BTC`\
`Rate Fixed: 496`\
`Rate Per Block: 0.000000496 (0.0000496%)`\
`Execution Fee:  0.00001001 BTC`\
`Max batch fee rate: 100 sat/vByte`\
`Max chain fee: 0.0016325 BTC`\
`Is public: true`\
`Confirm order (yes/no): yes`\
`{`\
&#x20;   `"accepted_order_nonce": "a46ae15ecadae7e3e11cea7f2c3f9f8bb96a80fa7064fcbf7be5bcbab8d78543",`\
&#x20;   `"updated_sidecar_ticket": ""`\
`}`

## Buy zero-confirmation sidecar channels through Pool <a href="#docs-internal-guid-e8ba0c4b-7fff-22a6-a0a2-ddef8134a33e" id="docs-internal-guid-e8ba0c4b-7fff-22a6-a0a2-ddef8134a33e"></a>

Pool can be used to buy [sidecar channels](sidecar\_channels.md) for third parties. This can be a capital effective way of onboarding your users, for instance when distributing a self-hosted payment processor or node. Sidecar channels can also be an attractive tool for those reselling Pool’s liquidity to the public.

`pool sidecar offer --amt 100000 --min_chan_amt 100000 --interest_rate_percent 0.5 --zero_conf_channel --channel_type script-enforced --auto --acct_key <your trader key>`

`-- Order Details --`\
`Bid Amount: 0.001 BTC`\
`Bid Duration: 2016`\
`Total Premium (paid to maker): 0.00000999 BTC`\
`Rate Fixed: 4960`\
`Rate Per Block: 0.000004960 (0.0004960%)`\
`Execution Fee:  0.00000101 BTC`\
`Max batch fee rate: 100 sat/vByte`\
`Max chain fee: 0.00016325 BTC`\
`Is public: true`\
`Confirm order (yes/no): yes`

This will return a sidecar ticket which can be passed on to the recipient of the channel for redemption.

`{`\
&#x20;   `"ticket":`\
`"sidecar187dAVSfEDAwHfcyTqEZxcnSNrKMLkq4mXAbmNaM9FH5xNgbjk2MzdFdwewkzQoUJjaeog6dCxCiF6QhV8yHtnZPLY6eb4LCprvMnUkLHWx6VbaFpH3uBypKrdnaMQwNbkWBXJV4MBagA2Xmevg5SWebckHWdzeYssBCDvg3ewXYDbP3kJR6gCbGA4pBJi52UTKK1VoRyYwFvUXo2RZnVoxNK3CDf51xXfXcje87FSGbBN2g8uyhuJGn6pLG69nD6g3Au"`\
`}`

## Register a zero-confirmation sidecar channel <a href="#docs-internal-guid-365816a1-7fff-3648-8bc6-058cf80e2f55" id="docs-internal-guid-365816a1-7fff-3648-8bc6-058cf80e2f55"></a>

To register a zero-confirmation sidecar channel, meaning to redeem a sidecar ticket, the recipient of the channel needs to have enabled zero-confirmation channels and SCID aliases on their LND node.

`pool sidecar register <sidecar ticket>`

Once the next batch has cleared, the channel will be available for use immediately to receive funds. Optionally, it is also possible to create balanced channels this way using the `--self_chan_balance` flag.

## Closing zero-confirmation channels <a href="#docs-internal-guid-eec12693-7fff-9895-9fa6-6a275278a8df" id="docs-internal-guid-eec12693-7fff-9895-9fa6-6a275278a8df"></a>

Zero-confirmation channels can be closed non-cooperatively at any time, like other channel types. They can also be closed cooperatively while the original channel funding is still unconfirmed. If the channel opening fees were not high enough to get the channel confirmed, then the channel closing fees have to be high enough to cover the difference to current market prices for the funds to be ultimately spendable again.

All zero-confirmation channels must be anchor channels to ensure that a [child-pays-for-parent](../lnd/unconfirmed-bitcoin-transactions.md) is always able to pay the fees necessary to get both the channel opening transaction and the commitment transaction confirmed in a reasonable amount of time, if this becomes necessary.
