# Sends

Payments in the Lightning Network are sent over a route, which consists of a set of channels connecting the sending and receiving node. This route could just be a single channel, if you are sending to a peer that you already have a channel open with, or over multiple channels, if you are not connected to the recipient. To protect sender privacy, payments are source-routed, which means that your node is responsible for finding this route from sender to receiver. 

## Pathfinding

Channels in the Lightning Network advertise their capacity, fees that they require to forward payments on your behalf, and the timeout that they require. Finding a path between your node and a destination node is a special case of the shortest path problem, so lnd uses a modified version of [Dijkstra’s algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) to find a path to your destination node, optimizing for low fees and timelock. 

Fee and time lock information is openly available, but the distribution of balances across lightning channels is not disclosed to the network. This is a privacy measure to ensure that surveillance nodes cannot attempt to connect senders to recipients by tracing changes in balance across the network. Lack of knowledge about node balances is the primary reason that payments fail - your node will select channels that have sufficient capacity to carry your payment, but when it is dispatched, the payment may fail because there is insufficient balance in the channel in the direction you are routing. 

### Mission Control

The Mission Control subsystem in `lnd` keeps track of your node’s previous payments, and uses the success and failure information to inform future routing attempts based on this dynamic information. It tracks the amounts that succeed and fail when we attempt to route through certain channels, which gives us a better idea of what the distribution of balance across the channel’s capacity is, and which nodes to avoid if they constantly fail us. The more payments you make, the more accurate your path finding will become!

The information that mission control learns is time sensitive; failures caused by nodes not having the correct liquidity balance in their channels for a certain amount may resolve themselves after time, because the node processes payments in the opposite direction, or uses a service like [Lightning Loop](https://lightning.engineering/loop/) to manage their liquidity. 

Mission control’s defaults can be updated to better cater this subsystem to your need:

<table>
  <thead>
    <tr>
      <th style="text-align:left"><b>routerrpc.minrtprob</b>
      </th>
      <th style="text-align:left">
        <p><b>The probability of success that is required for a route to dispatch a payment. Note that we will not attempt a payment at all if we cannot find a route with this probability of success, so setting your node to require 100%, while appealing, would result in very few payments being made.<br /></b>
        </p>
        <p><b>default: 0.01 /1%</b>
        </p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left"><b>routerrpc.apriorihopprob</b>
      </td>
      <td style="text-align:left"><b>The probability that we assign to hops that we currently have no information about. Lower values indicate that we are less trustful of unknown-hops, higher values indicate that we are more willing to take a chance.<br /><br />default: 0.6/ 60%</b>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>routerrpc.aprioriweight</b>
      </td>
      <td style="text-align:left">
        <p><b>A value in [0;1] which determines how we use mission control data. Setting this value to 1 ignores historical results and relies solely on apriori hop probabilities; setting it to 0 relies only on historical information.</b>
        </p>
        <p><b><br />default: 0.5</b>
        </p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left"><b>penaltyhalflife</b>
      </td>
      <td style="text-align:left">
        <p><b>Since data gathered by mission control is time-sensitive, we need to account for the fact that the data we gather will become out-of-date. This value determines how long it takes for a hop to recover to 50% probability. <br /></b>
        </p>
        <p><b>default 1 hour</b>
        </p>
      </td>
    </tr>
  </tbody>
</table>

### **Prepay Probes**

For best results when dispatching a payment, we recommend the use of a prepay probe. This involves dispatching a payment to your destination node that it will not recognize, and inspecting the error returned to ensure that the payment made it all the way to the destination node. This is helpful for providing mission control with up-to-date information about the path to your destination, and for providing end users with accurate fee information. 

To send a prepay probe, create a payment to your destination with the same amount as your real payment, and set a strong-random payment hash. We expect this payment to fail with _FAILURE\_REASON\_INCORRECT\_PAYMENT\_DETAILS_, because the recipient node does not know the preimage. If your prepay fails with another error, your main payment is unlikely to succeed, so you can inform the end user that the payment is not possible. Testing out payments like this also prevents your likelihood of stuck payments, covered in detail in the Monitoring Payments section. 

## Dispatching Payments

This section covers the use of the _SendPaymentV2_ API endpoint, which finds a route to your destination and dispatches the payment on your behalf. If you would like to manually find a route and dispatch it, this can be done with _QueryRoutes_ and _SendToRouteV2_. This is only recommended for advanced users, and will not be covered in this section.

`lnd` will handle pathfinding on your behalf, but the following parameters can be helpful in tuning pathfinding to fit your requirements:  


<table>
  <thead>
    <tr>
      <th style="text-align:left">timeout_seconds</th>
      <th style="text-align:left">
        <p>The maximum amount of time that we should spend trying to dispatch the
          payment. Note that this is not the total time that the payment will take,
          because a successfully dispatched payment may still take time to be settled
          back to our node.
          <br />
        </p>
        <p>This value can be adjusted with time preference; if you&#x2019;re willing
          to wait longer, and send more payment attempts, setting a higher value
          may lead to greater payment successes. However, if you need to quickly
          give user feedback, a lower value should be set.</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">max_parts</td>
      <td style="text-align:left">
        <p>The number of parts that your payment can be split into to complete the
          payment. Setting a value &gt; 1 makes your payment a Multi-Part-Payment,
          which makes it easier to route because the total amount can be split up
          into smaller parts.
          <br />
        </p>
        <p>Default: 1</p>
      </td>
    </tr>
    <tr>
      <td style="text-align:left">outgoing_chan_ids</td>
      <td style="text-align:left">The set of your channels that you would like the payment to. This can
        be useful for managing your own liquidity, but may affect the success or
        fee of the payment if the channels you select don&#x2019;t have a route
        to the destination, or have a more expensive one.</td>
    </tr>
    <tr>
      <td style="text-align:left">fee_limit_msat</td>
      <td style="text-align:left">The maximum fee you are willing to pay, expressed in millisatoshis.</td>
    </tr>
  </tbody>
</table>

### Payment Fees

Nodes in the Lightning Network that route payments on behalf of other nodes charge fees in exchange for the use of their capital. Each node in the network is free to set their fees as they see fit. If you send a multi-hop payment \(ie, a payment that is not to one of the nodes you have a direct channel with\), your will need to pay fees per-hop that the payment uses. 

Fee policies are structured with the following parameters:

* Base fee: a set amount, charged per forwarded HTLC
* Fee rate: an amount charged based on the amount being forwarded 

[Multi-Part-Payments](https://lightning.engineering/posts/2020-05-07-mpp/) split payments up into multiple routes, which helps get around bottlenecks in the capacity of the network, but means that more fees will be paid, because your payment has more base fees to pay. 

### Invoice vs Keysend

Payments can be made to an invoice supplied by the destination node, or using the experiential keysend feature, which is supported by all major implementations \(although un-upgraded nodes may not be able to receive these payments\). You may choose to support one or both of these sending methods, please consult the comparison table below to assess suitability for your use case:

|  | **Invoice** | **Keysend** |
| :--- | :--- | :--- |
| Interaction with Destination  | Invoice must be obtained from destination | No interaction required |
| Support | BOLT 11 complaint invoices should be accepted by all implementations.  | Requires that Feature Bit 9, TLV Onion, is set by the destination node. |
| Proof of Payment | Recipient sets preimage, providing cryptographically verifiable proof of payment | Sender sets preimage, no proof of payment.  |

#### Invoice Payment

If you have an invoice for the node you are paying, you can send a payment using only the encoded payment request that is included in the invoice. This string contains all of the information that your node requires to send the payment to its destination. 

#### Keysend Payment

If you are sending a keysend payment to a node which supports them, you will need to specify the payment amount and destination so that your node knows where to send the payment, as well as opting-in to the keysend.  


| amt\_msat | The amount to send the peer.  |
| :--- | :--- |
| dest | The public key of the node that you want to send the payment to.  |

## Monitoring Payments

The process of creating and settling a payment happens in two stages:

* Hops along the route add a htlc for the payment to their commitment, irrevocably committing them to settling the htlc or timing it out once its timeout elapses.
* Once the htlc is locked in, the receiving node will settle the htlc using the preimage, and each node along the route will remove the htlc from its commitment and shift the balance of funds to reflect this payment. 

If your payment fails in this first stage, perhaps because a node along the route was offline, or did not have sufficient balance to forward the payment, it is safe to retry. However, once the htlc is locked in along the route, the payment must be resolved. Ideally this occurs quickly, with the reveal of the preimage. However, if the receiving node does not release the preimage, or a node along the route goes offline, the payment will only be resolved after it times out. This is what is sometimes referred to as a “stuck payment”, it cannot be retried, and the sender needs to wait a long time before it can resolve the payment as failed or successful. 

The _TrackPaymentV2_ endpoint in `lnd` provides a reliable stream of information regarding the state of a payment. It can also be used as a payment lookup function for payments in a final state, because the stream will terminate if the payment state is final. It returns the following states for a payment:

* In Flight: the payment is still in the process of locking in htlcs along the route to the destination
* Succeeded: the payment was successful
* Failed: the payment permanently failed, and will not be reattempted.

