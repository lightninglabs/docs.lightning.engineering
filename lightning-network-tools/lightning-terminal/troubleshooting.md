---
description: >-
  In the event that you may run into issues with Lightning Terminal or one of
  its bundled products, you may refer to this page.
---

# Troubleshooting

Unable to find what you are looking for? Contact the team on [Slack](https://lightning.engineering/slack.html) for help!

## Unable to connect <a href="#docs-internal-guid-d0ac868a-7fff-0e26-52e4-c5cfe3f7199e" id="docs-internal-guid-d0ac868a-7fff-0e26-52e4-c5cfe3f7199e"></a>

In case you are unable to connect to your node, especially after your browser having been idle for a while or recently having been restarted, you may:

* Attempt to reload the page asking for your password
* Click on “use a pairing phrase,” then reload the page and attempt again
* [Generate a new pairing phrase](run-litd.md#connect-to-lightning-terminal), delete the browser cache, reload the page and connect again
* Delete the `session.db` in `~/.lit/mainnet`, restart `litd` and generate a new pairing phrase

## Pool account is not synced

In case you find yourself unable to connect to Pool due to a synchronization error, you may:

* Shut down `litd` with `kill -s INT $(pidof litd)`
* Remove or rename your `pool.db`
* [Start](get-lit.md#docs-internal-guid-ae172929-7fff-f9d0-7921-e6f8acc92f53) `litd`
* Run the Pool account recovery as below (NOTE that this will cancel any active orders. After recovering the account, the orders can be re-created manually).\


You can generally find your `pool.db` file in `~/.pool/mainnet`

In Umbrel: `~/.pool/mainnet/`

In BTCPay Server: `/var/lib/docker/volumes/generated_lnd_lit_1/_data` or `/root/.pool/mainnet`

## Pool account recovery

In case Lightning Terminal has been improperly deleted or is otherwise corrupted, you may recover your funds using pool accounts recover.

Depending on your installation, you may need to call this command with additional arguments:

`pool --tlscertpath ~/.lit/tls.cert --rpcserver=localhost:8443 accounts recover`

**Umbrel**: \
Find the docker process (lightning-terminal) with `docker ps`\
``Open the pool container with `docker exec -it 340a5b0839f1 /bin/bash`\
`Recover the account: pool --tlscertpath "/data/.lit/tls.cert" --rpcserver localhost:8443 --macaroonpath "/data/.pool/mainnet/pool.macaroon" accounts recover`

**BTCPay**:\
\
`cd btcpayserver-docker`

pool `--rpcserver=localhost:8443 --macaroonpath /root/.pool/mainnet/pool.macaroon --tlscertpath /root/.lit/tls.cert accounts recover`

[Read more about Pool Accounts Recovery](../pool/account\_recovery.md)
