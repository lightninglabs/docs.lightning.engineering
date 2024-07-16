---
description: Terminal is a web-based dashboard for Lightning Labs products.
---

# What is Lightning Terminal?

## Private and Secure

Lightning Labs does not see or store your node’s information. Using Lightning Node Connect (LNC), an end-to-end encrypted connection is established between your browser and your node. With this LNC connection, any private information about your node such as HTLCs, private channels, or any other non-public information remains private. The LNC proxy server (nor any other part of the Lightning Labs) stack cannot look at any of that private information, which appears as encrypted blobs.

## Features

By bringing Terminal to the web, we can deliver some of the familiar features of the Lightning Terminal daemon (`litd`) to a web based, remote experience. Furthermore, we can ship faster to meet the needs of our users

### Easy to run

To make use of Terminal, you will need to run `litd` together with `lnd`, either on the same or separate machines. After browsing to [terminal.lightning.engineering](http://terminal.lightning.engineering) and [initializing your session](connect.md) with Lightning Node Connect, you can enjoy all features of Terminal and interact with your node from your browser.&#x20;

### Top performing nodes

Terminal ranks public Lightning nodes based on their centrality, stability and routing ability. It can help you make better decisions about who to peer and [open channels](opening-channels.md) with, as well as give you suggestions on peers that would complement your node or the network.

### Your node’s information

Using Terminal, you are able to observe your node’s ranking, centrality and health assessments in addition to seeing your recent transactions, summary of fees earned and payments forwarded. Terminal provides you with a simple user interface to monitor your node and manage your node, such as opening channels or observe their balances.&#x20;

### Loop

[Lightning Loop](loop.md) is a service that allows users to make a Lightning transaction to an on-chain bitcoin address (Loop Out) or send on-chain bitcoin directly into a Lightning channel (Loop In). Loop can help manage channel liquidity, for example, by emptying out a channel and acquiring inbound capacity (or refilling a depleted channel).\


Users can use Terminal to initiate Loops, select which channel they would want to deplete or fill and monitor the status of their ongoing swaps.

### Pool

[Lightning Pool](pool.md) is a marketplace for buying and selling channel liquidity. Terminal allows users to place their own asks and bids through the web browser, see their matched orders, calculate fees earned and spent and monitor the channels opened through the platform.

### Taproot Assets

The [Taproot Assets Protocol](../../the-lightning-network/taproot-assets/taproot-assets-protocol.md) defines how collectibles and assets are issued on the Bitcoin Blockchain using the [Taproot Assets Daemon](../taproot-assets/), `tapd`. Taproot Assets can be deposited into Lightning Network channels and routed over the Bitcoin Lightning Network.\


[Connect your node to Terminal now.](https://terminal.lightning.engineering)

## Lightning Terminal and litd

Lightning Terminal including Pool and Loop will continue to be available as part of `litd` for those who prefer to self-host the application on their own device. It is currently not possible to see recommended channels, make and receive payments or see recent forwarded transactions through the interface of the self-hosted Lightning Terminal.

## What is Lightning Node Connect

Lightning Node Connect (LNC) is a new mechanism to smoothly establish a connection to your Lightning node, even if it is behind Tor or a NAT. LNC is an open source tool that allows for an end-to-end encrypted connection between an application and a node. The first implementation of the Lightning Node Connect technology is used by Terminal to enable anyone to manage their node easily over a web portal, independent from where the user or their node are located.

### How Lightning Node Connect works

LNC makes use of LND’s existing gRPC interface. The node makes an outgoing connection to a web proxy, to which the user is able to navigate using their browser or application. Using a password-authenticated key exchange (PAKE), the established session can be end-to-end encrypted and authenticated between the user and their node.\


Terminal Connect is implemented as part of Terminal and `litd 0.6`. It can be used by browser extensions, mobile wallets, lightning network explorers and other applications to connect directly to a Lightning node in order to manage it, make or receive payments and more.\


[Read more about how Lightning Node Connect works.](lightning-node-connect.md)
