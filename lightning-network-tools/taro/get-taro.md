---
description: >-
  The Taro Daemon tarod implements the Taro protocol for issuing assets on the
  Bitcoin blockchain.
---

# Get Started

## #Craeful <a href="#docs-internal-guid-f9af6317-7fff-eeb2-2957-b358d3da86da" id="docs-internal-guid-f9af6317-7fff-eeb2-2957-b358d3da86da"></a>

Taro is alpha software. It is configured to run on regtest, testnet3 and simnet only, where it’s okay if bitcoin or taro assets are irrevocably lost.

## Prerequisites <a href="#docs-internal-guid-29b5ec39-7fff-4a26-d7e9-dfa1d01ff2c6" id="docs-internal-guid-29b5ec39-7fff-4a26-d7e9-dfa1d01ff2c6"></a>

Taro requires [LND](https://github.com/lightningnetwork/lnd/) compiled with `tags=signrpc walletrpc chainrpc invoicesrpc` from source on the latest main branch, synced and running on the same bitcoin network as you are doing your testing. RPC connections need to be accepted and Macaroons need to be set. [Learn how to set up LND using the default configuration here.](../lnd/run-lnd.md)

## Installation: <a href="#docs-internal-guid-0652b60a-7fff-d0e5-15fc-159e8557bc88" id="docs-internal-guid-0652b60a-7fff-d0e5-15fc-159e8557bc88"></a>

### From source: <a href="#docs-internal-guid-5879af55-7fff-021d-8347-7ef95cd98105" id="docs-internal-guid-5879af55-7fff-021d-8347-7ef95cd98105"></a>

Compile Taro from source by cloning the Taro repository. [Go version 1.18](https://go.dev/dl/) or higher is required (you may check what version of go is running with go version).

`git clone https://github.com/lightninglabs/taro.git`\
`cd taro`\
`make install`

## Configuration: <a href="#docs-internal-guid-8aa3849c-7fff-4b8e-530a-a563b8d9d0b8" id="docs-internal-guid-8aa3849c-7fff-4b8e-530a-a563b8d9d0b8"></a>

Optionally, create a Taro configuration file under `~/.taro/taro.conf` on Linux or BSD, `~/Library/Application Support/Taro/taro.conf` in Mac OS or `$LOCALAPPDATA/Taro/taro.conf` in Windows.

Here you can permanently set your variables, such as paths and how to connect to LND.

## Running tarod: <a href="#docs-internal-guid-ebf73e49-7fff-b5ed-44ff-b9b0953c6082" id="docs-internal-guid-ebf73e49-7fff-b5ed-44ff-b9b0953c6082"></a>

Run Taro with the command `tarod`. Specify how Taro can reach LND and what network to run Taro with by passing it additional flags.

`tarod –network=testnet –debuglevel=debug —lnd.host=localhost:10009 --lnd.macaroonpath=~/.lnd/data/chain/bitcoin/testnet/admin.macaroon --lnd.tlspath=~/.lnd/tls.cert --tarodir=~/.taro --rpclisten=127.0.0.1:10029 --restlisten=127.0.0.1:8089`

You may run multiple `tarod` instances on the same machine, connected to the same LND. In this case, don’t forget to set an alternate Taro directory and API endpoints and specify these when calling `tarocli` as well.

You may for example create an alias in `.bash_aliases`:

`alias tarocli-alice='tarocli --rpcserver=127.0.0.1:10029 --tarodir=~/.taro-alice'`

`alias tarocli-bob='tarocli --rpcserver=127.0.0.1:10030 --tarodir=~/.taro-bob'`

