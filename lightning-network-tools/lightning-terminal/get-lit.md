---
description: >-
  Learn how to run litd in integrated node, install litd alongside your existing
  LND installation, or move an existing system to litd.
---

# 🛠 Get litd

Litd gives your node access to features such as LND Accounts or LNC while bundling LND with Loop, Pool, Faraday, and, in the future, Taro.

You can point litd at your existing LND, Loop or Pool installation, or you can run LND as part of litd. Running the entire bundle as a single binary is most reliable and convenient. Plus,individual components can be easily swapped out at will, for example to apply patches or run pre-release software.

## Install litd <a href="#docs-internal-guid-18156f91-7fff-a79f-e732-17a8c366357e" id="docs-internal-guid-18156f91-7fff-a79f-e732-17a8c366357e"></a>



You can install litd from source or via the provided binary. If you are running LND as part of a software bundle like Umbrel, litd might already be installed on your node.

[Continue here: Connect to Terminal](run-litd-1.md)

### Install the binary <a href="#docs-internal-guid-1711090d-7fff-5ad6-afb1-1123e0d0a834" id="docs-internal-guid-1711090d-7fff-5ad6-afb1-1123e0d0a834"></a>

Choose this option for a quick and convenient installation. You can find the binaries and verification instructions for the latest release on [Github](https://github.com/lightninglabs/lightning-terminal/releases).

Once you have downloaded the binary for your operating system, verify them and unpack them, either with your file manager or the command line. This may look like this:

`tar -xvf lightning-terminal--alpha.tar.gz`

Or on Windows:

`tar -xvzf C:\path\lightning-temrinal-alpha.tar.gz -C C:\path\litd`

You can now execute the program from its location, or place it where the system can conveniently find it, such as `/bin/litd` on Linux.

Continue here: Run litd

### Install from source <a href="#docs-internal-guid-9de54c81-7fff-3d72-df71-82722d926d98" id="docs-internal-guid-9de54c81-7fff-3d72-df71-82722d926d98"></a>

#### Prerequisites <a href="#docs-internal-guid-eb4075c6-7fff-64f4-e6ec-e91cb4ece7bf" id="docs-internal-guid-eb4075c6-7fff-64f4-e6ec-e91cb4ece7bf"></a>

1. You will need Go version 0.18 or higher. If you compiled LND from source this should already be installed on your system. [You can find detailed instructions here.](http://prerequisites)
2. You will need nodejs. [You can download and install it here](https://nodejs.org/en/download/). Most conveniently, you can install it with snap install node
3. You will need yarn. [You can download it here](https://classic.yarnpkg.com/en/docs/install). Most conveniently, you can install it with npm install --global yarn

#### Install litd <a href="#docs-internal-guid-c4edd295-7fff-ba4b-6d1f-7582ba048646" id="docs-internal-guid-c4edd295-7fff-ba4b-6d1f-7582ba048646"></a>

1. First we will download the source code from Github\
   `git clone https://github.com/lightninglabs/lightning-terminal.git`\
   `cd lightning-terminal`\
   `git checkout <latest version>`
2. We install litd with:\
   `make install`
3. As there may be existing binaries of the command line interfaces on your system, they are not installed by default. To install lncli, loop and pool, please run:\
   make `go-install-cli`

### Install in BTCPay Server <a href="#docs-internal-guid-b1e1624f-7fff-93d5-2d35-b317dc6c4643" id="docs-internal-guid-b1e1624f-7fff-93d5-2d35-b317dc6c4643"></a>

BTCPay contains an installation script for litd, which makes it easy to include litd into your BTCPay Server. [You may also refer to the official guide](https://docs.btcpayserver.org/Docker/lightning-terminal/#lightning-terminal-lit).

1. Set a password for your litd instance:\
   `export LIT_PASSWD="YOUR PASSWORD HERE"`
2. Add the fragment to your configuration and run the installation script:\
   `BTCPAYGEN_ADDITIONAL_FRAGMENTS="$BTCPAYGEN_ADDITIONAL_FRAGMENTS;opt-add-lightning-terminal"`\
   `. btcpay-setup.sh -i`
3. You can now find litd under Server Settings > Services

[Continue here: Connect to Terminal](run-litd-1.md)

