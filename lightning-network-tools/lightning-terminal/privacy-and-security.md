---
description: >-
  Terminal is operated in a way that Lightning Labs never has access or insight
  to your node.
---

# Privacy and Security

Lightning Terminal makes it possible to securely connect your browser to your node with an end-to-end encrypted connection made via a web-based proxy. While Terminal is built with the highest standards of security in mind, it is important to understand the security and privacy implications of using such a service.

## Your network

Terminal does not require you to make modifications to your node’s local network. You do not need to open additional ports or make changes to your [Tor configuration](../lnd/quick-tor-setup.md) to operate Terminal.

[Read: Secure your Lightning Network node.](../lnd/secure-your-lightning-network-node.md)

## Litd <a href="#docs-internal-guid-82ce45e1-7fff-9b95-2273-6f6b2328b9f5" id="docs-internal-guid-82ce45e1-7fff-9b95-2273-6f6b2328b9f5"></a>

The Lightning Terminal Daemon, or litd, is an application that either runs locally on the same machine as your Lightning Network node, or remotely on a separate machine. Access to litd needs to be carefully restricted, for example by making Lightning Terminal inaccessible from the internet, choosing a secure password and running it on a device you control and trust. Anybody with access to your Lightning Terminal Daemon instance could gain access to your Lightning Node.

You are able to revoke an application’s access to your node, such as the web version of Terminal, at any time by navigating to your Lightning Terminal Daemon user interface.

## The pairing phrase

The Lightning Terminal Daemon creates a pairing phrase for you to connect to the web version of Terminal (or in the future other applications). This pairing phrase does not need to be stored anywhere, but can be reused for another connection attempt. Only one concurrent connection is possible with each pairing phrase. The pairing phrase is communicated out of band between the machine running `litd` and your browser. Ideally you will be able to copy/paste it on your personal machine, or enter it manually.

Be careful where you enter the pairing phrase, as you might be targeted by phishing schemes. Be careful with verifying that you are navigating to the correct trusted site, e.g. [https://terminal.lightning.engineering/](https://terminal.lightning.engineering/) Do not enter your pairing phrase into applications and sites you do not trust.

## Your browser

Use a reputable and robust browser that ideally updates itself regularly. Be careful with extensions that might be able to intercept and alter content on display and transit. Your browser will store sensitive information, encrypted with a password of your choice.

## Terminal Security&#x20;

Be vigilant of phishing attacks directing you to sites attempting to steal your pairing phrase before you have connected yourself. Ideally, bookmark the page in your browser and only navigate to it using the bookmark bar.

Choose a strong and unique password for Terminal, for example one created using your password manager.

## Other applications

Lightning Node Connect is open source software, enabling developers to build their own applications that let you connect and manage your Lightning Network node. All software authorized to connect to your node needs to be sufficiently trusted. While it will be possible in the future to restrict the level of access to your node directly in Lightning Terminal, this is not implemented as of yet.

## Privacy

All connections between your Lightning node and Terminal are encrypted end-to-end. Lightning Labs can only see encrypted traffic along the route. Your node’s private information, such as private channel and on-chain balances, remains private. Lightning Labs only maintains usage statistics about how many nodes are connected through Lightning Terminal, and when they last connected.

Unless your node and browser are behind a VPN or other relay, the Terminal Proxy is able to see your IP addresses. Even if your Lightning node is running behind the Tor Socks proxy, `litd` will make an outwards connection in the clear.

Theoretically, the proxy server could be able to infer usage patterns from packets forwarded between your node and your browser, although no such information is stored or analyzed. Lightning Labs maintains usage statistics about how many nodes are connected through Lightning Terminal, and when they last connected.

Lightning Terminal makes use of the [mempool.space API services](https://mempool.space/terms-of-service) for timestamp and fee information for your node’s on-chain transactions. All calls are made from your browser and are not directly associated with your node. Similarly to navigating to mempool.space directly in your browser, this reveals your IP address.
