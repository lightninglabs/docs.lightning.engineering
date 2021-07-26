---
description: >-
  Prepare one or multiple existing Bitcoin Core nodes to work with LND's
  Neutrino mode.
---

# Enable ‘Neutrino mode’ in Bitcoin Core

With the inclusion of [BIP157](https://github.com/bitcoin/bips/blob/master/bip-0157.mediawiki), starting from [Bitcoin Core 0.21.0](https://bitcoincore.org/en/releases/0.21.0/), we are able to enable our Bitcoin node to serve block data to remote LND nodes. 

This can be useful if we are already running a fully synced Bitcoin node somewhere and want to use it for one or multiple remote instances of LND. If we have the additional bandwidth and storage available, we might also want to make our existing Bitcoin node available to the public as a free service. 

Easily available public Neutrino instances help the network grow more robust and remove bottlenecks. Such services are a prerequisite to light clients, which do not have a copy of the Bitcoin Blockchain available locally.

## Amend your bitcoin.conf

In your `bitcoin.conf` file, add the following paramenters:

`blockfilterindex=1  
peerblockfilters=1`

Once you restart your node, it will resync the Blockchain and build the `blockfilterindex`. This may take a while depending on your node’s available memory and computing power.

As soon as Bitcoin Core is running, it will now advertise itself to the network if you have set this in your configuration. To disable discovery, you may set `discover=0` in your `bitcoin.conf`.

## Connect from your LND

When starting lnd with neutrino, you will need to set the following settings in your `lnd.conf`, or use the corresponding flags at startup:

`bitcoin.node=neutrino  
neutrino.connect=<your Bitcoin node>`  
  
You may also use multiple options of `neutrino.addpeer=` instead of neutrino.connect= if you do not want to limit yourself to only connecting to a single neutrino node.

`bitcoin.node=neutrino`  
`neutrino.addpeer=<your Bitcoin node>  
neutrino.addpeer=faucet.lightning.community`

