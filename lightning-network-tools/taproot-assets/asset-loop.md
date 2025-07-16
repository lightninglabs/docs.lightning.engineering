---
description: >-
  Loop Out your Taproot Asset channel balances into your onchain Bitcoin wallet
  to free up inbound liquidity.
---

# Asset Loop

Starting from Loop v0.30-beta it is possible to perform a Loop Out directly using a Taproot Asset channel balance. Loop will perform an offchain payment to the Loop service via your Edge node. Loop will send BTC onchain to you.

To perform such a Loop Out, you need Taproot Assets in a channel with a peer performing edge node services. This peer needs outbound liquidity to the wider Lightning Network. It is not necessary to run `loopd` as part of `litd` for easy Autoloop to work.

The command `loop out` needs to specify the amount you expect to receive onchain in satoshis, the asset ID of the asset to be dispensed and the public key of the edge node. At this point, it is only possible to Loop Out assets from a single channel.

`loop out --amt 250000 --asset_id c5dc35d9ffa03abcbd22d2d2801d10813970875029843039bf4f99d543d15fef --asset_edge_node 0312bddcf146394bf0805feef967e8485b8648c66065fe7345c4bc97eac8312df7`

Loop will display the quote received from your edge node to provide you with an estimate of how many Taproot Asset units you are expected to pay.

```
Send off-chain:                     	250000000 Stablesigs
Exchange rate:                      	1000.0000 Stablesigs/SAT
Limit Send off-chain:               	266995000 Stablesigs
Receive on-chain:                      	247351 sat
Estimated total fee:                     	2649 sat

Fast swap requested.

CONTINUE SWAP? (y/n): y
Swap initiated
ID:         	4783f095351f2e7fb6d8eaf3c5bca66064349090d2b7795fca42ae2b144b02d7
HTLC address:   tb1ps4jl2l5rs44t6lsp3fkp73396pjsn0syxx9yjqqxktjmtmjtk52sc45drr

Run `loop monitor` to monitor progress.
```

This feature is available on mainnet, testnet and signet. The usual Loop Out minimums and maximums apply. At this point, the Loop node itself does not accept Taproot Asset channels.

## Easy Autoloop <a href="#docs-internal-guid-8ab27de6-7fff-8308-8d71-16e44d37d553" id="docs-internal-guid-8ab27de6-7fff-8308-8d71-16e44d37d553"></a>

Autoloop can also be configured with Taproot Assets. You can configure the `loop setparams` command for multiple Asset IDs. The settings will apply to all channels with these assets.

`loop setparams --asset_easyautoloop --asset_id c5dc35d9ffa03abcbd22d2d2801d10813970875029843039bf4f99d543d15fef --asset_localbalance 100000000`

[Read more: Configure Easy Autoloop](../loop/autoloop.md)
