---
description: Learn how to move your Lightning node to a new machine.
---

# Migrating LND

Use this guide if you want to move your node to a different machine or location.

### When NOT to migrate LND

Do NOT use this guide if you have experienced a fatal error.

Do NOT run two LND instances with the same seed or public key.

[Read: LND disaster recovery](disaster-recovery.md)

## When to migrate LND

There are lots of reasons why you might want to migrate your Lightning Node. You might be changing your host, move from a VPS to a personal physical server or just prefer to run LND in a different way. Migrating LND is a relatively straightforward and easy process that should not take long.

If you have experienced a fatal error and would like to recover your Lightning node, do not use this guide. Regardless, it is good to read the article “[Planning for failure](recovery-planning-for-failure.md)” to learn how to best prepare for any recovery scenarios.

Read through this entire document before you begin your migration.

## Prepare your new machine

It is not advised to migrate between different operating systems, as the file structures might differ in small, but important ways. This is especially true when migrating from or to a Windows machine. This is also true between different chip architectures. Before we begin the actual migration process, we must prepare our new machine. This will include:

* Updating and [hardening](secure-your-lightning-network-node.md) your device
* Installing and syncing your choice of Bitcoin node, unless you use Neutrino
* Install and set up Tor, if desired
* [Install LND](get-started-with-lnd.md)
* Install auxiliary services, such as [Loop](../loop/), [Pool](../pool/) or [Faraday](../faraday/)

## Migrating LND

To begin our migration, we first shut down our old LND node gracefully. Use the command `lncli stop` and wait for the process to shut down completely, for example by observing the logs.

Unless otherwise specified in your `lnd.conf` file \(check if unsure\), all the data necessary for your migration is in your `~/.lnd` directory.

To continue the migration, you should move all data from this directory to the new machine in the same location. Alternatively, the directory can be specified at startup with the flag `--lnddir=`

Logs and the data directory can also be split up, either by defining them in the configuration file, or at startup with `--datdir=` and `--logdir=`

## Checking your configuration file

Now that you are running LND on a different machine, some variables might have changed and need to be amended for LND to smoothly connect. Some areas of concern/for review are:

* Bitcoin RPC. You might connect to a different Bitcoin node with a new host, username or password
* Bitcoin ZMQ. Easy to overlook!
* If you are using Tor, the Socks proxy or control port and password might have changed
* Your Lightning node might have a new IP, domain or onion that will require a new TLS certificate

## Delete your TLS certificates

Unless your node’s IP address, domain or onion address will not change, you will need to delete your TLS certificates and key found in the `~/.lnd` directory. This will regenerate them when you first start up your migrated node. You may also delete your macaroon files together with the `macaroon.db` in `~/.lnd/data/chain/bitcoin/mainnet` to make sure any old copies are invalidated. Deleting the macaroon files alone does not invalidate them.

## Start LND

To complete our migration, we will start up LND and unlock our wallet with the usual password. You may observe your logs and verify that all channels and funds are present with `lncli getinfo`, `lncli walletbalance` and `lncli channelbalance`.

Once you successfully start LND on your new machine, delete the lnd directory on the old platform. Under no circumstances should two nodes with the same public key be run at the same time, as this will cause your channels to close and its funds possibly forfeited.

