---
description: Learn how to recover your funds in the event of a catastrophic failure.
---

# Disaster recovery

Use this guide as a last resort if you have lost access to your node or are unable to start LND due to a fatal error. Before using this guide, carefully examine your logs, [upgrade LND](run-lnd.md#part-4-upgrade-lnd) to the latest release and conduct a thorough analysis of the problem.

Following this guide will close all your channels. Your funds will become available on-chain with varying speed.

## **1. Recover as much data as you can**

The more data we have from our node, the more successful our recovery will be, and the more quickly we will be able to secure our funds on-chain.

* Seed phrase (aezeed)

The private key is an absolute must to recover any funds. Most commonly this key is derived from the aezeed seed phrase, but may also be recovered from the master private key found in the `wallet.db` file, together with the password used to encrypt it. Your seed phrase may have additionally been encrypted with a cipher seed phrase, which differs from your wallet password.

* Static channel backup (SCB)

The static channel backup is a protocol to close channels once a peer indicates to have suffered from a catastrophic failure. The channel.backup file in `.lnd/data/chain/bitcoin/mainnet` contains information about each of your peers, how to reach them and your channels. The SCB may also exist as individual text strings for each channel.

Once invoked, your node will ask your peers to send you their latest commitment transaction and force-close your channel, from which you can calculate your keys and sweep your funds.

* The most recent channel database

The `channel.db` file can be found in `.lnd/data/graph/mainnet` and contains all information about your channels, including your latest commitment transaction. Invoking this file as part of your recovery process can be risky if the channel.db is not up to date. Only use this file if you were able to recover it directly from your crashed node.

* Information about your channels from third parties

In some rare cases, especially with regard to old channels where both peers have suffered failures, we might be unable to close channels with the above tools. It might be useful to consult third-party tools such as [Lightning Network explorers](../../community-resources/resource-list.md#docs-internal-guid-c8a6648f-7fff-39eb-c8cc-47fadeadad71) to make sure we have closed all channels successfully.

If you still have access to it, you may make a backup of the entire `.lnd` directory.

## **2. Set up a new node**

To prepare for the recovery process, we will need to a LND node. Depending on the nature of our catastrophic failure, we may use the same node or set up a new node on a new machine.

If we are using the same node, don’t forget to move your old `.lnd` folder over somewhere else, so that we can start the recovery process with an empty directory.

In any other case, your old node should be turned off during the entire process and beyond.

[Read more: Get started with LND](run-lnd.md)

## **3. Begin the recovery process**

### **A) Initialize a new node**

We will begin the recovery process by initializing our new node. We begin with the command `lncli create` which will first prompt you for a password. This password must be at least eight characters long and can otherwise be freely chosen.

Next, lnd will offer us to enter a mnemonic seed, at which point we will provide the seed phrase (aezeed) from our old node. If your seed phrase was previously encrypted, we will also need to provide this cipher seed phrase.

Your node will now scan the bitcoin blockchain for eventual on-chain funds it can recover right away. This may take a while.

Once complete, you will be able to check your on-chain wallet balance with `lncli walletbalance`. You may move out your coins with `lncli sendcoins --sweepall <your bitcoin address>`

### **B) Static channel backup**

\-> Don’t have a SCB file for your node? Skip to the next step.

In this step, we will invoke the `channel.backup` file. Make sure your node is synced to chain and graph before continuing. You can check the latest status with the command `lncli getinfo`. We can place it in a separate directory and call it with the command `lncli restorechanbackup --multi_file /path/to/file/channel.backup`

Alternatively we can initiate the SCB for each channel manually with the command `lncli --single_backup <hex encoded channel backup>`

This will trigger your node to reach out to its former channel peers and ask them to force close your channels. The funds should arrive in your wallet quickly and be spendable immediately.

Not all of your channel peers will react immediately or be online at the time of your recovery, so it might be worth it to pause at this step and wait for a day or two.

If some channels do not close after this period, but you believe the peers are online, try to obtain their latest IP or onion address and connect to them manually.

### **C) Force-closing all other channels**

\-> Don’t have the channel database? Skip to the next step.

If any of our peers do not support SCB, are permanently unavailable or suffered from a catastrophic failure themselves, we will have to initiate the force-close transaction.

Using external tools such as [Chantools](https://github.com/guggero/chantools) we can publish the commitment transactions from our channel database ourselves. This can only be done if the `channels.db` file was recovered directly from the failed node. If our file is not the latest, there is a serious risk our commitment transactions can be invalidated by our channel peers, causing us to lose all funds in these channels.

You can find the documentation for Chantools [here](https://github.com/guggero/chantools). It also includes other neat tools that allow you to recover funds from channels that might have been force closed in your absence.

### **D) Manual intervention**

In some instances it may be of advantage to reach out to your channel partners directly and ask them to force close on you. Your peer might have left contact details on a Lightning Network explorer, chat bot or personal website. Consult the [Community Resources](../../community-resources/resource-list.md) for how to find these groups.

### **E) Secure your funds**

Once you have recovered your on-chain funds, don’t forget to sweep them to a separate wallet you control with the command `lncli sendcoins --sweepall <your bitcoin address>`

## **Additional tools**

You may also consult the following tools and resources as part of your node recovery:

[Guggero’s Chantools](https://github.com/guggero/chantools)

[Telegram Cheeserobot](https://t.me/cheeserobot)

[Zombie Channel Recovery Matcher](https://node-recovery.com/)
