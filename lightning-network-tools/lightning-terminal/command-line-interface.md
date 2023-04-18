---
description: >-
  litd can be accessed using the litcli, lncli, pool, loop and frcli command
  line interfaces (CLI).
---

# Command Line Interface

Litd comes with a command line interface litcli. This interface is primarily used to generate new sessions for Lightning Node Connect (LNC) and interact with LND Accounts. These tools can be used to connect remotely to your node, e.g. to Lightning Terminal or mobile wallets.

In addition, litd optionally bundles LND, Pool, Loop and Faraday with their command line interfaces. When compiling `litd`, by default, it doesn’t make `lncli`, `pool`, `loop` and `frcli`, as these might already be on your system. To specifically compile them, run make `go-install-cli` and refer to [our installation guide](get-lit.md).

These command line interfaces by default point at their standalone clients, so when using litd in integrated mode the arguments have to be slightly adjusted to allow proper communication  amongst the clients.

## Integrated mode <a href="#docs-internal-guid-8c53e272-7fff-5dd4-7b84-2b3bdfd4c6fb" id="docs-internal-guid-8c53e272-7fff-5dd4-7b84-2b3bdfd4c6fb"></a>

In integrated mode, litd, lnd, loopd, poold and faraday all run as part of the same binary.

**All of these services are exposed both via port 8443 and 10009, by default the TLS certificate can be found in `~/.lnd/tls.cert`**

This is done in order to make use of these tools as seen in the examples below:

### litcli <a href="#docs-internal-guid-bc066a10-7fff-c4e0-0c04-4a0c94ff2092" id="docs-internal-guid-bc066a10-7fff-c4e0-0c04-4a0c94ff2092"></a>

`litcli --tlscertpath ~/.lit/tls.cert sessions add --label="My LNC" --type admin`

By default, a pairing phrase created with litcli is valid for 3 months and is set to "readonly", meaning invoices cannot be paid or created and channels cannot be opened. You may extend this with the `--expiry <seconds>` and `--type` flags.

### lncli

`lncli getinfo`

In integrated mode, LND is available through the same port as when run as a standalone process. The TLS certificate is stored in its expected location as well, hence no modification to this cli call are necessary.

### loop

`loop --tlscertpath ~/.lnd/tls.cert --rpcserver=localhost:8443 terms in`

[Learn more: The Loop CLI](../loop/the-loop-cli.md)

### pool

`pool --tlscertpath ~/.lnd/tls.cert --rpcserver=localhost:8443 accounts list`

### frcli

`frcli --tlscertpath ~/.lnd/tls.cert --rpcserver=localhost:8443 insights`

[Learn more: The Faraday CLI](../faraday/the-faraday-cli.md)

### Remote mode <a href="#docs-internal-guid-5cf191c2-7fff-982c-9d69-6179b5c357da" id="docs-internal-guid-5cf191c2-7fff-982c-9d69-6179b5c357da"></a>

Remote mode refers to litd running on top of a LND node running in a separate process. This can be useful when adding litd to an existing production system, or when running a custom LND node.

**In remote mode, litd is available only over port 8443. The appropriate TLS certificate can be found in `~/.lit/tls.cert`**

It is possible to run any of the other processes, loopd, poold or faraday as standalone processes as well. In this case, their respective command line interfaces must point at the standalone client’s port and use the corresponding TLS certificate, rather than pointing at litd.

### litcli <a href="#docs-internal-guid-e71ea847-7fff-613f-9b3d-57ba32e413fa" id="docs-internal-guid-e71ea847-7fff-613f-9b3d-57ba32e413fa"></a>

`litcli --tlscertpath ~/.lit/tls.cert sessions add --label="My LNC" --type admin`

### loop

`loop --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 terms`

[Learn more: The Loop CLI](../loop/the-loop-cli.md)

### pool

`pool --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 orders`

### frcli

`frcli --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 insights`

[Learn more: The Faraday CLI](../faraday/the-faraday-cli.md)
