---
description: >-
  The Taproot Assets Daemon tapd implements the Taproot Assets Protocol for
  issuing assets on the Bitcoin blockchain.
---

# Get Started

## #Craeful <a href="#docs-internal-guid-f9af6317-7fff-eeb2-2957-b358d3da86da" id="docs-internal-guid-f9af6317-7fff-eeb2-2957-b358d3da86da"></a>

Taproot Assets is alpha software. Use it on mainnet at your own risk!

## Prerequisites <a href="#docs-internal-guid-29b5ec39-7fff-4a26-d7e9-dfa1d01ff2c6" id="docs-internal-guid-29b5ec39-7fff-4a26-d7e9-dfa1d01ff2c6"></a>

Taproot Assets requires [LND](https://github.com/lightningnetwork/lnd/) v0.17.0. If [compiled from source](../lnd/run-lnd.md#docs-internal-guid-8ffda72d-7fff-a07e-3bb8-93cdf01b5103), it needs to be built with `tags=signrpc walletrpc chainrpc invoicesrpc`. LND needs to be synced and running on the same bitcoin network as you are doing your testing. RPC connections need to be accepted and Macaroons need to be set. [Learn how to set up LND using the default configuration here](../lnd/run-lnd.md). For onchain operations, this LND node should have some funds in its onchain wallet, but does not need open channels to mint, send and receive Taproot Assets on chain.

## Installation: <a href="#docs-internal-guid-0652b60a-7fff-d0e5-15fc-159e8557bc88" id="docs-internal-guid-0652b60a-7fff-d0e5-15fc-159e8557bc88"></a>

### From source: <a href="#docs-internal-guid-5879af55-7fff-021d-8347-7ef95cd98105" id="docs-internal-guid-5879af55-7fff-021d-8347-7ef95cd98105"></a>

Compile Taproot Assets from source by cloning the taproot-assets repository. [Go version 1.21](https://go.dev/dl/) or higher is recommended (you may check what version of go is running with `go version`).

`git clone https://github.com/lightninglabs/taproot-assets.git`\
`cd taproot-assets`\
`checkout <latest version>`\
`make install`

## Configuration: <a href="#docs-internal-guid-8aa3849c-7fff-4b8e-530a-a563b8d9d0b8" id="docs-internal-guid-8aa3849c-7fff-4b8e-530a-a563b8d9d0b8"></a>

Optionally, create a Taproot Assets configuration file under `~/.tapd/tapd.conf` on Linux or BSD, `~/Library/Application Support/tapd/tapd.conf` in Mac OS or `$LOCALAPPDATA/Tapd/tap.conf` in Windows.

Within the `tapd.conf` file you can permanently set your variables, such as directory, macaroon or other paths and how to connect to your LND.

As there is currently no migration path between the SQLite and Postgres backends, the backend needs to be configured when `tapd` is first initialized.

## Running tapd: <a href="#docs-internal-guid-ebf73e49-7fff-b5ed-44ff-b9b0953c6082" id="docs-internal-guid-ebf73e49-7fff-b5ed-44ff-b9b0953c6082"></a>

Run Taproot Assets with the command `tapd`. Specify how Taproot Assets can reach LND and what bitcoin network to run Taproot Assets with by passing it additional flags.

`tapd --network=testnet --debuglevel=debug --lnd.host=localhost:10009 --lnd.macaroonpath=/.lnd/data/chain/bitcoin/testnet/admin.macaroon --lnd.tlspath=/.lnd/tls.cert --tapddir=~/.tapd --rpclisten=127.0.0.1:10029 --restlisten=127.0.0.1:8089`

You may run multiple tapd instances on the same machine, but you will also have to set up multiple LND instances. [Refer to this guide](../lnd/run-lnd.md) for how to set up multiple LND instances with a single Bitcoin backend using `rpcpolling`. When running multiple `tapd` instances on one machine, don’t forget to set an alternate Taproot Assets directory and API endpoints and specify these when calling `tapcli` as well.

For example, to run a second instance of `tapd`:

`tapd --tapddir=~/.tapd-2 --rpclisten=127.0.0.1:10030 --restlisten=127.0.0.1:8090`

To interact with this second instance using `tapcli`:

`tapcli --rpcserver=127.0.0.1:10030 --tapddir=~/.tapd-2`

You can make use of `tapcli profiles` to make calls to separate `tapd` instances on the same machine.
