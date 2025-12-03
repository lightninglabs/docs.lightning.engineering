---
description: >-
  Use Taproot Assets to mint, send, receive and burn assets on the Bitcoin
  blockchain.
---

# First Steps

## Command Line Interface <a href="#docs-internal-guid-491e4e6e-7fff-f299-8c84-0b4567fbbcaa" id="docs-internal-guid-491e4e6e-7fff-f299-8c84-0b4567fbbcaa"></a>

When running `tapd` as part of `litd` ([integrated mode](../lightning-terminal/integrating-litd.md)), you will need to specify that you are connecting to the `litd` process when executing `tapcli` commands from the command line interface. This has to include the `tls.cert` and port `8443`. Unless you are running on mainnet, the network has to be specified as well.

`tapcli --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 --network=signet assets list`

Future sample commands will omit these details for simplicity.

## Preparation <a href="#docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e" id="docs-internal-guid-3eb3e547-7fff-da1b-7a6b-6865cc97ba7e"></a>

Taproot Assets allows you to mint both collectible and normal assets. In this guide we will mint normal assets, meaning an asset that is divisible into equal parts. Before we can get started, we will have to decide on the parameters for our asset.

[**Read more: Asset Metadata**](asset-metadata.md)

## Minting Assets <a href="#docs-internal-guid-01b27eb6-7fff-e107-fcd4-9c9848363a92" id="docs-internal-guid-01b27eb6-7fff-e107-fcd4-9c9848363a92"></a>

Use `tapcli` to begin minting your first asset. We are minting a normal asset and we'll allow ourselves to increase the supply of this asset in the future by setting the `--new_grouped_asset` flag. The total supply will be 1,000 units, each divisible into 1,000 sub-units. For the decimal display to take effect, the `meta_type` needs to be set to `json` and a json will need to be supplied, either as a file or as a string. As of now there is no “official” format for what this json file should look like or what it should contain.

`tapcli assets mint --type normal --name beefbux --supply 1000000 --decimal_display 3 --meta_bytes '{"hello":true}' --meta_type json --new_grouped_asset`

This will add your asset to a minting queue called a batch, which allows multiple assets to be created in a single minting transaction. This saves fees and conserves blockspace. To execute the batch and publish your mint transaction to the blockchain run:

`tapcli assets mint finalize`

You will be given a `batch_txid`, which will have to be included in a block before you can spend your newly created assets. You can also inspect the newly created asset(s) by calling the command

`tapcli assets list --show_unconfirmed_mints`

```json
        {
            "version": "ASSET_VERSION_V0",
            "asset_genesis": {
                "genesis_point": "4b93a1f07e0bb8a7184f863844033459dd69f45293d6a233170feb529eac13e5:0",
                "name": "beefbux",
                "meta_hash": "76cc761e50db8f655449ec7e5ff60be23ce45611ed362aed2242b8e265fc672f",
                "asset_id": "322b2858648b05e60d424320599b6f1e64b50e1028e42f5707572c21054c95c9",
                "asset_type": "NORMAL",
                "output_index": 0
            },
            "amount": "1000000000000",
            "lock_time": 0,
            "relative_lock_time": 0,
            "script_version": 0,
            "script_key": "02d4f510511e3847e653ab00117f045370a7713c288aa82a8319f3ae8eea76581c",
            "script_key_is_local": true,
            "asset_group": {
                "raw_group_key": "0355748322584bcf5c8e19b7617b53ef595b4fec2d5002e7248586a9a347002b40",
                "tweaked_group_key": "03dc4493748649194848033dbb95975fb6e4e5722528308f65a0246c39cefa047a",
                "asset_witness": "01400341437de835de2f71bdf64f51ca9011060291c80c121a2692636e8011438eb7109e96853b1b6187c479808c538d23fd89e54e777014b0cbbeaeeaad4f93c3fb",
                "tapscript_root": ""
            },
            "chain_anchor": {
                "anchor_tx": "02000000000101e513ac9e52eb0f1733a2d69352f469dd5934034438864f18a7b80b7ef0a1934b00000000000000000002e8030000000000002251204a00de62399e03079991f367d3ce61aab63cb2462c6aa6e810564c118e60d9fad84d220000000000225120eff3512a06c6dd4ccdaea11992e5bd1b217f6fdcd2ae1cbb107d82e0a63b23760140cb79015ba98a2881cf55cf15d4744ab451e7e03aaf7ec8e40bebaccf55f9d8dd466cfcb963a86b4daf4b014cae392269aad6d101b6655a8e5e26dd92d1f5780400000000",
                "anchor_block_hash": "0000000000000000000000000000000000000000000000000000000000000000",
                "anchor_outpoint": "1fe097512f60ee6d120797919040f0a27a3dc416ce7a1856294db9351f3c9ca4:0",
                "internal_key": "0225c3102e51864c0e18ad30e65ac16e22867e2ded1eca02b613f678bfacd0e3c5",
                "merkle_root": "295c1787fdddf6dba941a5ac9d936ce44bebaeab394b9d4f35eb9ac42d893502",
                "tapscript_sibling": "",
                "block_height": 0
            },
            "prev_witnesses": [],
            "is_spent": false,
            "lease_owner": "",
            "lease_expiry": "0",
            "is_burn": false,
            "script_key_declared_known": true,
            "script_key_has_script_path": false,
            "decimal_display": {
                "decimal_display": 6
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

To increase the supply of such an asset, we will need its tweaked\_group\_key.

`tapcli assets mint --type normal --name beefbux --supply 100000 --decimal_display 3 --grouped_asset --group_key 025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc`

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

On regtest and signet you will have to also [run a universe locally](universes.md). On signet, you can use `signet.universe.lightning.finance:10029.`

`tapcli universe sync --universe_host universe.lightning.finance:10029 --group_key 025234364112f83ea7ee8e35f061d625df82ee07e443835107947e3bb53e8e9bfc`

Upon successful sync, information about existing assets should be retrieved, alongside their issuance proofs.

## Generating Taproot Assets addresses <a href="#docs-internal-guid-b63629f3-7fff-ba71-770c-b7d5f5eac736" id="docs-internal-guid-b63629f3-7fff-ba71-770c-b7d5f5eac736"></a>

As soon as your minted assets have one confirmation on the blockchain, you are able to transfer them. You will first need the recipient’s Taproot Assets address. This address can either be interactive or non-interactive.

#### Interactive Taproot Assets addresses  <a href="#docs-internal-guid-5eaf86ff-7fff-7c5f-fab8-1ef9e6931c07" id="docs-internal-guid-5eaf86ff-7fff-7c5f-fab8-1ef9e6931c07"></a>

In situations where the asset ID is not known, for instance grouped assets, when the requested amount is flexible or a Taproot Assets address is meant to be reusable, interactive Taproot Assets addresses are preferable. The sender and recipient have to be both online to negotiate the transaction, although the final transaction may be submitted to the blockchain only at a later point.

To generate such an address, only the group key is required.

`tapcli addrs new --group_key 02875ce409b587a6656357639d099ad9eb08396d0dfea8930a45e742c81d6fc782`

#### Non-interactive Taproot Assets addresses

Non-interactive Taproot Assets addresses arespecific to an asset and amount, so to generate an address, the recipient needs to know an asset’s asset\_id, as well as be synced to the issuer’s universe. Reuse of non-interactive Taproot Assets address reuse should be avoided. This type of transfer is ideal when the asset ID is known and the amount is fixed. The recipient does not need to be online during the transfer.

`tapcli addrs new --asset_id b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b --amt 21`

## Sending an asset <a href="#docs-internal-guid-5d8fd7ee-7fff-475c-a392-4855bf9afc85" id="docs-internal-guid-5d8fd7ee-7fff-475c-a392-4855bf9afc85"></a>

#### Interactive Taproot Assets transactions <a href="#docs-internal-guid-18439dd9-7fff-260c-8c17-b1a80524770f" id="docs-internal-guid-18439dd9-7fff-260c-8c17-b1a80524770f"></a>

To send the asset in the interactive flow, the sender can then use the tapcli assets send command, using the generated taproot asset address and the amount, separated by a colon. For this type of send, address reuse is acceptable or even encouraged, but both the sender and the receiver are expected to be online simultaneously.

`tapcli assets send --addr_with_amount taptb1qqqsyqspqqzjzq58tnjqndv85ejkx4mrn5ye4k0tpquk6r074zfs5308gtyp6m78sgrzzqaaxepdtxjlytle39tjem4mh88hyg7jxpwrn3nkq7mdt95hpw0rpyyzzqcf0vcytzhvhy5mze28ye4zzrm5c38av735md2382zmzxc07zfzcs9qzqqv8ash2argd4skjmrzdauzkatwd9mx2unnv4e8qce69uhhx6t8dejhgtn4de5hvetjwdjjumrfva58gmnfdenjuenfdeskucm98g6rgvc8ar5ce:100`

```json
{
    "encoded":  "taptb1qqqsyqspqqzjzq58tnjqndv85ejkx4mrn5ye4k0tpquk6r074zfs5308gtyp6m78sgrzzqaaxepdtxjlytle39tjem4mh88hyg7jxpwrn3nkq7mdt95hpw0rpyyzzqcf0vcytzhvhy5mze28ye4zzrm5c38av735md2382zmzxc07zfzcs9qzqqv8ash2argd4skjmrzdauzkatwd9mx2unnv4e8qce69uhhx6t8dejhgtn4de5hvetjwdjjumrfva58gmnfdenjuenfdeskucm98g6rgvc8ar5ce",
    "asset_id":  "",
    "asset_type":  "NORMAL",
    "amount":  "0",
    "group_key":  "02875ce409b587a6656357639d099ad9eb08396d0dfea8930a45e742c81d6fc782",
    "script_key":  "03bd3642d59a5f22ff989572ceebbb9cf7223d2305c39c67607b6d596970b9e309",
    "internal_key":  "03097b30458aecb929b16547266a210f74c44fd67a34db5513a85b11b0ff0922c4",
    "tapscript_sibling":  "",
    "taproot_output_key":  "bd3642d59a5f22ff989572ceebbb9cf7223d2305c39c67607b6d596970b9e309",
    "proof_courier_addr":  "authmailbox+universerpc://signet.universe.lightning.finance:443",
    "asset_version":  "ASSET_VERSION_V0",
    "address_version":  "ADDR_VERSION_V2"
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

#### Non-interactive Taproot Assets transactions <a href="#docs-internal-guid-30a129a3-7fff-2f33-f0c1-921bb94b13ba" id="docs-internal-guid-30a129a3-7fff-2f33-f0c1-921bb94b13ba"></a>

To send the asset to a non-interactive Taproot Asset address, run the command below from the tapd instance of the sender. This will generate the appropriate Merkle trees for the recipient and their change outputs, sign the Taproot Assets transaction with their internal Taproot Assets key and publish the Bitcoin transaction. Note that you cannot send unconfirmed assets.

`tapcli assets send --addr taptb1qqqszqspqqzzpwdwsm6jmj77ul4836rtyceqsxwyfsh5lz53h8q9tjs27nzdrv3tq5ssy535xeq397p75lhgud0sv8tzthuzacr7gsur2yregl3mk5lgaxluqcss9z9grekhnm97ymknzptz6zptw22cn54u3tdwqphnl5kwthqafzyapqss8zlu9rqjndpjjxa7xue6csqg7l6u7r8vw2hpw8v23mmdckktqhlzpgq32rpkw4hxjan9wfek2unsvvaz7tm5v4ehgmn9wsh82mnfwejhyum99ekxjemgw3hxjmn89enxjmnpde3k2w33xqcrywgs04lws --sat_per_vbyte 16`

You’ll also be able to inspect this address again anytime with the command `tapcli addrs query`

Once the transaction is confirmed on the Bitcoin Blockchain the sender will attempt to make the proofs available to the recipient via an [end-to-end encrypted mailbox](../lightning-terminal/lightning-node-connect.md), similar to Lightning Node Connect (LNC).

By default, this mailbox is set to your default universe, but you can [run your own mailbox through aperture](../aperture/mailbox.md) and configure tapd to use it by specifying the `--hashmailcourier.addr=` flag at startup.

{% embed url="https://www.youtube.com/watch?v=o30AiqbsYhw" %}
Tapping into Taproot Assets #7: Send from the CLI
{% endembed %}

[Also watch: Send from the API](https://www.youtube.com/watch?v=UEaNXu8me24)

## Burning Assets

Burning assets works by sending assets to a provably unspendable address.

`tapcli assets burn --asset_id b9ae86f52dcbdee7ea78e86b26320819c44c2f4f8a91b9c055ca0af4c4d1b22b --amount 50`

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
