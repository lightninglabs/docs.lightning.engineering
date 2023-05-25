---
description: >-
  Lightning Polar provides you with an easy-to-use interface to set up your
  Lightning Network testing environment, including Taproot Assets.
---

# Lightning Polar

Lightning Polar is an application that lets you quickly spin up a local testing environment for your Lightning Network node and applications. It supports LND, CLN and Eclair, with a Bitcoin Core backend on regtest.

{% embed url="https://www.youtube.com/watch?v=vuF6TOrlU_g" %}
Taproot Assets on Polar
{% endembed %}

## Prerequisites

Before you can get started with Lightning Polar, you will need Docker. On Windows and Mac OS you can use [Docker Desktop](https://www.docker.com/products/docker-desktop/), while on Linux it is recommended to run [Docker Engine](https://docs.docker.com/engine/install/#server).

## Download Lightning Polar

You can [download Lightning Polar](https://lightningpolar.com/) from the official website, [Github](https://github.com/jamaljsr/polar/releases/tag/v2.0.0), or build it from source. Detailed installation instructions can be found in the [project’s readme](https://github.com/jamaljsr/polar).

## Run Polar and create your network

Run polar by executing it on your machine. This will launch the Polar user interface from where you can launch a new network.

For the purpose of this guide, we are going to set up two LND nodes running on top of the same Bitcoin Core backend.

<figure><img src="../../.gitbook/assets/Screenshot from 2023-05-24 15-18-03.png" alt=""><figcaption><p>Start by creating your own Lightning Network</p></figcaption></figure>

## Start the network and deposit funds

We can start the network by clicking on “Start” on the top right corner, which will load the Bitcoin and LND nodes. Once our network and nodes are running, we can click on one of our Lightning nodes and deposit funds into it. This will trigger our regtest Bitcoin node to mine regtest-Bitcoin in the background and transfer them to the internal wallet of our node.

## Install and run the Taproot Assets daemon

We will install Tapd by dragging its icon from the “Network Designer'' to one of the LND nodes. If you cannot access the Network Designer, try clicking on an empty part of your network plane.

We are going to need two Taproot Assets clients, connected to each of the LND nodes.

<figure><img src="../../.gitbook/assets/Screenshot from 2023-05-24 15-24-17.png" alt=""><figcaption><p>A simple network without channels, two LND nodes sharing the same Bitcoin backend, and two Tapd instances.</p></figcaption></figure>

## Mint assets

We can mint our Taproot Assets by clicking on one of the Tapd clients, then selecting “Actions” and, finally, “Mint.” We have the option between “Normal” and “Collectible” assets, setting a name and an amount. We can mint these assets immediately.

## Synchronize to a universe and generate Taproot Assets address

On the node to which we want to send the assets, we navigate to “Actions” then “New Address.” We will first have to sync to the minting node (e.g. Alice) before we can see the asset in the drop-down menu. Once we filled in an amount, we can generate the address which looks like this:

`taprt1qqqsqq3q5vap3thd2ms5zs0n8te9zlgcwdzfgnd0408lzp8cgdg65qyurgrqgggzyglt8lhnkdxqxc3qqggze05gu6f2z963r26yctv4j3xpzg6gf4xqvggz4avwwzxt3wwpqype8dlxqu95z96w8d8lyx89kn927chyla6nelyssqtytwdc5s`

## Send Taproot Assets

Using the address we generated in the previous step, we can navigate back to the minting node and paste the address under “Actions” and “Send Asset.” Following this action, we should be able to see balance in the recipient’s node under “Info.”

## Useful information

Lightning Polar will expose the connection information for all your Bitcoin, LND and Taproot Assets clients. You are able to launch a terminal and interact with these clients directly, or right-click on any node and see its logs.
