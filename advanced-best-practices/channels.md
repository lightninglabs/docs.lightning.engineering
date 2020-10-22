# Channels

Once your node is set up and funded, it’s time to open some channels so that you can transact off chain. This section will primarily focus on peer selection and the process of opening and closing channels. 

## Peer Selection

A good peer makes all the difference to the operation of a node. Every off chain transaction that your node participates in involves cooperation with one of your peers. When sending a payment, your node selects one of your channels to dispatch the payment on, sends it a request to add a HTLC for the payment, and later the peer will settle or fail the HTLC depending on the outcome of the payment. Likewise for reciepts, the peer that delivers a payment to your node will send your node a request to add a HTLC, and your node will later settle or fail the HTLC back. Adding, failing and settling HTLC all require interaction with your peer, because you need to agree on and sign a new shared state to reflect the new balance in the channels involved. 

If your peer is unavailable to update this shared state, the channels that you have with them can't be used for any further payments or reciepts, because you cannot negotiate new state with them. Further, if you have any pending HTLCs on your commitment \(which would be the case if a HTLC was added, but the peer went offline before it could be settled or failed back\), you will have to wait until your peer comes back online to resolve those payments. In the worst case, if your peer remains offline, your node will need to broadcast its latest commitment state on chain to resolve the HTLCs that are stuck. This is undesirable, because your payments will take a long time to resolve, and your node will need to pay on-chain fees to resolve these HTLCs. 

Selecting good peers to open channels with \(and limiting the channels that your node accepts\) will provide you with a more relably operating node, and keep your on-chain costs down. The sub-sections that follow outline some strategies for identifying good peers in the network. 

### Network Information

Nodes in the network gossip information about channels to one another so that they can build up a view of the network for routing. Information about the number of channels a node has, their size and age is publicly available - see the _DescribeGraph_ command. The channel updates gossiped on the network also include a _disabled_ flag, which nodes set when their channel peer have been unreachable for ~20 minutes. These updates are available for every public channel in the network, and can be monitored to get an approximate measure of a node's uptime before opening a channel with it. The _SubscribeChannelGraph_ API provides a live stream of these updates. See [our blog post](https://lightning.engineering/posts/2019-11-07-routing-guide-2/) covering peer selection for more details regarding how this information can be used to select good peers. 

### Routing

Another consideration when opening channels with a peer is how they will serve you as a routing node. A good peer is well positioned in the network, and actively maintains channels with other good peers. This is why it is not always a good idea to just connect to the most “popular” nodes in the network - they have a lot of channels, but those channels may be with nodes that are poorly maintained, or even offline, which will not facilitate routing well. 

### BOS Scores

Lightning Labs maintains a set of scores called the [BOS scores](https://nodes.lightning.computer/availability/v1/btc.json) which monitor assess a node’s ability to receive an average sized payment. These scores take into account the scores that a node’s peers have, as well as network level information, as covered in the previous section. The highest possible BOS score is 100,000,000, and we do not report nodes that have a score less than 10,000,00. 

At the time of writing, only 5% of the channels in the Lightning Network obtained scores higher than the 10,000,00 minimum and only 7.6% of the nodes in that category achieved perfect scores. These statistics tell the story of the structure of the Lightning Network; while there are many public channels, only a few nodes are maintaining serious routing nodes. We expect these numbers to grow as the network matures and node management is simplified and automated. In these early stages of the network, we recommend connecting with nodes on the BOS scores list to ensure that you do not peer with unperformant nodes.

![](https://lh6.googleusercontent.com/Dr95i_VmhbrVfUWYdxa-PTzcQX54PSlPsUkzNh3M_CtXqFBdlBaI5qtzlWPPEUviv81k7FNtSX16HMqBED7gtMVkl31QT9fkBYmuxiqF35xCWrncthGMj6zuvRrcnq8AUccUfCOf)

### Betweenness Centrality

The betweenness centrality of a node reflects the number of shortest paths a node lies on, where a shortest path is defined as the path between two nodes in the network with the fewest hops. Connecting to nodes with good betweenness centrality positions your node on many shortest paths, which positions you well for sending, receiving and routing payments. The _GetNodeMetrics_ endpoint in `lnd` provides a normalized set of betweenness centrality metrics:

```text
$ lncli getnodemetrics
    "03cd9ff03194229804da2b35201bee7106c1f782283c8e613909af8f7dae66d1fa": {
         "value": 9.971403494290085,
         "normalized_value": 0.00001685847661936634
    },
    "03cdf70eb84607142fbef5a2b33c6150f77d269ab18b31467282ac22735e96dddb": {
         "value": 0,
         "normalized_value": 0
    },
    "03ce15db49e389edd19c5332ca112514d4e63fdaefa3f748781b0bee3d35b9ad21": {
         "value": 0,
         "normalized_value": 0
    }
```

This value is normalized between 0 and 1, meaning that a score of 0 means that the node is not on any shortest paths, and a score of 1 meaning that the node lies on every shortest path in the network. 

### Availability

Available peers are counted as good peers because you are less likely to need to resort to on chain resolution, and they can be relied upon to quickly process payments. Since your node is not connected to every node in the network, it is difficult to determine what the uptime of a peer will be before you open a channel with it and see for yourself. Measures like the disabled flag discussed in the Network Information section, or curated scores such as the BOS scores can be used as a proxy for node availablilty. 

However, if you already have a channel open with a peer, you can see its current uptime and the amount of time that this uptime has been monitored for using the _ListChannels_ endpoint. Note that we only monitor uptime of peers that we have channels open with because they have an incentive to remain connected to us. If you are looking to open another channel with one of your existing peers, this is a good measure to check before doing so. 

```text
$ lncli listchannels
"remote_pubkey": "03b25c204679cde4ddd77b2c338f468b76b29b74569a8d39c04bfc89d8c",
...
"lifetime": "1280847", // total time we have monitored this peer for (seconds)
"uptime": "1280783", // total time the peer has been online for (seconds)
```

## Opening Channels

Once you have chosen a peer to open a channel with, you need to connect to that peer to open a channel. This requires knowledge of the peer node’s public key, IP address and the port that it is listening for peer connections on. You can check whether you are connected with a peer by looking for its public key in the output of the _ListPeers_ endpoint, and the _ConnectPeer_ endpoint can be used if you are not currently connected to them. 

```text
$ lncli listpeers | grep 03b25c204679cde4ddd77b2c396f000638f468b76b29b74569a8d39c0
"pub_key": "03b25c204679cde4ddd77b2c396f000638f468b76b29b74569a8d39c0"
```

### Open Channel Parameters

The parameters you select for your channel determine how your channel can be used, as well as its security and visibility to the network. 

### Funding Parameters

The first decision that needs to be made is the amount of funds that you would like to place in your node. Note that you will need to run your node with the _--protocol.wumbo-channels_ flag to allow creation of channels that are larger than 0.16 BTC.

| Parameter | **Description** |
| :--- | :--- |
| local\_funding\_amount | The amount of funds to contribute to the channel, exclusive of the fees that will be paid on chain to fund the channel. If a push amount is set, this value will be inclusive of the push amount. |
| push\_sat | The amount of satoshis to give to your channel peer. This is not recommended unless you would like to part with your sats! |

###  Fee Parameters

If you would like to set custom fees for your channel’s funding transaction, this can either be done by setting the number of blocks that you would like your transaction to confirm in, or by setting a manual fee rate:

| Parameter |  |
| :--- | :--- |
| target\_conf | The number of block that you would like your funding transaction to confirm in, using bitcoind’s built-in fee estimator |
| sat\_per\_byte | A manual fee rate set in satoshis per byte that should be used to create the funding transaction. Note that peers may give up on channels that do not confirm within 2 weeks, so this value should aim to at least confirm within two weeks. No funds will be lost if the transaction does not confirm.  |

### Routing Parameters

Channels in the Lightning Network can forward payments on behalf of other nodes in exchange for fees. Nodes that would like to do so advertise their channels to the network, and ideally maintain good liquidity and uptime so that they can reliably route payments. If you would not like to advertise your channel to the network for operational or privacy reasons, the private parameter can be set for your channel. 

| Parameter | Description |
| :--- | :--- |
| private | Whether a channel should be private, false by default. |

If you do intend to route payments, the minimum htlc parameter can be used to place a limit on the size of payment that you are willing to route. In the event that your peer goes offline while you have unresolved payments in your channel that are nearing expiry, your `lnd` node will force close the channel and resolve it on chain. In this case, `lnd` will broadcast a sweep transaction that spends these funds back to our node on chain, which costs use fees. Toggling this minimum amount allows you to set the minimum amount that you’ll allow your node to go on chain for. Setting a higher minimum HTLC value also helps to protect your node against being spammed with small payments. 

<table>
  <thead>
    <tr>
      <th style="text-align:left">Parameter</th>
      <th style="text-align:left">Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">min_htlc_msat</td>
      <td style="text-align:left">
        <p>The minimum amount that your channel will accept.</p>
        <p></p>
        <p>Default: 1 millisatoshi</p>
      </td>
    </tr>
  </tbody>
</table>

### Security Parameters

Trustlessness is achieved in the Lightning Network through the use of the LN-Penalty mechanism, which allows your node to claim all of your peer’s funds if they try to cheat you by broadcasting an old state. When a channel is force closed by one of the parties in the channel, all of their funds are unavailable for a period of time, to allow the other party to claim this penalty if they were cheated. From our perspective, the delay on the remote peer’s funds represents the amount of time that we have to see that our peer has attempted to cheat us, and to claim our penalty on-chain. 

| Parameter | Description |
| :--- | :--- |
| remote\_csv\_delay | The number of blocks that we require the remote party’s channels be delayed by when they force close a channel. By default, this value is scaled with channel size. |

If your peer supports the upfront-shutdown-script feature, see _ListPeers_ to check whether they do, you can set the address that you would like the channel to close out to on cooperative close on channel creation. This can be useful for setting your channels to close out to cold storage, or a specific operational wallet by default. Peers that support the feature will not accept cooperative channel closes to any other address. 

Note that this address is not paid out in the event of a force close, so the security guarantee provided by this feature is limited. It should be treated more as a convenience field than a security assurance. 

| Parameter | Description |
| :--- | :--- |
| close\_address | The address that funds should be paid out to in the event of a cooperative close. This address does not need to be controlled by LND, so can pay funds directly out to cold storage \(for example\) on channel close.  |

### Channel Opening Process

The process of opening a channel is as follows:

* The nodes creating the channel exchange the information and signatures required to create the channel.
* The funding transaction is broadcast on chain, creating a 2-of-2 multisig output, which is referred to as the funding outpoint, or channel point. 
* The funding channel reaches the number of confirmations that are required, and the channel becomes usable. 

A channel open can be initiated synchronously using the _OpenChannelSync_ endpoint that will unblock once the funding transaction has been broadcast, or asynchronously using the OpenChannel endpoint which will deliver a stream of updates throughout the channel opening process, terminating once the channel has confirmed on chain. 

### **Accepting Channels**

If your node accepts inbound connections from peers, or you have previously created an outbound connection to a peer, they can open a channel to your node. Since they contribute the funds for the channel in the current version of the protocol, the default behavior of your node is to accept the channel. 

Accepting channels from bad peers can be detrimental to your node in a variety of ways. If the peer has bad uptime, or often restarts, your node may attempt to forward a payment through the peer, which gets stuck because the peer subsequently goes offline and it cannot be settled or failed back to you. In the worst case, your node will need to force close the channel to resolve the HTLC on chain, which costs fees.

Although it is not always the case, badly run nodes tend to open channels with lnd’s default fee settings. This will make them attractive to your node’s pathfinding logic, because these fees tend to be lower than performant nodes on the network that charge for the quality they provide, thus compounding the problem. `lnd`’s routing subsystem will learn to ignore these bad peers as payments fail, but your node will still need to learn that lesson the hard way.

Recent literature covering attacks on the Lightning Network point to the low cost of setting up a node and opening channels to would-be victims as a low barrier to entry for potential attackers. Only accepting channels from more established and maintained nodes \(as covered in our peer selection section\) increases the cost of attack, and thus decreases its likelihood, because an attacker has to dedicate time and money towards creating a node that can open a channel with yours.

LND has a channel acceptor endpoint which allows you to dynamically accept or reject channels based on your own logic. Once you have called the _ChannelAcceptor_ endpoint, `lnd` will send channel open requests which your custom logic can decide to accept or reject.

| Parameter | Description |
| :--- | :--- |
| acceptortimeout | The amount of time we allow the channel acceptor to respond before we return false. Defaults to 15 seconds.  |

The following channel acceptors could be useful for a production-level lightning node:

* Only accept nodes that are on the BOS scores list
* Place a soft-limit on the size of channels that your will accept 
* Limit the peers that you will accept channels from

## Monitoring Channels

The _SubscribeChannels_ endpoint provides callers with a stream of updates which will notify you of channel opens, closes and updates. This stream can be used to monitor your current set of channels in realtime and ensure that your node has sufficient channels open for your purposes. 

The following notifications are provided:

* Pending open: once the process of negotiating signatures for a new channel is complete, and the funding transaction is ready to be broadcast, a pending open notification is dispatched. 
* Open: once the funding transaction has reached the required number of confirmations, a channel open notification will be dispatched. 
* Active Channel: once LND is ready to start using a channel to route payments an active notification is sent. 
* Inactive Channel: if a channel becomes unusable, which may occur in the case where LND is preparing to close the channel, or an error occurs, an inactive channel notification is dispatched.
* Closed: when a channel is cooperatively or force closed, a channel closed notification will be dispatched. Note that in the case of a force closed channel, some actions still need to be taken on chain after this close is reported. 

Alternatively, if you would like to poll your channel state, or obtain additional information about your channel, the following endpoints are available:

* _ListChannels_: a list of your node’s currently open channels. This endpoint is useful for monitoring your incoming and outgoing liquidity, checking your peer’s uptime over the life of the channel and examining current commitment state.  
* _PendingChannels_: channels that are currently in the process of being opened or closed are listed by this endpoint. 
  * Pending open: channels that are waiting for their funding transaction to confirm. 
  * Pending force closing: channels that were force closed and are waiting to be resolved on chain. Note that channels may remain in this category for a while, because funds may be encumbered behind a timelock. 
  * Waiting closing: channels that are waiting for their close transaction to confirm on chain. 
* _ClosedChannels_: a list of closed channels that have been fully resolved on chain. If you expect to see a channel in this list, but it is not present, check the _PendingChannels_ output to determine whether it is still in the process of resolving on chain.

## Closing Channels

Once you have opened a channel with a peer, it is possible that the channel proves to be unproductive. This may happen if your peer is offline a lot or manages their liquidity poorly and is not able to facilitate payments. If you would like to allocate the capital in that channel elsewhere, it may be time to close the channel. 

### Identifying Channels to Close

Some basic data points that you can examine to determine whether a channel is performant are uptime, forwards and use for your own payments. If you would like to check these values manually in lnd, the following endpoints will be useful:

* _ListChannels_:
  * The uptime and total monitored time for a channel is provided by this endpoint, where uptime/lifetime provides total uptime percentage for the channel. 
  * The total satoshis sent/received provide an indication of the volume of sends from your node and receives to your node that the channel has dispatched and delivered. 
* _ForwardingHistory_:
  * This endpoint provides a list of all the successful forwards your node has participated in. Searching for a short channel ID within these results provides an account of how much this channel has been forwarding payments. 

Our [Faraday](https://github.com/lightninglabs/faraday) tool’s close recommendations feature processes these values for you, and provides close recommendations based on manually set thresholds or by identifying outliers among the set of channels you currently have open.

### Close Types

The way in which you close a channel depends on whether your peer is online to coordinate closing of the channel with you. Regardless of the type of close, the channel initiator will pay the close fees for the channel.  

#### Cooperative Close

Channels can be cooperatively closed when your peer is online to participate in closing out the channel. Since both parties agree to closing the channel, they can sign a new commitment transaction paying out each party their owed balance immediately. Note that your node needs to wait until all HTLCs on the channel are resolved \(so that it knows which party must be paid out\) before the channel will be closed on chain, which may take some time. 

If you are cooperatively closing a channel that does not have an upfront shutdown address set, you can provide an address which you would like your funds to be paid out to.

| Parameter | Description |
| :--- | :--- |
| delivery\_address | The bitcoin address to pay your funds out to. This can be useful for closing channels and paying directly into cold storage, or to another operational address. **** |

#### Force Close

If your peer is not available to sign a cooperative close transaction, a channel can still be closed by force closing. This close type is achieved by broadcasting the last signed commitment transaction that you have, paying out each peer the latest state of the channel. Since you are broadcasting your commitment, your funds will only be available after a timeout has elapsed. If there are any pending HTLCs on the commitment, these too will need to be resolved on chain. Ideally force closes are only used in the case where your peer is consistently offline. 

### LND-Initiated Force Closes

If one of your channels has a HTLC on its commitment transaction, and the remote node that the channel is open with does not settle or fail that HTLC, `lnd` will need to force close the channel to claim the funds on chain. This is one of the greatest downsides of having offline peers in Lightning. This will happen automatically, so we highly recommend tracking your current set of channels so that you have an accurate picture of the set of channels that your node has open, and can open more channels if required.   


