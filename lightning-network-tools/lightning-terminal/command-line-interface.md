---
description: >-
  litd can be accessed using the litcli, pool, loop and frcli command line
  interfaces (CLI).
---

# Command Line Interface

Starting with version 0.6, `litd` comes with a command line interface `litcli`. This interface is primarily used to generate new sessions for Lightning Node Connect, e.g. to connect to the web-based Lightning Terminal at terminal.lightning.engineering.\


In addition, litd optionally bundles the Pool, Loop and Faraday clients including their command line interfaces. To include these, install litd with the commands

`make go-install-cli`\
`make install`

Alternatively, Pool, Loop and Faraday can be installed separately, and their CLIs can be used to call the bundled binaries in litd. It is important to specify the correct port, as `litd` will run `poold`, `loopd` and `faraday` on a separate port, making it possible to run two instances of loop or pool simultaneously. The TLS path also needs to be specified. Alternatively the `tls.cert` can be copied from `.lit/tls.cert` to `.pool/mainnet`, `.loop/mainnet` and `.faraday/mainnet`

To make use of these tools as seen in the examples below:

## litcli <a href="#docs-internal-guid-50d3e658-7fff-9d98-fc94-56686082029b" id="docs-internal-guid-50d3e658-7fff-9d98-fc94-56686082029b"></a>

`litcli --lndtlscertpath ~/.lit/tls.cert sessions add --label="My LNC"` --expiry 7776000

By default, a pairing phrase created with `litcli` is valid for only 1h. You may extend this with the `--expiry <seconds>` flag.

## pool

`pool --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 orders`

[Read more about the pool CLI](../pool/accounts.md)

## loop

`loop --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 terms`

[Read more about the loop CLI](../loop/the-loop-cli.md)

## frcli

`frcli --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 insights`

[Read more about the Faraday CLI](../faraday/the-faraday-cli.md)
