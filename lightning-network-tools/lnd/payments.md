# Sending Payments

Payments in the Lightning Network are sent over a route, which consists of a set of channels connecting the sending and receiving node. This route could just be a single channel, if you are sending to a peer that you already have a channel open with, or over multiple channels, if you are not connected to the recipient. To protect sender privacy, payments are source-routed, which means that your node is responsible for finding this route from sender to receiver.

## Pathfinding

Channels in the Lightning Network advertise their capacity, fees that they require to forward payments on your behalf, and the timeout that they require. Finding a path between your node and a destination node is a special case of the shortest path problem, so lnd uses a modified version of [Dijkstra’s algorithm](https://en.wikipedia.org/wiki/Dijkstra's\_algorithm) to find a path to your destination node, optimizing for low fees and timelock.

Fee and time lock information is openly available, but the distribution of balances across lightning channels is not disclosed to the network. This is a privacy measure to ensure that surveillance nodes cannot attempt to connect senders to recipients by tracing changes in balance across the network. Lack of knowledge about node balances is the primary reason that payments fail - your node will select channels that have sufficient capacity to carry your payment, but when it is dispatched, the payment may fail because there is insufficient balance in the channel in the direction you are routing.

### Mission Control

The Mission Control subsystem in `lnd` keeps track of your node’s previous payments, and uses the success and failure information to inform future routing attempts based on this dynamic information. It tracks the amounts that succeed and fail when we attempt to route through certain channels, which gives us a better idea of what the distribution of balance across the channel’s capacity is, and which nodes to avoid if they constantly fail us. The more payments you make, the more accurate your path finding will become!

The information that mission control learns is time sensitive; failures caused by nodes not having the correct liquidity balance in their channels for a certain amount may resolve themselves after time, because the node processes payments in the opposite direction, or uses a service like [Lightning Loop](https://lightning.engineering/loop/) to manage their liquidity.

Mission control’s defaults can be updated to better cater this subsystem to your need:

| Parameter                | Description                                                                                                                                                                                                                                                                                                                       |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| routerrpc.minrtprob      | <p>The probability of success that is required for a route to dispatch a payment. Note that we will not attempt a payment at all if we cannot find a route with this probability of success, so setting your node to require 100%, while appealing, would result in very few payments being made.<br></p><p>default: 0.01 /1%</p> |
| routerrpc.apriorihopprob | <p>The probability that we assign to hops that we currently have no information about. Lower values indicate that we are less trustful of unknown-hops, higher values indicate that we are more willing to take a chance.<br><br>default: 0.6/ 60%</p>                                                                            |
| routerrpc.aprioriweight  | <p>A value in [0;1] which determines how we use mission control data. Setting this value to 1 ignores historical results and relies solely on apriori hop probabilities; setting it to 0 relies only on historical information.</p><p><br>default: 0.5</p>                                                                        |
| penaltyhalflife          | <p>Since data gathered by mission control is time-sensitive, we need to account for the fact that the data we gather will become out-of-date. This value determines how long it takes for a hop to recover to 50% probability.<br></p><p>default 1 hour</p>                                                                       |

### **Prepay Probes**

For best results when dispatching a payment, we recommend the use of a prepay probe. This involves dispatching a fake payment to your destination node that it will not recognize, and inspecting the error returned to ensure that the payment made it all the way to the destination node. This is helpful for providing mission control with up-to-date information about the path to your destination, and for providing end users with accurate fee information.

To send a prepay probe, create a payment to your destination with the same amount as your real payment, and set a strongly-random payment hash. We would expect this payment to fail with _FAILURE\_REASON\_INCORRECT\_PAYMENT\_DETAILS_ if it reaches the destination node, because the recipient node does not know the preimage. If your prepay fails with another error, your main payment is unlikely to succeed, so you can inform the end user that the payment is not possible. Testing out payments like this also prevents your likelihood of stuck payments, covered in detail in the Monitoring Payments section.

The downside of using prepay probes is that it may limit the ability to leverage multi-part payments (MPP), and forwarding nodes are not compensated for the cost of forwarding the probe payment.&#x20;

### Prepay Probes to Private Wallets

Probing to a private Lightning wallet can sometimes provide challenges, especially if the user is a self-custodied mobile user. The best practice to observe in this case is to instead probe to the final hop node before the destination wallet, compute the total fee that will be paid for the user, and then once the user has agreed to the fee, dispatch the payment as described below.

These specific private Lightning wallets can be identified in two ways:

1\) The invoices they generate include `route_hints`, like in this dummy invoice decoded with `lncli decodepayreq`:

```
{
    "destination": "03d710aa8a1231f054f51aea39a19eb28d0ccfe687d4223e1bc013b12639acecb6",
    "payment_hash": "1effc86c64293bda832c498103adf52f3d6d98f1afa050ad5b0d17043c67ee95",
    "num_satoshis": "10000",
    "timestamp": "1692057841",
    "expiry": "86400",
    "description": "",
    "description_hash": "",
    "fallback_addr": "",
    "cltv_expiry": "40",
    "route_hints": [
        {
            "hop_hints": [
                {
                    "node_id": "0352937e521b2a2ed4b9c880765efd0f12987f6f1593d0756ea7889f92aa9a2ae5",
                    "chan_id": "151732604698624",
                    "fee_base_msat": 1000,
                    "fee_proportional_millionths": 1,
                    "cltv_expiry_delta": 40
                }
            ]
        }
    ],
    "payment_addr": "e933852d3f68890415b195298a5d4f27d2a28046c2b6ed63edd1fa321d9f97a7",
    "num_msat": "10000000",
    "features": {
        "9": {
            "name": "tlv-onion",
            "is_required": false,
            "is_known": true
        },
        "14": {
            "name": "payment-addr",
            "is_required": true,
            "is_known": true
        },
        "17": {
            "name": "multi-path-payments",
            "is_required": false,
            "is_known": true
        }
    }
}
```

2\) Their destination node doesn't appear in the public graph, which can be checked like this:

```
$ lncli getnodeinfo 03d710aa8a1231f054f51aea39a19eb28d0ccfe687d4223e1bc013b12639acecb6
[lncli] rpc error: code = NotFound desc = unable to find node
```

If as a wallet operator, you are presented an invoice that includes `route_hints` AND a `destination` pubkey that does not appear in the graph, we recommend using a special type of prepay probe that checks the route to the final hop node before the destination wallet, and then computes what the total fee will be paid for the user using the provided information. In pseudocode, this is what the probing function should look like:

```
func probe (invoice, payment_amount):

	if route_hints is empty:
		route_hints = [destination_node]

	min_fee = infinite

	for each route_hint in invoice:
		private_route_hint = remove announced channels from the front of route_hint
		public_node = extract first node from private_route_hint
		final_hop_fee = fee from traversing private_route_hint with payment_amount
		probing_amount = payment_amount + final_hop_fee
		public_fee, success = execute probe for probing_amount to public_node
		if success:
			// it may make sense to return here if prioritizing speed
			min_fee = min(min_fee, public_fee + final_hop_fee)

	return min_fee
```

One potential implementation could look like this. From the invoice, the wallet operator deduces what the `final_hop_fee` (which will not be tested in the probe payment) will be as follows. It is possible to see more than one `hop_hints` in a single `route_hint`, but very unlikely:

```
final_hop_fee = payment_request.route_hints[0].hop_hints.reverse().reduce((output_amount, hop) => \
> hop.fee_base_msat / 1000 + payment_request.num_satoshis * hop.fee_proportional_millionths / 1000000 + \
> payment_request.num_satoshis, payment_request.num_satoshis) - payment_request.num_satoshis
```

The probe command itself should look like this (where `payment_request` is represented by the decoded JSON in 1) above):

```
lncli sendpayment \
> dest=payment_request.route_hints.hop_hints.node_id \
> amt=payment_request.num_satoshis + final_hop_fee \
> payment_hash=random32bytes
```

As expected, this probe payment will fail and return both the total fee to get to the last hop before the destination (`probe_fee`), and the error `FAILURE_REASON_INCORRECT_PAYMENT_DETAIL`. The total fee that the user will pay will be the fee returned from the probe plus:

The user can then be presented with `probe_fee + final_hop_fee`, and, assuming they accept, the payment can be dispatched.

In the case of multiple `route_hints` per invoice, we recommend executing a probe per `route_hint` until an acceptable total fee is discovered to present the user with. In practice, we would be surprised to see more than two `route_hint`s per invoice generated by a node not in the public graph.

## Dispatching Payments

This section covers the use of the _SendPaymentV2_ API endpoint, which finds a route to your destination and dispatches the payment on your behalf. If you would like to manually find a route and dispatch it, this can be done with _QueryRoutes_ and _SendToRouteV2_. This is only recommended for advanced users, and will not be covered in this section.

`lnd` will handle pathfinding on your behalf, but the following parameters can be helpful in tuning pathfinding to fit your requirements:

| Parameter           | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| timeout\_seconds    | <p>The maximum amount of time that we should spend trying to dispatch the payment. Note that this is not the total time that the payment will take, because a successfully dispatched payment may still take time to be settled back to our node.<br></p><p>This value can be adjusted with time preference; if you’re willing to wait longer, and send more payment attempts, setting a higher value may lead to greater payment successes. However, if you need to quickly give user feedback, a lower value should be set.</p> |
| max\_parts          | <p>The number of parts that your payment can be split into to complete the payment. Setting a value > 1 makes your payment a Multi-Part-Payment, which makes it easier to route because the total amount can be split up into smaller parts.<br></p><p>Default: 1</p>                                                                                                                                                                                                                                                             |
| outgoing\_chan\_ids | The set of your channels that you would like the payment to go through. This can be useful for managing your own liquidity, but may affect the success or fee of the payment if the channels you select don’t have a route to the destination, or have a more expensive one.                                                                                                                                                                                                                                                      |
| fee\_limit\_msat    | The maximum fee you are willing to pay, expressed in millisatoshis.                                                                                                                                                                                                                                                                                                                                                                                                                                                               |

### Payment Fees

Nodes in the Lightning Network that route payments on behalf of other nodes charge fees in exchange for the use of their capital. Each node in the network is free to set their fees as they see fit. If you send a multi-hop payment (ie, a payment that is not to one of the nodes you have a direct channel with), your node will need to pay fees per-hop that the payment uses.

Fee policies are structured with the following parameters:

* Base fee: a set amount, charged per forwarded HTLC
* Fee rate: an amount charged based on the amount being forwarded

[Multi-Part-Payments](https://lightning.engineering/posts/2020-05-07-mpp/) split payments up into multiple routes, which helps get around bottlenecks in the capacity of the network, but means that more fees will be paid, because your payment has more base fees to pay.

### Invoice vs Keysend

Payments can be made to an invoice supplied by the destination node, or using the experimental keysend feature, which is supported by all major implementations (although un-upgraded nodes may not be able to receive these payments). You may choose to support one or both of these sending methods, please consult the comparison table below to assess suitability for your use case:

|                              | Invoice                                                                        | Keysend                                                                 |
| ---------------------------- | ------------------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| Interaction with Destination | Invoice must be obtained from destination                                      | No interaction required                                                 |
| Support                      | BOLT 11 complaint invoices should be accepted by all implementations.          | Requires that Feature Bit 9, TLV Onion, is set by the destination node. |
| Proof of Payment             | Recipient sets preimage, providing cryptographicly verifiable proof of payment | Sender sets preimage, no proof of payment.                              |

#### Invoice Payment

If you have an invoice for the node you are paying, you can send a payment using only the encoded payment request that is included in the invoice. This string contains all of the information that your node requires to send the payment to its destination.

#### Keysend Payment

If you are sending a keysend payment to a node which supports them, you will need to specify the payment amount and destination so that your node knows where to send the payment, as well as opting-in to the keysend.

| Parameter | Description                                                      |
| --------- | ---------------------------------------------------------------- |
| amt\_msat | The amount to send the peer.                                     |
| dest      | The public key of the node that you want to send the payment to. |

## Monitoring Payments

The process of creating and settling a payment happens in two stages:

* Hops along the route add a HTLC for the payment to their commitment, irrevocably committing them to settling the HTLC or timing it out once its timeout elapses.
* Once the HTLC is locked in, the receiving node will settle the HTLC using the preimage, and each node along the route will remove the HTLC from its commitment and shift the balance of funds to reflect this payment.

If your payment fails in this first stage, perhaps because a node along the route was offline, or did not have sufficient balance to forward the payment, it is safe to retry. However, once the HTLC is locked in along the route, the payment must be resolved. Ideally this occurs quickly, with the reveal of the preimage. However, if the receiving node does not release the preimage, or a node along the route goes offline, the payment will only be resolved after it times out. This is what is sometimes referred to as a “stuck payment”, it cannot be retried, and the sender needs to wait a long time before it can resolve the payment as failed or successful.

The _TrackPaymentV2_ endpoint in `lnd` provides a reliable stream of information regarding the state of a payment. It can also be used as a payment lookup function for payments in a final state, because the stream will terminate if the payment state is final. It returns the following states for a payment:

* In Flight: the payment is still in the process of finding and path locking in HTLCs along the route to the destination
* Succeeded: the payment was successful
* Failed: the payment permanently failed, and will not be reattempted.
