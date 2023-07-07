---
description: >-
  Lightning Node Connect (LNC) lets you connect applications to your node by
  only passing on an eight word connection phrase, even if your node is behind a
  NAT or Tor.
---

# LNC Backend

From version 0.2 aperture supports connecting to its LND backend over LNC, allowing you to connect to your personal node without the need to open ports or configuring Tor or NAT.

This configuration is different than configuring the [LNC Mailbox](mailbox.md), though both may be configured at the same time.

## Create an LNC pairing phrase <a href="#docs-internal-guid-a24df49a-7fff-3fb2-349f-bd877f7028c0" id="docs-internal-guid-a24df49a-7fff-3fb2-349f-bd877f7028c0"></a>

[You can create a pairing phrase using the Lightning Terminal UI or the command line.](../lightning-terminal/connect.md)

## Configure Aperture <a href="#docs-internal-guid-d81cd037-7fff-d310-921e-9e435d777d57" id="docs-internal-guid-d81cd037-7fff-d310-921e-9e435d777d57"></a>

To configure Aperture, you will need to edit or create the configuration file in `~/.aperture/aperture.yaml`

The relevant section should look like this:

```yaml
# The address which the proxy can be reached at.
listenaddr: "localhost:8080"

# Settings for the lnd node used to generate payment requests. All of these
# options are required.
authenticator:
  passphrase: "your pairing phrase"
  mailboxaddress: "mailbox.terminal.lightning.today:443"
  network: "mainnet"
  devserver: false

# The selected database backend. The current default backend is "sqlite".
# Aperture also has support for postgres and etcd.
dbbackend: "sqlite"
```

At the time of writing, Aperture over LNC only works with the default database backend sqlite.

## Run Aperture

You should be able to run aperture with `aperture`.
