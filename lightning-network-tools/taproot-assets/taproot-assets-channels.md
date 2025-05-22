---
description: >-
  Taproot Assets can be deposited into Lightning Network channels, where they
  can be transferred instantly at low fees.
---

# Taproot Assets Channels

While `tapd` is used to mint and transfer Taproot Assets on the Bitcoin blockchain, `lnd` is used to open channels and handle Lightning Network payments. To communicate between `tapd` and `lnd`, `litd` is required. For the moment, `litd` needs to be run in [integrated mode](../lightning-terminal/integrating-litd.md), meaning `lnd`, `tapd` and `litd` are run as a single binary.

## Configuration

To be able to make use of Taproot Assets on the Lightning Network, the following configuration options are needed as part of `lit.conf`

```
lnd.protocol.option-scid-alias=true
lnd.protocol.zero-conf=true
lnd.protocol.simple-taproot-chans=true
lnd.protocol.simple-taproot-overlay-chans=true
lnd.protocol.custom-message=17
lnd.accept-keysend=true
```

## Preparation <a href="#docs-internal-guid-5a441281-7fff-ada5-e31d-43995a475505" id="docs-internal-guid-5a441281-7fff-ada5-e31d-43995a475505"></a>

You will need a recently minted Taproot Asset held by your tapd.&#x20;

[Read more: Minting Taproot Assets on the Bitcoin blockchain](../pool/first-steps.md)

You will need two separate `litd` nodes. They may share the same Bitcoin Core backend (using RPC polling).&#x20;

[Read more: Get litd](../lightning-terminal/get-lit.md)

## Command Line Interface

With litd integrated mode, all applications are running as part of the litd binary. We will still use the regular CLIs to interact with the applications running as part of litd. For instance, we will use `lncli` to interact with LND and `tapcli` to interact with onchain Taproot Assets.

However, when opening, closing, or maintaining Taproot Assets channels or making Taproot Assets payments, we will use `litcli`.

Unless you are running `litd` on any other network than mainnet, you will have to specify the network you are running every time you invoke `litcli`.

For example:

`litcli --network=signet status`

In all following example commands, this detail is omitted for simplicity.

[Read more: Debugging Tapd](debugging-tapd.md)

## Open channels <a href="#docs-internal-guid-726c810f-7fff-a475-78a5-501c81d0113e" id="docs-internal-guid-726c810f-7fff-a475-78a5-501c81d0113e"></a>

To open a channel, we will identify the asset that we would like to deposit into our channel. We can get the group keys of the Taproot Assets we hold using `tapcli assets list`. To open the channel, we will need the `tweaked_group_key` and how many of these assets we want to deposit into our channel.

Specifying a fee rate for the channel opening transaction helps getting the transaction confirmed in time. We will need to find a peer that supports Taproot Assets. Ideally you or this peer is willing to act as an edge node, meaning they are willing to swap the asset in question for satoshis on the Lightning Network.

[Learn more: Edge nodes](../../the-lightning-network/taproot-assets/edge-nodes.md)

`litcli ln fundchannel --node_key 03e347d089c071c27680e26299223e80a740cf3e3fc4b4237fa219bb67121a670b --sat_per_vbyte 16 --asset_amount 1000 --group_key 2875ce409b587a6656357639d099ad9eb08396d0dfea8930a45e742c81d6fc782`

As the channel is opening, you will see the channel `txid`. You should be able to immediately see the channel details with `lncli pendingchannels` and once confirmed, with `lncli listchannels`:

```
{
    "channels": [
        {
            "active": true,
            "remote_pubkey": "0312bddcf146394bf0805feef967e8485b8648c66065fe7345c4bc97eac8312df7",
            "channel_point": "4cc78d1220c5547cf8321120471e3c5022a9d06c0df1bcfa1559a9a8e023d79b:0",
            "chan_id": "9bd723e0a8a95915fabcf10d6cd0a922503c1e47201132f87c54c520128dc74c",
            "scid": "278301786179043328",
            "scid_str": "253114x399x0",
            "capacity": "100000",
            "local_balance": "98122",
            "remote_balance": "0",
            "commit_fee": "1548",
            "commit_weight": "614",
            "fee_per_kw": "1259",
            "unsettled_balance": "0",
            "total_satoshis_sent": "0",
            "total_satoshis_received": "0",
            "num_updates": "0",
            "pending_htlcs": [],
            "csv_delay": 144,
            "private": true,
            "initiator": true,
            "chan_status_flags": "ChanStatusDefault",
            "local_chan_reserve_sat": "1000",
            "remote_chan_reserve_sat": "1062",
            "static_remote_key": false,
            "commitment_type": "SIMPLE_TAPROOT_OVERLAY",
            "lifetime": "3418",
            "uptime": "3418",
            "close_address": "",
            "push_amount_sat": "0",
            "thaw_height": 0,
            "local_constraints": {
                "csv_delay": 144,
                "chan_reserve_sat": "1000",
                "dust_limit_sat": "354",
                "max_pending_amt_msat": "99000000",
                "min_htlc_msat": "1",
                "max_accepted_htlcs": 83
            },
            "remote_constraints": {
                "csv_delay": 144,
                "chan_reserve_sat": "1062",
                "dust_limit_sat": "354",
                "max_pending_amt_msat": "99000000",
                "min_htlc_msat": "1",
                "max_accepted_htlcs": 83
            },
            "alias_scids": [
                "17592186044416000018"
            ],
            "zero_conf": false,
            "zero_conf_confirmed_scid": "0",
            "peer_alias": "Hannahs-2nd-Signet-Node",
            "peer_scid_alias": "17592186044416000010",
            "memo": "",
            "custom_channel_data": {
                "funding_assets": [
                    {
                        "version": 1,
                        "asset_genesis": {
                            "genesis_point": "d31420284ed707c98af9b35de1c87966bb449ee0a3d2aafb5eff52172decbeb0:1",
                            "name": "Stablesigs",
                            "meta_hash": "76cc761e50db8f655449ec7e5ff60be23ce45611ed362aed2242b8e265fc672f",
                            "asset_id": "c28399c74ffbbfa0166428cb91bf7b196e827d5b4bfec6117433353aa2129d5c"
                        },
                        "amount": 10000000000,
                        "script_key": "023e65e41a9f04a63968a17e3b2cfd8742b4ffaf0d39e535c5eee227fcb137990b",
                        "decimal_display": 6
                    },
                    {
                        "version": 1,
                        "asset_genesis": {
                            "genesis_point": "ac7b4bc6efdde36261850b4a8e61c49385a7be8b7c4c31da07ac9caa1a32842d:2",
                            "name": "Stablesigs",
                            "meta_hash": "76cc761e50db8f655449ec7e5ff60be23ce45611ed362aed2242b8e265fc672f",
                            "asset_id": "c5dc35d9ffa03abcbd22d2d2801d10813970875029843039bf4f99d543d15fef"
                        },
                        "amount": 8997750,
                        "script_key": "02a207ba37828ba9f9aaacddcd2da3cdf30c1d6e2c2c74cdc620f4198088691334",
                        "decimal_display": 6
                    }
                ],
                "local_assets": [
                    {
                        "asset_id": "c28399c74ffbbfa0166428cb91bf7b196e827d5b4bfec6117433353aa2129d5c",
                        "amount": 10000000000
                    },
                    {
                        "asset_id": "c5dc35d9ffa03abcbd22d2d2801d10813970875029843039bf4f99d543d15fef",
                        "amount": 8997750
                    }
                ],
                "remote_assets": [],
                "outgoing_htlcs": [],
                "incoming_htlcs": [],
                "capacity": 10008997750,
                "group_key": "02875ce409b587a6656357639d099ad9eb08396d0dfea8930a45e742c81d6fc782",
                "local_balance": 10008997750,
                "remote_balance": 0,
                "outgoing_htlc_balance": 0,
                "incoming_htlc_balance": 0
            }
        }
    ]
}

```

## Generate invoices <a href="#docs-internal-guid-ed4b6f8d-7fff-0ee2-2db0-95d8f5942eca" id="docs-internal-guid-ed4b6f8d-7fff-0ee2-2db0-95d8f5942eca"></a>

To be able to generate invoices, you must have a channel with a remote balance for the asset you are requesting. Your peer also needs to be configured for RFQ (request for quote).

[Learn: How to set up RFQ and become an Edge Node](rfq.md)

The invoice generation format follows that of LND.

`litcli ln addinvoice --memo "my first taproot asset transfer" --group_key 02875ce409b587a6656357639d099ad9eb08396d0dfea8930a45e742c81d6fc782 --asset_amount 10000000`

`lntb100n1pngas7zpp587tawysmkje0nn3ky924kn6uqrah3kg3r74fy0dxlld9cm3x6wgqdpjd4ujqenfwfehggr5v9c8ymm0wssxzumnv46zqarjv9h8xen9wgcqzzsxqzpurzjqwkt9dep6spnj6j675lwsnkqw29cq4l4apsjgdvaqp3utu6tcq3r6e3ctdznnjyxpsqqqqlgqqqqqqgq2qsp5gfvdzsac6nn869ldzljaruwnzkn4mgjfgef6t7hnka3urvgxjtss9qxpqysgqwsdtk928g7a5dcnw52nd5vp5u062h2puncsepj6w43yh4cxly9sk3fm8vqtykd6sc4hs0452kf6mh5dwe8knryz3sz5e5w7wh2uze2qp69s94y`

## Make payments <a href="#docs-internal-guid-f17bd41b-7fff-f2ab-303f-0f18de7a70b4" id="docs-internal-guid-f17bd41b-7fff-f2ab-303f-0f18de7a70b4"></a>

You can make the payment by passing the invoice to `litcli` on the sender’s node. The invoice needs to be passed together with the asset ID.

`litcli ln payinvoice --pay_req lntb100n1pngas7zpp587tawysmkje0nn3ky924kn6uqrah3kg3r74fy0dxlld9cm3x6wgqdpjd4ujqenfwfehggr5v9c8ymm0wssxzumnv46zqarjv9h8xen9wgcqzzsxqzpurzjqwkt9dep6spnj6j675lwsnkqw29cq4l4apsjgdvaqp3utu6tcq3r6e3ctdznnjyxpsqqqqlgqqqqqqgq2qsp5gfvdzsac6nn869ldzljaruwnzkn4mgjfgef6t7hnka3urvgxjtss9qxpqysgqwsdtk928g7a5dcnw52nd5vp5u062h2puncsepj6w43yh4cxly9sk3fm8vqtykd6sc4hs0452kf6mh5dwe8knryz3sz5e5w7wh2uze2qp69s94y --group_key 02875ce409b587a6656357639d099ad9eb08396d0dfea8930a45e742c81d6fc782`

You will notice that as the payment succeeds, a small amount of satoshis also gets pushed to the remote side. Satoshis are needed to anchor the taproot asset in an [HTLC](../../the-lightning-network/multihop-payments/hash-time-lock-contract-htlc.md). In a testing environment it may make sense to balance the bitcoin in the channel using keysend in order to be able to send and receive smoothly.

`lncli sendpayment --dest 03e347d089c071c27680e26299223e80a740cf3e3fc4b4237fa219bb67121a670b --outgoing_chan_id 3152442773369192448 --amt 50000 --keysend`

## Taproot Assets routing <a href="#docs-internal-guid-ac805352-7fff-651a-864e-3243c67310cb" id="docs-internal-guid-ac805352-7fff-651a-864e-3243c67310cb"></a>

In a testing environment, try to create multihop routes that involve Taproot Assets channel.

litd (A) <-> litd (B) <-> any Lightning node implementation (C)

We can simulate an environment in which a user (A) holds Taproot Assets in a Lightning Network channel with an Edge Node (B). User (A) will now be able to pay generic Bolt11 Lightning Network invoices presented by node (C).

User (A) is also able to request assets by generating invoices that are payable by node (C), regardless of whether node (C) has knowledge of Taproot Assets.

## Close channels <a href="#docs-internal-guid-cae8d4b8-7fff-8602-fd37-0f33c55122ea" id="docs-internal-guid-cae8d4b8-7fff-8602-fd37-0f33c55122ea"></a>

We can close channels using `lncli` as if it were a normal channel. It is preferable to close channels cooperatively, but if the peer cannot be reached, it may be necessary to unilaterally close a channel with the `--force` flag.

`lncli closechannel --chan_point 3596bc22e11333b5c06ea9b4b05ced089acd545df4d1125dca8346b1b5fc64b5:0`
