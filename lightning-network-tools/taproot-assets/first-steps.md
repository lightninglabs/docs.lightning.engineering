---
description: >-
  You can use Taproot Assets to mint, send and receive assets, verify and export
  proofs as well as generate profiles to handle your portfolio.
---

# First Steps

## Command Line Interface <a href="#docs-internal-guid-491e4e6e-7fff-f299-8c84-0b4567fbbcaa" id="docs-internal-guid-491e4e6e-7fff-f299-8c84-0b4567fbbcaa"></a>

When running `tapd` as part of `litd` ([integrated mode](../lightning-terminal/integrating-litd.md)), you will need to specify that you are connecting to the `litd` process when executing `tapcli` commands from the command line interface. This has to include the `tls.cert` and port `8443`. Unless you are running on mainnet, the network has to be specified as well.

`tapcli --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 --network=testnet assets list`

Future sample commands will omit these details for simplicity.

## Preparation <a href="#docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e" id="docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e"></a>

Taproot Assets allows you to mint both collectible and normal assets. In this guide we will mint normal assets, meaning an asset that is divisible into equal parts. Before we can get started, we will have to decide on the parameters for our asset.

**Type**\
An asset can be either set to normal or collectible. A normal asset is divisible into parts of equal value.

**Name**\
An asset requires a name. Uniqueness cannot be enforced over this name, so it can’t be used to uniquely identify the asset.

**Supply**\
The total supply of your asset. Don’t forget to consider decimal places!

**Decimal display**\
The number of decimal places your asset will have. Two decimal places would allow only for cents, while six decimal places would allow for micro-units. Too few decimal places can result in rounding errors when transferring assets over the Lightning Network. You can choose up to 12 decimal places.

If you want to mint 1 million units of an asset, each divisible into one thousand pieces, you will have to choose a total supply of 1,000,000,000.

**Meta Data**\
You can associate your asset with additional metadata. This data can be added in the form of a string (----meta\_bytes), a file on disk (--meta\_file\_path), and be either in opaque or json form (--meta\_type)

**Grouped Asset**\
For grouped assets the total supply can later be inflated, while ungrouped assets have a permanently fixed supply.

## Minting Assets <a href="#docs-internal-guid-01b27eb6-7fff-e107-fcd4-9c9848363a92" id="docs-internal-guid-01b27eb6-7fff-e107-fcd4-9c9848363a92"></a>

Use `tapcli` to begin minting your first asset. We are minting a normal asset and we'll allow ourselves to increase the supply of this asset in the future by setting the `--new_grouped_asset` flag. The total supply will be 1,000 units, each divisible into 1,000 sub-units. For the decimal display to take effect, the `meta_type` needs to be set to `json` and a json will need to be supplied, either as a file or as a string. As of now there is no “official” format for what this json file should look like or what it should contain.

`tapcli assets mint --type normal --name beefbux --supply 1000000 --decimal_display 3 --meta_bytes '{"hello":true}' --meta_type json --new_grouped_asset`

This will add your asset to a minting queue called a batch, which allows multiple assets to be created in a single minting transaction. This saves fees and conserves blockspace. To execute the batch and publish your mint transaction to the blockchain run:

`tapcli assets mint finalize`

You will be given a `batch_txid`, which will have to be included in a block before you can spend your newly created assets. You can also inspect the newly created asset(s) by calling the command

`tapcli assets list`

```json
    	{
        	"version": "ASSET_VERSION_V0",
        	"asset_genesis": {
            	"genesis_point": "357e113296993b79b98f7dbf1f86166377cc07e4099d64b6c59dbea66c1db9d0:1",
            	"name": "beefbux",
            	"meta_hash": "1b206639244dae9875be0db3babd9c326e9ffe319f9a913c56b765c8e80b6299",
            	"asset_id": "b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b",
            	"asset_type": "NORMAL",
            	"output_index": 0
        	},
        	"amount": "1000000",
        	"lock_time": 0,
        	"relative_lock_time": 0,
        	"script_version": 0,
        	"script_key": "02699e225abed4f8fd746d4888984278a7a57f63a0c542df04eac22ed9f1db5e25",
        	"script_key_is_local": true,
        	"asset_group": {
            	"raw_group_key": "034ec8be86f4ee8e1afcd6b18efb828319ab9a1ec69254bfdae8e07689461c8257",
            	"tweaked_group_key": "025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc",
            	"asset_witness": "014027a12fcaefb594be606056e48f9fd5bdf9c0100fdc82d6753172c641a880059e2c1fdfdb85217999408bf5dff8498f7a5ecc0fda8cbda98fc589b1349b5d5c06",
            	"tapscript_root": ""
        	},
        	"chain_anchor": {
            	"anchor_tx": "02000000000101d0b91d6ca6be9dc5b6649d09e407cc776316861fbf7d8fb9793b999632117e3501000000000000000002e80300000000000022512028a7b14f59e3094b596528399f2d06f5e0ebfbd09296b05859f3ae4e4344fde54eed090200000000225120ec77e0c605f8c7a8bab47843daad6a0ddddbd7b46dceffee6a5a0623db0a90d60140661a4c8a27e5abb9376518e462f8f586a5af2141d114a2cbd45422ae243df2f8d63a3f36624bb55bcedb388432eb60683e60e9f43de7d094f9005e350b3bd08f00000000",
            	"anchor_block_hash": "00000000ccaac8ee1d015fe5036080c5062cd2a8fd36d336df8742738a9cf537",
            	"anchor_outpoint": "183274b98657bb37012369cac96d9923ddeca67239eb651a52dada975c9d94a5:0",
            	"internal_key": "02a64259f5878d7db1681041f5d0ff9313b4e9dc57e358bdc8a1da3f4d212e488d",
            	"merkle_root": "4785adef0150d57ad473fa9ea312e258dd7663de9e844c2e503b3f47f010db3a",
            	"tapscript_sibling": "",
            	"block_height": 0
        	},
        	"prev_witnesses": [],
        	"is_spent": false,
        	"lease_owner": "",
        	"lease_expiry": "0",
        	"is_burn": false,
        	"script_key_declared_known": false,
        	"script_key_has_script_path": false,
        	"decimal_display": {
            	"decimal_display": 3
        	}
    	}

```

The output of this command can be explained as follows:

`version:` The asset protocol version with which this asset was created\
`genesis_point:` The first input of the minting transaction\
`name:` The name of the asset as defined at its creation\
`meta_hash:` The metadata as defined at its creation\
`asset_id:` The asset ID is a digest of the information found under asset\_genesis in the format `sha256(genesis_outpoint || asset_tag || asset_meta || output_index || asset_type)`.\
`asset_type:` Whether an asset is “normal” or a collectible\
`output_index:` The output of the minting transaction where the asset will be anchored. This is set to 0 while the transaction confirms\
`amount:` The quantity of this asset held by you\
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
`is_burn`: Whether the asset has been burned.\
`script_key_declared_known:` used for Lightning Network channels\
`script_key_has_script_path:` used for Lightning Network channels\
`decimal_display:` The number of decimal places configured for this asset.

{% embed url="https://www.youtube.com/watch?v=FccI6j0mxuE" %}
Tapping into Taproot Assets #5: Mint from the CLI
{% endembed %}

[Also watch: Mint from the API](https://www.youtube.com/watch?v=IL4ojWyFPSk)

## Minting asset groups <a href="#docs-internal-guid-3bcd56b4-7fff-bfc0-8abd-da4246828716" id="docs-internal-guid-3bcd56b4-7fff-bfc0-8abd-da4246828716"></a>

Assets that were minted with the flag `--new_grouped_asset` do not have a fixed supply. A new batch of this asset can be minted later in a way that the two assets are considered of the same asset group, and therefore fungible.

**Note: At the moment it is not possible to spend two assets with different asset IDs, even if they belong to the same asset group.**

To increase the supply of such an asset, we will need its tweaked\_group\_key.

`tapcli assets mint --type normal --name beefbux --supply 100000 --decimal_display 3 --meta_type json --grouped_asset --group_key 025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc`

We again have to publish the new mint transaction with:

`tapcli assets mint finalize`

You can also specify a custom fee rate (in sat/vB) using the flag `--sat_per_vbyte`

Now we can check our groups. They are ordered by their tweaked group key.

`tapcli assets groups`

```json
    	"025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc": {
        	"assets": [
            	{
                	"id": "b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b",
                	"amount": "1000000",
                	"lock_time": 0,
                	"relative_lock_time": 0,
                	"tag": "beefbux",
                	"meta_hash": "1b206639244dae9875be0db3babd9c326e9ffe319f9a913c56b765c8e80b6299",
                	"type": "NORMAL",
                	"version": "ASSET_VERSION_V0"
            	},
            	{
                	"id": "37a91afeeb815a65f055e9d4e4fc9b5ada094468006d710d92daabe74072722f",
                	"amount": "100000",
                	"lock_time": 0,
                	"relative_lock_time": 0,
                	"tag": "beefbux",
                	"meta_hash": "e3087117d53f3dcd9317a3bee2848f29622a27c02d932b17621baf98938fa75e",
                	"type": "NORMAL",
                	"version": "ASSET_VERSION_V0"
            	}
        	]
	}
```

To inspect your balances, run `tapcli assets balance`. To show the cumulative balance across asset groups, run `tapcli assets balance --by_group`

## Synchronizing with a universe <a href="#docs-internal-guid-d7bd6e05-7fff-a92f-5b1d-a845abe07e3c" id="docs-internal-guid-d7bd6e05-7fff-a92f-5b1d-a845abe07e3c"></a>

Taproot Assets uses universes to communicate information about which assets exist and where in the blockchain they are anchored. A universe can be thought of as a virtual mempool, an explorer, or a repository.

Your node will sync with the universe whenever you create a new Taproot Assets address with an unknown asset ID, or when specifically instructed to. This requires an asset ID or a group key.

On testnet, you can use `testnet.universe.lightning.finance:10009`, or you can [run your own universe](universes.md).

`tapcli universe sync --universe_host universe.lightning.finance:10009 --group_key 025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc`

Upon successful sync, information about existing assets should be retrieved, alongside their issuance proofs.

## Generating Taproot Assets addresses <a href="#docs-internal-guid-b63629f3-7fff-ba71-770c-b7d5f5eac736" id="docs-internal-guid-b63629f3-7fff-ba71-770c-b7d5f5eac736"></a>

As soon as your minted assets have one confirmation on the blockchain, you are able to send them. To send assets, you will need the recipient’s Taproot Assets address. This Taproot Assets address is specific to an asset and amount, so to generate an address, the recipient needs to know an asset’s asset\_id, as well as be synced to the issuer’s universe. Taproot Assets address reuse should be avoided.

When generating a Taproot Assets address, the receiver will create their expected Merkle trees, and tweak a Taproot key with it. The resulting key is converted to a Taproot address, where the receiver waits for an incoming transaction.

To generate a Taproot Assets address requesting 21 beefbux, use the following command from the tapd instance of the receiver:

`tapcli addrs new --asset_id b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b --amt 21`



```json
{
	"encoded": "taptb1qqqszqspqqzzpwdwsm6jmj77ul4836rtyceqsxwyfsh5lz53h8q9tjs27nzdrv3tq5ssy535xeq397p75lhgud0sv8tzthuzacr7gsur2yregl3mk5lgaxluqcssy8ghaz0ph5py0hr3vfzl25caxp8k2a2zls9e3mxt8lnmkrqnt0nvpqssyq7ghy5fnu0myjy2lkypu5u9qpe35c7hkt80cec9j4vv3cz8vn3xpgq32rpkw4hxjan9wfek2unsvvaz7tm5v4ehgmn9wsh82mnfwejhyum99ekxjemgw3hxjmn89enxjmnpde3k2w33xqcrywgur62n4",
	"asset_id": "b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b",
	"asset_type": "NORMAL",
	"amount": "21",
	"group_key": "025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc",
	"script_key": "021d17e89e1bd0247dc716245f5531d304f657542fc0b98eccb3fe7bb0c135be6c",
	"internal_key": "0203c8b92899f1fb2488afd881e538500731a63d7b2cefc67059558c8e04764e26",
	"tapscript_sibling": "",
	"taproot_output_key": "2fd47bf48b0547f3ec352468b858ba1ea9a392cdbf6634bb7c6129ba09d15e52",
	"proof_courier_addr": "universerpc://testnet.universe.lightning.finance:10029",
	"asset_version": "ASSET_VERSION_V0",
	"address_version": "ADDR_VERSION_V1"
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

To send the asset, run the command below from the tapd instance of the sender. This will generate the appropriate Merkle trees for the recipient and their change outputs, sign the Taproot Assets transaction with their internal Taproot Assets key and publish the Bitcoin transaction. Note that you cannot send unconfirmed assets.

`tapcli assets send --addr taptb1qqqszqspqqzzpwdwsm6jmj77ul4836rtyceqsxwyfsh5lz53h8q9tjs27nzdrv3tq5ssy535xeq397p75lhgud0sv8tzthuzacr7gsur2yregl3mk5lgaxluqcss9z9grekhnm97ymknzptz6zptw22cn54u3tdwqphnl5kwthqafzyapqss8zlu9rqjndpjjxa7xue6csqg7l6u7r8vw2hpw8v23mmdckktqhlzpgq32rpkw4hxjan9wfek2unsvvaz7tm5v4ehgmn9wsh82mnfwejhyum99ekxjemgw3hxjmn89enxjmnpde3k2w33xqcrywgs04lws --sat_per_vbyte 16`

```json
{
	"transfer": {
    	"transfer_timestamp": "1720023083",
    	"anchor_tx_hash": "aa98f0c02553b2f3aa58bf50be3a84ffb9bee7ef5646ed17678cd6dba41c31bd",
    	"anchor_tx_height_hint": 2865816,
    	"anchor_tx_chain_fees": "4072",
    	"inputs": [
        	{
            	"anchor_point": "183274b98657bb37012369cac96d9923ddeca67239eb651a52dada975c9d94a5:0",
            	"asset_id": "b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b",
            	"script_key": "02699e225abed4f8fd746d4888984278a7a57f63a0c542df04eac22ed9f1db5e25",
            	"amount": "1000000"
        	}
    	],
    	"outputs": [
        	{
            	"anchor": {
                	"outpoint": "bd311ca4dbd68c6717ed4656efe7beb9ff843abe50bf58aaf3b25325c0f098aa:0",
                	"value": "1000",
                	"internal_key": "02d30fa2e2b05b3dda5dc42561fc10d30a4633fed3a1fce840ff3c0f9741e47af7",
                	"taproot_asset_root": "0c11e91c40c1602b640be236844e1f65744f5145cdb218a69ec01a5010c6c882",
                	"merkle_root": "0c11e91c40c1602b640be236844e1f65744f5145cdb218a69ec01a5010c6c882",
                	"tapscript_sibling": "",
                	"num_passive_assets": 0
            	},
            	"script_key": "02353b522d14c357bcc9a48ce3f8c03591268b3cb9ab787fb40a3fc921aa28f567",
            	"script_key_is_local": true,
            	"amount": "999979",
            	"new_proof_blob": "544150500004000000000224a5949d5c97dada521a65eb3972a6ecdd23996dc9ca69230137bb5786b9743218000000000450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000096e88000000000000000006fd016302000000000102a5949d5c97dada521a65eb3972a6ecdd23996dc9ca69230137bb5786b9743218000000000000000000386c8b04f74aa6bbf344316b017c055478f240b1c2dbd69c0aaa7a0db8a9628901000000000000000003e8030000000000002251206625580d8e68996c2d673dd3a6870923d94801e2582794bf946a5020a0e2228de803000000000000225120ffed7ed4c6f37a22caa94a89eca75276bdcac20655e8461db84ae9b5f267a6c58ec9090200000000225120d72b7ca1bfa5b074de27cd90ecb13bd7545dc97f93d729a903d78a82238c76a3014013ec44ba7828e5201e5a45246fca9091892fd9763d609bb6aa82e313533e9f60e94eb9bbed16a2a68442fdf0080693a13152623f0431d4104f061e3d158f1df40140781bd5af7978f1670bdf5089fb9eede08a8a3685d81ec4a7291572c5ba03e071395a5e974381a92309b860d1ed234aa593bd2feecd97012fc5fd14039b715ac0000000000801000afd01830001000251d0b91d6ca6be9dc5b6649d09e407cc776316861fbf7d8fb9793b999632117e350000000107626565666275781b206639244dae9875be0db3babd9c326e9ffe319f9a913c56b765c8e80b629900000000000401000605fe000f422b0bad01ab0165a5949d5c97dada521a65eb3972a6ecdd23996dc9ca69230137bb5786b974321800000000b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b02699e225abed4f8fd746d4888984278a7a57f63a0c542df04eac22ed9f1db5e25034201409d36acbea1349fe09e300d475a1e16a50e7117ff358f9cc006bcc189d34fb8870626d2dd0ca799900bbe61d96b8b42bf52190494888a73d2afcb1b2802dd70d60d28b56a6f8c50a0e64ab71e131457a4616fd2b96c951e0079804f05cd3f7e705e3500000000000f42400e020000102102353b522d14c357bcc9a48ce3f8c03591268b3cb9ab787fb40a3fc921aa28f5671121025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc0c9f000400000000022102d30fa2e2b05b3dda5dc42561fc10d30a4633fed3a1fce840ff3c0f9741e47af70374014900010002204b6e10c823458cf3f88610acb856ad3d8e7c8d6c98e2b0cc555ea817c745007f04220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff022700010202220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0df802c70004000000010221038bfc28c129b43291bbe3733ac4008f7f5cf0cec72ae171d8a8ef6dc5acb05fe2039c017100010002204b6e10c823458cf3f88610acb856ad3d8e7c8d6c98e2b0cc555ea817c745007f044a0001a747229910afb342aa789d28829b4484e95572f81bfa46cef02b8ea80e3c10050000000000000015ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f022700010202220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2e000400000002022102aded69752e870b53d04f98b1d0438f0f7da19b3fa6e88e939e1d8e6ddfe5899f0503040101160400000000",
            	"split_commit_root_hash": "b56a6f8c50a0e64ab71e131457a4616fd2b96c951e0079804f05cd3f7e705e35",
            	"output_type": "OUTPUT_TYPE_SPLIT_ROOT",
            	"asset_version": "ASSET_VERSION_V0",
            	"lock_time": "0",
            	"relative_lock_time": "0"
        	},
        	{
            	"anchor": {
                	"outpoint": "bd311ca4dbd68c6717ed4656efe7beb9ff843abe50bf58aaf3b25325c0f098aa:1",
                	"value": "1000",
                	"internal_key": "038bfc28c129b43291bbe3733ac4008f7f5cf0cec72ae171d8a8ef6dc5acb05fe2",
                	"taproot_asset_root": "348eeff7dbb2c5e7754563a8cbca4fad3db4fc1787710a85e7bb1d374845f81e",
                	"merkle_root": "348eeff7dbb2c5e7754563a8cbca4fad3db4fc1787710a85e7bb1d374845f81e",
                	"tapscript_sibling": "",
                	"num_passive_assets": 0
            	},
            	"script_key": "0288a81e6d79ecbe26ed310562d082b729589d2bc8adae006f3fd2ce5dc1d4889d",
            	"script_key_is_local": false,
            	"amount": "21",
            	"new_proof_blob": "544150500004000000000224a5949d5c97dada521a65eb3972a6ecdd23996dc9ca69230137bb5786b9743218000000000450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000096e88000000000000000006fd016302000000000102a5949d5c97dada521a65eb3972a6ecdd23996dc9ca69230137bb5786b9743218000000000000000000386c8b04f74aa6bbf344316b017c055478f240b1c2dbd69c0aaa7a0db8a9628901000000000000000003e8030000000000002251206625580d8e68996c2d673dd3a6870923d94801e2582794bf946a5020a0e2228de803000000000000225120ffed7ed4c6f37a22caa94a89eca75276bdcac20655e8461db84ae9b5f267a6c58ec9090200000000225120d72b7ca1bfa5b074de27cd90ecb13bd7545dc97f93d729a903d78a82238c76a3014013ec44ba7828e5201e5a45246fca9091892fd9763d609bb6aa82e313533e9f60e94eb9bbed16a2a68442fdf0080693a13152623f0431d4104f061e3d158f1df40140781bd5af7978f1670bdf5089fb9eede08a8a3685d81ec4a7291572c5ba03e071395a5e974381a92309b860d1ed234aa593bd2feecd97012fc5fd14039b715ac0000000000801000afd02ea0001000251d0b91d6ca6be9dc5b6649d09e407cc776316861fbf7d8fb9793b999632117e350000000107626565666275781b206639244dae9875be0db3babd9c326e9ffe319f9a913c56b765c8e80b629900000000000401000601150bfd024001fd023c0165000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005fd01d14a00011c4dc7a124da6dda0d604c6d21497a74c482e032efe704a6f646b0592ec9941b00000000000f422bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7ffd01830001000251d0b91d6ca6be9dc5b6649d09e407cc776316861fbf7d8fb9793b999632117e350000000107626565666275781b206639244dae9875be0db3babd9c326e9ffe319f9a913c56b765c8e80b629900000000000401000605fe000f422b0bad01ab0165a5949d5c97dada521a65eb3972a6ecdd23996dc9ca69230137bb5786b974321800000000b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b02699e225abed4f8fd746d4888984278a7a57f63a0c542df04eac22ed9f1db5e25034201409d36acbea1349fe09e300d475a1e16a50e7117ff358f9cc006bcc189d34fb8870626d2dd0ca799900bbe61d96b8b42bf52190494888a73d2afcb1b2802dd70d60d28b56a6f8c50a0e64ab71e131457a4616fd2b96c951e0079804f05cd3f7e705e3500000000000f42400e020000102102353b522d14c357bcc9a48ce3f8c03591268b3cb9ab787fb40a3fc921aa28f5671121025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc0e02000010210288a81e6d79ecbe26ed310562d082b729589d2bc8adae006f3fd2ce5dc1d4889d1121025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc0c9f0004000000010221038bfc28c129b43291bbe3733ac4008f7f5cf0cec72ae171d8a8ef6dc5acb05fe20374014900010002204b6e10c823458cf3f88610acb856ad3d8e7c8d6c98e2b0cc555ea817c745007f04220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff022700010202220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0df802c7000400000000022102d30fa2e2b05b3dda5dc42561fc10d30a4633fed3a1fce840ff3c0f9741e47af7039c017100010002204b6e10c823458cf3f88610acb856ad3d8e7c8d6c98e2b0cc555ea817c745007f044a00011d84338038c2ea5f9e479914affebffee80985ee6157874661840095602c20f900000000000f422bffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f022700010202220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2e000400000002022102aded69752e870b53d04f98b1d0438f0f7da19b3fa6e88e939e1d8e6ddfe5899f05030401010f9f000400000000022102d30fa2e2b05b3dda5dc42561fc10d30a4633fed3a1fce840ff3c0f9741e47af70374014900010002204b6e10c823458cf3f88610acb856ad3d8e7c8d6c98e2b0cc555ea817c745007f04220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff022700010202220000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff160400000000",
            	"split_commit_root_hash": "",
            	"output_type": "OUTPUT_TYPE_SIMPLE",
            	"asset_version": "ASSET_VERSION_V0",
            	"lock_time": "0",
            	"relative_lock_time": "0"
        	}
    	]
	}
}

```

You will notice the transaction id (`bd311ca4dbd68c6717ed4656efe7beb9ff843abe50bf58aaf3b25325c0f098aa`) has two inputs. One input is the newly minted asset (easily identifiable by its 1000 sat amount), while the other is from LND’s internal wallet. This second input is used to pay the onchain fees.

There are three outputs. Two outputs of 1000 satoshis each and the change output of LND’s internal wallet. The two 1000 satoshi inputs anchor the proofs of the sender and receiver. Even when the sender spends all of their assets, such an output is still created to carry proof of the transfer.

Once the transaction is confirmed on the Bitcoin Blockchain the sender will attempt to make the proofs available to the recipient via an [end-to-end encrypted mailbox](../lightning-terminal/lightning-node-connect.md), similar to Lightning Node Connect (LNC).

By default, this mailbox is set to your default universe, but you can [run your own mailbox through aperture](../aperture/mailbox.md) and configure tapd to use it by specifying the `--hashmailcourier.addr=` flag at startup.

{% embed url="https://www.youtube.com/watch?v=o30AiqbsYhw" %}
Tapping into Taproot Assets #7: Send from the CLI
{% endembed %}

[Also watch: Send from the API](https://www.youtube.com/watch?v=UEaNXu8me24)

## Burning Assets

Burning assets works by sending assets to a provably unspendable address.

tapcli assets burn --asset\_id b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b --amount 50

```
Please confirm destructive action.
Asset ID: b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b
Current available balance: 100000
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
