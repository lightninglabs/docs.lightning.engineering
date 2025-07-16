---
description: >-
  Lightning Polar provides you with an easy-to-use interface to set up your
  Lightning Network testing environment, including Taproot Assets.
---

# Lightning Polar

Lightning Polar is an application that lets you quickly spin up a local testing environment for your Lightning Network node and applications. It supports Litd, LND, CLN and Eclair, with a Bitcoin Core backend on regtest.

{% embed url="https://www.youtube.com/watch?v=pYh-4EfdZaM" %}
Tapping into Taproot Assets #2: Prototype with Polar
{% endembed %}

## Prerequisites

Before you can get started with Lightning Polar, you will need Docker. On Windows and Mac OS, you can use [Docker Desktop](https://www.docker.com/products/docker-desktop/), while on Linux it is recommended to run [Docker Engine](https://docs.docker.com/engine/install/#server).

## Download Lightning Polar

You can [download Lightning Polar](https://lightningpolar.com/) from the official website, [Github](https://github.com/jamaljsr/polar/releases/tag/v2.0.0), or build it from source. Detailed installation instructions can be found in the [project’s readme](https://github.com/jamaljsr/polar).

## Run Polar and create your network

Run polar by executing it on your machine. This will launch the Polar user interface from where you can launch a new network.

For the purpose of this guide, we are going to set up two Litd nodes, each with their own Bitcoin Core backend. One Litd node (Alice) acts as the user; the other (Edgar) acts as the edge node. The edge node is connected to a CLN, Eclair and LND node, representing the broader Lightning Network.

<figure><img src="../../.gitbook/assets/Screenshot from 2024-08-22 17-17-37.png" alt=""><figcaption><p>Sample Lightning Network to test edge node configuration.</p></figcaption></figure>

## Start the network and deposit funds

We can start the network by clicking on “Start” on the top right corner, which will load the Bitcoin and Lightning nodes. Once our network and nodes are running, we can click on one of our Lightning nodes and deposit funds into it. This will trigger our regtest Bitcoin node to mine regtest-Bitcoin in the background and transfer them to the internal wallet of our node.

## Interact with the Taproot Assets daemon

Our Litd nodes include all the functionality necessary to mint Taproot Assets and open Taproot Assets channels. We can open a terminal for the Edge node and mint an asset, for example using the command `tapcli assets mint --type normal --name lollar --supply 1000000000 --decimal_display 3 --meta_bytes '{"hello":true}' --meta_type json --new_grouped_asset`

We can then go ahead and mint this batch with `tapcli assets mint batches finalize`

Don't forget to mine a few blocks to get the transaction confirmed!

Before we can use this asset to open a channel, we will have to sync the asset to Alice's node. The easiest way to do that is to use the Polar UI by "creating an Asset address," then "sync assets from Edgar's node." Don't forget to click on "generate" to make sure the synchronization process is completed.

To open Taproot Asset channels, we can use the command below. Don't forget to substitute the node key for Alice's key and the asset ID for the asset you minted above.

`litcli --macaroonpath ~/.lnd/data/chain/bitcoin/regtest/admin.macaroon ln fundchannel --node_key 03d30bdaa3f44dd0a5ae7ed7cb1ad1c0ddd13b8db979b719cd963b65508815c4f1 --asset_amount 1000000 --asset_id b7e048c449feebb898138f1a7f340cc210ab2a04304b5595f20715a8a6e0ba34 --sat_per_vbyte 10`

Ordinary Lightning Network channels can be created using the Polar UI.

## End-to-end transfers

We can also simulate environments in which assets are sent through two separate edge nodes.

In the example below, Alice and Alfred are able to send their assets to Zara and Zane, using Edgar and Eda as the edge nodes. Elen and Cora represent the wider Lightning Network.

<figure><img src="../../.gitbook/assets/Screenshot from 2024-08-29 16-34-54.png" alt=""><figcaption></figcaption></figure>

## Useful information

Lightning Polar will expose the connection information for all your Bitcoin, LND and Taproot Assets clients. You are able to launch a terminal and interact with these clients directly, or right-click on any node and see its logs.
