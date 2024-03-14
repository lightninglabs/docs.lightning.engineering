---
description: >-
  Instant Loop Out is a form of submarine swap that makes onchain funds
  immediately available without needing to wait for block confirmations
---

# Instant Loop Outs

Instant Loop Out is a new Loop feature available from `version 0.28`. It allows users to swap offchain to onchain funds immediately without waiting for onchain confirmations through the use of a pre-configured reservation in the form of an onchain commitment.. These funds can then be sent to any other onchain address within a set number of blocks within the creation of the reservation. Funds not sent out in that time frame are swept into your LND node’s internal wallet. These optimizations allow for better fee estimations, expression of time preference, and liquidity management.

Select users are able to take advantage of Instant Loop Outs. This service will be rolled out slowly and will require some manual intervention on both the server and client side.

[Read more: Instant Submarine Swaps](../../the-lightning-network/multihop-payments/instant-submarine-swaps.md)

Configuration: To make use of Instant Loop Outs, you must run `loopd version 0.28` and add `experimental=true` to your `loopd.conf` file under `~/.loop/mainnet` or start Loop with the `--experimental` flag.

To be invited, reach out to [support@lightning.engineering](mailto:support@lightning.engineering) and be prepared to share your L402, which you can obtain under id under loop listauth or in the Lightning Terminal dropdown menu. For now, reservations are done manually upon request and valid for 1000 blocks.

Once a reservation is made, it can be inspected with `loop reservations list`

```
[
    	{
        	"reservation_id":  "9f54c37bfa17766a35c48e810d7076842cc7e74f25fb60f2be954032e001f7cf",
        	"state":  "Confirmed",
        	"amount":  "250000",
        	"tx_id":  "0ccd141613f4f71996fba808a3a4604d985be7f166dca621cfd47d7de2706ddc",
        	"vout":  0,
        	"expiry":  2583088
    	}
]
```

The `expiry` shows the block height at which the reservation can be swept back by the Loop service. The Loop Out should be completed before this block height.

As of now, Instant Loop Outs can only be completed with the full amount of the reservation. To perform an Instant Loop Out, run `loop instantout`. You will see your available reservations and will be able to select one or multiple to complete.

```
Available reservations:

Reservation 1: shortid 9f54c3, amt 250000, expiry height 2583088

Max amount to instant out: 250000

Select reservations for instantout (e.g. '1,2,3')
Type 'ALL' to use all available reservations.
ALL

Estimated on-chain fee:                   	112 sat
Service fee:                              	500 sat

CONTINUE SWAP? (y/n): y
Starting instant swap out
Instant out swap initiated with ID: b59f246c6a96e7775f8693561fe23926a6f13289251e9b4980c92b2a0f910272, State: WaitForSweeplessSweepConfirmed
Sweepless sweep tx id: b18a829161f1b05dd6f6a369e5a8f5d7530c451978e6907ce6b4387bb815c33c
```

To get a list of completed swaps, run `loop listinstantouts`

```
{
	"swaps":  [
    	{
        	"swap_hash":  "b59f246c6a96e7775f8693561fe23926a6f13289251e9b4980c92b2a0f910272",
        	"state":  "FinishedSweeplessSweep",
        	"amount":  "250000",
        	"reservation_ids":  [
            	"9f54c37bfa17766a35c48e810d7076842cc7e74f25fb60f2be954032e001f7cf"
        	],
        	"sweep_tx_id":  "b18a829161f1b05dd6f6a369e5a8f5d7530c451978e6907ce6b4387bb815c33c"
    	}
	]
}

```

[Running loop as part of litd? Read here on how to use the command line interface](../lightning-terminal/command-line-interface.md)
