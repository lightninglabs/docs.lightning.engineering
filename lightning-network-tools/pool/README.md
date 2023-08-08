---
description: >-
  Understand the basics of Lightning Pool and how it can help you find and
  leverage your position in the Lightning Network
---

# Pool

[Launched in November 2020](https://lightning.engineering/posts/2020-11-02-pool-deep-dive/), Lightning Pool is a non-custodial marketplace for Lightning Network channel liquidity. It allows participants to earn interest for liquidity they provide or pay to acquire liquidity, all without giving up control of your funds.

## Requirements <a href="#docs-internal-guid-17793911-7fff-a092-4056-9e403aa8f2de" id="docs-internal-guid-17793911-7fff-a092-4056-9e403aa8f2de"></a>

To participate, you need a Lightning node with at least one public channel, some outgoing capacity and on-chain bitcoin. You will need to run the pool daemon, either as a standalone binary or as part of litd.

To earn fees for providing outbound liquidity through Pool, your node must be ranked, meaning it must pass all six [health checks in Lightning Terminal](../lightning-terminal/health-checks.md).

→ [Install Pool](install.md)

→ [Install litd](../lightning-terminal/get-lit.md)

## Use cases <a href="#docs-internal-guid-b53f95ad-7fff-e348-d8ec-1b7177b88c7b" id="docs-internal-guid-b53f95ad-7fff-e348-d8ec-1b7177b88c7b"></a>

Lightning Pool can be used to either buy or sell liquidity on the Lightning Network, either for yourself or on behalf of others. Lightning Pool supports [zero-confirmation channels](zero-confirmation-channels.md) that can be used without waiting for Blockchain confirmations.

Node operators can use Pool to:

* Bootstrap a routing node through balanced channels
* Acquire more inbound capacity instantly through zero-confirmation channels
* Onboard a new user to Lightning with a mobile wallet through Sidecar channels
* Earn fees for deploying funds to the Lightning Network completely non-custodially

## Accounts <a href="#docs-internal-guid-1a00219f-7fff-798e-3bc1-d1a3a0509427" id="docs-internal-guid-1a00219f-7fff-798e-3bc1-d1a3a0509427"></a>

Funds in your pool account are held in a 2-of-2 multisignature account between your node and Pool. This account has an expiration time of 90 days, after which the account can be closed unilaterally by the account owner. While the account is active, it can be closed at any time cooperatively. At no point does Pool or Lightning Labs take possession or control over your funds.

[Learn more: Pool Accounts](accounts.md)

## Markets <a href="#docs-internal-guid-4cd4c4e8-7fff-62bc-6d6d-1330ac3b694b" id="docs-internal-guid-4cd4c4e8-7fff-62bc-6d6d-1330ac3b694b"></a>

Pool offers various markets for both inbound and outbound liquidity. By having the option to become a bidder or asker for either inbound or outbound, Pool offers the most optimal price discovery for both inbound and outbound capacity.

Both inbound and outbound markets are divided into multiple time frames, allowing bidders and askers to express their desired preferences for varying channel durations.

[Learn more: Pool markets](orders.md)

## Auctions batches <a href="#docs-internal-guid-5bb13eb9-7fff-d95e-691a-6b0ca8b3bddf" id="docs-internal-guid-5bb13eb9-7fff-d95e-691a-6b0ca8b3bddf"></a>

All markets clear in batches, at most once per ten minutes. Each auction clears at a uniform price, meaning all your orders are matched with a price better than your initial ask or bid. Your bid can be set to public or remain sealed, meaning not known to the participants.&#x20;

Each batch is executed in a single on-chain transaction to save its participants on fees.

[Learn more: Pool auctions](batch\_execution.md)

## Sidecar channels <a href="#docs-internal-guid-37b08531-7fff-5cd7-f1e5-123a3ea14e29" id="docs-internal-guid-37b08531-7fff-5cd7-f1e5-123a3ea14e29"></a>

Sidecar channels are channel lease bids on behalf of a third node, typically without its own pool account. They are a useful tool for [Lightning Service providers](../../the-lightning-network/liquidity/lightning-service-provider.md) to help bootstrap new nodes, for instance mobile wallets or merchants, who may not have their own Pool account, an existing channel or a UTXO.

Sidecar channels, like other channels, can be opened with a local and a remote balance, making it easier and faster to bootstrap a node with balanced channels, giving them the ability to both send and receive satoshis right from the start.

[Learn more: Sidecar channels](sidecar\_channels.md)

## Zero-confirmation channels <a href="#docs-internal-guid-d3c9d7f2-7fff-e166-a3c7-d6ecede6c19d" id="docs-internal-guid-d3c9d7f2-7fff-e166-a3c7-d6ecede6c19d"></a>

As all channels sold through Pool are co-signed by Pool from a 2-of-2 multisignature account, they cannot be maliciously double-spent by their initiator. This makes it safe for participants to accept such channels without waiting for on-chain confirmations, allowing channels to be deployed instantly.

This is particularly useful in situations where liquidity is urgently needed to receive or send funds over the Lightning Network.

[Learn more: Zero-confirmation channels](zero-confirmation-channels.md)

## Bundled with litd <a href="#docs-internal-guid-fca0f6ab-7fff-5e70-b63e-08be7208c0ec" id="docs-internal-guid-fca0f6ab-7fff-5e70-b63e-08be7208c0ec"></a>

Pool is included in the litd bundle and may already be installed and running on your node. To [install litd, follow this guide](../lightning-terminal/get-lit.md).

[Learn more: litd](../lightning-terminal/)

## L402s <a href="#docs-internal-guid-7c12e434-7fff-0353-dc57-8613d8ecb850" id="docs-internal-guid-7c12e434-7fff-0353-dc57-8613d8ecb850"></a>

Pool uses L402s to authenticate its users. L402s are Macaroons that include a proof of payment.

[Learn more: L402s](../../the-lightning-network/l402/l402.md)

## Documentation

You can find the Pool API documentation here:

{% embed url="https://lightning.engineering/api-docs/api/pool/" %}
Pool API documentation
{% endembed %}
