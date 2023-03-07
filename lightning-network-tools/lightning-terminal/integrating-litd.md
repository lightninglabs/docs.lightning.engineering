---
description: >-
  Move your LND, Loop, Pool and litd all into a single binary: litd in
  integrated mode.
---

# Integrating litd

Litd is most conveniently run in integrated mode, meaning litd, LND, Loop, Pool and Faraday are bundled into a single binary, simplifying the process of starting, stopping and upgrading all your Lightning Labs tools.

Whether you have only recently begun running litd or are still considering adding litd to your node, integrating litd is easy and convenient.

## Evaluate

First, consider your current node software stack. You are running LND, but are you also running litd, Loop, Pool and Faraday? Would you like to integrate all of these, or only some?

Not integrating a specific service makes sense when you are running custom code or pre-release software, or simply would like to have more granular control over when to upgrade each service.

If you are running pre-release software, please make sure you are not downgrading LND or any other service, as this might cause problems. You can see which software is bundled with the [latest release of litd here](https://github.com/lightninglabs/lightning-terminal/releases).

## Integrate <a href="#docs-internal-guid-2cf588aa-7fff-7efe-87ec-169e58d93b55" id="docs-internal-guid-2cf588aa-7fff-7efe-87ec-169e58d93b55"></a>

To integrate a service, simply stop litd and the process in question. If you are integrating LND, please stop all processes.

Next, [configure litd](run-litd.md) to integrate the service, for example by setting `lnd-mode=integrated` in your `lit.conf` file, or by passing it as `--lnd-mode=integrated` at startup. If your .lnd directory, macaroon and TLS certificate are in a non-standard location, don’t forget to specify this as well.

Finally, start litd with the command `litd`. This command should start litd and all processes set to integrated mode. All remote processes will have to be started separately.

## Interact with your integrated litd <a href="#docs-internal-guid-8e5f5ed1-7fff-6736-8f08-77e9dadc2d2c" id="docs-internal-guid-8e5f5ed1-7fff-6736-8f08-77e9dadc2d2c"></a>

When integrating LND, the service will remain reachable with the same macaroon at the usual port, meaning no adjustments are necessary.

The Loop, Pool and Faraday processes are reachable inside litd at a new port and the LND TLS certificate.

[Read more: litd Command Line Interface](command-line-interface.md)

## Remote <a href="#docs-internal-guid-2f4a97ee-7fff-b357-6e75-2740fa5c850e" id="docs-internal-guid-2f4a97ee-7fff-b357-6e75-2740fa5c850e"></a>

It is always possible to go back to remote mode for any of the integrated services. To do this, simply stop the litd process, change its configuration and start the remote services separately before restarting litd in remote mode.
