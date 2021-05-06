---
description: >-
  Learn how to install LND on your machine, configure it optimally and your
  first steps in the Lightning Network.
---

# Getting started with LND and the Lightning Network

The Lightning Network Daemon \(LND\) is a complete implementation of a Lightning Network node. That means that LND is able to perform all actions necessary to participate and interact with all aspects of the Lightning Network and its nodes. It fully complies with all Lightning Network specifications \(BOLTs\) [as described here](https://github.com/lightningnetwork/lightning-rfc/blob/master/00-introduction.md). As these specifications are currently rapidly evolving, so is LND.

## Part 1: Installation <a id="docs-internal-guid-ff85e2ff-7fff-ef9c-0f05-8da12a86ea43"></a>

There are multiple methods for getting LND running on your machine. Your choice will depend on your requirements, the purpose of the installation, your technical expertise, your hardware, security needs and comfort with various tools.

Your requirements and dependencies will vary between installation types, as will the effort to maintain them.

### System requirements

LND generally has low system requirements and performs well on small single-board devices with 2 GiB and a CPU with over 1 GHz quad core, such as a Raspberry Pi. Generally the system requirements for Bitcoind are higher than those for LND. A 64-bit architecture is recommended, and due to the frequent read and write operations LND should not be run from an SD card.

### Installing LND using third-party scripts

You can install LND inside a variety of third-party software, such as [BTCPay Server](https://btcpayserver.org/), [RaspbiBlitz](https://raspiblitz.org/) or [Umbrel](https://getumbrel.com/). This might become your installation of choice if you want to use Lightning payments primarily to receive payments in commerce, or if you want to easily run LND along a variety of other software that leverage your Bitcoin user experience as an individual user.

### Installing the LND binary \(recommended\)

If you are a regular user and intend to use LND in production, we recommend using the binaries. You can find up-to-date releases of binaries for various operating systems and architectures [here](https://github.com/lightningnetwork/lnd/releases).

**Verification**  
You can verify the manifest using PGP with the command `gpg --verify manifest-<developer>-<latest-release>.txt`

You can also verify the git tag with the command `git verify-tag <latest release>`

**Unpacking**  
Choose the package \(ending in tar.gz\) for your architecture and operating system. We recommend choosing 64-bit binaries over 32-bit if your operating system supports it.

How to unpack the package depends on your operating system. In Linux or MacOS, you can unpack the file using the command `tar -xvf lnd<latest release>.tar.gz`

On Windows the command might look like this: `tar -xvzf C:\path\lnd<latest-release>.tar.gz -C C:\path\lnd`

Now move the unpacked binaries somewhere where the system can find it, such as `/bin/lnd`

You can use the file manager or command line, but may have to create this directory first, which may require superuser \(sudo\) or administrator privileges.

Congratulations, you have successfully installed LND using the binary release. [Jump to: Configuring LND](get-started-with-lnd.md#docs-internal-guid-f1be3c4d-7fff-b4f7-e6cd-ce2c32ba2d86)

### Installing Lightning via Docker <a id="docs-internal-guid-fe99d99a-7fff-2f7a-022e-4fab339d71f9"></a>

For those familiar with Docker, or those interested in easily running a variety of software alongside each other, the Docker installation is a convenient and quick way to get started with lightning.

To install LND via Docker you will need `docker`, `make` and `bash` on your system. You can install lnd with the following commands:

`git clone https://github.com/lightningnetwork/lnd  
cd lnd  
git checkout <latest-release>  
make docker-release tag=<latest-release>`

You are now able to find the binaries in the directory lnd&lt;latest-release&gt; for your use. Congratulations, [jump to: Configuring LND](get-started-with-lnd.md#docs-internal-guid-f1be3c4d-7fff-b4f7-e6cd-ce2c32ba2d86)

### Installing LND from source

Installing LND from source is recommended when using it in development or on testnet. To install LND from source, you will need Go version 1.13 or higher. We recommend using Go 1.15.

**Installing Go in Linux**  
You can find the latest version of Golang [on its official website](https://golang.org/dl/). Make sure to verify the checksum before you install Go. 

You can now install go with the command:  
`tar -C /usr/local -xzf go[version].linux-[platform].tar.gz  
export PATH=$PATH:/usr/local/go/bin`

**Installing Go on MacOS**  
To install, simply run the command:  
`brew install go@[version]`

**Set your Go path**  
To ensure that the command go refers to the correct path, you will need to set your Go path:  
`export GOPATH=~/gocode  
export PATH=$PATH:$GOPATH/bin`

**Installing LND**  
We can now install LND. We can run the following command from our home directory:  
`git clone https://github.com/lightningnetwork/lnd  
cd lnd  
git checkout [version]  
make install tags="autopilotrpc chainrpc invoicesrpc routerrpc signrpc walletrpc watchtowerrpc wtclientrpc"`

LND is now installed from source.

## Part 2: Configuring LND <a id="docs-internal-guid-f1be3c4d-7fff-b4f7-e6cd-ce2c32ba2d86"></a>

### Bitcoin

LND requires either btcd, bitcoind or neutrino. They can be running on the same machine or a separate instance, but must be reachable over a network interface. In addition to configuring LND, you will also have to configure this Bitcoin node.

**Neutrino**  
Neutrino is an experimental Bitcoin light client written in Go. To use Neutrino, you will need to specify a remote Neutrino node at startup, such as faucet.lightning.community. 

Neutrino itself does not need to run on your machine and as such will not have to be configured separately. Using Neutrino over Bitcoind or btcd allows you to run your node in ‘light mode’, meaning it can run on low powered devices such as a mobile phone without the extensive storage or bandwidth requirements of syncing your full bitcoin node.

**Bitcoind**  
The most popular choice for the Bitcoin backend is bitcoind, the Bitcoin Core daemon. We do not recommend using bitcoind with pruning enabled. At maximum, only transactions older than the oldest Lightning channels may be discarded, e.g. 2017 and before. You can typically find your configuration file in `~/.bitcoin/bitcoin.conf`

We recommend giving LND access to bitcoind PRC using rpcauth. You can read how to set this in the [bitcoind documentation](https://github.com/bitcoin/bitcoin/blob/master/share/examples/bitcoin.conf). 

`rpcauth=[user]:[password hash]`

Alternatively you may also use the rpcuser and rpcpassword commands.  
`rpcuser=` Username for RPC connections. You may choose this freely, but it must match the username provided later in the LND configuration.  
`rpcpassword=` Password for RPC connections. You may choose this freely, we recommend something long and unique.  
`zmqpubrawblock=` The address listening for ZMQ connections to deliver raw block notifications  
`zmqpubrawtx=` The address listening for ZMQ connections to deliver raw transaction notifications  
`txindex=` LND does not require txindex to be set, but will run faster with txindex=1

**btcd**  
To configure btcd for use with LND, you will need to set the following parameters in the btc configuration file, which can be typically found in `~/.btcd/btcd.conf` on Linux.

`rpcuser=` Username for RPC connections. You may choose this freely, but it must match the username provided later in the LND configuration.  
`rpcpass=` Password for RPC connections. You may choose this freely, we recommend something long and unique.

### Configuring LND

To configure LND, we will need to edit the configuration file, which can be typically found in `~/.lnd/lnd.conf` If this directory and the file does not exist yet, you may create it with `~/.lnd/ && touch ~/.lnd/lnd.conf`.

First, we will have to tell LND where and how to find our Bitcoin node. This slightly varies across the different options.

**Bitcoind**  
`rpcuser=` Username for RPC connections. It must match the username provided earlier in the Bitcoind configuration, or the username set in rpcauth  
`rpcpassword=` Password for RPC connections. It must match the password set in the Bitcoind configuration file or the password obtained through rpcauth.  
`zmqpubrawblock=` The address listening for ZMQ connections to deliver raw block notifications  
`zmqpubrawtx=` The address listening for ZMQ connections to deliver raw transaction notifications  
`rpchost=` \(Optional\) The daemon's rpc listening address. If a port is omitted, then the default port for the selected chain parameters will be used. \(default: localhost\)  
`dir=` \(Optional\) The base directory that contains the node's data, logs, configuration file, etc. \(default: /Users/Library/Application Support/Bitcoin\)  
`estimatemode=` \(Optional\) The fee estimate mode. Must be either "ECONOMICAL" or "CONSERVATIVE". \(default: CONSERVATIVE\)

**btcd**  
`rpcuser=` Username for RPC connections. It must match the username provided earlier in the btcd configuration.  
`rpcpass=` Password for RPC connections. It must match the password set in the btcd configuration file.  
`rpccert=`  File containing the daemon's certificate file \(default: `/Users/Library/Application Support/Btcd/rpc.cert`\)  
`rawrpccert=` The raw bytes of the daemon's PEM-encoded certificate chain which will be used to authenticate the RPC connection.  
`rpchost=` \(Optional\) The daemon's rpc listening address. If a port is omitted, then the default port for the selected chain parameters will be used. \(default: `localhost`\)  
`dir=` \(Optional\) The base directory that contains the node's data, logs, configuration file, etc. \(default: `/Users/Library/Application Support/Btcd`\)

**Neutrino**  
When starting lnd with neutrino, you will need to set the following flags:`--bitcoin.node=neutrino --neutrino.connect=faucet.lightning.community`

### Configuring your node

To make your node available as a routing node, you will need to listen to incoming connections. In your [lnd.conf configuration file](https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf), include the following lines:

`listen=0.0.0.0:9735  
listen=[::1]:9736`

This will allow your node to listen on all IPv4 \(port 9735\) and IPv6 \(port 9736\) interfaces.

Note, if you have set`nolisten=true`, this will override the above and make your node unreachable.

### Configuring your system

Be aware of any firewall that might be enabled on your system, for example by using the iptables utility:

`sudo iptables -S`

Using a firewall is a great idea, although the ports defined above need to remain accessible:

`sudo ufw status  
sudo ufw allow OpenSSH  
sudo ufw allow 9735`

#### Other available configurations

There are plenty of options to configure lnd. Have a look at the [sample lnd.conf file here](https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf) and read our article on the optimal configuration for your node.

## Part 3: Running LND <a id="docs-internal-guid-9df27c7d-7fff-522a-838a-a42710fe3e75"></a>

Now that we have LND installed and configured with its Bitcoin backend we may start it for the first time.

We may start lnd by simply using the command `lnd`. Depending on our installation, we might have to specify the location, such as through the command `/bin/lnd` or `~/go/bin/lnd`.

While LND, the Lightning Network Daemon will run in the background, we will use lncli \(LND Command Line Interface\) to interact with it. `lncli` will pass our commands to lnd and return useful information back to us.

As we started LND for the first time, we will have to create a wallet with the command `lncli create`.

Follow the steps carefully and write down your 24 word mnemonic seed phrase. Store it in a secure place, for example on paper or in encrypted storage. You may also choose a password, which will be used to encrypt this wallet on your disk.

Later, we will need to unlock this wallet everytime we restart lnd using the command `lncli unlock`.

### Deposit some Bitcoin

We now have LND running, but to be able to use it to send and receive payments, we will still have to complete a few steps. We will have to deposit bitcoin into our wallet, find a peer and open a channel before we can make our first transaction.

To deposit bitcoin, we obtain a bitcoin address from our LND wallet with the command `lncli newaddress p2wkh`. If for some reason our existing wallet or exchange causes us problems sending bitcoin to this address, we may also use a differently encoded address with `lncli newaddress np2wkh`.

Any bitcoin sent to these addresses will now show up in the `lncli walletbalance` command.

\[[Transactions not confirming? Use this guide to speed them up.](unconfirmed-bitcoin-transactions.md)\]

### Find a peer

Next, we will need to identify a peer to open a channel with. Ideally, a good peer is one that is well connected, capitalized, offers stability, features and competitive fees, but may also be a node that we expect to frequently interact with.

We will need to obtain this peer’s public key as well as its url, IP address or onion address.

\[How to identify good peers in the Lightning Network.\]

### Open a channel

We will now open a channel with this peer, using the command `lncli openchannel`

Depending on how many satoshis we intend to commit to this channel, we may place our entire balance in this channel or open multiple channels with different peers.

Such a command could look like this:  
`lncli openchannel --conf_target 6 --node_key 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d --connect 54.184.88.251:9735 --local_amt 1000000`

\[[How to manage liquidity in the Lightning Network.](../../the-lightning-network/liquidity/manage-liquidity.md)\]

### Make payments and get incoming liquidity

Once our channel has at least three confirmations on the network it becomes active and we can make payments through it. To make a payment, we will need to obtain a lightning invoice, which we can pay with the command `lncli payinvoice <lightning invoice>`.

As soon as we make some outgoing payments and our channel balance empties, our outgoing capacity becomes incoming capacity and we are able to receive payments as well. There are other ways to get incoming capacity, too, such as Loop and Pool.

\[Learn to get incoming liquidity.\]

