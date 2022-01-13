---
description: Experimental Ideas for Building on Bitcoin
---

# Lightning Bulb 💡

The Lightning Network enables new and exciting ways to build on bitcoin, but the endless possibilities can be overwhelming. That’s why we are launching Lightning Bulb to help inspire the community and kick-start new Lightning projects. This is where we'll host open research questions, experimental ideas, and other forms of inspiration for the Lightning developer community.

If you’re just getting started building on Lightning, we [have a beginner’s guide](https://docs.lightning.engineering/build-a-lapp/build-a-lapp-overview) that will familiarize you with our [lnd](https://github.com/lightningnetwork/lnd) Lightning implementation and its APIs.

We will track developer progress and showcase projects here and on our social channels. These questions will be updated with input from the team and community. If you have ideas of your own you would like to propose, send us an email at [hello@lightning.engineering](mailto:hello@lightning.engineering) or [submit a PR](https://github.com/lightninglabs/docs.lightning.engineering/) directly to the Github repository.

We are here to help. If you have questions or need to bounce ideas around, feel free to jump in our dev [Slack](https://join.slack.com/t/lightningcommunity/shared\_invite/zt-bpe1a687-1UzHhrG15Fs\_DMRI1jhbpg) or join our developer office hours on [Discord](https://discord.gg/bpkWbUCtr7) to chat with our team and the rest of the community. Let’s get building!

## **Lightning Bulb Requests for Development:**

**A native interface to Lightning on the web**

* New Lightning browser extensions like [Joule](https://lightningjoule.com) and the [Lightning Browser Extension](https://github.com/bumi/lightning-browser-extension) built on the [WebLN](https://webln.dev/#/) standard.
* Suggestion: extending [WebLN](https://webln.dev/#/) to encompass liquidity APIs [Loop](https://lightning.engineering/loop) and [Pool](https://lightning.engineering/pool) as well as any other Lightning APIs.

**Streaming payments on social platforms**

* Build an easy way for creators on Twitch, YouTube, and other popular platforms to accept streaming payments from their audience.
* Suggestion: use webhooks to build ways for Lightning payments to interact with existing platform creator tools and enable audience engagement.

**Distributed compute with Lightning**

* Use [LSATs](https://lsat.tech) for a decentralized metered container execution service (like [Travis CI](https://travis-ci.org)). Will have with the potential to reach a more global audience without the requirement of credit cards.&#x20;
* Suggestion: think serverless microVMs like [Firecracker VM](https://firecracker-microvm.github.io) as a starting point, will likely need a small overlay layer to let people find other nodes.

**Lightning Paywall Plugin**

* Combined with the Web LN work mentioned above, implement as a [BTCPayServer](https://btcpayserver.org), [Wordpress](https://wordpress.com) and/or [Ghost](https://ghost.org) plug-in. Long term, the plugin should target [WASM](https://webassembly.org) so only a Chrome extension install is required.
* For thought: could potentially serve as a captcha replacement, where popular sites present de minimis paywalls at first, ramping up only with actual abuse.

**Pay-per-use Lightning API calls**

* Create APIs where all requests and responses are made with Lightning push payments with [Keysend](https://wiki.ion.radar.tech/tech/research/sphinx-send), instead of requiring an invoice
* Suggestions: a Keysend Services Directory, ability to sell Mission Control data to a peer in need of updated routing data, etc.

## LSAT implementation ideas

Lightning Service Authentication Tokens (LSATs) allow for paid APIs in distributed systems. LSATs are built on top of Macaroons -- they can carry caveats, attenuations, can be delegated and further restricted by the bearer.

Implementing LSATs is most attractive in services that require metered or paid access together with granular access control. A key advantage of LSATs is that the logic of collecting payments can be separate from verifying access, often without the need to maintain customer records or expose them to the open internet.

Here are just some initial ideas for potential LSAT powered products:

* Bitcoin price API

There are many APIs for obtaining Bitcoin prices, some paid, others free. A Bitcoin price API built with LSATs may issue a macaroon to each new user, allowing for some free usage. Upon hitting a daily or total limit, the API can issue an LSAT together with a Lightning invoice. There could be separate pricing for surge traffic or historic data. One idea is to issue LSATs that include a “delay” as a caveat. Free access requests are served after a few seconds, while paid access is served immediately.

* Virtual Private Network

A VPN provider can use LSATs to sell bandwidth, adjusting their rates by location and speed. This makes it easy to integrate the VPN service into other products, resell bandwidth or share bandwidth between users or applications.

* Voice over IP gateway

There are plenty of low-fee VoIP gateways, troubled by high payment costs. A VoIP gateway using LSATs could quickly become attractive for other applications to integrate once pay-as-you-go plans over Lightning become available. LSATs could be obtained for a set amount of minutes, a monthly plan or for each call separately, turning every Lightning wallet also into a phone, fax or SMS application.

* Podcasts and movies

Podcasts could become available with advertisements to the general public, and without ads to paying subscribers. LSATs issued to the subscriber define which episodes and versions are available. The paying subscriber can also share an attenuated LSAT with their friends that lets them listen to a single episode without having to pay for it. This can be implemented into existing infrastructure without breaking backwards compatibility.

* Cloud storage (differentiated by speed, per bandwidth or by storage, delegate access)

A cloud storage provider can sell their space and bandwidth and use LSATs to track payments and organize access control. A user can attenuate their LSATs and share them among their separate devices or even specific files with friends.
