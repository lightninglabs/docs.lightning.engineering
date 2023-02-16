---
description: >-
  Autofees is a feature that sets fees for your channels based on how much they
  earn.
---

# Autofees

Starting with litd v0.8.6 and the accompanying Lightning Terminal web release, users are able to choose dynamic, automatic channel fee adjustment over manually setting fees. This feature can help to reduce the maintenance overhead of a routing node while increasing fee revenue and help balance funds on a node.

By opting into Autofees, you give permission to Terminal to remotely read some information from your node and use it to programmatically set outbound fees for channels. You can set Autofees for all your channels, or limit it to only some.

Once Autofees has been enabled from Lightning Terminal, your node will automatically create a new dedicated [Lightning Node Connect](lightning-node-connect.md) session with its own [Macaroon](../lnd/macaroons.md) through which fees will be set.

## The algorithm <a href="#docs-internal-guid-76eb4c4b-7fff-125a-37fb-077d5b7bb163" id="docs-internal-guid-76eb4c4b-7fff-125a-37fb-077d5b7bb163"></a>

When Autofees is enabled, Terminal will use the forwarded traffic of the top five earning peers over 60 days as a reference for the entire node (in order to determine a target throughput per peer). It will then look at the forwarded traffic from the past days and decide whether to adjust fees upwards or downwards for each peer. The algorithm is designed to stabilize traffic and to prevent underpricing liquidity while adapting to changes in demand and routing flows.

If the forwarded traffic of a channel is lower than the target throughput, Terminal will lower fees. If the forwarded traffic is higher, then fees will be increased. Each fee adjustment is made in small increments once every three days, a tradeoff to limit gossip data on the network.

As a channel sees 7/8th of their liquidity depleted, fees are once again mildly raised to signal scarcity, to keep the channel balanced, and to keep liquidity for excess demand periods. This helps senders in the Lightning Network to reduce forwarding failures.

The algorithm can be enabled for all peers, or only for specific ones. It runs purely on historical forwarding data, current channel balancedness, and charged relative routing fees provided by LND, without a state or database on the litd side.

Results are expected to improve over time as the algorithm matures. By using Terminal the user always has access to the latest Autofee algorithm without the need to upgrade their node or litd client.

## Security & Privacy <a href="#docs-internal-guid-8d174f91-7fff-6e6f-dd09-9926abf105f2" id="docs-internal-guid-8d174f91-7fff-6e6f-dd09-9926abf105f2"></a>

At its core, Autofees does not change [the security model](privacy-and-security.md) of your Terminal session. By enabling Autofees for all or specific channels, you create a new additional session with the Autofees server, where the session is only allowed to access forwarding data, channel balances, and fee rate policies. Autofees has limited write permissions to only set new fee policies. The session is visible in litd and can be revoked at any time.

Due to the built-in rule mechanics enforced by litd, the Autofee feature has limited access to forwarding data (60 days into the past) and is only able to run in a predetermined frequency. The litd firewall rules limit algorithmically set fee rates by defining maximum values.

To improve privacy around data sharing, channel ids, channel points and node pubkeys are obfuscated by litd. Amounts and timestamps in forwarding data are randomly obfuscated to break amount and time correlation. Channel details only include randomized balance information such as to be still accurate enough for the algorithm to act. Per-peer aggregated forwarding data is stored to improve on the algorithm in the future to learn historic price-demand data pairs.

| Enabling Autofees will set your channels’ [CLTV delta](../../the-lightning-network/multihop-payments/timelocks.md) to 100. |
| -------------------------------------------------------------------------------------------------------------------------- |

## Configuration <a href="#docs-internal-guid-df361fd3-7fff-7d3f-4ce1-669733ea2856" id="docs-internal-guid-df361fd3-7fff-7d3f-4ce1-669733ea2856"></a>

To make optimal use of Autofees, consider:

* [Set default high fee rates](../lnd/channel-fees.md), so they can be lowered later without risk of seeing a channel depleted without adequate compensation (suggested value bitcoin.feerate=2500 in your lnd.conf)
* Only enable Autofees for peers you don’t know an accurate price of. For some peers, such as for example Loop, you can keep your manually set fees
* Manual intervention in fee setting is possible
* Avoid to restart Autofees as a new session will be created every time as there may be false double accounting for overlapping periods

### How to enable Autofees

You can enable Autofees in your Lightning Terminal under Liquidity -> Loop. [Learn how to connect to Terminal here](run-litd.md).
