---
description: >-
  Deploy your Lightning and Taproot Assets testing infrastructure to Bitcoin
  Signet
---

# Testing on Signet

Signet is a privately run Bitcoin test network. Unlike testnet, signet cannot be mined, so all coins must be obtained from the maintainers. Unlike testnet3 & 4, signet runs reliably at one block every \~10 minutes, stable fees and predictable rules.

In the context of the Lightning Network, signet is often preferred as it allows for a durable, public network under realistic network conditions.

## Faucets

The highest barrier to the signet network remains getting signet coins, as they are considered worthless and are not traded. Some faucets exist that can help you get access to coins, though their reliability and availability isn’t always guaranteed.

Powcoins, a command line interface that let’s you spend proof of work to obtain coins:

[https://github.com/ajtowns/powcoins](https://github.com/ajtowns/powcoins)

Browser-based signet faucets:

[https://signet257.bublina.eu.org/](https://signet257.bublina.eu.org/)

[https://signetfaucet.com/](https://signetfaucet.com/)

[https://faucet.coinbin.org/](https://faucet.coinbin.org/)

## Bitcoin

To configure Bitcoin Core or Btcd to run on signet, it is sufficient to specify signet in the configuration file:

`signet=1`

If you cannot find any peers, you may try:

`bitcoin-cli addnode 170.75.165.5:8333 add`

As of signet block 300,000, the blockchain consumes about \~19GB of space and may be pruned, plus 3.7GB for the UTXO set.

## Lightning

LND can be easily run on signet by appending the following to your lnd.conf:

`network=signet`

Don’t forget to append `--network=signet` to your LND and Litd calls!

You can find an overview of the signet Lightning Network, as well as the connection information of various nodes here:

[https://mempool.space/signet/lightning](https://mempool.space/signet/lightning)

## Litd

You may run Lightning Terminal on signet just as you would on mainnet, with only `network=signet` as additional configuration. In integrated (LND) mode, `lnd.bitcoin.signet=1` also needs to be present.&#x20;

Autopilot has to either be disengaged on on signet, or pointed at a separate host by setting your `lit.conf` file:

`autopilot.disable=true`

or

`autopilot.address=signet.autopilot.lightning.finance:12010`

## Loop

Use all Loop features on signet, just as you are used to.

To peer with Loop signet node, connect to the following URI: `022b9e44b3a8093d9512b61f5f83a72d5634201efc49718efd34f2ee851b3afa8e@50.112.25.211:9735`

## Pool

Pool is available on Signet. To run `poold` on signet, pass the `network=signet` flag or add it to your configuration file.

## Taproot Assets

To run `tapd` on signet, define network=signet on startup or as part of `tapd.conf`

A universe can be found at `signet.universe.lightning.finance:443`

## Other resources

### Bitcoin Wiki

[https://en.bitcoin.it/wiki/Signet](https://en.bitcoin.it/wiki/Signet)

### Electrum Signet

Electrum can be started on signet with the `--signet` flag.

[https://electrum.org/](https://electrum.org/)

### Blink

[https://dev.blink.sv/self-host/deployment/signet](https://dev.blink.sv/self-host/deployment/signet)

### LNbits

[https://signet.laisee.org/](https://signet.laisee.org/)
