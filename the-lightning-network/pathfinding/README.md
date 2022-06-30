# Pathfinding

In the Lightning Network, a payer decides on the route they want their payment to take. Ideally they find a direct and cheap path quickly, but, in some cases, they might have to attempt multiple available routes with varying fees.

Nodes may employ different strategies for how to most efficiently find the most economical route to their destination quickly. In some implementations, nodes may outsource pathfinding to an external party.

Routes are onion encrypted, meaning only the sender sees the full route. All nodes along the route will only see what channel a payment is coming from and going to. The recipient does not learn the origin of the payment, only of its final hop.

{% content-ref url="finding-routes-in-the-lightning-network.md" %}
[finding-routes-in-the-lightning-network.md](finding-routes-in-the-lightning-network.md)
{% endcontent-ref %}

{% content-ref url="channel-fees.md" %}
[channel-fees.md](channel-fees.md)
{% endcontent-ref %}

{% content-ref url="multipath-payments-mpp.md" %}
[multipath-payments-mpp.md](multipath-payments-mpp.md)
{% endcontent-ref %}
