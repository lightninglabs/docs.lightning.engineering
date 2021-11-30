---
description: >-
  You can install litd on your Linux, MacOS or Windows machine, either in
  integrated or remote mode.
---

# Get litd

You can install `litd` from source or via the provided binary. If you are running LND as part of a software bundle like Umbrel, `litd` might already be installed on your node.

## Install the binary

Choose this option for a quick and convenient installation. You can find the binaries and verification instructions for the latest release on [Github](https://github.com/lightninglabs/lightning-terminal/releases/).

Once you have downloaded the binary for your operating system, verify them and unpack them, either with your file manager or the command line. This may look like this:

`tar -xvf lightning-terminal-<latest release>-alpha.tar.gz`

Or on Windows:

`tar -xvzf C:\path\lightning-temrinal<latest-release>-alpha.tar.gz -C C:\path\litd`

You can now execute the program from its location, or place it where the system can conveniently find it, such as `/bin/litd` on Linux.

Continue here: Run litd

## Install from source

### Prerequisites <a href="#docs-internal-guid-7cbeda7b-7fff-ea25-6c45-b336fa1d808e" id="docs-internal-guid-7cbeda7b-7fff-ea25-6c45-b336fa1d808e"></a>

1. You will need Go. If you compiled LND from source this should already be installed on your system. You can find [detailed instructions here](https://golang.org/doc/install).
2. You will need nodejs. You can [download and install it here](https://nodejs.org/en/download/).
3. You will need yarn. You can [download it here](https://classic.yarnpkg.com/en/docs/install). Most conveniently, you can install it with `npm install --global yarn`
4. You will need to run the latest release of LND (`lnd v0.14.1`). Have a look at this [upgrade guide](../lnd/run-lnd.md#upgrading-from-source).

First, turn off lnd

`lncli stop`

Then, pull from source and install the latest master

`cd path/to/lnd`

`git pull`

`git checkout v0.14.1-beta`

`make install tags="autopilotrpc chainrpc invoicesrpc routerrpc signrpc walletrpc watchtowerrpc wtclientrpc"`

### Install litd <a href="#docs-internal-guid-ae172929-7fff-f9d0-7921-e6f8acc92f53" id="docs-internal-guid-ae172929-7fff-f9d0-7921-e6f8acc92f53"></a>

1. First we will download the source code from Github

`git clone https://github.com/lightninglabs/lightning-terminal.git`

git checkout \<latest release>

1. Now we will install it:

`make install`

The binaries should be found in your Go path, most commonly \~/go/bin/ You can navigate and check your Go path with cd $GOPATH

Continue here: Run litd
