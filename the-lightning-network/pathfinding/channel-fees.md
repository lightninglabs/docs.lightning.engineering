# Channel Fees

In the Lightning Network, routing nodes are able to charge a fee for forwarding payments, so-called Hash-Time-Locked-Contracts (HTLCs). This compensation is necessary to incentivize the efficient allocation of capital in the network to be able to receive and send fees inside of the network.

On the HTLC level, channel fees are the difference between the HTLC sent to the routing node, and the HTLC sent from the routing node onwards. As an example, if you are presented a 1000 satoshis invoice from a node one hop away that charges 1 satoshi, you will send an HTLC over 1001 satoshis to the routing node, which sends a 1000 satoshis HTLC to the final recipient.

[Read more: Hash Time-lock Contracts](https://docs.lightning.engineering/the-lightning-network/multihop-payments/hash-time-lock-contract-htlc)

As fees are included in the payment, and all HTLCs contingent on the same preimage, you can only charge fees for successful payments.

Fees are applied only once per peer and per channel. Each peer can independently set their fee policies for all their channels, which are applied to the capital in the outoing channel in the event of a forward. Meaning, as you push a payment to your neighbor node, you are able to charge a fee, and as payments are pushed to you, your neighbor charges the fee, even if the channel was created by you. Another rule of thumb is that when your capital in a channel is depleted, you get to charge the fee.

There are two kinds of fees, the base fee and the fee rate.

## Base fee <a href="#docs-internal-guid-26e6ce80-7fff-d1fc-7a0e-94728676bd0a" id="docs-internal-guid-26e6ce80-7fff-d1fc-7a0e-94728676bd0a"></a>

The base fee is a fixed sum that is charged on each forward, typically 1 satoshi. You may also set this base fee higher or to 0, or charge any amount of millisatoshis.

As each forward costs you computational power and storage, the base fee is meant to compensate you for your efforts of forwarding any payment. For example, for each new channel state your node has to keep a new revocation key on file. In case you are using a watchtower, this information has to be sent and stored on the watchtower as well. Such information has to be stored until the channel is closed, which can be costly. Choose your base fee wisely!

## Fee rate <a href="#docs-internal-guid-2bf18532-7fff-0072-5350-0251529b2c93" id="docs-internal-guid-2bf18532-7fff-0072-5350-0251529b2c93"></a>

The fee rate is a proportion of the payment that you forward, typically measured in parts per million (ppm).

It is meant to compensate you for the capital that you commit to your Lightning channels.

[Read more: Update your channel fees](../../lightning-network-tools/lnd/channel-fees.md)
