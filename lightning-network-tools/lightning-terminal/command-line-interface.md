---
description: >-
  litd can be accessed using the litcli, lncli, pool, loop and frcli command
  line interfaces (CLI).
---

# Command Line Interface

Litd comes with a command line interface litcli. This interface is primarily used to generate new sessions for Lightning Node Connect (LNC) and interact with LND Accounts. These tools can be used to connect remotely to your node, e.g. to Lightning Terminal or mobile wallets.

In addition, litd optionally bundles LND, Pool, Loop and Faraday with their command line interfaces. When compiling `litd`, by default, it doesn’t make `lncli`, `pool`, `loop` and `frcli`, as these might already be on your system. To specifically compile them, run make `go-install-cli` and refer to [our installation guide](get-lit.md).

These command line interfaces by default point at their standalone clients, so when using litd in integrated mode the arguments have to be slightly adjusted to allow proper communication  amongst the clients.

## Lightning Terminal <a href="#docs-internal-guid-8c53e272-7fff-5dd4-7b84-2b3bdfd4c6fb" id="docs-internal-guid-8c53e272-7fff-5dd4-7b84-2b3bdfd4c6fb"></a>

In remote mode, `litd`, `loopd`, `poold`, `faraday` and `tapd` are run as part of the same binary by default, although each daemon may be run separately, or _remote_.

### litcli <a href="#docs-internal-guid-bc066a10-7fff-c4e0-0c04-4a0c94ff2092" id="docs-internal-guid-bc066a10-7fff-c4e0-0c04-4a0c94ff2092"></a>

`litcli sessions add --label="My LNC" --type admin`

By default, a pairing phrase created with litcli is valid for 3 months and is set to "readonly", meaning invoices cannot be paid or created and channels cannot be opened. You may extend this with the `--expiry <seconds>` and `--type` flags.

## Integrated mode

In integrated mode, all binaries including LND are run as one. **All of these services are exposed both via port 8443 and 10009, by default the TLS certificate can be found in `~/.lit/tls.cert`**

In some cases this certificate path has to be specified for the connection to succeed.

### loop

`loop --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 terms in`

[Learn more: The Loop CLI](../loop/the-loop-cli.md)

### pool

`pool --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 accounts list`

### frcli

`frcli --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 insights`

[Learn more: The Faraday CLI](../faraday/the-faraday-cli.md)

### lncli

`lncli getinfo`

In integrated mode, LND is available through the same port as when run as a standalone process. The TLS certificate is stored in its expected location as well, hence no modification to this cli call are necessary.
