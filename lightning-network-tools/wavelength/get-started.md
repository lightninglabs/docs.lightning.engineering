---
description: Install Wavelength and configure it with a back-end of your choice
---

# Get Started

Wavelength is an easy-to-use Bitcoin wallet that lets you send and receive funds over the Lightning Network as well as onchain. The user holds their own Virtual Unspent Transaction Outputs (vtxos) which can be unilaterally broadcast and settled on the Bitcoin Blockchain.

{% hint style="danger" %}
Warning: Wavelength is alpha software. It is recommended you test on Bitcoin testnet or signet before using real money.
{% endhint %}

## Installation <a href="#docs-internal-guid-ec0a1230-7fff-5e01-0c8d-181162811d80" id="docs-internal-guid-ec0a1230-7fff-5e01-0c8d-181162811d80"></a>

You may install Wavelength either using the binaries, or directly from source.

### Binaries

**Download**:

You can find up-to-date releases of [binaries for various operating systems and architectures here.](https://github.com/lightninglabs/wavelength/releases)

**Unpack**:

Unpack the compressed tarball to retrieve the binaries.

`tar -xvf wavelength-linux-amd64-v0.1.0.tar.gz`

**Installation**:

To install the binaries, simply place the files in your path where your operating system can find it, or add the directory containing the binary to your path.

Type $PATH to see your current path directories.

For example:

`mv waved /usr/local/bin`

Congratulations, you have successfully installed Wavelength using the binary release. [Jump to Configuring Wavelength](get-started.md#configuration).

### From source <a href="#docs-internal-guid-4b32540e-7fff-68fd-9754-528816d7d2d9" id="docs-internal-guid-4b32540e-7fff-68fd-9754-528816d7d2d9"></a>

You will need go version 1.25 or higher. Refer to the [Run LND](../lnd/run-lnd.md) guide for how to install go.

`git clone https://github.com/lightninglabs/wavelength`\
`cd wavelength`\
`git checkout <most recent version>`\
`make install-wavewalletrpc`

Congratulations, you have successfully installed Wavelength from source. [Jump to Configuring Wavelength.](get-started.md#configuration)

## Configuration

To run Wavelength, you will for now have to define a couple of relevant parameters manually.

Most importantly, you will have the choice between running on signet and testnet, and using LND, lwwallet (esplora) or neutrino has a backend.

`network=` \
`signet` (**Recommended**: Bitcoin default signet)\
`testnet` (Bitcoin Testnet 3)\
`testnet4` (Bitcoin Testnet4)

`wallet.type=` \
`lwwallet` (**Default**: Esplora)\
`lnd` (LND)\
`btcwallet` (neutrino)

When using LND as a backend you may define how `waved` connects to your node:

`lnd.host=localhost:10009`\
`lnd.tlspath=$HOME/.lnd/tls.cert`\
`lnd.macaroonpath=$HOME/.lnd/data/chain/bitcoin/<network>/admin.macaroon`

When using `lwwallet` as a back-end you may optionally define your own Esplora endpoint.

`wallet.esploraurl=`\
`https://mempool-signet.testnet.lightningcluster.com/api/` (Signet)\
`wallet.pollinterval=90s`

When using `btcwallet` (also known as Neutrino) as a back-end you will need to refine a fee url.

`wallet.feeurl=`\
`https://nodes.lightning.computer/fees/v1/btc-fee-estimates.json`

## Run Wavelength

To run Wavelength, execute `waved` using the parameters of your choice, for instance using the default lwwallet (esplora) back-end on Signet:

`waved --network=signet`

Or using LND as a back-end on testnet3:

`waved`\
`--network=testnet \` \
`--wallet.type=lnd \`\
`--lnd.host=localhost:10039 \` \
`--lnd.tlspath=$HOME/.lnd/tls.cert \`\
`--lnd.macaroonpath=$HOME/.lnd/data/chain/bitcoin/signet/admin.macaroon`
