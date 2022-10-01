---
description: >-
  You can use Taro to mint, send and receive assets, verify and export proofs as
  well as generate profiles to handle your portfolio.
---

# First Steps

## Minting assets: <a href="#docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e" id="docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e"></a>

Use `tarocli` to begin minting your first asset.

`tarocli assets mint --type normal --name beefbux --supply 1000 –enable_emission false --meta "fantastic money"`

This will add your asset to a minting queue called a batch, which allows multiple assets to be created in a single minting transaction. This saves fees and conserves blockspace. Minting a transaction to the blockchain immediately is possible by appending the flag `--skip_batch` to the mint command.

Inspect the newly created asset(s) by calling the command

`tarocli assets list`

```json
{
    "assets": [
        {
            "version": 0,
            "asset_genesis": {
                "genesis_point": "75c32c802872113933fc65a4814063083483540475223434441f0d8ef3a3b554:2",
                "name": "beefbux",
                "meta": "66616e746173746963206d6f6e6579",
                "asset_id": "33644efe039d3569e6bafb07bc8f5959578a909e9c5e1c15949c986c54edbf35",
                "output_index": 0,
                "genesis_bootstrap_info": "54b5a3f38e0d1f44343422750454833408634081a465fc3339117228802cc37500000002076c656f636f696e0f66616e746173746963206d6f6e65790000000000",
                "version": 0
            },
            "asset_type": "NORMAL",
            "amount": "1000",
            "lock_time": 0,
            "relative_lock_time": 0,
            "script_version": 0,
            "script_key": "029b9c43658d9b5f500765133ab3ced84eb64d53c5e3a9c16f3c3478bdf0801536",
            "asset_family": null,
            "chain_anchor": {
                "anchor_tx": "0200000000010154b5a3f38e0d1f44343422750454833408634081a465fc3339117228802cc3750200000000ffffffff02e803000000000000225120d24719222f29af678c9b4e0c09de85bab1630d21e3105dd56f4e3f96f87715fbd1662f0100000000160014b4e3d6ab7ab26fbd89eda823afa492a9fb6b60e00247304402202e11465d042306a75db1664eb7592c8d22811820b5f0cead01edd652777ad38b0220357e5476a8c330636a5db64bcb1181051af1fe28e1a265c069695ac529be0b850121030124d8eafacf0fb7fd354bac66346c3c4d4d42082459ad0a8e9f6f8e784fda6900000000",
                "anchor_txid": "92c2c1a210e750826d5b7ea708221f3b10a571e91eb11055fa7e1cc253760100",
                "anchor_block_hash": "356a55a10a5119611a12b3b793823f1f052bd41052ab90620a00000000000000",
                "anchor_outpoint": "00017653c21c7efa5510b11ee971a5103b1f2208a77e5b6d8250e710a2c1c292:0",
                "internal_key": "03202ad86dea8a65274191db0fc4f4b621d7e65b5ae45b5ccf06ef018237f4a329"
            }
        }
    ]
}

```

The output of this command can be explained as follows:

`genesis_point`: The first input of the minting transaction.

`name`: The name of the asset as defined at its creation.

`meta`: The metadata as defined at its creation.

`asset_id`: The asset ID is a digest of the information found under asset\_genesis in the format `sha256(genesis_outpoint || asset_tag || asset_meta || output_index || asset_type)`.

`output index`: The output of the minting transaction where the asset will be anchored.

`genesis_bootstrap_info`: Similar to asset\_id, this field includes all of the asset\_genesis data, starting with the genesis\_outpoint in reverse.

`asset_type`: Whether an asset is “normal” or a collectible.

`amount`: The quantity of this asset held by you

`lock_time`: An asset can be locked in time, similar to a bitcoin script

`relative_lock_time`: Relative locktime, analogous to bitcoin script

`script_key`: The script key associated with the asset

`asset_family`: If the asset belongs to an asset family, its key will be listed here

`chain_anchor`:

&#x20;   `tx`: The raw minting transaction.

&#x20;   `txid`: The hash of the minting transaction, in reverse.

&#x20;   `block_hash`: The hash of the block that the minting transaction was included in.

&#x20;   `anchor_output`: The outpoint on the bitcoin blockchain that holds the Taro asset.

&#x20;   `internal_key`: The Taproot key that holds the outpoint containing the asset.

## Generating Taro addresses: <a href="#docs-internal-guid-326a3acb-7fff-c694-2400-496ff7278e63" id="docs-internal-guid-326a3acb-7fff-c694-2400-496ff7278e63"></a>

To send assets, you will need the recipient’s Taro address. This Taro address is specific to an asset and amount, so to generate an address, the recipient needs to know an asset’s `genesis_bootstrap_info`, which contains the genesis\_outpoint, name, meta and outpoint index.  Taro address reuse should be avoided.

When generating a Taro address, the receiver will create their expected Merkle trees, and tweak a Taproot key with it. The resulting key is converted to a Taproot address, where the receiver waits for an incoming transaction.

To generate a Taro address, use the following command:

`tarocli addrs new --genesis_bootstrap_info 54b5a3f38e0d1f44343422750454833408634081a465fc3339117228802cc37500000002076c656f636f696e0f66616e746173746963206d6f6e65790000000000 --amt 100`

```json
{
    "encoded": "tarotb1qqqsqqjp2j668uuwp505gdp5yf6sg4yrxsyxxsyp53jlcveez9ez3qpvcd6sqqqqqgrkcet0vdhkjms0veskuarpwd6xjceqd4hkueteqqqqqqqqqssgq4g9dfcd47p7v49z3djqm0ml4zfe20u88x99rd7zqg2jqsp22jcxypz54jcam0tengv084s9r4a6ggde3a02ya07hs67wmh89r4uurs9wzqpvswczyf7",
    "asset_id": "33644efe039d3569e6bafb07bc8f5959578a909e9c5e1c15949c986c54edbf35",
    "asset_type": "NORMAL",
    "amount": "100",
    "family_key": null,
    "script_key": "028055056a70daf83e654a28b640dbf7fa893953f87398a51b7c2021520402a54b",
    "internal_key": "02454acb1ddbd799a18f3d6051d7ba421b98f5ea275febc35e76ee728ebce0e057",
    "taproot_output_key": "ceba6020c7cdc1eb35b3c50c4d4514779aab8cf3802985911e9bd3cfe971cc97"
}
```

`encoded`: The bech32 encoded taro address.

`asset_id`: The asset ID of the asset that the address corresponds to.

`family_key`: If emission is enabled for an asset, its family key will appear here.

`script_key`: This key identifies the script that defines how a Taro asset may be transfered.

`internal_key`: The key that holds the Taro asset.

`taproot_output_key`: The key that is going to hold the Taproot output once it is received.

\
You’ll also be able to inspect this address again anytime with the command `tarocli addrs query`

## Sending a Taro asset <a href="#docs-internal-guid-90fc9698-7fff-dc82-4d66-091df08c58a9" id="docs-internal-guid-90fc9698-7fff-dc82-4d66-091df08c58a9"></a>

To send the asset, run the command below. The sender will then generate the appropriate Merkle trees for the recipient and their change outputs, sign the Taro transaction with their internal Taro key and publish the Bitcoin transaction.

tarocli assets send -–addr `` tarotb1qqqsqqjp2j668uuwp505gdp5yf6sg4yrxsyxxsyp53jlcveez9ez3qpvcd6sqqqqqgrkcet0vdhkjms0veskuarpwd6xjceqd4hkueteqqqqqqqqqssgq4g9dfcd47p7v49z3djqm0ml4zfe20u88x99rd7zqg2jqsp22jcxypz54jcam0tengv084s9r4a6ggde3a02ya07hs67wmh89r4uurs9wzqpvswczyf7

```json
{
    "transfer_txid": "6331bcce0723065436b2a7fbca530b5b7a2ddf97a4a908f497edf409af70a396",
    "anchor_output_index": 0,
    "transfer_tx_bytes": "0200000000010292c2c1a210e750826d5b7ea708221f3b10a571e91eb11055fa7e1cc2537601000100000000ffffffff92c2c1a210e750826d5b7ea708221f3b10a571e91eb11055fa7e1cc25376010000000000000000000003e803000000000000225120c97db2ab400fd348807204da195fa646490273725bb4ddd5c28e5aaf0092fa95e803000000000000225120ceba6020c7cdc1eb35b3c50c4d4514779aab8cf3802985911e9bd3cfe971cc97e9612f01000000001600143d07986e00f2fa88e0dce8f3d6820c4339ecfb9c02483045022100abcb4b72b84eaa8971314237b13109efaaba88441713f3930a059bb9f33a90ac02206514e335fb67326859ab6dc83001b21191569f3b192b09e98d95790835927e3e0121029d4d78a69d1cb057cf36801c59d0a8bed46ed34c24e914966c0bee64f3d33aaf01405d3abab2f8153943966bec70477d0265d01c93b1281627eb0ba22d27256976f615c51ea95a72732b3c427794adfc4f0b4194a68e715a0818cf1cd1868331032b00000000",
    "taro_transfer": {
        "old_taro_root": "1cf5d432c6b9e886910f459c80e32b6481eca171f15ae0fdb1df50c3db3ae445",
        "new_taro_root": "2703ea2f4535c46fedfa6d3dde17bca691e6e5a9ffc5a14fd487caed019b306a",
        "prev_inputs": [
            {
                "anchor_point": "00017653c21c7efa5510b11ee971a5103b1f2208a77e5b6d8250e710a2c1c292:0",
                "asset_id": "33644efe039d3569e6bafb07bc8f5959578a909e9c5e1c15949c986c54edbf35",
                "script_key": "029b9c43658d9b5f500765133ab3ced84eb64d53c5e3a9c16f3c3478bdf0801536",
                "amount": "1000"
            }
        ],
        "new_outputs": [
            {
                "anchor_point": "96a370af09f4ed97f408a9a497df2d7a5b0b53cafba7b23654062307cebc3163:0",
                "asset_id": "33644efe039d3569e6bafb07bc8f5959578a909e9c5e1c15949c986c54edbf35",
                "script_key": "028055056a70daf83e654a28b640dbf7fa893953f87398a51b7c2021520402a54b",
                "amount": "900",
                "new_proof_blob": null,
                "split_commit_proof": null
            },
            {
                "anchor_point": "96a370af09f4ed97f408a9a497df2d7a5b0b53cafba7b23654062307cebc3163:0",
                "asset_id": "33644efe039d3569e6bafb07bc8f5959578a909e9c5e1c15949c986c54edbf35",
                "script_key": "028055056a70daf83e654a28b640dbf7fa893953f87398a51b7c2021520402a54b",
                "amount": "100",
                "new_proof_blob": null,
                "split_commit_proof": null
            }
        ]
    },
    "total_fee_sats": "0"
}
```

Once the transaction is confirmed on the Bitcoin Blockchain the sender will attempt to make the proofs available to the recipient via a [LNC-style end-to-end encrypted mailbox](../lightning-terminal/lightning-node-connect.md).

Sender sample log output:

```
2022-09-29 20:41:03.415 [INF] FRTR: Outbound parcel now pending for 33644efe039d3569e6bafb07bc8f5959578a909e9c5e1c15949c986c54edbf35:028055056a70daf83e654a28b640dbf7fa893953f87398a51b7c2021520402a54b, delivering notification
2022-09-29 20:41:03.416 [INF] FRTR: Waiting for confirmation of transfer_txid=96a370af09f4ed97f408a9a497df2d7a5b0b53cafba7b23654062307cebc3163
2022-09-29 20:56:33.483 [INF] FRTR: Importing receiver proof into local Proof Archive
2022-09-29 20:56:33.486 [INF] FRTR: Marking parcel (txid=96a370af09f4ed97f408a9a497df2d7a5b0b53cafba7b23654062307cebc3163) as confirmed!
2022-09-29 20:56:33.487 [INF] PROF: Attempting to deliver receiver proof for send of asset_id=33644efe039d3569e6bafb07bc8f5959578a909e9c5e1c15949c986c54edbf35, amt=100
2022-09-29 20:56:33.490 [INF] PROF: Creating sender mailbox w/ sid=8874afa1e82a389b492647399b68f27289897001854037faec21fc857ad77aa41a55f719debb47c97b5c199f2391ae339eb86e23cd11ccdceab040fa8aeaf6e6
2022-09-29 20:56:33.570 [INF] PROF: Sending receiver proof via sid=8874afa1e82a389b492647399b68f27289897001854037faec21fc857ad77aa41a55f719debb47c97b5c199f2391ae339eb86e23cd11ccdceab040fa8aeaf6e6
2022-09-29 20:56:33.570 [INF] PROF: Creating receiver mailbox w/ sid=8874afa1e82a389b492647399b68f27289897001854037faec21fc857ad77aa41a55f719debb47c97b5c199f2391ae339eb86e23cd11ccdceab040fa8aeaf6e7
2022-09-29 20:56:33.652 [INF] PROF: Waiting for receiver proof via sid=8874afa1e82a389b492647399b68f27289897001854037faec21fc857ad77aa41a55f719debb47c97b5c199f2391ae339eb86e23cd11ccdceab040fa8aeaf6e7
2022-09-29 20:56:33.822 [INF] PROF: Received ACK from receiver! Cleaning up mailboxes…js
```

Similarly, the recipient will call the same mailbox and await their proofs there. These proofs include previous Merkle trees and signatures.

Recipient sample log output:

```
2022-09-29 20:40:20.007 [INF] RPCS: [NewAddr]: making new addr: asset_id=33644efe039d3569e6bafb07bc8f5959578a909e9c5e1c15949c986c54edbf35, amt=100, type=Normal
2022-09-29 20:40:20.055 [INF] GRDN: Imported Taro address tarotb1qqqsqqjp2j668uuwp505gdp5yf6sg4yrxsyxxsyp53jlcveez9ez3qpvcd6sqqqqqgrkcet0vdhkjms0veskuarpwd6xjceqd4hkueteqqqqqqqqqssgq4g9dfcd47p7v49z3djqm0ml4zfe20u88x99rd7zqg2jqsp22jcxypz54jcam0tengv084s9r4a6ggde3a02ya07hs67wmh89r4uurs9wzqpvswczyf7 into wallet, watching p2tr address tb1pe6axqgx8ehq7kddnc5xy63g5w7d2hr8nsq5ctyg7n0ful6t3ejtsuq30t7 on chain
2022-09-29 20:41:03.267 [INF] GRDN: Found inbound asset transfer for Taro address tarotb1qqqsqqjp2j668uuwp505gdp5yf6sg4yrxsyxxsyp53jlcveez9ez3qpvcd6sqqqqqgrkcet0vdhkjms0veskuarpwd6xjceqd4hkueteqqqqqqqqqssgq4g9dfcd47p7v49z3djqm0ml4zfe20u88x99rd7zqg2jqsp22jcxypz54jcam0tengv084s9r4a6ggde3a02ya07hs67wmh89r4uurs9wzqpvswczyf7 in 96a370af09f4ed97f408a9a497df2d7a5b0b53cafba7b23654062307cebc3163:1
2022-09-29 20:41:03.365 [INF] PROF: Attempting to receive proof via sid=8874afa1e82a389b492647399b68f27289897001854037faec21fc857ad77aa41a55f719debb47c97b5c199f2391ae339eb86e23cd11ccdceab040fa8aeaf6e6
2022-09-29 20:56:33.651 [INF] PROF: Sending ACK to sender via sid=8874afa1e82a389b492647399b68f27289897001854037faec21fc857ad77aa41a55f719debb47c97b5c199f2391ae339eb86e23cd11ccdceab040fa8aeaf6e7
2022-09-29 20:56:33.743 [INF] GRDN: Received new proof file, version=0, num_proofs=2
```

Alternatively, you may also find the proof files in `~/.taro/data/testnet/proofs`

You can export the proof of a particular asset with the command below.

`tarocli proofs export –genesis_bootstrap_info 33644efe039d3569e6bafb07bc8f5959578a909e9c5e1c15949c986c54edbf35 –script_key 029b9c43658d9b5f500765133ab3ced84eb64d53c5e3a9c16f3c3478bdf0801536`

The recipient may import them using the commmand:

`tarocli proofs import –proof_file 028055056a70daf83e654a28b640dbf7fa893953f87398a51b7c2021520402a54b.taro`
