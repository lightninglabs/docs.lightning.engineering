---
description: Learn how to install Taro, mint and transfer assets.
---

# Taro

The Taro Daemon `tarod` implements the [Taro protocol](https://github.com/Roasbeef/bips/blob/bip-taro/bip-taro.mediawiki) for issuing assets on the Bitcoin blockchain. Taro leverages Taproot transactions to commit to newly created assets and their transfers in an efficient and scalable manner. Multiple assets can be created and transferred in a single bitcoin UTXO, while witness data is transacted and kept off-chain.

{% content-ref url="get-taro.md" %}
[get-taro.md](get-taro.md)
{% endcontent-ref %}

{% content-ref url="first-steps.md" %}
[first-steps.md](first-steps.md)
{% endcontent-ref %}

{% embed url="https://lightning.engineering/api-docs/api/taro/" %}
Taro API documentation
{% endembed %}
