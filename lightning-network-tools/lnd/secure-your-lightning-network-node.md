---
description: >-
  Learn what best practices to follow to make sure nobody is gaining
  unauthorized access to your Lightning Node and satoshis or lose funds in
  accidents.
---

# Secure Your Lightning Network Node

Your Lightning Network node holds a range of cryptographic keys that need to be guarded against error, loss and theft. As a node operator you are solely responsible for your own funds. To guard against any kind of loss or compromise of your Lightning node you will have to take a multi-layered approach considering a variety of risks and strategies.

## Your device

If your Lightning node is set up on a physical device you control, be mindful of who could gain access to its physical interfaces. If you rented a dedicated server or provisioned a virtual private server, inform yourself about the trustworthiness of the provider, their security policies and track record. You may for example check how your account can be secured and whether hidden administration panels exist that may need to be disabled or locked down separately.

Similarly, all your personal devices that contain Bitcoin wallets, ssh keys or authentication tokens need to be secured as well and accounted for in your threat model.

## Your platform

Your device’s operating system needs to be actively maintained and regularly updated. This includes all services and third-party code that may be used to operate your system, such as OpenSSH.

Use a firewall to limit exposure to your platform and the services running on it. To open port 9735 is not required, but recommended to accept incoming connections and inbound channels. REST and RPC (default ports 8080 and 10009) only need to be exposed when required by an external application you configured.

You may consider making some endpoints only available inside trusted networks, or connect to your node only via SSH or a VPN. Configure your platform to only use keys for authentication, not passwords.

## Your LND

When installing LND, verify the authenticity of the binaries or source code using PGP and git verify-tag as well as that of all dependencies, such as Go.

Just like the operating system of your node and personal device, lnd will need to be regularly updated. You may check the [latest releases on Github](https://github.com/lightningnetwork/lnd/releases), check for announcements on the [blog](https://lightning.engineering/blog/) or follow Lightning Labs on [Twitter](https://twitter.com/lightning) to not miss important security announcements.

How you update your LND will depend on how you installed it. You may for example replace the binary on your machine with its latest version, or run the following commands in your lnd git directory when updating from source:

`git pull`\
`make clean && make && make install tags="autopilotrpc chainrpc invoicesrpc routerrpc signrpc walletrpc watchtowerrpc wtclientrpc"`

## Your wallet <a href="#docs-internal-guid-4d50a2e2-7fff-6a56-4160-813804306ee7" id="docs-internal-guid-4d50a2e2-7fff-6a56-4160-813804306ee7"></a>

When creating your wallet with `lncli create`, you are given a 24 word long "aezeed" seed phrase. Similar to a BIP39 seed phrase, it can be used to recover your on-chain Bitcoin, meaning that if it falls into the wrong hands your bitcoin are at risk of being taken. Similarly, if you are not in possession of this seed phrase yourself, you may not be able to regain control over your funds in the event of an error.

You may write your seed phrase, in its correct order, on a piece of paper and store it somewhere securely. Alternatively, you may store it in encrypted storage elsewhere, such as your password manager.

Never run two separate LND nodes with the same seed!

Your private key is contained in your node's `wallet.db`. This wallet database and the macaroon database are encrypted with the password chosen when initializing the wallet using `lncli create`. If you lose your wallet password, you may recreate the wallet and macaroon database using the seed.

## Your macaroons

Your node uses macaroons to authenticate API calls, including from `lncli`. Make sure your macaroons can only be accessed by authorized applications. To invalidate a macaroon, it is not enough to delete it. Instead, the `macaroons.db` has to be deleted in its entirety. A specific macaroon can be invalidated using `lncli deletemacaroonid` and its macaroon ID.

## Your channels <a href="#docs-internal-guid-8725c728-7fff-9b34-f746-fcdc7a49c5e5" id="docs-internal-guid-8725c728-7fff-9b34-f746-fcdc7a49c5e5"></a>

In the event that your hard drive becomes corrupted or the entire device destroyed or deleted, you may recover your on-chain funds using the seed phrase above. Your channels however can’t be backed up directly, though a mechanism exists to recover them separately from your on-chain funds.

You can typically find your channel backups in the file `~/.lnd/data/chain/bitcoin/mainnet/channel.backup`

This file is changed every time a channel is opened or closed. You may set up a script that [backs up this file whenever it is changed](https://gist.github.com/alexbosworth/2c5e185aedbdac45a03655b709e255a3), or copy it manually. It is necessary to back up this file whenever a new channel has been opened. Invoking the `channel.backup` initiates a force close by your remote peers.

The `channel.db` file is not suitable for backups. Keeping an up-to-date backup of this file is close to impossible, and you may lose your funds when recovering from an outdated `channel.db` file. This file can only be used when migrating your node, not when restoring.

## Operational safety <a href="#docs-internal-guid-f7878f4c-7fff-d8de-f925-4704b4d0790e" id="docs-internal-guid-f7878f4c-7fff-d8de-f925-4704b4d0790e"></a>

When operating your node, it is important to note that you not interrupt lncli commands that alter the channel.db file, such as:

`openchannel`\
`closechannel` and `closeallchannels`

`abandonchannel`\
`updatechanpolicy`\
`restorechanbackup`

To safely shut down your Lightning Node, use the command `lncli stop`

## Your external applications <a href="#docs-internal-guid-fb6b5911-7fff-e340-f874-86a51944a08c" id="docs-internal-guid-fb6b5911-7fff-e340-f874-86a51944a08c"></a>

LND uses macaroons to authenticate external applications. These may be applications running on the same machine as LND or externally.

By default you will see the `admin.macaroon`, `invoice.macaroon`, `readonly.macaroon` and `router.macaroon` files in your `<lnddir>/data/chain/bitcoin/mainnet/` directory. They each have their own permissions, and you may create your own macaroons with specific purposes. Only share these macaroons with applications on devices you trust.

To recreate macaroons you may delete all of the macaroon files and restart LND. However, this will NOT invalidate old macaroons. To invalidate old macaroons, you will have to delete the `macaroon.db` file as well before restarting LND.
