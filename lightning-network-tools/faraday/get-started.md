---
description: Install and run faraday and frcli
---

# Get Started

## Installation <a href="#docs-internal-guid-83e367ac-7fff-1ea9-0a8d-a1444b90286f" id="docs-internal-guid-83e367ac-7fff-1ea9-0a8d-a1444b90286f"></a>

Faraday comes bundled in Lightning Terminal. Meaning if you have Lightning Terminal installed, you can already access Faraday through the command line and you may skip the step below. If you want to install Lightning Terminal, [follow this guide](../lightning-terminal/).

To run Faraday, you need to be running LND from the [binary releases](https://github.com/lightningnetwork/lnd/releases), or compile from source with the command `make install tags="signrpc walletrpc chainrpc invoicesrpc"`

You can run Faraday directly from the [binary releases](https://github.com/lightninglabs/faraday/releases), or compile it from source:

`git clone https://github.com/lightninglabs/faraday.git`\
`cd faraday`\
`make && make install`

## Run Faraday

Faraday, like bitcoind, LND and others, comes with two components: Faraday itself, and a command line interface (CLI) to interact with it. In this case, they are called `faraday` and `frcli`.

To make full use of Faraday you will need to connect it to your Bitcoin node, for example `bitcoind` or `btcd`. To do that, run Faraday with the command `faraday --connect_bitcoin --bitcoin.host=localhost:8332 --bitcoin.user=[the RPC username as defined in bitcoin.conf] --bitcoin.password=[the RPC password as defined in bitcoin.conf]`

If you want to run Faraday in the background, you can also write the output to `/dev/null` by amending `&>/dev/null &` to the above command.\


### Lightning Terminal

If you are running Lightning Terminal already, either locally or remotely, Faraday will be running inside of it already. However, you will need to specify the port everytime you run frcli using the flag `--rpcserver=localhost:8443`, for example `./frcli --rpcserver=localhost:8443 audit`

If you are a Lightning Terminal user and want to avoid having to include the `--rpcserver` command every time or navigating to the location of the frcli binary, you may also add an entry to your aliases file (e.g. `~/.bash_aliases`):

`alias frcli=’~/path/to/lit/./frcli --rpcserver=localhost:8443’`

You may have to manually move over your node’s `tls.cert` to `~/.faraday/mainnet`

To use all of Faraday’s features, we will have to configure Lightning Terminal to connect to our Bitcoin node. We can do that by amending the following lines to our `lit.conf` file:

`faraday.connect_bitcoin=1`\
`faraday.bitcoin.host=[the ip or domain of our bitcoind node]:8332`\
`faraday.bitcoin.user=[our bitcoind username, as specified in our bitcoin.conf]`\
`faraday.bitcoin.password=[our bitcoind password, as specified in our bitcoin.conf]`\


Typically, bitcoind will not allow RPC connections from outside, although this can be configured with `rpcallowip=[IP of the machine you are running LiT on]`. If you are unsure about the security implications of opening up bitcoind’s RPC calls, consider using faraday on the same machine as your bitcoin node.
