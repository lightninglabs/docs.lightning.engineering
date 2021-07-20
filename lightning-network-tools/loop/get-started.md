---
description: Install and run Loop
---

# Get Started

## Install Loop <a id="docs-internal-guid-a15d1019-7fff-cd65-8961-f4145a3bd0d5"></a>

Loop comes bundled with [Lightning Terminal](../lightning-terminal/). Meaning, if you have Lightning Terminal installed, you can already access Loop through the command line and you may skip the step below. 

\[[Follow this guide to install Lightning Terminal](../lightning-terminal/get-lit/)\]

To run Loop you need to be running LND from the [binary releases](https://github.com/lightningnetwork/lnd/releases), or compile from source with the command `make install tags="signrpc walletrpc chainrpc invoicesrpc"`

You can run Loop directly from the binary releases, or compile it from source:

`git clone https://github.com/lightninglabs/loop.git  
cd loop  
make && make install`

## Run Loop

Loop, like bitcoind, LND and others, comes with two components: Loopd and a command line interface \(CLI\) to interact with it called loop.

You will need to first run Loop with the command `loopd`

If you want to run Loop in the background, you can also write the output to `/dev/null` by amending `&>/dev/null &` to the above command.

### Lightning Terminal

If you are running Lightning Terminal already, either locally or remotely, Loop will be running inside of it already. You can make use of Loop using the Lightning Terminal GUI as explained in the Guide to Lightning Terminal.

If you want to interact with Loop in Lightning Terminal through the command line, you will need to specify the port and tls.cert every time you run loop using the flag `--rpcserver=localhost:8443 --tlscertpath=~/.lit/tls.cert`, for example `./loop --rpcserver=localhost:8443 --tlscertpath=~/.lit/tls.certquote in 500000`

Alternatively you may also copy over the `tls.cert` from `~/.lit` into `~/.loop/mainnet`

If you are a Lightning Terminal used and want to avoid having to include the `--rpcserver` command every time or navigate to the location of the loop binary, you may also add an entry to your aliases file \(e.g. `~/.bash_aliases`\):

`alias loop=’~/path/to/loop --rpcserver=localhost:8443’`

