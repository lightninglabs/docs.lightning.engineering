---
description: >-
  You can use Taproot Assets to mint, send and receive assets, verify and export
  proofs as well as generate profiles to handle your portfolio.
---

# First Steps

## Minting assets <a href="#docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e" id="docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e"></a>

Use `tapcli` to begin minting your first asset.

`tapcli assets mint --type normal --name beefbux --supply 100 --meta_bytes "fantastic money" --enable_emission true`

This will add your asset to a minting queue called a batch, which allows multiple assets to be created in a single minting transaction. This saves fees and conserves blockspace. To execute the batch and publish your mint transaction to the blockchain run:

`tapcli` assets mint finalize

Inspect the newly created asset(s) by calling the command

`tapcli assets list`

```json
    	{
        	"version": 0,
        	"asset_genesis": {
            	"genesis_point": "a0a006debdb9d8bb9762342dab3f0a5025b1f4d18bfded996a51fc76f1c25adb:1",
            	"name": "beefbux",
            	"meta_hash": "04e552053fd4c8e2c01bc14cb9a0ce00f07d4ffdffff68fe455c70b934b22a43",
            	"asset_id": "a40a503a04f6bd5a63a97201adfbf67fb3c9bc4edf5e6ef1017cda009d0d5a29",
            	"output_index": 0,
            	"version": 0
        	},
        	"asset_type": "NORMAL",
        	"amount": "100",
        	"lock_time": 0,
        	"relative_lock_time": 0,
        	"script_version": 0,
        	"script_key": "027191bd1ae6004de4865f1ad4209d2bd5f9bbbb8f641e05ebe1527063444846d9",
        	"script_key_is_local": true,
        	"asset_group": {
            	"raw_group_key": "02c2548cf34e093a1436410ad5f08ce89fbb5f66a709389108f9532c9ed190c5d7",
            	"tweaked_group_key": "02c6ca1985ae9ef257af33bb5e3389f28e798711abcb5326d8f760fdeb90c387b5",
            	"asset_id_sig": "92023dfda65e0f0dbff4c68fc9efad586273ac370ac95e86e46705d14cbc881207035b7f16f958c3e2778ff74ea6cd2fca72340e905fb815a230c2916710a867"
        	},
        	"chain_anchor": {
            	"anchor_tx": "02000000000101db5ac2f176fc516a99edfd8bd1f4b125500a3fab2d346297bbd8b9bdde06a0a00100000000ffffffff02e803000000000000225120d46c97ab87c7bead688180be67928d879e7f0e6b9fa46442d8706ac1c079f64a71a72d0100000000225120f37da1318803e4a162dd070689f7141968fe49ec58915362554e0b5e816a92590140119970f27d6ce48b3dcdd6235b5283addacb93e764fc30294da574b0b24fd7b0199f6cbebf5492a1495791784db0af00b5f0a1a3a3dfd69be186770d37f06c5d00000000",
            	"anchor_txid": "923991e16658f4720d0a347369005a1494166e12ddf692a1e67dbc14f9632544",
            	"anchor_block_hash": "5dd19802ac50fee0b45fd288799601e05f47086335b56ebd0400000000000000",
            	"anchor_outpoint": "923991e16658f4720d0a347369005a1494166e12ddf692a1e67dbc14f9632544:0",
            	"internal_key": "033cd4127cd8bafce215cc43e9c0dc6dde7c8aed8d77f4b47a673c90b4b57c934a",
            	"merkle_root": "eefd0b6a63a7cf25a4db7c4bea4383b4ec33ba461e15cbdaddca08c3f389e6e9",
            	"tapscript_sibling": null
        	},
        	"prev_witnesses": [
        	],
        	"is_spent": false
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
`asset_id_sig`: The signature used to prove that this asset was issued by the owner of the group key\
`chain_anchor`:\
`tx`: The raw minting transaction\
`txid`: The hash of the minting transaction\
`block_hash`: The hash of the block that the minting transaction was included in. This is set to zeros as the transaction is unconfirmed\
`anchor_outpoint`: The outpoint on the bitcoin blockchain that holds the asset\
`internal_key`: The Taproot key that holds the outpoint containing the asset\
`merkle_root`: The merkle root of the tree that includes the asset\
`tapscript_sibling`: The taproot leaf to the left or right of the leaf committing to the asset. It is used to calculate the merkle root\
`prev_witnesses`: Signatures and data related to previous transfers of this asset\
`is_spent`: Whether this asset has been spent

## Minting asset groups <a href="#docs-internal-guid-326a3acb-7fff-c694-2400-496ff7278e63" id="docs-internal-guid-326a3acb-7fff-c694-2400-496ff7278e63"></a>



Assets that were minted with the flag `--emission_true` do not have a fixed supply. A new batch of this asset can be minted later in a way that the two assets are considered of the same asset group, and therefore fungible.

To increase the supply of such an asset, we will need its `tweaked_group_key`.

`tapcli assets mint --type normal --name beefbux --supply 100 --group_key 02c6ca1985ae9ef257af33bb5e3389f28e798711abcb5326d8f760fdeb90c387b5`

We again have to publish the new mint transaction with:

`tapcli assets mint finalize`

Now we can check our groups with:

`tapcli assets groups`

```json
{
	"groups": {
    	"02c6ca1985ae9ef257af33bb5e3389f28e798711abcb5326d8f760fdeb90c387b5": {
        	"assets": [
            	{
                	"id": "a40a503a04f6bd5a63a97201adfbf67fb3c9bc4edf5e6ef1017cda009d0d5a29",
                	"amount": "100",
                	"lock_time": 0,
                	"relative_lock_time": 0,
                	"tag": "beefbux",
                	"meta_hash": "04e552053fd4c8e2c01bc14cb9a0ce00f07d4ffdffff68fe455c70b934b22a43",
                	"type": "NORMAL"
            	},
            	{
                	"id": "c4eec833fe1753d839557304d15d799596d3ae34de01bc80691251dfc386e30d",
                	"amount": "100",
                	"lock_time": 0,
                	"relative_lock_time": 0,
                	"tag": "beefbux",
                	"meta_hash": "0000000000000000000000000000000000000000000000000000000000000000",
                	"type": "NORMAL"
            	}
        	]
    	}
}

```

## Synchronizing with a universe <a href="#docs-internal-guid-c0745e5e-7fff-7933-c248-d3445ea631b1" id="docs-internal-guid-c0745e5e-7fff-7933-c248-d3445ea631b1"></a>

Taproot Assets uses universes to communicate information about which assets exist and where in the blockchain they are anchored. A universe can be thought of as a virtual mempool, an explorer or a repository.

Tapd bundles the software necessary to run a universe, allowing anyone to run a universe, or even connecting to others peer-to-peer. Typically, before requesting an asset transfer or creating a Taproot Asset address, the recipient would synchronize with a universe, either to obtain information about all assets in existence, a specific asset ID or group key.

In the example below we are fetching the list of assets from a universe running on port 10029 on the same machine.

`tapcli universe sync --universe_host 127.0.0.1:10029`

Upon successful sync, information about existing assets should be retrieved, alongside their issuance proofs. To push information about assets you created, you will need to add this universe to your local federation.

## Running a universe and universe federations <a href="#docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f" id="docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f"></a>

Running a universe is as simple as running `tapd`. To run a universe, set your instance to listen on the RPC port (10029) and ensure this port is open on your machine. Being publicly reachable is not a requirement for a universe, however. Your universe may only serve resources on a private network, or be otherwise restricted.

`tapd --rpclisten 0.0.0.0:10029`

As a universe you may choose to synchronize yourself with other universes, called a federation. Each client defines their own federation, meaning a set of universes with which they periodically sync with and exchange information about newly created and transferred assets.

`tapcli universe federation add --universe_host testnet.universe.lightning.finance`

## Generating Taproot Assets addresses <a href="#docs-internal-guid-2d861222-7fff-ef76-60b9-65367a4fd1b7" id="docs-internal-guid-2d861222-7fff-ef76-60b9-65367a4fd1b7"></a>

To send assets, you will need the recipient’s Taproot Assets address. This Taproot Assets address is specific to an asset and amount, so to generate an address, the recipient needs to know an asset’s `asset_id`, as well as be synced to the issuer’s universe. Taproot Assets address reuse should be avoided.

When generating a Taproot Assets address, the receiver will create their expected Merkle trees, and tweak a Taproot key with it. The resulting key is converted to a Taproot address, where the receiver waits for an incoming transaction.

To generate a Taproot Assets address requesting 21 beefbux, use the following command:

tapcli addrs new --asset\_id 86b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e2 --amt 21



```json
{
	"encoded": "taptb1qqqsqq3qs666sxcl6493w0ph32m843cgvzqryazfn0fa5urswjezyv2kjr3qgggzre78k5uky43x6pftrrwfsrd66kzx8k5dm0g3phh7d7y73yv36xlsvggzc05kyp6q4amtwv9u2r570uhn2qxrd5qdkgekcsfjku4kzgqpc9pqsqg466zcju",
	"asset_id": "86b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e2",
	"asset_type": "NORMAL",
	"amount": "21",
	"group_key": null,
	"script_key": "021e7c7b539625626d052b18dc980dbad58463da8ddbd110defe6f89e89191d1bf",
	"internal_key": "02c3e9620740af76b730bc50e9e7f2f3500c36d00db2336c4132b72b612001c142",
	"tapscript_sibling": null,
	"taproot_output_key": "00b6f8a9312180dae841f4eef10a9e0ce3d95b5c23f7d7f516264d4ccfae8426"
}

```

`encoded`: The bech32 encoded Taproot Assets address.\
`asset_id`: The asset ID of the asset that the address corresponds to.\
`family_key`: If emission is enabled for an asset, its family key will appear here.\
`asset_type`: Whether an asset is fungible, or a collectible.\
`amount`: The requested amount of this asset.\
`group_key`: If a key is set here, this asset is part of an asset group, meaning the issuer can expand its supply.\
`script_key`: This key identifies the script that defines how an asset may be transferred.\
`internal_key`: The key that holds the asset.\
`taproot_output_key`: The key that is going to hold the Taproot output once it is received.

You’ll also be able to inspect this address again anytime with the command `tapcli addrs query`

## Sending an asset <a href="#docs-internal-guid-5d8fd7ee-7fff-475c-a392-4855bf9afc85" id="docs-internal-guid-5d8fd7ee-7fff-475c-a392-4855bf9afc85"></a>

To send the asset, run the command below. The sender will then generate the appropriate Merkle trees for the recipient and their change outputs, sign the Taproot Assets transaction with their internal Taproot Assets key and publish the Bitcoin transaction.

`tapcli assets send --addr taptb1qqqsqq3qs666sxcl6493w0ph32m843cgvzqryazfn0fa5urswjezyv2kjr3qgggzre78k5uky43x6pftrrwfsrd66kzx8k5dm0g3phh7d7y73yv36xlsvggzc05kyp6q4amtwv9u2r570uhn2qxrd5qdkgekcsfjku4kzgqpc9pqsqg466zcju`

```json
{
	"transfer": {
    	"transfer_timestamp": "1683332161",
    	"anchor_tx_hash": "73d321500505fc795b0c479c3a6030ead15f2f73f43bef50a2479c6cc7d7bfbd",
    	"anchor_tx_height_hint": 2431910,
    	"anchor_tx_chain_fees": "256",
    	"inputs": [
        	{
            	"anchor_point": "0698086338868634107ecfee79da1f0d09da16b355220363e92c729789d4099d:0",
            	"asset_id": "86b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e2",
            	"script_key": "020f5ed7a45d9970a998c6f8283b10f3287f23b37c2ed489dd2fee9742e5364334",
            	"amount": "58"
        	}
    	],
    	"outputs": [
        	{
            	"anchor": {
                	"outpoint": "bdbfd7c76c9c47a250ef3bf4732f5fd1ea30603a9c470c5b79fc05055021d373:0",
                	"value": "1000",
                	"internal_key": "027bcd8e0aa88b4394f4cb515c4625cf2cbef56355e780c8fab492e9f8ab68cd84",
                	"tap_root": "4e13f7ac6e012b46dba9c482ca34d133f0cb7065d625a5fd68f4cd8e582c575c",
                	"merkle_root": "4e13f7ac6e012b46dba9c482ca34d133f0cb7065d625a5fd68f4cd8e582c575c",
                	"tapscript_sibling": null,
                	"num_passive_assets": 0
            	},
            	"script_key": "02b1383908554974589b80923a400809d3537ed27555c9a7b17e21e937a1156f21",
            	"script_key_is_local": true,
            	"amount": "37",
            	"new_proof_blob": "00249d09d48997722ce963032255b316da090d1fda79eecf7e103486863863089806000000000150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000096e88000000000000000002fd018102000000000102fed28e57510897d40d8965fd057c66b2e291c87b2c3fdb7c59d1ecad9d3a5f430100000000ffffffff9d09d48997722ce963032255b316da090d1fda79eecf7e10348686386308980600000000000000000003e80300000000000022512020838d1e810846e74d45661ba16ca5edece1fb517a140a27b4b86744fbdfc19de80300000000000022512000b6f8a9312180dae841f4eef10a9e0ce3d95b5c23f7d7f516264d4ccfae8426f3c22d01000000001600146e4b35798e1d01f37e43132a2f253d4fd71ed96902483045022100c9c9d1c87f0b2933b1d78294b051b22e5142912981050e7bf4d3177c2f735ee30220107a0d7d8f24e16ef1ee985439412fbf1041d0545938811df4bfa1d0a332d99d01210341b2382ff83a137cc3de470dbbe8a3d5234327dcdec3b212c78a39038368737a0140e1d914f20dd919b0d1f7e5b4ada23673d93404e77f6c529232daf91be4c68ec5aa551a972d2dc28c3279e29afd1bffa54e272a3bc180bedfd14eee25eb54246d0000000003010004fd016000010001556331bcce0723065436b2a7fbca530b5b7a2ddf97a4a908f497edf409af70a396000000020b66616e74617379636f696e04e552053fd4c8e2c01bc14cb9a0ce00f07d4ffdffff68fe455c70b934b22a43000000000002010003012506ad01ab00659d09d48997722ce963032255b316da090d1fda79eecf7e1034868638630898060000000086b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e2020f5ed7a45d9970a998c6f8283b10f3287f23b37c2ed489dd2fee9742e536433401420140702c84050a03e6b16b5238a03a45c485cf1a9bf4a28bb0f06555f2c21ea50ca3d3c97a3fa44bb962ce8408671afaf294d75812688cce74e0052886c3c15fd56f07281a823d464dc06be6529f0aee8da78da224ca6c0eb849a39f55e69cc50b2c0c72000000000000003a08020000092102b1383908554974589b80923a400809d3537ed27555c9a7b17e21e937a1156f21059f0004000000000121027bcd8e0aa88b4394f4cb515c4625cf2cbef56355e780c8fab492e9f8ab68cd8402740049000100012086b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e202220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff012700010001220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff06c901c7000400000001012102c3e9620740af76b730bc50e9e7f2f3500c36d00db2336c4132b72b612001c142029c0071000100012086b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e2024a00018093d84f911c1084ebf4a70d7b7c8a98c984a495b827f151ed06c0477977937f0000000000000015ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffbf012700010001220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            	"split_commit_root_hash": "1a823d464dc06be6529f0aee8da78da224ca6c0eb849a39f55e69cc50b2c0c72"
        	},
        	{
            	"anchor": {
                	"outpoint": "bdbfd7c76c9c47a250ef3bf4732f5fd1ea30603a9c470c5b79fc05055021d373:1",
                	"value": "1000",
                	"internal_key": "02c3e9620740af76b730bc50e9e7f2f3500c36d00db2336c4132b72b612001c142",
                	"tap_root": "7dffe5de5f22dee531f6bf2b56690779765fafa66ff4f57822a6e9aa89b10fec",
                	"merkle_root": "7dffe5de5f22dee531f6bf2b56690779765fafa66ff4f57822a6e9aa89b10fec",
                	"tapscript_sibling": null,
                	"num_passive_assets": 0
            	},
            	"script_key": "021e7c7b539625626d052b18dc980dbad58463da8ddbd110defe6f89e89191d1bf",
            	"script_key_is_local": false,
            	"amount": "21",
            	"new_proof_blob": "00249d09d48997722ce963032255b316da090d1fda79eecf7e103486863863089806000000000150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000096e88000000000000000002fd018102000000000102fed28e57510897d40d8965fd057c66b2e291c87b2c3fdb7c59d1ecad9d3a5f430100000000ffffffff9d09d48997722ce963032255b316da090d1fda79eecf7e10348686386308980600000000000000000003e80300000000000022512020838d1e810846e74d45661ba16ca5edece1fb517a140a27b4b86744fbdfc19de80300000000000022512000b6f8a9312180dae841f4eef10a9e0ce3d95b5c23f7d7f516264d4ccfae8426f3c22d01000000001600146e4b35798e1d01f37e43132a2f253d4fd71ed96902483045022100c9c9d1c87f0b2933b1d78294b051b22e5142912981050e7bf4d3177c2f735ee30220107a0d7d8f24e16ef1ee985439412fbf1041d0545938811df4bfa1d0a332d99d01210341b2382ff83a137cc3de470dbbe8a3d5234327dcdec3b212c78a39038368737a0140e1d914f20dd919b0d1f7e5b4ada23673d93404e77f6c529232daf91be4c68ec5aa551a972d2dc28c3279e29afd1bffa54e272a3bc180bedfd14eee25eb54246d0000000003010004fd02a800010001556331bcce0723065436b2a7fbca530b5b7a2ddf97a4a908f497edf409af70a396000000020b66616e74617379636f696e04e552053fd4c8e2c01bc14cb9a0ce00f07d4ffdffff68fe455c70b934b22a43000000000002010003011506fd021d01fd02190065000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002fd01ae4a000140e2e20719575ce8c20708feefa95170a9133821dfb9a690826a8dc63bde880f0000000000000025ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdffd016000010001556331bcce0723065436b2a7fbca530b5b7a2ddf97a4a908f497edf409af70a396000000020b66616e74617379636f696e04e552053fd4c8e2c01bc14cb9a0ce00f07d4ffdffff68fe455c70b934b22a43000000000002010003012506ad01ab00659d09d48997722ce963032255b316da090d1fda79eecf7e1034868638630898060000000086b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e2020f5ed7a45d9970a998c6f8283b10f3287f23b37c2ed489dd2fee9742e536433401420140702c84050a03e6b16b5238a03a45c485cf1a9bf4a28bb0f06555f2c21ea50ca3d3c97a3fa44bb962ce8408671afaf294d75812688cce74e0052886c3c15fd56f07281a823d464dc06be6529f0aee8da78da224ca6c0eb849a39f55e69cc50b2c0c72000000000000003a08020000092102b1383908554974589b80923a400809d3537ed27555c9a7b17e21e937a1156f21080200000921021e7c7b539625626d052b18dc980dbad58463da8ddbd110defe6f89e89191d1bf059f000400000001012102c3e9620740af76b730bc50e9e7f2f3500c36d00db2336c4132b72b612001c14202740049000100012086b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e202220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff012700010001220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff06c901c70004000000000121027bcd8e0aa88b4394f4cb515c4625cf2cbef56355e780c8fab492e9f8ab68cd84029c0071000100012086b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e2024a0001188f9ea691c11d64f41a6f5110e37a6eca42921166e67cb6399523fe7b9d1b520000000000000025ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffbf012700010001220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff079f0004000000000121027bcd8e0aa88b4394f4cb515c4625cf2cbef56355e780c8fab492e9f8ab68cd8402740049000100012086b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e202220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff012700010001220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
            	"split_commit_root_hash": null
        	}
    	]
	}
}
```

You will notice the transaction id (`bdbfd7c76c9c47a250ef3bf4732f5fd1ea30603a9c470c5b79fc05055021d373`) has two inputs. One input is the newly minted asset (easily identifiable by its 1000 sat amount), while the other is from LND’s internal wallet. This second input is used to pay the onchain fees.

There are three outputs. Two outputs of 1000 satoshis each and the change output of LND’s internal wallet. The two 1000 satoshi inputs anchor the proofs of the sender and receiver. Even when the sender spends all of their assets, such an output is still created to carry proof of the transfer.

Once the transaction is confirmed on the Bitcoin Blockchain the sender will attempt to make the proofs available to the recipient via an [end-to-end encrypted mailbox](../lightning-terminal/lightning-node-connect.md), similar to Lightning Node Connect (LNC).

By default, this mailbox is set to mailbox.terminal.lightning.today:443, but you can [run your own mailbox through aperture](../../the-lightning-network/l402/aperture.md) and configure tapd to use it by specifying the `--hashmailcourier.addr=` flag at startup.

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
2023-05-06 00:16:01.269 [INF] FRTR: Broadcasting new transfer tx, txid=bdbfd7c76c9c47a250ef3bf4732f5fd1ea30603a9c470c5b79fc05055021d373
2023-05-06 00:16:01.448 [INF] FRTR: Outbound parcel with txid bdbfd7c76c9c47a250ef3bf4732f5fd1ea30603a9c470c5b79fc05055021d373 now pending (num_inputs=1, num_outputs=2), delivering notification
2023-05-06 00:16:01.449 [INF] FRTR: ChainPorter executing state: SendStateWaitTxConf
2023-05-06 00:16:01.451 [INF] FRTR: Waiting for confirmation of transfer_txid=bdbfd7c76c9c47a250ef3bf4732f5fd1ea30603a9c470c5b79fc05055021d373
2023-05-06 00:16:28.870 [INF] FRTR: ChainPorter executing state: SendStateStoreProofs
2023-05-06 00:16:28.871 [INF] FRTR: Importing 0 passive asset proofs into local Proof Archive
2023-05-06 00:16:28.874 [INF] FRTR: Importing proof for output 0 into local Proof Archive
2023-05-06 00:16:28.881 [INF] FRTR: Importing proof for output 1 into local Proof Archive
2023-05-06 00:16:28.882 [INF] FRTR: ChainPorter executing state: SendStateReceiverProofTransfer
2023-05-06 00:16:28.883 [INF] PROF: Attempting to deliver receiver proof for send of asset_id=38366235613831623166643534623137336333373861623637616337303836303830333237343439396264336461373037303734623232323331353639306532, amt=21
2023-05-06 00:16:28.885 [INF] PROF: Creating sender mailbox w/ sid=9d9f3adadb69bba026ab781551db0c9a68271f4be233f48ec48fea73751fce709055172ff5c1e5d3f2c9d4fbecb618844a7d9367141664b5aee2b0d2a502692b
2023-05-06 00:16:28.965 [INF] PROF: Creating receiver mailbox w/ sid=9d9f3adadb69bba026ab781551db0c9a68271f4be233f48ec48fea73751fce709055172ff5c1e5d3f2c9d4fbecb618844a7d9367141664b5aee2b0d2a502692a
2023-05-06 00:16:29.050 [INF] PROF: Sending receiver proof via sid=9d9f3adadb69bba026ab781551db0c9a68271f4be233f48ec48fea73751fce709055172ff5c1e5d3f2c9d4fbecb618844a7d9367141664b5aee2b0d2a502692b
2023-05-06 00:16:29.051 [INF] PROF: Waiting (5s) for receiver ACK via sid=9d9f3adadb69bba026ab781551db0c9a68271f4be233f48ec48fea73751fce709055172ff5c1e5d3f2c9d4fbecb618844a7d9367141664b5aee2b0d2a502692a
2023-05-06 00:16:29.296 [INF] PROF: Received ACK from receiver! Cleaning up mailboxes...
2023-05-06 00:16:29.455 [INF] FRTR: Marking parcel (txid=bdbfd7c76c9c47a250ef3bf4732f5fd1ea30603a9c470c5b79fc05055021d373) as confirmed!
2023-05-06 00:16:29.462 [INF] GRDN: Received new proof file, version=0, num_proofs=4

```

Similarly, the recipient will call the same mailbox and await their proofs there. These proofs include previous Merkle trees and signatures.

Recipient sample log output:

```
2023-05-06 00:16:18.145 [INF] GRDN: Found inbound asset transfer (asset_id=86b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e2) for TAP address taptb1qqqsqq3qs666sxcl6493w0ph32m843cgvzqryazfn0fa5urswjezyv2kjr3qgggzre78k5uky43x6pftrrwfsrd66kzx8k5dm0g3phh7d7y73yv36xlsvggzc05kyp6q4amtwv9u2r570uhn2qxrd5qdkgekcsfjku4kzgqpc9pqsqg466zcju in bdbfd7c76c9c47a250ef3bf4732f5fd1ea30603a9c470c5b79fc05055021d373:1
2023-05-06 00:16:18.234 [INF] PROF: Attempting to receive proof via sid=9d9f3adadb69bba026ab781551db0c9a68271f4be233f48ec48fea73751fce709055172ff5c1e5d3f2c9d4fbecb618844a7d9367141664b5aee2b0d2a502692b
2023-05-06 00:16:29.132 [INF] PROF: Sending ACK to sender via sid=9d9f3adadb69bba026ab781551db0c9a68271f4be233f48ec48fea73751fce709055172ff5c1e5d3f2c9d4fbecb618844a7d9367141664b5aee2b0d2a502692a
2023-05-06 00:16:29.317 [INF] GRDN: Received new proof file, version=0, num_proofs=4
```

You can export the proof of a particular asset with the command below.

`tapcli proofs export --asset_id 86b5a81b1fd54b173c378ab67ac70860803274499bd3da707074b222315690e2 --script_key 021e7c7b539625626d052b18dc980dbad58463da8ddbd110defe6f89e89191d1bf`

Alternatively, you may also find the proof files in `~/.taproot-assets/data/testnet/proofs/`

The recipient may import them using the commmand:

`tapcli proofs import –proof_file 028055056a70daf83e654a28b640dbf7fa893953f87398a51b7c2021520402a54b.tap`

## Start building on Taproot Assets

You can find the [API references for `tapd` here](https://lightning.engineering/api-docs/api/taproot-assets).
