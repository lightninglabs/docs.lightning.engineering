---
description: >-
  You can use Taproot Assets to mint, send and receive assets, verify and export
  proofs as well as generate profiles to handle your portfolio.
---

# First Steps

## Minting assets <a href="#docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e" id="docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e"></a>

Use `tapcli` to begin minting your first asset. We are minting a normal, fungible asset and we'll allow ourselves to increase the supply of this asset in the future by setting the `--new_grouped_asset` flag.

`tapcli assets mint --type normal --name beefbux --supply 100 --meta_bytes` 66616e746173746963206d6f6e6579 `--new_grouped_asset`

This will add your asset to a minting queue called a batch, which allows multiple assets to be created in a single minting transaction. This saves fees and conserves blockspace. To execute the batch and publish your mint transaction to the blockchain run:

`tapcli assets mint finalize`

You will be given a batch txid, which will have to be included in a block before you can spend your newly created assets. You can also inspect the newly created asset(s) by calling the command

`tapcli assets list`

```json
    	{
    "assets":  [
        {
            "version":  "ASSET_VERSION_V0",
            "asset_genesis":  {
                "genesis_point":  "ac6af5ab4c9485146035efa17ff16a756129472f33faa650aa56548d03f217ca:1",
                "name":  "beefbux",
                "meta_hash":  "4f5dc2c98fa1ab3cd70f18a0a63e66bb823275a47d1da48f39cf468d2be3c791",
                "asset_id":  "6ab81f9b6b72138bc77189ea4afeabcfdb8722d1d5485ddbefc7a344bd9884e6",
                "output_index":  0,
                "version":  0
            },
            "asset_type":  "NORMAL",
            "amount":  "100",
            "lock_time":  0,
            "relative_lock_time":  0,
            "script_version":  0,
            "script_key":  "0282f621af104d54bf98482f7ca8a1fce4c79aeb7100d4d28c348fe3b39f1e8982",
            "script_key_is_local":  true,
            "asset_group":  {
                "raw_group_key":  "02b397e289e828ea33ad15acb2253a7a0680e9b15e75c0315802ab7fdd465b3802",
                "tweaked_group_key":  "02671c771a383a34ac8c1872f71323a745db2ad87171590f4edd682568e453e3b3",
                "asset_witness":  "01401619352dfbc36d366cbbaefc016acac7c8934f0dc060dd9ea94bdc36247ed3ad8e95cb47a05602bc1ea2664af20d8aae8ad1affd0c661070e0157a5eb4dee92d"
            },
            "chain_anchor":  {
                "anchor_tx":  "02000000000101ca17f2038d5456aa50a6fa332f472961756af17fa1ef35601485944cabf56aac0100000000ffffffff02e8030000000000002251209745b8b13de2f58ad27acc0eb34e3528519ed1ee080dc080e52d55855010339a50162d01000000002251205744757055959c6fc95f07e2a9d102f987082dc66bcbe487ac91185c4ea0b5950140155b2951a8fd27f5699927356c200aad40db593939179b5375721e069e93ca89f52b1c19e339b23b4445675b80bcacbfa742ff2a5c548702d1bc70eb0db392da00000000",
                "anchor_txid":  "8bc4b17043b8d9165743accad55b8c8df6627b5d86341109f7f39a86eec07918",
                "anchor_block_hash":  "0000000000000000000000000000000000000000000000000000000000000000",
                "anchor_outpoint":  "8bc4b17043b8d9165743accad55b8c8df6627b5d86341109f7f39a86eec07918:0",
                "internal_key":  "03e975be0d9ba76c29c31f141029c375ef3c2fe232de5cde5a2e7c99a0e1ba08b5",
                "merkle_root":  "87acb4f74709381c82e90e0e8e95049fc705849ec2b28c9590537f32899e905f",
                "tapscript_sibling":  "",
                "block_height":  0
            },
            "prev_witnesses":  [],
            "is_spent":  false,
            "lease_owner":  "",
            "lease_expiry":  "0",
            "is_burn":  false
        }
    ]
}

```

The output of this command can be explained as follows:

`genesis_point`: The first input of the minting transaction\
`name`: The name of the asset as defined at its creation\
`meta`: The metadata as defined at its creation\
`meta_hash`: The hash of the metadata\
`asset_id`: The asset ID is a digest of the information found under asset\_genesis in the format sha256(genesis\_outpoint || asset\_tag || asset\_meta || output\_index || asset\_type).\
`output index`: The output of the minting transaction where the asset will be anchored. This is set to 0 while the transaction confirms\
`version`: The asset protocol version with which this asset was created\
`asset_type`: Whether an asset is “normal” or a collectible\
`amount`: The quantity of this asset held by you\
`lock_time`: An asset can be locked in time, similar to a bitcoin script\
`relative_lock_time`: Relative locktime, analogous to bitcoin script\
`script version`: The script protocol version with which the script was created\
`script_key`: The script key associated with the asset\
`script_key_is_local`: Whether you hold the key associated with this script.\
`asset_group`:\
`raw_group_key`: If the asset belongs to an asset group, its key will be listed here\
`tweaked_group_key`: The tweaked key is needed to later issue more assets of this group\
`asset_witness`: The witness (e.g. signature) used to prove that this asset was issued by the owner of the group key\
`chain_anchor`:\
`anchor_tx`: The raw minting transaction\
`anchor_txid`: The hash of the minting transaction\
`anchor_block_hash`: The hash of the block that the minting transaction was included in. This is set to zeros as the transaction is unconfirmed\
`anchor_outpoint`: The outpoint on the bitcoin blockchain that holds the asset\
`internal_key`: The Taproot key that holds the outpoint containing the asset\
`merkle_root`: The merkle root of the tree that includes the asset\
`tapscript_sibling`: The taproot leaf to the left or right of the leaf committing to the asset. It is used to calculate the merkle root\
`prev_witnesses`: Signatures and data related to previous transfers of this asset\
`is_spent`: Whether this asset has been spent\
`lease_owner`: Similar to leased UTXOs in LND, tapd allows specific UTXOs to be "held" for a certain amount of time, for example while waiting for signatures or channel opens. This prevents the UTXO from being accidentally spent by another process.\
`lease_expiry`: When the UTXO becomes available again for spending.\
`is_burn`: Whether the asset has been burned.

{% embed url="https://www.youtube.com/watch?v=FccI6j0mxuE" %}
Tapping into Taproot Assets #5: Mint from the CLI
{% endembed %}

[Also watch: Mint from the API](https://www.youtube.com/watch?v=IL4ojWyFPSk)

## Minting asset groups <a href="#docs-internal-guid-326a3acb-7fff-c694-2400-496ff7278e63" id="docs-internal-guid-326a3acb-7fff-c694-2400-496ff7278e63"></a>

Assets that were minted with the flag `--new_grouped_asset` do not have a fixed supply. A new batch of this asset can be minted later in a way that the two assets are considered of the same asset group, and therefore fungible.

**Note: At the moment it is not possible to spend two assets with different asset IDs, even if they belong to the same asset group.**

To increase the supply of such an asset, we will need its `tweaked_group_key`.

`tapcli assets mint --type normal --name beefbux --supply 100 --grouped_asset --group_key 02c6ca1985ae9ef257af33bb5e3389f28e798711abcb5326d8f760fdeb90c387b5`

We again have to publish the new mint transaction with:

`tapcli assets mint finalize`

You can also specify a custom fee rate (in sat/kw) using the flag `--fee_rate`

Now we can check our groups with:

`tapcli assets groups`

```json
{
    "groups":  {
        "02671c771a383a34ac8c1872f71323a745db2ad87171590f4edd682568e453e3b3":  {
            "assets":  [
                {
                    "id":  "6ab81f9b6b72138bc77189ea4afeabcfdb8722d1d5485ddbefc7a344bd9884e6",
                    "amount":  "100",
                    "lock_time":  0,
                    "relative_lock_time":  0,
                    "tag":  "beefbux",
                    "meta_hash":  "4f5dc2c98fa1ab3cd70f18a0a63e66bb823275a47d1da48f39cf468d2be3c791",
                    "type":  "NORMAL",
                    "version":  "ASSET_VERSION_V0"
                },
                {
                    "id":  "9cfada48cd7df34e61c4a29230aaf9f37e44b5381639d7bed667cd2e60565392",
                    "amount":  "100",
                    "lock_time":  0,
                    "relative_lock_time":  0,
                    "tag":  "beefbux",
                    "meta_hash":  "0000000000000000000000000000000000000000000000000000000000000000",
                    "type":  "NORMAL",
                    "version":  "ASSET_VERSION_V0"
                }
            ]
        }
    }
}


```

To inspect your balances, run `tapcli assets balance`. To show the cumulative balance across asset groups, run `tapcli assets balance --by_group`

## Synchronizing with a universe <a href="#docs-internal-guid-c0745e5e-7fff-7933-c248-d3445ea631b1" id="docs-internal-guid-c0745e5e-7fff-7933-c248-d3445ea631b1"></a>

Taproot Assets uses universes to communicate information about which assets exist and where in the blockchain they are anchored. A universe can be thought of as a virtual mempool, an explorer or a repository.

Your node will sync with the universe whenever you create a new taproot asset address with an unknown asset ID, or when specifically instructed to. This requires an asset ID or a group key.

`tapcli universe sync --universe_host <universe_ip:port> --asset_id <asset id>`

Upon successful sync, information about existing assets should be retrieved, alongside their issuance proofs.

## Generating Taproot Assets addresses <a href="#docs-internal-guid-2d861222-7fff-ef76-60b9-65367a4fd1b7" id="docs-internal-guid-2d861222-7fff-ef76-60b9-65367a4fd1b7"></a>

As soon as your minted assets have one confirmation on the blockchain, you are able to send them. To send assets, you will need the recipient’s Taproot Assets address. This Taproot Assets address is specific to an asset and amount, so to generate an address, the recipient needs to know an asset’s `asset_id`, as well as be synced to the issuer’s universe. Taproot Assets address reuse should be avoided.

When generating a Taproot Assets address, the receiver will create their expected Merkle trees, and tweak a Taproot key with it. The resulting key is converted to a Taproot address, where the receiver waits for an incoming transaction.

To generate a Taproot Assets address requesting 21 beefbux, use the following command from the tapd instance of the receiver:

`tapcli addrs new --asset_id 6ab81f9b6b72138bc77189ea4afeabcfdb8722d1d5485ddbefc7a344bd9884e6 --amt 21`



```json
{
    "encoded":  "taptb1qqqsqqspqqzzq64cr7dkkusn30rhrz02ftl2hn7msu3dr42gthd7l3argj7e3p8xq5ssyecuwudrsw354jxpsuhhzv36w3wm9tv8zu2epa8d66p9drj98canqcssyksqefuaf788ch95089vqnsn8zx5q5sevsv6u9spk0wmzh30elkspqss8ngqlx2t9x96yffvy3wqekzhaewx3ml4k37yvg3s9vgdg069pgwxpgq32rpww4hxjan9wfek2unsvvaz7tm4de5hvetjwdjjumrfva58gmnfdenjuenfdeskucm98gcnqvpj8y3rh965",
    "asset_id":  "6ab81f9b6b72138bc77189ea4afeabcfdb8722d1d5485ddbefc7a344bd9884e6",
    "asset_type":  "NORMAL",
    "amount":  "21",
    "group_key":  "02671c771a383a34ac8c1872f71323a745db2ad87171590f4edd682568e453e3b3",
    "script_key":  "025a00ca79d4f8e7c5cb479cac04e13388d4052196419ae1601b3ddb15e2fcfed0",
    "internal_key":  "03cd00f994b298ba2252c245c0cd857ee5c68eff5b47c4622302b10d43f450a1c6",
    "tapscript_sibling":  "",
    "taproot_output_key":  "e2e79389a414c4bdf1d33dba5d472134ef85dd0674d4a644cb8f09c8e0dad606",
    "proof_courier_addr":  "universerpc://universe.lightning.finance:10029",
    "asset_version":  "ASSET_VERSION_V0"
}

```

`encoded`: The bech32 encoded Taproot Assets address.\
`asset_id`: The asset ID of the asset that the address corresponds to.\
`asset_type`: Whether an asset is fungible, or a collectible.\
`amount`: The requested amount of this asset.\
`group_key`: If a key is set here, this asset is part of an asset group, meaning the issuer can expand its supply.\
`script_key`: This key identifies the script that defines how an asset may be transferred.\
`internal_key`: The key that holds the asset.\
`tapscript_sibing`: Used when sending assets to custom scripts.\
`taproot_output_key`: The key that is going to hold the Taproot output once it is received.\
`proof_courier_addr`: The mailbox over which the asset proofs are being delivered.\
`asset_version`: The version of the asset.

You’ll also be able to inspect this address again anytime with the command `tapcli addrs query`

## Sending an asset <a href="#docs-internal-guid-5d8fd7ee-7fff-475c-a392-4855bf9afc85" id="docs-internal-guid-5d8fd7ee-7fff-475c-a392-4855bf9afc85"></a>

To send the asset, run the command below from a the tapd instance of the sender. This will generate the appropriate Merkle trees for the recipient and their change outputs, sign the Taproot Assets transaction with their internal Taproot Assets key and publish the Bitcoin transaction. Not that you cannot send unconfirmed assets.

`tapcli assets send --addr taptb1qqqsqqspqqzzq64cr7dkkusn30rhrz02ftl2hn7msu3dr42gthd7l3argj7e3p8xq5ssyecuwudrsw354jxpsuhhzv36w3wm9tv8zu2epa8d66p9drj98canqcssyksqefuaf788ch95089vqnsn8zx5q5sevsv6u9spk0wmzh30elkspqss8ngqlx2t9x96yffvy3wqekzhaewx3ml4k37yvg3s9vgdg069pgwxpgq32rpww4hxjan9wfek2unsvvaz7tm4de5hvetjwdjjumrfva58gmnfdenjuenfdeskucm98gcnqvpj8y3rh965`

```json
{
    "transfer":  {
        "transfer_timestamp":  "1697139691",
        "anchor_tx_hash":  "6609cb8eca5ec250d627db843d8dc396f2d7a4e0ef17276f00151dcd7f41f900",
        "anchor_tx_height_hint":  2532414,
        "anchor_tx_chain_fees":  "257",
        "inputs":  [
            {
                "anchor_point":  "8bc4b17043b8d9165743accad55b8c8df6627b5d86341109f7f39a86eec07918:0",
                "asset_id":  "6ab81f9b6b72138bc77189ea4afeabcfdb8722d1d5485ddbefc7a344bd9884e6",
                "script_key":  "0282f621af104d54bf98482f7ca8a1fce4c79aeb7100d4d28c348fe3b39f1e8982",
                "amount":  "100"
            }
        ],
        "outputs":  [
            {
                "anchor":  {
                    "outpoint":  "00f9417fcd1d15006f2717efe0a4d7f296c38d3d84db27d650c25eca8ecb0966:0",
                    "value":  "1000",
                    "internal_key":  "02228586e7c2847b03043afc70367ed64b77df85df8925486ed52dbc6f96ec4204",
                    "taproot_asset_root":  "e8ffb79b416efb32167f12d4bf4472df8bfcc21e191f576fc1d9777a5499cd54",
                    "merkle_root":  "e8ffb79b416efb32167f12d4bf4472df8bfcc21e191f576fc1d9777a5499cd54",
                    "tapscript_sibling":  "",
                    "num_passive_assets":  0
                },
                "script_key":  "026662e4898323b036de86e7d0a546b2a9fe9f5a8c058167be5a2b1ea4885c9ed7",
                "script_key_is_local":  true,
                "amount":  "79",
                "new_proof_blob":  "5441505000040000000002241879c0ee869af3f7091134865d7b62f68d8c5bd5caac435716d9b84370b1c48b000000000450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000096e88000000000000000006fd016302000000000102dd53fb37d9c791e2f32311e76aa186f7e842503d134d605a3c2648f420deecbf0100000000ffffffff1879c0ee869af3f7091134865d7b62f68d8c5bd5caac435716d9b84370b1c48b00000000000000000003e8030000000000002251209910eafb44a642ae94e8e022abb391958d66506d9e51953ff407d1462a6f61bce803000000000000225120e2e79389a414c4bdf1d33dba5d472134ef85dd0674d4a644cb8f09c8e0dad606e40c2d0100000000225120a5a745ffbe961f24127fb6f76a28fc2e1d4a8648b305d2b79b3ac6f71ce1725f014040aaae55f1c85405e73414c58600419d468c1b8ec1a7a458800340b39f5e4c974f065b18e5f817e92d67444960de58512c8067a1bc4a0d46a7a38c7a7af727900140e6b32e5d3eaa9830b1eb776ede8bdbff60fe365528a0a49dd679baf2dbb8f0d0d3cb56453bb110c8172a5a554772effac51cf3e41f6451df261fcda3d1dd0c4a000000000801000afd017f0001000251ca17f2038d5456aa50a6fa332f472961756af17fa1ef35601485944cabf56aac0000000107626565666275784f5dc2c98fa1ab3cd70f18a0a63e66bb823275a47d1da48f39cf468d2be3c791000000000004010006014f0bad01ab01651879c0ee869af3f7091134865d7b62f68d8c5bd5caac435716d9b84370b1c48b000000006ab81f9b6b72138bc77189ea4afeabcfdb8722d1d5485ddbefc7a344bd9884e60282f621af104d54bf98482f7ca8a1fce4c79aeb7100d4d28c348fe3b39f1e898203420140c83f269e61e2a3c0ae986d6d1270389554d6133270a4b4e5edd1803ff3037da29569ea376d829d11477626ad2bf6ea99420619d3c17044c103e6b7344ac4d4690d28d09aa8f54e3bc7016e056fe79ab3e625d86f3d9362b69742c24fb1c5c9df4ef700000000000000640e0200001021026662e4898323b036de86e7d0a546b2a9fe9f5a8c058167be5a2b1ea4885c9ed7112102671c771a383a34ac8c1872f71323a745db2ad87171590f4edd682568e453e3b30c9f000400000000022102228586e7c2847b03043afc70367ed64b77df85df8925486ed52dbc6f96ec42040374014900010002201ba8c569da5506fc0dac06e25055a8acaf755da516a1cfef301e4404705597ad04220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff022700010002220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0df802c7000400000001022103cd00f994b298ba2252c245c0cd857ee5c68eff5b47c4622302b10d43f450a1c6039c017100010002201ba8c569da5506fc0dac06e25055a8acaf755da516a1cfef301e4404705597ad044a0001df29748ed601e517a70fda1ba5ca3844a1f2bb30da9df744aac5a8d40a4b11870000000000000015ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f022700010002220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2e000400000002022102a5ed9bab876767a62ed0bd0bb1e25f4ca1b0887a07fa88834c8ab50735b456e90503040101160400000000",
                "split_commit_root_hash":  "d09aa8f54e3bc7016e056fe79ab3e625d86f3d9362b69742c24fb1c5c9df4ef7",
                "output_type":  "OUTPUT_TYPE_SPLIT_ROOT",
                "asset_version":  "ASSET_VERSION_V0"
            },
            {
                "anchor":  {
                    "outpoint":  "00f9417fcd1d15006f2717efe0a4d7f296c38d3d84db27d650c25eca8ecb0966:1",
                    "value":  "1000",
                    "internal_key":  "03cd00f994b298ba2252c245c0cd857ee5c68eff5b47c4622302b10d43f450a1c6",
                    "taproot_asset_root":  "4a2e05c584f7b7eedf62267d971a56f04c0fb4e3caa6685c1f7f749e4c8a740a",
                    "merkle_root":  "4a2e05c584f7b7eedf62267d971a56f04c0fb4e3caa6685c1f7f749e4c8a740a",
                    "tapscript_sibling":  "",
                    "num_passive_assets":  0
                },
                "script_key":  "025a00ca79d4f8e7c5cb479cac04e13388d4052196419ae1601b3ddb15e2fcfed0",
                "script_key_is_local":  false,
                "amount":  "21",
                "new_proof_blob":  "5441505000040000000002241879c0ee869af3f7091134865d7b62f68d8c5bd5caac435716d9b84370b1c48b000000000450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000096e88000000000000000006fd016302000000000102dd53fb37d9c791e2f32311e76aa186f7e842503d134d605a3c2648f420deecbf0100000000ffffffff1879c0ee869af3f7091134865d7b62f68d8c5bd5caac435716d9b84370b1c48b00000000000000000003e8030000000000002251209910eafb44a642ae94e8e022abb391958d66506d9e51953ff407d1462a6f61bce803000000000000225120e2e79389a414c4bdf1d33dba5d472134ef85dd0674d4a644cb8f09c8e0dad606e40c2d0100000000225120a5a745ffbe961f24127fb6f76a28fc2e1d4a8648b305d2b79b3ac6f71ce1725f014040aaae55f1c85405e73414c58600419d468c1b8ec1a7a458800340b39f5e4c974f065b18e5f817e92d67444960de58512c8067a1bc4a0d46a7a38c7a7af727900140e6b32e5d3eaa9830b1eb776ede8bdbff60fe365528a0a49dd679baf2dbb8f0d0d3cb56453bb110c8172a5a554772effac51cf3e41f6451df261fcda3d1dd0c4a000000000801000afd02e60001000251ca17f2038d5456aa50a6fa332f472961756af17fa1ef35601485944cabf56aac0000000107626565666275784f5dc2c98fa1ab3cd70f18a0a63e66bb823275a47d1da48f39cf468d2be3c79100000000000401000601150bfd023c01fd02380165000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005fd01cd4a00013e69977bacb3b08e4fa85c6174a4d217a827bd2d108dfc6bc716c67fccc00423000000000000004fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdffd017f0001000251ca17f2038d5456aa50a6fa332f472961756af17fa1ef35601485944cabf56aac0000000107626565666275784f5dc2c98fa1ab3cd70f18a0a63e66bb823275a47d1da48f39cf468d2be3c791000000000004010006014f0bad01ab01651879c0ee869af3f7091134865d7b62f68d8c5bd5caac435716d9b84370b1c48b000000006ab81f9b6b72138bc77189ea4afeabcfdb8722d1d5485ddbefc7a344bd9884e60282f621af104d54bf98482f7ca8a1fce4c79aeb7100d4d28c348fe3b39f1e898203420140c83f269e61e2a3c0ae986d6d1270389554d6133270a4b4e5edd1803ff3037da29569ea376d829d11477626ad2bf6ea99420619d3c17044c103e6b7344ac4d4690d28d09aa8f54e3bc7016e056fe79ab3e625d86f3d9362b69742c24fb1c5c9df4ef700000000000000640e0200001021026662e4898323b036de86e7d0a546b2a9fe9f5a8c058167be5a2b1ea4885c9ed7112102671c771a383a34ac8c1872f71323a745db2ad87171590f4edd682568e453e3b30e0200001021025a00ca79d4f8e7c5cb479cac04e13388d4052196419ae1601b3ddb15e2fcfed0112102671c771a383a34ac8c1872f71323a745db2ad87171590f4edd682568e453e3b30c9f000400000001022103cd00f994b298ba2252c245c0cd857ee5c68eff5b47c4622302b10d43f450a1c60374014900010002201ba8c569da5506fc0dac06e25055a8acaf755da516a1cfef301e4404705597ad04220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff022700010002220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0df802c7000400000000022102228586e7c2847b03043afc70367ed64b77df85df8925486ed52dbc6f96ec4204039c017100010002201ba8c569da5506fc0dac06e25055a8acaf755da516a1cfef301e4404705597ad044a0001b6871b6f913014b1e08ed5c2c8df0a876f3aef77b38170620c89752e636b067d000000000000004fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f022700010002220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2e000400000002022102a5ed9bab876767a62ed0bd0bb1e25f4ca1b0887a07fa88834c8ab50735b456e905030401010f9f000400000000022102228586e7c2847b03043afc70367ed64b77df85df8925486ed52dbc6f96ec42040374014900010002201ba8c569da5506fc0dac06e25055a8acaf755da516a1cfef301e4404705597ad04220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff022700010002220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff160400000000",
                "split_commit_root_hash":  "",
                "output_type":  "OUTPUT_TYPE_SIMPLE",
                "asset_version":  "ASSET_VERSION_V0"
            }
        ]
    }
}

```

You will notice the transaction id (`00f9417fcd1d15006f2717efe0a4d7f296c38d3d84db27d650c25eca8ecb0966`) has two inputs. One input is the newly minted asset (easily identifiable by its 1000 sat amount), while the other is from LND’s internal wallet. This second input is used to pay the onchain fees.

There are three outputs. Two outputs of 1000 satoshis each and the change output of LND’s internal wallet. The two 1000 satoshi inputs anchor the proofs of the sender and receiver. Even when the sender spends all of their assets, such an output is still created to carry proof of the transfer.

Once the transaction is confirmed on the Bitcoin Blockchain the sender will attempt to make the proofs available to the recipient via an [end-to-end encrypted mailbox](../lightning-terminal/lightning-node-connect.md), similar to Lightning Node Connect (LNC).

By default, this mailbox is set to your default universe, but you can [run your own mailbox through aperture](../aperture/get-aperture.md) and configure tapd to use it by specifying the `--hashmailcourier.addr=` flag at startup.

Once the transaction is confirmed on the Bitcoin Blockchain the sender will attempt to make the proofs available to the recipient via a [LNC-style end-to-end encrypted mailbox](../lightning-terminal/lightning-node-connect.md).

{% embed url="https://www.youtube.com/watch?v=o30AiqbsYhw" %}
Tapping into Taproot Assets #7: Send from the CLI
{% endembed %}

[Also watch: Send from the API](https://www.youtube.com/watch?v=UEaNXu8me24)

## Burning Assets

Burning assets works by sending assets to a provably unspendable address.&#x20;

`tapcli assets burn --asset_id 9cfada48cd7df34e61c4a29230aaf9f37e44b5381639d7bed667cd2e60565392 --amount 50`



```
Please confirm destructive action.
Asset ID: 9cfada48cd7df34e61c4a29230aaf9f37e44b5381639d7bed667cd2e60565392
Current available balance: 100
Amount to burn: 50
Are you sure you want to irreversibly burn (destroy, remove from circulation)
 the specified amount of assets?
Please answer 'yes' or 'no' and press enter: yes
```

{% embed url="https://www.youtube.com/watch?v=qBTGxSHpyDo" %}
Tapping into Taproot Assets #9: Burn from the CLI
{% endembed %}

[Also watch: Burn from the API](https://www.youtube.com/watch?v=hYUBA-AxrtE)

## Start building on Taproot Assets

You can find the [API references for `tapd` here](https://lightning.engineering/api-docs/api/taproot-assets).
