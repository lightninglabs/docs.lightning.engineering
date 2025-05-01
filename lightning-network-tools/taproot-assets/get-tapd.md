---
description: >-
  The Taproot Assets Daemon tapd implements the Taproot Assets Protocol for
  issuing and transferring assets on the Bitcoin blockchain.
---

# Get Started

## #Craeful <a href="#docs-internal-guid-f9af6317-7fff-eeb2-2957-b358d3da86da" id="docs-internal-guid-f9af6317-7fff-eeb2-2957-b358d3da86da"></a>

{% hint style="info" %}
Taproot Assets is alpha software. Use it on mainnet at your own risk!
{% endhint %}

## Full featureset <a href="#docs-internal-guid-dfe5d706-7fff-fe20-2c99-ce4fa398fe31" id="docs-internal-guid-dfe5d706-7fff-fe20-2c99-ce4fa398fe31"></a>

To make use of all Taproot Assets features, you must run `litd` in integrated mode, meaning all binaries, including LND and tapd are running as part of one binary.

[Follow this guide to install litd.](../lightning-terminal/get-lit.md)

[Follow this guide to configure litd in integrated mode.](../lightning-terminal/run-litd.md)

[Already running LND? Follow this guide to integrate litd](../lightning-terminal/integrating-litd.md)

## Standalone <a href="#docs-internal-guid-24188b0f-7fff-cc1b-10da-87278749e8ce" id="docs-internal-guid-24188b0f-7fff-cc1b-10da-87278749e8ce"></a>

If you do not need to make use of Lightning channels, you may install `tapd` as a standalone binary with a connection to LND. If LND is compiled from source, it needs to be built using `tags=signrpc walletrpc chainrpc invoicesrpc`

LND needs to be synced and running on the same bitcoin network as tapd. RPC connections need to be accepted and Macaroons need to be set.[ Learn how to set up LND using the default configuration here](https://docs.lightning.engineering/lightning-network-tools/lnd/run-lnd). For onchain operations, this LND node should have some funds in its onchain wallet, but does not need open channels to mint, send and receive Taproot Assets on chain.

### From source: <a href="#docs-internal-guid-5879af55-7fff-021d-8347-7ef95cd98105" id="docs-internal-guid-5879af55-7fff-021d-8347-7ef95cd98105"></a>

Compile Taproot Assets from source by cloning the taproot-assets repository. [Go version 1.21](https://go.dev/dl/) or higher is recommended (you may check what version of go is running with `go version`).

`git clone https://github.com/lightninglabs/taproot-assets.git`\
`cd taproot-assets`\
`checkout <latest version>`\
`make install`

{% embed url="https://www.youtube.com/watch?v=Z7KLo-pGBJA" %}
Tapping into Taproot Assets #1: Install from Source
{% endembed %}

## Configuration: <a href="#docs-internal-guid-8aa3849c-7fff-4b8e-530a-a563b8d9d0b8" id="docs-internal-guid-8aa3849c-7fff-4b8e-530a-a563b8d9d0b8"></a>

Optionally, create a Taproot Assets configuration file under `~/.tapd/tapd.conf` on Linux or BSD, `~/Library/Application Support/tapd/tapd.conf` in Mac OS or `$LOCALAPPDATA/Tapd/tap.conf` in Windows.

Within the `tapd.conf` file you can permanently set your variables, such as directory, macaroon or other paths and how to connect to your LND.

As there is currently no migration path between the SQLite and Postgres backends, the backend needs to be configured when `tapd` is first initialized.

### Signet and Regtest

Lightning Labs currently does not provide a Taproot Asset Universe on Signet. In addition to [disabling the autopilot](../lightning-terminal/run-litd.md#docs-internal-guid-59891e79-7fff-362e-d160-3ba75a10db52), users will have to [configure a local or alternative universe](universes.md). To properly close channels, both peers will have to configure the same proof courier as well. In the `lit.conf`:

`taproot-assets.proofcourieraddr=universerpc://universe.signet.laisee.org:8443`

Using the command line:

`tapcli universe federation add --universe_host universe.signet.laisee.org:8443`

## Running tapd: <a href="#docs-internal-guid-ebf73e49-7fff-b5ed-44ff-b9b0953c6082" id="docs-internal-guid-ebf73e49-7fff-b5ed-44ff-b9b0953c6082"></a>

Run Taproot Assets with the command `tapd`. Specify how Taproot Assets can reach LND and what bitcoin network to run Taproot Assets with by passing it additional flags.

`tapd --network=signet --debuglevel=debug --lnd.host=localhost:10009 --lnd.macaroonpath=/home/ubuntu/.lnd/data/chain/bitcoin/signet/admin.macaroon --lnd.tlspath=/home/ubuntu/.lnd/tls.cert --tapddir=~/.tapd --rpclisten=127.0.0.1:10029 --restlisten=127.0.0.1:8089`

You may run multiple tapd instances on the same machine, but you will also have to set up multiple LND instances. [Refer to this guide](../lnd/run-lnd.md) for how to set up multiple LND instances with a single Bitcoin backend using `rpcpolling`. When running multiple `tapd` instances on one machine, don’t forget to set an alternate Taproot Assets directory and API endpoints and specify these when calling `tapcli` as well.

For example, to run a second instance of `tapd`:

`tapd --tapddir=~/.tapd-2 --rpclisten=127.0.0.1:10030 --restlisten=127.0.0.1:8090`

To interact with this second instance using `tapcli`:

`tapcli --rpcserver=127.0.0.1:10030 --tapddir=~/.tapd-2`

You can make use of `tapcli profiles` to make calls to separate `tapd` instances on the same machine.

## Litd

Tapd is included in the Litd bundle. This allows you to run LND and Tapd in the same process and removes the need to configure the two separately.

[Read more: Get Litd](../lightning-terminal/get-lit.md)

{% embed url="https://www.youtube.com/watch?v=EaPZ3EbTWhE" %}
Tapping into Taproot Assets #3: Launch with Litd
{% endembed %}
