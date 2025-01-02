---
description: Install Loopd from source or the binaries
---

# 🛠️ Get Started

## Install Loop <a href="#docs-internal-guid-a15d1019-7fff-cd65-8961-f4145a3bd0d5" id="docs-internal-guid-a15d1019-7fff-cd65-8961-f4145a3bd0d5"></a>

Loop comes bundled with [Lightning Terminal](../lightning-terminal/) (`litd`). If you are already running `litd`, you can access Loop through the command line or the [Lightning Terminal UI](../lightning-terminal/connect.md) and may skip the steps below.

[Follow this guide to install Lightning Terminal](../lightning-terminal/get-lit.md)

## Installation

To run Loop you need to be running LND from the[ binary releases](https://github.com/lightningnetwork/lnd/releases), or compile from source with the command make install `tags="signrpc walletrpc chainrpc invoicesrpc"`

### Run the Binary <a href="#docs-internal-guid-42583cca-7fff-ed7e-46c6-2304f786c1e8" id="docs-internal-guid-42583cca-7fff-ed7e-46c6-2304f786c1e8"></a>

You can run Loop directly from the binary releases, [which you can find here](https://github.com/lightninglabs/loop/releases).

### Compile from source

You can compile Loop from source. This requires Golang. Instructions for how to install Go can be found in the [LND installation guide](../lnd/run-lnd.md).

`git clone https://github.com/lightninglabs/loop.git`\
`cd loop`\
`make && make install`

## Configuration

By default, the `loopd.conf` is placed in `~/.loop/mainnet/` If you are starting `loopd` on another network (e.g. `loopd --network=signet`), the configuration file is expected in the relevant directory (e.g. `~/.loop/signet`). You may also pass a custom directory with the `--configfile=` flag.
