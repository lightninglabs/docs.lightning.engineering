---
description: Learn how to install LND on your machine, configure it and keep it up to date.
---

# 🛠 Get Started

The Lightning Network Daemon is a full implementation of a Lightning Network node. The Lightning Network and its specification are rapidly evolving, and so is LND. Use this guide to install LND from the binaries, source or docker and keep it up to date with new releases.

{% embed url="https://www.youtube.com/watch?v=rf-GvVYuWa8" %}
Video: RUN LND: Building a Node from Scratch
{% endembed %}

## Prerequisites <a href="#docs-internal-guid-b519fc5f-7fff-49d2-4038-dbcc3e23af33" id="docs-internal-guid-b519fc5f-7fff-49d2-4038-dbcc3e23af33"></a>

**Operating system:**\
LND runs on Windows or Mac OS X, but Unix operating systems are recommended, while Debian/Ubuntu is used for the examples below. A 64-bit architecture is required due to files growing larger than 2GB.

**Machine:**\
LND requires at minimum 2GB RAM and a 1 GHz quad core with at least 5GB of storage. LND makes frequent reads and writes, meaning you should not use a SD card, but instead a SSD of good quality.

**Bitcoin:**\
LND does not require a Bitcoin backend as you may run your node in Neutrino mode. For performance reasons it is recommended to run either Bitcoin Core or btcd on the same machine or on a machine on the same network. You may prune your Bitcoin node, though doing so aggressively may impact performance. To make use of LND’s taproot functionalities you must run at least bitcoind v0.21 or btcd v0.23.1.

## Part 1: Installation <a href="#docs-internal-guid-c531bf19-7fff-07a1-45c2-0d01f5f4396f" id="docs-internal-guid-c531bf19-7fff-07a1-45c2-0d01f5f4396f"></a>

[Install from the binaries (recommended)](run-lnd.md#binaries)

[Install from source](run-lnd.md#docs-internal-guid-8ffda72d-7fff-a07e-3bb8-93cdf01b5103)

[Install using docker](run-lnd.md#docs-internal-guid-05531972-7fff-3243-8a52-edb04cdbfeef)

[Install via third-party platforms](run-lnd.md#installing-lnd-using-third-party-scripts)

### Binaries

If you are a regular user and intend to use LND in production, we recommend using the binaries.

**Download:**\
You can find up-to-date releases of binaries for various operating systems and architectures [here](https://github.com/lightningnetwork/lnd/releases).

**Verification:**\
Each release is signed by multiple developers. You may find their keys in the [LND repository here](https://github.com/lightningnetwork/lnd/tree/master/scripts/keys). Import these keys and verify the signatures.

`gpg –import key.asc`\
`gpg --verify manifest-beta.sig manifest-beta.txt`

Lastly, you will compare the hash of the .tar.gz file with the hash listed in the manifest.

`sha256sum lnd.tar.gz`

**Unpack:**\
Unpack the compressed tarball to retrieve the binaries.

`tar -xvf lnd.tar.gz`

**Installation:**\
To install the binaries, simply place the files in your path where your operating system can find it, or add the directory containing the binary to your path.

Type `$PATH` to see your current path directories.

`$PATH`\
`mv lnd /usr/local/bin`

Congratulations, you have successfully installed LND using the binary release. [Jump to Configuring LND](run-lnd.md#docs-internal-guid-5ec077cf-7fff-8995-7975-30492f03ed17). Additionally, you may use [this sample file](https://github.com/lightningnetwork/lnd/blob/d3faef56913d5a101d0578b0568ad9fafcb0a3dc/contrib/init/lnd.service) to configure LND to run with systemd.

### From source <a href="#docs-internal-guid-8ffda72d-7fff-a07e-3bb8-93cdf01b5103" id="docs-internal-guid-8ffda72d-7fff-a07e-3bb8-93cdf01b5103"></a>

**Install go:**\
``Installing LND from source is recommended when using it in development or on testnet. To install LND from source, you will need Go version 1.18 or higher.

You can find the latest version of Golang [on its official website](https://golang.org/dl/). Make sure to verify the checksum before you install Go.

`sudo tar -C /usr/local -xzf go[version].linux-[platform].tar.gz`

`export PATH=$PATH:/usr/local/go/bin`

To permanently include this new directory in your path, add the following lines to your `.bashrc` file and open a new terminal window to activate it.

`export GOPATH=~/go`\
`export PATH=$PATH:$GOPATH/bin`

**Install LND:**\
``We can install lnd with the following commands. Starting with lnd 0.15 all important subsystems are built by default and no longer have to be manually specified.

`git clone https://github.com/lightningnetwork/lnd`\
`cd lnd`\
`git checkout <most recent version>`\
`make install`

LND is now installed from source.

Included subsystems: [autopilotrpc](https://github.com/lightningnetwork/lnd/blob/master/lnrpc/autopilotrpc/autopilot.proto), [signrpc](https://github.com/lightningnetwork/lnd/blob/master/lnrpc/signrpc/signer.proto), [walletrpc](https://github.com/lightningnetwork/lnd/blob/master/lnrpc/walletrpc/walletkit.proto), [chainrpc](https://github.com/lightningnetwork/lnd/blob/master/lnrpc/chainrpc/chainnotifier.proto), [invoicesrpc](https://github.com/lightningnetwork/lnd/blob/master/lnrpc/invoicesrpc/invoices.proto), [neutrinorpc](https://github.com/lightningnetwork/lnd/blob/master/lnrpc/neutrinorpc/neutrino.proto), [routerrpc](https://github.com/lightningnetwork/lnd/blob/master/lnrpc/routerrpc/router.proto), [watchtowerrpc](https://github.com/lightningnetwork/lnd/blob/master/lnrpc/watchtowerrpc/watchtower.proto), [monitoring](https://github.com/lightningnetwork/lnd/blob/master/monitoring), [peersrpc](https://github.com/lightningnetwork/lnd/blob/master/lnrpc/peersrpc/peers.proto), [kvdb\_postrgres](https://github.com/lightningnetwork/lnd/blob/master/docs/postgres.md), [kvdb\_etcd](https://github.com/lightningnetwork/lnd/blob/master/docs/etcd.md)

Congratulations, you have successfully installed LND using the binary release. [Jump to Configuring LND](run-lnd.md#docs-internal-guid-5ec077cf-7fff-8995-7975-30492f03ed17). Additionally, you may use [this sample file](https://github.com/lightningnetwork/lnd/blob/d3faef56913d5a101d0578b0568ad9fafcb0a3dc/contrib/init/lnd.service) to configure LND to run with systemd.

### Using docker <a href="#docs-internal-guid-05531972-7fff-3243-8a52-edb04cdbfeef" id="docs-internal-guid-05531972-7fff-3243-8a52-edb04cdbfeef"></a>

For those familiar with Docker, or those interested in easily running a variety of software alongside each other, the Docker installation is a convenient and quick way to get started with lightning.

To install LND via Docker you will need docker, make and bash on your system. You can install lnd with the following commands:

`git clone https://github.com/lightningnetwork/lnd`\
`cd lnd`\
`git checkout <latest-release>`\
`make docker-release tag=<latest-release>`

You are now able to find the images in the directory `/lnd` for your use. Congratulations, you have successfully installed LND using the docker. [Jump to Configuring LND](run-lnd.md#docs-internal-guid-5ec077cf-7fff-8995-7975-30492f03ed17).

### Installing LND using third-party scripts

You can install LND inside a variety of third-party software, such as [BTCPay Server](https://btcpayserver.org), [RaspbiBlitz](https://raspiblitz.org), [myNode](https://mynodebtc.com) or [Umbrel](https://getumbrel.com). This might become your installation of choice if you want to use Lightning payments primarily to receive payments in commerce, or if you want to easily run LND along with a variety of other software that leverage your Bitcoin user experience as an individual user.

## Part 2: Configuration <a href="#docs-internal-guid-5ec077cf-7fff-8995-7975-30492f03ed17" id="docs-internal-guid-5ec077cf-7fff-8995-7975-30492f03ed17"></a>

### Configuring Bitcoin

You may prune your Bitcoin backend. As LND will then need to fetch some blocks elsewhere, aggressive pruning can lead to performance loss.

**Neutrino:**\
If you are running LND with Neutrino as a backend, you may skip this section. You may also be interested in how to configure your Bitcoin node to [serve blocks to light clients in the broader network](enable-neutrino-mode-in-bitcoin-core.md).

**Bitcoind:**\
Most importantly, your Bitcoin Core node needs to have RPC enabled, either through `rpcauth` or with a username and password. The following entries refer to your `bitcoin.conf` file. [Here](https://github.com/bitcoin/bitcoin/blob/master/contrib/devtools/README.md) you find instructions on how to create an up to date sample configuration file for Bitcoin Core.

`rpcauth=[user]:[password hash]`

OR

`rpcuser=[any username]`\
`rpcpassword=[any unique password of your choosing]`

To get the latest block data, you should enable ZMQ. The experimental “rpcpolling” option can make ZMQ obsolete, making it possible to set up multiple LND nodes per Bitcoind backend, or multiple Bitcoind backends for one or multiple LND using a load balancer.

If your Bitcoin Core and LND nodes are not running on the same machine, you will need to be aware of the relevant IP addresses.

`zmqpubrawblock=tcp://127.0.0.1:28332`\
`zmqpubrawtx=tcp://127.0.0.1:28333`

When running a full, unpruned Bitcoin node you may set the following flag for small performance improvements:

`txindex=1`

**Btcd:**\
****Your btcd backend needs RPC enabled.

`rpcuser=[any username]`\
`rpcpass=[any unique password of your choosing]`

### Configuring LND <a href="#docs-internal-guid-1c142120-7fff-1b35-7b66-af56937af371" id="docs-internal-guid-1c142120-7fff-1b35-7b66-af56937af371"></a>

You can find your lnd.conf file in `~/.lnd` in Linux, `~/Library/Application Support/Lnd` in Mac OS X and `$LOCALAPPDATA/Lnd` in Windows. You can find a [sample `lnd.conf` here](lnd.conf.md).

You will need to specify in this configuration file which backend you prefer to use and how your node should connect to it.

**General configuration:**

`bitcoin.active=true`\
`bitcoin.mainnet=true`

**Neutrino:**

`bitcoin.node=neutrino`\
`neutrino.connect=faucet.lightning.community`

**Bitcoind:**

`bitcoin.node=bitcoind`\
`bitcoind.rpcuser=[any username]`\
`bitcoind.rpcpass=[any unique password of your choosing]`\
`bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332`\
`bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333`

If you have chosen to omit ZMQ in your bitcoind configuration file, you will have to set the following in lnd instead:

`bitcoind.rpcpolling`

**Btcd:**

`bitcoin.node=btcd`\
`btcd.rpcuser=[any username]`\
`btcd.rpcpass=[any unique password of your choosing]`\
`btcd.rpccert=`

Additionally, you may have a look at `the` guides “[Optimal configuration for a routing node](optimal-configuration-of-a-routing-node.md)” and “[Tor setup](quick-tor-setup.md).”

### Run LND <a href="#docs-internal-guid-a3db49cc-7fff-5f8c-ae41-6f2de68e8fb7" id="docs-internal-guid-a3db49cc-7fff-5f8c-ae41-6f2de68e8fb7"></a>

Now that we have LND installed and configured with its Bitcoin backend we may start it for the first time.

We may start lnd by simply using the command `lnd`. Depending on our installation, we might have to specify the location or add it to our path.

`lnd`

While LND, the Lightning Network Daemon will run in the background, we will use lncli (LND Command Line Interface) to interact with it. lncli will pass our commands to lnd and return useful information back to us.

`lncli`

## Part 3: Upgrade LND <a href="#docs-internal-guid-277e81aa-7fff-ccda-4359-bf5ca2a712bc" id="docs-internal-guid-277e81aa-7fff-ccda-4359-bf5ca2a712bc"></a>

It is recommended to upgrade to the latest release whenever it becomes available. If you miss a release, it is generally recommended to upgrade directly to the latest version.

[Upgrade using the binaries (recommended)](run-lnd.md#docs-internal-guid-5d9031c2-7fff-0da3-d810-6914af3b84ac)

[Upgrade from source](run-lnd.md#docs-internal-guid-81f5d0bd-7fff-a946-26ac-c5049b110196)

[Upgrade using docker](run-lnd.md#docs-internal-guid-bf36d4fb-7fff-b38f-6dcb-1a64cb68845e)

### Using the binaries <a href="#docs-internal-guid-5d9031c2-7fff-0da3-d810-6914af3b84ac" id="docs-internal-guid-5d9031c2-7fff-0da3-d810-6914af3b84ac"></a>

If you are running the LND binary, you may download, verify and unpack LND in the same way as during the installation. You can download the latest releases for [various operating systems here](https://github.com/lightningnetwork/lnd/releases).

You can then gracefully shut down LND with the command `lncli stop`. This may take a minute.

Now move the binaries to the directory of your existing LND, overwriting the previous binary.

You can now start LND again, unlock the wallet and verify you are using the correct version with `lncli version`.

### From source <a href="#docs-internal-guid-81f5d0bd-7fff-a946-26ac-c5049b110196" id="docs-internal-guid-81f5d0bd-7fff-a946-26ac-c5049b110196"></a>

You can gracefully shut down LND with the command `lncli stop`. This may take a minute.

Then navigate to your local copy of the LND github repository and pull from it before installing the latest version of LND.

`git pull`\
`git checkout <latest release>`\
`make clean && make && make install`

You can now start LND again, unlock the wallet and verify you are using the correct version with `lncli version`.

### Using docker <a href="#docs-internal-guid-bf36d4fb-7fff-b38f-6dcb-1a64cb68845e" id="docs-internal-guid-bf36d4fb-7fff-b38f-6dcb-1a64cb68845e"></a>

If you are running LND in a docker container, you can upgrade this container as follows. Don’t forget to gracefully shut down LND with the command `lncli stop` before the upgrade. This may take a minute.

First navigate to the local copy of the lnd github repository. Then execute the following commands:

`git pull`\
`git checkout <latest release>`\
`make docker-release tag=<latest release>`

You can now start lnd again, unlock the wallet and verify you are using the correct version with `lncli version`.
