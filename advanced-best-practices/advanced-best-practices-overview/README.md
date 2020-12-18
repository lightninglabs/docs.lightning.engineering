# Overview

In this guide, we will walk you through the best practices for maintaining a mainnet `lnd` Lightning Network node. [`lnd`](https://github.com/lightningnetwork/lnd) is a golang implementation of the Lightning Network [Specification](https://github.com/lightningnetwork/lightning-rfc), maintained by Lightning Labs which fully conforms to the [Lightning Network Specification \(BOLTS\)](https://github.com/lightningnetwork/lightning-rfc).

Hopefully if you are reading this, you have already completed our [Build a Lapp guide](../../build-a-lapp/build-a-lapp-overview.md) and our [Installation guide](../../intermediate-get-lit/get-lit-overview/). 

This guide assumes some basic knowledge of how Bitcoin and the Lightning Network operate. We recommend understanding of the following concepts before proceeding with the guide, as some foundational concepts will ease the learning curve. 

* [Lightning Network Basics](https://wiki.ion.radar.tech/tech/lightning/lightning-network)
* [Bi-directional payment channels](https://bitcoinmagazine.com/articles/understanding-the-lightning-network-part-building-a-bidirectional-payment-channel-1464710791)
* [Ln-penalty commitment update mechanism](https://www.youtube.com/watch?v=DAuNlOfws0o)
* [Cooperative vs force closed channels](https://www.youtube.com/watch?v=Gyt4nxRHy04&t=2s)
* [Hash time locked contracts](https://wiki.ion.radar.tech/tech/bitcoin/hltc) \(HTLCs\)

## A note on Feature Bits:

To allow easy upgrades to the network, nodes advertise the features that they support so that there are no misunderstandings when trying to communicate. These feature bits are advertised in two places:

* **Node announcements**: broadcast to the entire network, indicating the features that a node supports and those which it requires. These feature bits can be viewed using the _DescribeGraph_ API call.
* **Invoices**: to allow updates to the way in which we make payments, invoices also include feature bits, so that payers know how the invoice can be paid. These feature bits are largely internally managed by `lnd`, so you do not need to worry about them. 

The feature bits that a node supports determines the way in which your node can interact with it; on a node-level, it determines the channel types you can open, and on an invoice-level, it determines the ways in which you can pay that invoice. If your implementation depends on a feature in this guide that notes that it needs a specific feature bit, be sure to check that the nodes you interact with support the feature bits you need!

