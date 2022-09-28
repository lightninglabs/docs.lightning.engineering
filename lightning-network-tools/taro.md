---
description: >-
  The Taro Daemon tarod implements the Taro protocol for issuing assets on the
  Bitcoin blockchain.
---

# Taro

## Get started

## #Careful <a href="#docs-internal-guid-f9af6317-7fff-eeb2-2957-b358d3da86da" id="docs-internal-guid-f9af6317-7fff-eeb2-2957-b358d3da86da"></a>

Taro is alpha software. It is configured to run on regtest, testnet3 and simnet only, where it’s okay if bitcoin or taro assets are irrevocably lost.

## Prerequisites <a href="#docs-internal-guid-29b5ec39-7fff-4a26-d7e9-dfa1d01ff2c6" id="docs-internal-guid-29b5ec39-7fff-4a26-d7e9-dfa1d01ff2c6"></a>

Taro requires [LND](https://github.com/lightningnetwork/lnd/) compiled from source on the latest main branch, synced and running on the same bitcoin network as you are doing your testing. RPC connections need to be accepted and Macaroons need to be set. [Learn how to set up LND using the default configuration here.](lnd/run-lnd.md)

## Installation: <a href="#docs-internal-guid-0652b60a-7fff-d0e5-15fc-159e8557bc88" id="docs-internal-guid-0652b60a-7fff-d0e5-15fc-159e8557bc88"></a>

### From source: <a href="#docs-internal-guid-5879af55-7fff-021d-8347-7ef95cd98105" id="docs-internal-guid-5879af55-7fff-021d-8347-7ef95cd98105"></a>

Compile Taro from source by cloning the Taro repository. [Go version 1.18](https://go.dev/dl/) or higher is required (you may check what version of go is running with go version).

`git clone https://github.com/lightninglabs/taro.git`\
`cd taro`\
`make install`

## Configuration: <a href="#docs-internal-guid-8aa3849c-7fff-4b8e-530a-a563b8d9d0b8" id="docs-internal-guid-8aa3849c-7fff-4b8e-530a-a563b8d9d0b8"></a>

Optionally, create a Taro configuration file under \~/.taro/taro.conf on Linux or BSD, \~/Library/Application Support/Taro/taro.conf in Mac OS or $LOCALAPPDATA/Taro/taro.conf in Windows.

Here you can permanently set your variables, such as paths and how to connect to LND.

## Running tarod: <a href="#docs-internal-guid-ebf73e49-7fff-b5ed-44ff-b9b0953c6082" id="docs-internal-guid-ebf73e49-7fff-b5ed-44ff-b9b0953c6082"></a>

Run Taro with the command `tarod`. Specify how Taro can reach LND and what network to run Taro with by passing it additional flags.

`tarod –network=testnet –debuglevel=debug —lnd.host=localhost:10009 --lnd.macaroonpath=~/.lnd/data/chain/bitcoin/testnet/admin.macaroon --lnd.tlspath=~/.lnd/tls.cert --tarodir=~/.taro --rpclisten=127.0.0.1:10029 --restlisten=127.0.0.1:8089`

You may run multiple `tarod` instances on the same machine, connected to the same LND. In this case, don’t forget to set an alternate Taro directory and API endpoints and specify these when calling `tarocli` as well.

You may for example create an alias in `.bash_aliases`:

`alias tarocli-alice='tarocli --rpcserver=127.0.0.1:10029 --tarodir=~/.taro-alice'`

`alias tarocli-bob='tarocli --rpcserver=127.0.0.1:10030 --tarodir=~/.taro-bob'`

## Usage: <a href="#docs-internal-guid-344a2ad4-7fff-a480-202e-57d9f3a7e1cc" id="docs-internal-guid-344a2ad4-7fff-a480-202e-57d9f3a7e1cc"></a>

You can use Taro to mint, send and receive assets, verify and export proofs as well as generate profiles to handle your portfolio.

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
                "genesis_point": "c3308bb6e628ab5359e3d799b9b19b0cadbbe744bc34743f3bb576f6aade4590:1",
                "name": "leocoin",
                "meta": "66616e746173746963206d6f6e6579",
                "asset_id": "80c9c415a0f2d0f26e99ad7a140c2ceb6b9f213cb84bf763910bbc4dce3161d7",
                "output_index": 0,
                "genesis_bootstrap_info": "9045deaaf676b53b3f7434bc44e7bbad0c9bb1b999d7e35953ab28e6b68b30c300000001076c656f636f696e0f66616e746173746963206d6f6e65790000000000",
                "version": 0
            },
            "asset_type": "NORMAL",
            "amount": "1000",
            "lock_time": 0,
            "relative_lock_time": 0,
            "script_version": 0,
            "script_key": "027206a32cbdaf9db7f46dfe3ae0be13fe6126802f27a93a3e4ec8a7e3857b9e74",
            "asset_family": null,
            "chain_anchor": {
                "anchor_tx": "020000000001019045deaaf676b53b3f7434bc44e7bbad0c9bb1b999d7e35953ab28e6b68b30c30100000000ffffffff02e803000000000000225120d3ee88d6c6f0b1316728359b790936dc75f89058ca237702328a7743c7472c17d512310100000000160014c2e57e98fdc9a22f568b2871ccb68e4394ceb50102483045022100aff2c3fe1a17b3ea714ff97ee644429a495aa4e0c833acd90812ae619705c25802203d1f410f1a767979f2af72f56d3feb7a0815e53148439f45ad7ce85acbc6131b012103915c984949eced1bbab08960aa64517d1f5f3624fade309ce82bd764006f2de100000000",
                "anchor_txid": "51146b91f80e58127f31398804849481e36ae066d19522240d80f02cd2cada9e",
                "anchor_block_hash": "0000000000000000000000000000000000000000000000000000000000000000",
                "anchor_outpoint": "9edacad22cf0800d242295d166e06ae3819484048839317f12580ef8916b1451:0",
                "internal_key": "03b18f04ae5f737ff41b13ff1c57c095a5ed7a29696e6c300a48ae4a154c02b8b9"
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

To generate a Taro address, use the following command:

`tarocli addrs new --genesis_bootstrap_info bab084072016a97059bf44a6782e44445556da48e35bce8d4d872afa3129bf6d00000001076c656f636f696e0a6c696f6e206d6f6e65790000000000 --amt 1000000`

```json
{
    "addrs": [
        {
            "encoded": "tarotb1qqqsqqj9ls6nzap4plve7kydeptufhh0leppcr3jsqwnxsgs930puwkv980sqqqqqy9kvctww3shx7trda5kurmxv9h8gctnw35kxgrddahx27gqqqqqqqqyyzn9s38jmj9v4knymw7pdmetusvdw7l30l9altrq437vhlefjeqfzp3q4zl3svll5ntd6cch5y0r2xfadwf0m4wz2rnwz6dcvr93zt5p4eessqtywpre3a",
            "asset_id": "45e1dac2cdd23453104b1af5b7b303a081b1d7cf649a1ea674e6364b191786f3",
            "asset_type": "NORMAL",
            "amount": "100",
            "family_key": null,
            "script_key": "02a65844f2dc8acada64dbbc16ef2be418d77bf17fcbdfac60ac7ccbff29964091",
            "internal_key": "03a8bf1833ffa4d6dd6317a11e35193d6b92fdd5c250e6e169b860cb112e81ae73",
            "taproot_output_key": "c4a0d5dd83c7956d9624710b9f7f4d6d737d134b5fddc18eb117a152ed92490c"
        }
    ]
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
