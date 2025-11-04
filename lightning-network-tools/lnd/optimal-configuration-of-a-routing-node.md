---
description: >-
  Understand the parameters of your LND configuration to optimize your node for
  routing payments
---

# Configuration of a Routing Node

Every Lightning routing node is different, but many share a common goal: To reliably serve their peers and maximize profits from deployed capital.

LND ships with sensible defaults, optimized for security and reliability. However, you might operate under different assumptions or want to make different trade-offs. This guide aims to help you understand various configurations in order to make the best decisions for your node and your peers.

Unless otherwise stated, the below configuration options are highlighted with their default values.

## Hardware and network <a href="#docs-internal-guid-aaf6ad01-7fff-66f0-2a47-ffe8f9f7f8a5" id="docs-internal-guid-aaf6ad01-7fff-66f0-2a47-ffe8f9f7f8a5"></a>

A performant routing node will run on hardware significantly above the [recommended minimum requirements](run-lnd.md#docs-internal-guid-b519fc5f-7fff-49d2-4038-dbcc3e23af33). It is always available, meaning it has continuous power and a reliable internet connection. Monitor the uptime of your own node to identify resource bottlenecks or unreliable connectivity.

It can be of advantage to separate the operating system, Bitcoin data and LND data into separate partitions, or entirely separate SSDs. You may also consider RAID for sensitive data, for example the \~/.lnd directory. Redundancy will help keep your node available during hardware outages or necessary Blockchain rescans.

## Bitcoin

You can typically find your `bitcoin.conf` file in `~/.bitcoin`

A routing node will not aggressively prune their Bitcoin backend. They might consider indexing the Blockchain to be able to look up transactions faster. In some situations it might be useful to have a larger mempool, but this can also be adjusted when the need arises. Even if your Lightning Network node runs on clearnet, you may put your Bitcoin backend behind Tor and not listen to incoming connections.

`txindex=1 # (default: 0)`\
`listen=0 # (default: 1)`\
`onlynet=onion # (default: any)`\
`proxy=127.0.0.1:9050`\
`maxmempool=300`

## Tor

The Tor network is widely popular among node operators. It removes the requirement to broadcast your personal IP address and can significantly reduce the attack surface of your node. It also makes it easy to make a node reachable behind NAT.

Privacy concerns aside, it helps being reachable both via Tor and clearnet as well as being able to connect outwards through either network. This is commonly referred to as “[hybrid mode](quick-tor-setup.md)” and maximizes availability across networks while limiting latency.

`lnd.tor.skip-proxy-for-clearnet-targets=true # (default: false)`

## LND

Your `lnd.conf` file should be located in `~/.lnd`. If you are using `litd` in integrated mode, all of the configurations below have to be added to your `lit.conf` file in `~/.lit`, prefixed with `lnd.`. For example instead of `listen=:9735`, you have to add `lnd.listen=:9735`

### Incoming and outgoing connections <a href="#docs-internal-guid-ba20da56-7fff-f3b6-ea61-1ad3dc7f01ad" id="docs-internal-guid-ba20da56-7fff-f3b6-ea61-1ad3dc7f01ad"></a>

Your node will listen to incoming connections over Tor and clearnet. If you have the option to enable IPv6 this may further extend your reach and make it easier for nodes to connect to you.

`listen=:9735`\
`externalip=<your IPv6>`\
`externalip=<your IPv4>`

The stagger flag will limit the amount of connections your node attempts at the same time upon restart. The node will connect to 10 peers at first, and then wait between 0s and 30s before connecting to others. This helps preserve bandwidth and resources when restarting a node with a large number of peers.

`stagger-initial-reconnect=true # (default: false)`

### Channel defaults

In the context of fees we are concerned about both onchain fees, which we will have to pay for sweeps, channel open and closes as well as Lightning Network fees, which you will charge to others for your provision of liquidity. Your default fees should be high enough so liquidity is not underpriced when a new channel is opened.

`bitcoin.basefee=1000`\
`bitcoin.feerate=2000 # (default: 1)`

The cornerstone of routing payments are [Hash Timelock Contracts (HTLCs)](../../the-lightning-network/multihop-payments/hash-time-lock-contract-htlc.md). Each HTLC carries with it the risk of a channel closure, so it might make sense to adjust the minimum HTLC size that you are willing to forward in addition to the base fee.

`bitcoin.minhtlc=1`\
`bitcoin.minhtlcout=1000`

You may also adjust the time lock delta upwards. A timelock delta of 144 for example allows you up to 24h to resolve issues related to your node before HTLCs are resolved on chain. Allowing for fewer HTLCs per channel can mitigate the potential fallout of a force closure, but can also cause the channel to be unusable when all HTLC slots are used up.

`bitcoin.timelockdelta=144 # (default: 80)`\
`default-remote-max-htlcs=483`

You can also set other defaults relevant to channels, such as a minimum channel size or how many confirmations to require before accepting an incoming channel. The maximum CLTV expiry defines how long you maximally have to wait before you get your funds back in the event of your node force closing a channel.

`maxpendingchannels=1`\
`bitcoin.defaultchanconfs=[3; 6]`\
`minchansize=1000000 # (default: 20000)`\
`protocol.wumbo-channels=true # (default: false)`\
`max-cltv-expiry=2016`

Increasing the payments expiration grace period will allow for longer time to wait for pending HTLCs to be settled before a channel is closed.

`payments-expiration-grace-period=1h # (default: 0s)`

### Database configuration

LND requires a database to store information about transactions, invoices, channels, macaroons and all kinds of other information to operate safely. By default, LND runs with bbolt. In the future, SQLite will take over as the default. Both are embedded databases, meaning they do not need additional software or configuration, but work out of the box as part of LND and can be migrated easily.

LND Databases:

* bbolt\*
* etcd\*
* **SQLite**
* **Postgres**

Backends marked with (\*) will be phased out with future versions. Migration scripts will be made available to help migrate data from legacy backends (bbolt/etcd) for the existing nodes.

Default:

`db.backend=bolt`

Alternative options:

`db.backend=etcd`

`db.backend=postgres`

`db.backend=sqlite`

LND users with SQLite or Postgres backends can enable a performance-enhancing "native SQL schema" via configuration. This option was available for new nodes since v0.18.0, and existing nodes can be configured to use it starting with v0.19.0.

`db.use-native-sql=true`

### Database migration

In the context of LND’s development path, database migrations have two components. First, the move backend from bbolt/etcd to SQLite/Postgres. Second, the move from kvdb to native SQL data structures.

#### Move backend

The switch to SQLite/Postgres is made possible with the lndinit [migration script](https://github.com/lightninglabs/lndinit/blob/main/docs/data-migration.md). This tool migrates LND bbolt databases to either SQLite or Postgres, preserving the key-value (kvdb) data structure. Use this tool if you are looking to migrate your LND backend from bbolt to SQLite.

{% hint style="info" %}
Migrating to Postgres using this tool is currently not recommended. The key-value schema can lead to poor performance in Postgres, especially for older nodes with large amounts of Payment and Invoice data. Performance issues on Postgres will be addressed in future releases with additional data store migration to native SQL schema.
{% endhint %}

If you have migrated to Postgres and would like to optimize performance, have a look at [these config recommendations](https://gist.github.com/djkazic/526fa3e032aea9578997f88b45b91fb9).

#### Move to native SQL data structure

Starting with version 0.19, LND will perform automatic migrations from kvdb to native SQL for users on SQLite/Postgres backend. The migration process will create tables in the backend and move the data from the existing kv schema to the new tables at startup time.

To trigger this migration, simply set `db.use-native-sql=true` and restart your node. This migration can be abandoned by setting `db.skip-native-sql-migration=true` but this option should only be set if you are encountering errors during the migration process.

### Rebalancing

While rebalancing is not strictly necessary for a competitive routing node, it can be useful to push liquidity in or out of certain channels that way, especially when the potential earnings on that channel are higher than the cost to rebalance.

To rebalance channels, you will need to allow circular routes, meaning your node has to be allowed to pay itself.

`allow-circular-route=true # (default: false)`

If your node is primarily conducting payments for the purpose of rebalancing, it can also make sense to adjust the Router RPC settings. This will lower your chance of finding a path quickly, but increase your chance of finding a cheap route eventually.

`routerrpc.attemptcost=100`\
`routerrpc.attemptcostppm=1000`

`routerrpc.apriori.hopprob=0.6`\
`routerrpc.apriori.weight=0.5`\
`routerrpc.apriori.penaltyhalflife=1h`\
`routerrpc.apriori.capacityfraction=0.9999`

### Routing

This option will prune a channel from the graph if only a single edge marked the channel as inactive, allowing for a more compact channel graph.

`routing.strictgraphpruning=true # (default: false)`\
`ignore-historical-gossip-filters=true # (default: false)`

### High fee environment

When performing in a high fee environment, these settings may help reduce the overall burden. Instead of selecting UTXOs at random, you may instruct LND to choose the largest UTXOs instead, reducing the potential number of signatures required. This may require a manual consolidation of UTXOs when fees have subsided.

`coin-selection-strategy=largest # (default: random)`

Setting the fee estimate mode to economical and increasing the target confirmations for onchain transactions can also help save on fees, but with the risk that some transactions may not confirm in time, requiring more manual monitoring and eventual intervention.

`bitcoind.estimatemode=ECONOMICAL # (default: CONSERVATIVE)`\
`coop-close-target-confs=1000`

On the other hand, increasing your commit fee for anchor channels can help get these transactions propagated. While it is always possible to bump the transaction fees of such commitment transactions later using CPFP, a low maximum commit fee may prevent these transactions from being propagated in the first place.

`max-commit-fee-rate-anchors=100 # (default: 10)`

The maximum percentage of total funds in a channel that is allocated to fees can also be adjusted.

`max-channel-fee-allocation=0.5`

Increasing the batch window and lowering the fee rate for sweeps can also help lower fees.

`sweeper.batchwindowduration=30s`\
`sweeper.maxfeerate=1000`

### Node management

Your choice of a database matters. While Bolt, the default, may not be slower than other options, it is significantly slower to start up, meaning your node can be restarted much quicker with a postgres or etcd backend.

`db.backend=postgres # (default: bolt)`

When running Bolt, it may make sense to compress the database regularly. You can also define how frequently this process should take place, for example not more than once every 168h.

`db.bolt.auto-compact=true # (default: false)`\
`db.bolt.auto-compact-min-age=168h`

Canceled invoices can also be deleted on startup or on the fly to increase performance.

`gc-canceled-invoices-on-startup=true # (default: false)`\
`gc-canceled-invoices-on-the-fly=true # (default: false)`

Increasing the block cache will consume resources, but also result in better performance as more blocks are cached and not requested again.

`blockcachesize=20971520`

### Communication

Node runners may notify each other of issues they see when opening channels or forwarding payments. To be able to receive keysend messages, the following must be set.

`accept-keysend=true # (default: false)`\
`accept-amp=true # (default: false)`

### Lightning Terminal

Lightning Terminal gives visual insights into your earnings and activity. It also offers tools that can help with managing a routing node, such as Autofees, Loop and Pool. For Terminal to be able to run, you will need to allow it to intercept RPC calls to your LND node.

`rpcmiddleware.enable=true # (default: false)`

### Pool

To make use of [zero confirmation channels](../pool/zero-confirmation-channels.md), you will need to set the following in your LND configuration. This will enable zero-confirmation channels only when these channels were purchased or sold through Lightning Pool or manually accepted through the channel acceptor middleware.

`protocol.option-scid-alias=true # (default: false)`\
`protocol.zero-conf=true # (default: false)`

## Content Delivery Networks

Content Delivery Networks (CDNs) have paid infrastructure in place that can detect and mitigate even the most powerful DDoS attacks. To configure your node with a CDN, you will need to configure it with a domain name instead of an IP address.

You will also need to add your domain name to the TLS certificate and instruct LND to advertise a domain name instead of an IP address. If you have previously advertised your IP address, it might be necessary to change that or otherwise restrict traffic.

Please note that not all CDNs will offer this feature for non HTTPS data or non-standard ports by default.

`tlsextradomain=my-node-domain.com`\
`externalhosts=my-node-domain.com`

### Cloud server infrastructure

Many cloud service providers include some basic DDoS protection in their products, or offer them at an extra cost. Similar to CDNs this can be a worthwhile tactic of protecting your node. Do read the fineprint, as protection levels and policies differ. Some providers for example might disable access to your instance completely once they detect a DDoS attack.

### During an attack

While experiencing a sudden large amount of traffic to your node, you may close your ports or even change IP address. You may only remain reachable via the Tor network, or not at all. Unless the entire network or your peers are under attack, you will still be able to make outgoing connections and keep your channels active.

Qdisc is a linux traffic control, or network scheduling utility in Linux. It is enabled on many distributions by default and can help mitigate some DDoS attacks.

`sudo tc qdisc replace dev wg0 root cake bandwidth 300mbit nat`

## Node management tools

Node operators may make use of additional tools to monitor their node, manage liquidity, open and close channels as well as adjust channel fees.

### Lightning Terminal

Lightning Terminal is a tool suite developed by Lightning Labs. The web interface communicates with your node through an end-to-end encrypted connection with your node. Terminal gives you an easy overview over your recent forwards, fees and balances. It allows you to [adjust fees programmatically](../lightning-terminal/autofees.md), make use of Lightning Loop for liquidity management, buy and sell channels through Lightning Pool and find peers.

[Read more: How to connect to Lightning Terminal](../lightning-terminal/get-lit.md)

### Bos

[Balance of Satoshis](https://github.com/alexbosworth/balanceofsatoshis) makes many LND features more accessible and can be used to open balanced channels, make probes, create alerts and rebalance channels.

### LNDg

[LNDg](https://github.com/cryptosharks131/lndg) is a GUI to analyze LND data and automate tasks such as rebalancing channels.

## LND 0.19.2

If you are observing fluctuations in your peer count, otherwise stable peers repeatedly disconnecting or connecting or excessive bandwidth usage, you may experience an issue in how gossip messages are handled.

You may reconfigure the following values in your `lnd.conf`:\
`gossip.msg-rate-bytes=524288`\
`gossip.msg-burst-bytes=1048576`\
`num-restricted-slots=200`

[To understand gossip rate limiting better you may refer to this in-depth guide.](https://github.com/Roasbeef/lnd/blob/c9afe0058541cb7a270176e6ec85daab8bd4674f/docs/gossip_rate_limiting.md)\
Details can also be found in [pull request 10096](https://github.com/lightningnetwork/lnd/pull/10096) and [10097](https://github.com/lightningnetwork/lnd/pull/10097).
