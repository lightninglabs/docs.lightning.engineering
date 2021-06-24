---
description: '"That''s planning for failure, Morty. Even dumber than regular planning."'
---

# Recovery: Planning for failure

In order to achieve near-instant and cheap Bitcoin payments, the Lightning Network makes some tradeoffs in comparison to the Bitcoin base layer. One of those tradeoffs is that its security model is more complex. 

To protect yourself from loss of funds or significant downtime, it is important to plan ahead for the unexpected.

## Threat modelling

In this article, our goal is to protect ourselves mainly from loss of funds due to our node failing. We want to be able to recover quickly from such incidents and get back on the Lightning Network with minimal effort.

There are a variety of threats we want to consider, but our strategy will be similar. We might fear that our cloud storage provider suffers from a failure or shuts down entirely. We want to protect ourselves from hardware failures, disk errors, software bugs, fire or temporary power outages as much as our node being stolen or otherwise unavailable.

The process of recovering your node \(e.g. from a hardware failure\) is different to that of a lightning node migration \(e.g. moving your node to a physical server\). The precautions discussed here relate to non-scheduled recovery due to emergencies.

## Hardware

LND is very read and write intensive and, as such, may wear out your storage medium faster than other software, and be more sensitive to even small hardware errors. LND should not be run on a SD card \(Secure Digital\). SSDs \(Solid-state drives\) are preferable over HDDs \(Hard disk drives\).

If you decide to deploy your Lightning node in the cloud, choose a reputable provider known for reliable hardware and uptime. You may use RAID \(Redundant Array of Independent Disks\) to mitigate failures.

**If your Lightning node is going to run on a device you physically control, invest in a high-quality SSD and consider setting up RAID.**

\[[Also read: Operational safety](safety.md)\]

## aezeed

The key to your Lightning node is generated with lncli create when you first start up your node. This seed phrase consists of 24 English words and can be used to derive your node’s public key as well as the Bitcoin private keys of all your on-chain funds. Using only this key, you will be able to recover all on-chain funds in your LND wallet as well as all funds from channels your peers force close on you after your node goes offline.

**Keep your aezeed securely backed up, ideally on a piece of paper or in encrypted storage, for example in your password manager.**

## Static channel backups \(SCB\)

In the case that our node faces a catastrophic failure, we are unable to revive our channels. Instead, we will rely on static channel backups to contact our former peers and ask them to force close our channels.

A static channel backup exists for each channel we maintain. It contains information about the channel and our peers. The information is encrypted with our node’s private key, meaning our SCBs can only be used by us in conjunction with our aezeed.

To obtain our SCBs, we can use the channel.backup file found in `.lnd/data/chain/bitcoin/channel.backup`. This file contains all backups for all our currently existing channels and it is updated every time we or somebody else opens a new channel. We can also obtain the SCB for a specific channel with the command `lncli exportchanbackup --chan_point <channel point>`

**Keep a copy of your channel.backup file on a separate machine and update it whenever a new channel is opened between your node and a peer.**

## Channel Database

The `channel.db` file found in `.lnd/graph/mainnet` contains important additional information about our channels. We cannot recover from it directly and will need help from additional advanced tools, but the information derived from it can be helpful in recovering funds from channels where peers are not reachable.

**Back up this file regularly, but do not rely on it for recovery.**

[Learn how to recover your funds.](https://docs.lightning.engineering/lightning-network-tools/lnd/recovery)

## Close zombie channels

As part of our preparation for the unexpected, we might want to close zombie channels early. Zombie channels are channels that can no longer be used as the peer is no longer online or abandoned the channel. How long we might want to wait before a channel is considered a zombie channel can vary, and we must not confuse them with \(private\) channels to peers that only occasionally come online.

Generally, if we have a channel with a peer that we don’t expect to come back online, we should close this channel. Older channels for which a SCB does not exist or channels with peers that do not support this feature may also be worth closing.

\[[Manage liquidity in the Lightning Network.](../../the-lightning-network/liquidity/manage-liquidity.md)\]

## Be \#craeful not \#reckless

The Lightning Network offers a multitude of options to recover from failure. LND continues to improve and eliminate bugs that might lead to a fatal node failure. If you encounter a bug, [file an issue](https://github.com/lightningnetwork/lnd/issues/) or contact us through[ Slack](https://lightning.engineering/slack.html),[ Discord](https://discord.gg/9u83Jxeu), and[ Twitter](http://twitter.com/lightning)!

