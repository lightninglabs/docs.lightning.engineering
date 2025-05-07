---
description: The guide to Lightning Loop
---

# Loop

[Lightning Loop](https://lightning.engineering/posts/2020-02-05-loop-beta/) is a service that allows users to make a Lightning transaction to an onchain Bitcoin address (Loop Out), or send on-chain Bitcoin directly into a Lightning channel (Loop In). Loop can help manage channel liquidity, for example, by emptying out a channel and [acquiring inbound capacity](../../the-lightning-network/liquidity/how-to-get-inbound-capacity-on-the-lightning-network.md) (or refilling a depleted channel).

Lightning Loop uses submarine swaps to transact non-custodially, meaning that Loop is trustless. Loop Out transactions are batched to save on transaction fees.

Loop uses [L402s](../../the-lightning-network/l402/l402.md) for authentication.

{% content-ref url="get-started.md" %}
[get-started.md](get-started.md)
{% endcontent-ref %}

{% content-ref url="the-loop-cli.md" %}
[the-loop-cli.md](the-loop-cli.md)
{% endcontent-ref %}

{% content-ref url="autoloop.md" %}
[autoloop.md](autoloop.md)
{% endcontent-ref %}

{% content-ref url="static-loop-in-addresses.md" %}
[static-loop-in-addresses.md](static-loop-in-addresses.md)
{% endcontent-ref %}

{% content-ref url="instant-loop-outs.md" %}
[instant-loop-outs.md](instant-loop-outs.md)
{% endcontent-ref %}

{% content-ref url="peer-with-loop.md" %}
[peer-with-loop.md](peer-with-loop.md)
{% endcontent-ref %}

{% embed url="https://lightning.engineering/api-docs/api/loop/" %}
