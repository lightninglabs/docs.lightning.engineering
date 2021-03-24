---
description: Experimental Ideas for Building on Bitcoin
---

# Lightning Bulb 💡

The Lightning Network enables new and exciting ways to build on bitcoin, but the endless possibilities can be overwhelming. That’s why we are launching Lightning Bulb to help inspire the community and kick-start new Lightning projects. This is where we'll host open research questions, experimental ideas, and other forms of inspiration for the Lightning developer community.

We will track developer progress and showcase projects here and on our social channels. These questions will be updated with input from the team and community. If you have ideas of your own you would like to propose, send us an email at [hello@lightning.engineering](mailto:hello@lightning.engineering) or [submit a PR](https://github.com/lightninglabs/docs.lightning.engineering/) directly to the Github repository.

We are here to help. If you have questions or need to bounce ideas around, feel free to jump in our dev [Slack](https://join.slack.com/t/lightningcommunity/shared_invite/zt-bpe1a687-1UzHhrG15Fs_DMRI1jhbpg) or join our developer office hours on [Discord](https://discord.gg/bpkWbUCtr7) to chat with our team and the rest of the community. Let’s get building!

**A native interface to Lightning on the web**

* New Lightning browser extensions like [Joule](https://lightningjoule.com/) and the [Lightning Browser Extension](https://github.com/bumi/lightning-browser-extension) built on the [WebLN](https://webln.dev/#/) standard.
* Suggestion: extending [WebLN](https://webln.dev/#/) to encompass liquidity APIs [Loop](https://lightning.engineering/loop) and [Pool](https://lightning.engineering/pool) as well as any other Lightning APIs.

**Blob storage and retrieval using Lightning authentication**

* Use [LSATs](https://lsat.tech), a means of authentication solely using a Lightning payment, for arbitrary file storage with a periodic challenge and response which results in streaming content in real-time.
* Suggestion: small overlay layer to let people find other nodes, anything from a simple hosted bulletin board to full-blown decentralized order book.

**Metered container execution service using Lightning authentication**

* Use [LSATs](https://lsat.tech) for a decentralized Travis CI, but with the potential to reach a more global audience given no credit cards required. 
* Suggestion: think [Firecracker VM](https://firecracker-microvm.github.io/) as a starting point for the service, will likely need a small overlay layer to let people find other nodes.

**Lightning-based metered VPN**

* More privacy preserving payments for access to a VPN as compared to credit cards, ideally integrated with [WireGuard](https://www.wireguard.com/).

**Lightning Paywall Plugin**

* Combined with the Web LN work mentioned above, implement as a [BTCPayServer](https://btcpayserver.org/) and/or [Wordpress](https://wordpress.com/) and/or [Ghost](https://ghost.org/) plug-in. Long term, the plugin should target [WASM](https://webassembly.org/) so only a Chrome extension install is required.
* For thought: could potentially serve as a captcha replacement, where popular sites present de minimis paywalls at first, ramping up only with actual abuse.

**Paid Lightning API calls**

* Create APIs where all requests and responses are made with Lightning [Keysend](https://wiki.ion.radar.tech/tech/research/sphinx-send) payments, instead of requiring an invoice
* Suggestions: a Keysend Services Directory, ability to sell Mission Control data to a peer in need of updated routing data, etc.

**Developer sponsorship tools**

* An easy-to-integrate-static QR code that enters the user into an [AMP](https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-February/000993.html) \([coming soon](https://twitter.com/bitconner/status/1349140620376383488?s=20)™️\) subscription push payment.

