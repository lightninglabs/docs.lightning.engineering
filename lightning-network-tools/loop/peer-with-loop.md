---
description: >-
  We are always looking for well-connected routing node operators who are
  interested in earning routing fees to help route these funds to the Loop node.
---

# Peer with Loop

The Loop Lightning Network node is publicly reachable and accepts incoming channels.

Lightning Loop helps merchants and other Lightning services swap their off-chain funds for on-chain funds. We are always looking for well-connected routing node operators who are interested in earning routing fees to help route these funds to the Loop node.

## Understand

As merchants and services perform Loop Out operations to move their off-chain earnings onto the blockchain, the unidirectional movement of funds will "drain" your channels, which can happen rapidly for routing nodes with competitive fee rates and good connectivity., As the liquidity moves to Loop the channel capacity is exhausted and the channel is closed.

Loop peers are compensated for their blockchain fees and liquidity costs, mainly by earning fees on the forwarded payments. It is important that the fees for your channel with Loop are appropriately set before the channel is active, ideally by configuring defaults.

Any channel opened to Loop may deplete quickly using appropriate fees, after which the channel is likely to be cooperatively closed so the on-chain funds, which have moved to Loop’s side of the channel can be used to fund the swaps on-chain. Peering with Loop requires adequate [inbound capacity](../../the-lightning-network/liquidity/how-to-get-inbound-capacity-on-the-lightning-network.md) from the wider network, which is likely to deplete overtime.

Nodes with an abundance of inbound liquidity may find it profitable to earn routing fees by selling their excess inbound liquidity. In practice we see most of the fees of a Loop Out being paid to routing node operators rather than the Loop service itself.

## How to peer with Loop <a href="#docs-internal-guid-d9dbc50f-7fff-dabe-a66b-53363dd08bd8" id="docs-internal-guid-d9dbc50f-7fff-dabe-a66b-53363dd08bd8"></a>

To take advantage of aggregation benefits and minimize on-chain fees, Loop requires a minimum channel size of 30,000,000 satoshis.

Amend your configuration file `lnd.conf`

`bitcoin.feerate=1000`

Restart LND to put this change into effect

Open your channel to Loop

`lncli openchannel –node_key 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d –connect 50.112.125.89:9735 –local_amt 210000000 –conf_target 6`&#x20;

Your channel will become active after 6 confirmations.

### Mainnet

You can find the Loop node at `021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d@44.228.158.82:9735`

### Testnet3 <a href="#docs-internal-guid-d9fa217c-7fff-5faa-c826-c2106b10dd06" id="docs-internal-guid-d9fa217c-7fff-5faa-c826-c2106b10dd06"></a>

You can find the Loop testnet3 node at `0200a7f20e51049363cb7f2a0865fe072464d469dca0ac34c954bb3d4b552b6e95@80.253.94.252:9736`

### Signet

You can find the Loop signet node at `022b9e44b3a8093d9512b61f5f83a72d5634201efc49718efd34f2ee851b3afa8e@50.112.25.211:9735`

## Loop In

Performing [Loop Ins](../lightning-terminal/loop.md#loop-in), meaning to refill your channels through an onchain swap, is a cost effective way to extend the lifetime of your channel with Loop, keep it from closing.

These swaps use Taproot by default, which significantly lowers the amount of data that needs to be recorded on chain. This allows Loop In to be priced as low as 1 ppm. At a fee rate of 50 sat/vB for example, a one-input-one-output transaction costs about 7200 satoshis, compared to about 8000 satoshis to close a channel, plus a minimum of 7200 to reopen it.
