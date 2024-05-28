---
description: >-
  Inbound channel fees allow node operators to more efficiently signal where
  liquidity scarcities occur. This improves capital allocation in the Lightning
  Network and allows channels to be utilized more
---

# Inbound Channel Fees

Inbound channel fees allow a node operator to set a fee on the incoming channel of a payment, as opposed to only the outgoing channel. This allows for a more granular fee schedule, which more accurately signals supply and demand of liquidity.

While it is currently possible to limit the flow of funds to certain peers by raising outbound fees, it is not possible to limit the flow from certain peers.

Inbound channel fees make this possible and solve the problem of “outbound drains.” Such outbound drains are nodes that open channels to you, push their funds outwards through your node and close their channel, leaving you without adequate outbound, an onchain UTXO, and no compensation.

## How inbound channel fees work

Inbound channel fees are available as negative fees, or discounts on the outgoing channel fee. This allows for backwards compatibility, as nodes not compatible with inbound channel fees will still be able to make use of the channels, albeit without making use of the discount.

To allow for safe usage of inbound channel fees, the discount is only applied as long as the total fee is larger than the combined fee of incoming and outgoing channel. This makes it impossible to lose funds through routing.

Inbound channel fees are propagated as part of the general Lightning gossip, as older nodes will pass on information even if they do not understand it themselves.

Positive inbound channel fees can optionally be set as well. However, as these positive inbound channel fees can only be understood by upgraded nodes, setting positive inbound channel fees is risky, as it can lead to routing failures among older nodes.

To be able to set positive inbound channel fees, add the following to your `lnd.conf` file:\
`accept-positive-inbound-fees=true`

For updated nodes, both positive and negative inbound channel fees become part of the network graph and are taken into account when calculating the fee of a potential payment route.

## How to set inbound channel fees

Similar to outbound channel fees, inbound channel fees consist of a flat base fee, expressed in milli-satoshis, and a variable fee rate, expressed in parts per million (ppm).

As of now, inbound channel fees can only be specified through the update channel policy command. For now, inbound channel fees should only be defined as a discount, e.g. set to zero or a negative value.

All other values also have to be set every time this command is called. For example:

`lncli updatechanpolicy --base_fee_msat 100 --fee_rate 1000 --time_lock_delta 80  --inbound_base_fee_msat -1000 --inbound_fee_rate_ppm -100 --chan_point b9740e90782497f9109fbbf4a787b1bf024e480813d781f402679a1ede96043c:0`

\
An empty array should be returned in case of success.
