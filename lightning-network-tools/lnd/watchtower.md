---
description: >-
  Learn how to setup a watchtower, either as a client or as a server, to watch
  over your own or another node.
---

# Configuring Watchtowers

A [watchtower](../../the-lightning-network/payment-channels/watchtowers.md) is a feature of a Lightning node that allows you to watch a node for potential [channel breaches](../../the-lightning-network/payment-channels/lifecycle-of-a-payment-channel.md) (the watchtower server). This functionality comes bundled in LND, but needs to be specifically enabled. Two nodes can act as each other’s watchtowers, meaning they simultaneously operate in server and client mode.

The watchtowers discussed here are altruistic, meaning there is no compensation or other incentive for these watchtowers to serve your node.

Ideally, such a watchtower is provided by yourself, on a separate machine, network and location from your own node to protect yourself against channel breaches that may occur while your node is offline for any reason.

## Run a watchtower <a href="#docs-internal-guid-fea1c39e-7fff-cb2c-63e0-b509c35d891c" id="docs-internal-guid-fea1c39e-7fff-cb2c-63e0-b509c35d891c"></a>

To run a watchtower, you will have to enable its server functionality. This is done by adding the following to your `lnd.conf` configuration file:

`watchtower.active=1`

Once you have restarted your node, you should be able to see your watchtower’s information with:

`lncli tower info`

Your watchtower has its own public key. If you have [configured Tor](quick-tor-setup.md), the command above will also return your tower’s unique onion. If the above command cannot be found (No help topic for 'tower'), you may have to make sure LND is [compiled](run-lnd.md) with the `watchtowerrpc` flag.

```
{
"pubkey": "02f1158dd65fb7dad3d8274e39edcb8c03ff639365884ced2f143372b5fb050bc1",
"listeners": [
     "[::]:9911"
],
"uris": [   "02f1158dd65fb7dad3d8274e39edcb8c03ff639365884ced2f143372b5fb050bc1@ddoi7crm7rhj2eyztcsv6iprclrxhmsquhaswef3xphhu2fin726w7ad.onion:9911"
]
}
```

## Connect your node to a watchtower <a href="#docs-internal-guid-fe75e876-7fff-0569-2962-e0636fcb66c2" id="docs-internal-guid-fe75e876-7fff-0569-2962-e0636fcb66c2"></a>

To connect to a watchtower, you will have to enable the client functionality. This can be done by adding the following to your `lnd.conf` configuration file:

`wtclient.active=1`

Once you have restarted your LND node, you may add a watchtower with the following command:

`lncli wtclient add 02f1158dd65fb7dad3d8274e39edcb8c03ff639365884ced2f143372b5fb050bc1@ddoi7crm7rhj2eyztcsv6iprclrxhmsquhaswef3xphhu2fin726w7ad.onion:9911`

\
Using the wtclient commands you can also list your watchtowers, remove them or display stats or your watchtowers policy.

`lncli wtclient add`

`lncli wtclient remove`

`lncli wtclient towers`

`lncli wtclient tower`

`lncli wtclient stats`

`lncli wtclient policy`

The sweep fee is expressed in satoshi per vByte and can be changed by adding or editing the following in your configuration file:

`wtclient.sweep-fee-rate=10`
