---
description: >-
  Learn about the concept of liquidity in the context of the Lightning network
  and how to best open, manage, balance and close your channels.
---

# Managing Liquidity on the Lightning Network

## On-chain Bitcoin <a id="docs-internal-guid-f32642c8-7fff-bda4-5003-3937885e00bc"></a>

The liquidity of on-chain bitcoin is predictable. Bitcoin exists in the form of UTXOs, which are unspent outputs from a previous transaction. To spend bitcoin, you need to receive or mine them first, but generally, they can be moved by the owner at any time.

On-chain bitcoin require multiple confirmations by the Bitcoin network to be considered settled. Unless these bitcoin are ‘locked’ in special addresses, they can be spent at any time and confirmed within an hour if an appropriate fee is set.

Your Lightning node is able to receive and send on-chain bitcoin.

* `lncli newaddress` Generate a new Bitcoin address
* `lncli walletbalance` Check your balance.
* `lncli sendcoins` Send Bitcoin from this wallet

This command follows the format `lncli sendcoins [command options] addr amt`

Useful tips:

* The `amt` value is denominated in satoshi. One bitcoin equals 100 million satoshi.
* If you want to spend your entire balance, you can set the option `--sweepall` and omit the `amt` value.
* You can define the fee rate, in sat/vbyte by setting the option `--sat_per_byte` \(`--sat_per_vbyte` from `lnd 0.13.0`\)
* Instead of setting a fee you can set the value for `--conf_target`, which is the number of blocks within which you expect your transaction to have been confirmed.
* You can record a memo for your transaction with the `--label` option.

Example transactions:

* `lncli sendcoins --sat_per_byte 10 --label savings bc1qaxcxcpunn6ns3gpu6ywcy57tcmy2vsjzwdklxr 100000`
* `lncli sendcoins --sweepall --conf_target 6 bc1qaxcxcpunn6ns3gpu6ywcy57tcmy2vsjzwdklxr`

Advanced users can also send to many addresses at once with the command `lncli sendmany`. This requires to pass a json string of the format `{"ExampleAddr": NumCoinsInSatoshis, "SecondAddr": NumCoins}`

## Channels

Lightning channels are two-of-two multisignature contracts that hold a certain amount of bitcoin on the Bitcoin blockchain. They also include a refund transaction that can be broadcast by either party to close the channel at any time \(see below: Force closing a channel\).

We speak of outbound channels when the node in question has initiated the channel, and inbound channels when another party has opened the channel. This does not imply whether the funds in that channel are held by one peer or the other.

The funds held in channels are in some ways more liquid than on-chain bitcoin, because they can be spent instantly and typically at a lower fee. However, if a channel is offline, the funds held in that channel will need to be retrieved through a non-cooperative close, which might make them unavailable, and illiquid, for a longer period of time.

The liquidity of your channel balance can also depend on who you are peering with. If you open a channel with node A, which is the only channel node A has, then the funds inside of that channel can only be spent to node A, and not any other node in the network. The same can happen if node A has no funds of their own, e.g. only inbound channels.

### Opening a channel

To open a channel, you need bitcoin. Typically, you would deposit bitcoin into your Lightning node using the above commands, but it is also possible to fund a channel with funds from a Partially Signed Bitcoin Transaction \(PSBT\)-compatible wallet or raw signed transaction.

You can open a channel with any other Lightning node, as long as it is online and accepts your channel request.

To open a channel, we use the command `lncli openchannel`, which follows the format `lncli openchannel [command options] node-key local-amt push-amt`

Useful tips:

* Before opening a channel with a remote peer, you may connect to it using the command `lncli connect <pubkey>@<host>`, such as `lncli connect 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d@54.184.88.251:9735`
* You can optionally set the fee manually with the commands `--sat_per_byte` or `--conf_target`, similar to the on-chain transaction above.
* The argument `--local-amt` is typically used to define both your share of the channel as well as its full capacity. With `--push-amt`, however, it is possible to send satoshis directly to the node of the peer. This is equivalent to making a payment to the other peer, and should only be used when they are aware of it. It’s not recommended to use the `--push-amt` flag.
* You can prevent a channel from being announced to the network with the flag `--private`. Other nodes will be unaware of this channel, and will be unable to include it in their routing paths. This means that funds cannot be routed through this channel, but the channel can be used to send and receive satoshis.
* When setting the `--close_address` option for a cooperative close, bitcoin will not be sent to your internal wallet. This is useful when using an external wallet for funding.
* The `--pbst` argument can be used to create a channel directly from an external wallet. This can reduce the need for sending the bitcoin transaction to your Lightning wallet.

Example usage:

* `lncli openchannel 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d 1000000`
* `lncli openchannel --sat_per_byte 21 --local-amt 800000 --close_address bc1qsltz4tt23k0825q76ylj5mt0gwenlm8wr7umkl 021c97a90a411ff2b10dc2a8e32de2f29d2fa49d41bfbb52bd416e460db0747d0d` 

To see if your channel is pending confirmation, you can use the command `lncli pendingchannels`.

### Remote vs local balance

Once your channel is open, you are able to make Lightning payments, and depending on your channel’s capacity you are able to receive payments as well. The satoshis in your channels are now more liquid than they were as UTXOs, as they can be transferred immediately at a low fee. Through channels, you may also obtain the ability to receive satoshi quickly.

The command `lncli listchannels` will give you a list of all your channels. You can restrict this list with the arguments `--active_only`, `--inactive_only`, `--public_only`, `--private_only` or by `--peer` value.

To get information related to routing policies for a specific channel, you can use the command `lncli getchaninfo`, followed by the compact channel ID of the channel, which you can obtain through `lncli listchannels`. Some individual channel information from `lncli listchannels` is not included in this output.

Your local balance includes your reserve and the amount of satoshis you can spend, while your remote balance shows how much you can receive through that channel. Your local balance is your peer’s remote balance, and vice versa.

As you spend satoshis on the Lightning Network, your local balance becomes your remote balance. When routing payments, you are receiving on one channel, while sending in another, Your remote balance in one channel becomes local balance, and vice versa in another channel.

Another interesting parameter in the output of `lncli listchannels` are the lifetime and uptime parameters, which tell you,  how long a channel has been online since the last restart of lnd. A channel that is rarely online can still be profitable, for example if it was created as a private channel by a frequent user.

### Channel fees

To route payments, you will need at least two channels, a local balance and a remote balance. Ideally, all your public channels contain enough balance on both the local and remote sides to be able to route a meaningfully large payment.

You are able to charge fees for routing payments. You can use the command `lncli feereport` to see the fee policy for all your channels, as well as get a summary for how many satoshis you have earned in routing fees.

By default, your fee policy may look something like this:

        `{  
            "chan_id": "739918549049147393",  
            "channel_point": "3ebdb34f1fc1948b5b49d127b52b19d24549779661af03a691cf934aa3b86e3f:1",  
            "base_fee_msat": "1000",  
            "fee_per_mil": "1",  
            "fee_rate": 0.000001  
        }`

This means to route payments through this channel, your node will charge 1,000 milli-satoshi \(1 satoshi\), plus 1 milli-satoshi per million milli-satoshi \(`fee_rate` times one million equals fee\_per\_mil\). So when routing a payment of 10,000 satoshi, you will earn 1.01 satoshi in fees. This fee policy is applied to all outgoing payments, meaning you will only earn the fee as it is passed on. The fee policy on the incoming channel is decided by that peer. As a rule of thumb, you decide on the fee policy of your capital.

You can set your default fees in your lnd.conf file. The entries will look like this:

`bitcoin.basefee=1000 (referring to base_fee_msat above)  
bitcoin.feerate=1 (referring to fee_per_mil above)`

Once you change these values in your configuration file, it affects new channels. If you would like to only change your fee rates for existing channels, apply the command `lncli updatechanpolicy`. 

The command `lncli updatechanpolicy` follows the format `lncli updatechanpolicy [command options] base_fee_msat fee_rate time_lock_delta [--max_htlc_msat=N] [channel_point]`

Useful tips:

* You can define the minimum and maximum payments you are willing to forward with the `--min_htlc_msat` value and `--max_htlc_msat` arguments. They are defined in milli-satoshis, meaning 1/1000th of a satoshi.
* You can update the fees for all channels at the same time by omitting the `channel_point` argument, or update fees for each channel individually.
* You can set a custom Time Lock Delta with the `--time_lock_delta` value flag, with the default being 40. That means your node has 40 blocks to claim any forwarded Hashed TimeLock Contracts \(HTLCs\). If your node goes offline during that time you might be at risk of losing funds, as your peer will have claimed their forwarded funds, but you will have not yet claimed yours.

If the Time Lock Delta is too long, however, your channel will become less attractive to routing as the uncertainty of unclaimed HTLCs might put a strain on yours and other routing nodes.

Example usage:

* `lncli updatechanpolicy base_fee_msat 100 fee_rate 0.00001`
* `lncli updatechanpolicy base_fee_msat 1000 fee_rate 0.000001 --max_htlc_msat 100000000`

Updating your channel fee policies frequently is not recommended, as this might make you appear to be a less reliable node by your peers.

To see which payments you have successfully forwarded, use the command `lncli fwdinghistory`. You can manually define the start and end time of that list with the arguments `--start_time` value and `--end_time` value.

### Rebalancing channels

As you route payments, you may find that your channels become unbalanced, meaning the local and remote balance become skewed. It’s popular to periodically balance these channels, most commonly by making a payment to yourself in a way that spends your local balance from channels with high balances, to those with lower balances. This is done through a circular path.

Balancing channels is time intensive and comes at a cost. It requires careful consideration and planning to be economical. For instance, you will need to make sure that rebalancing your channels does not cost more than you earned routing through this channel since the last rebalancing.

To balance manually, you will have to first identify the two channels that you want to balance. One of these channels will have a large local balance, and it will become the first channel in your route. The other channel is the one with a large remote balance, and it will be the last in your route.

You can balance your channels manually through the command line, or use an external tool.

Alternatively, you may familiarize yourself with software and scripts specifically for the purpose of rebalancing your node:

[https://github.com/C-Otto/rebalance-lnd](https://github.com/C-Otto/rebalance-lnd)  
[https://github.com/alexbosworth/balanceofsatoshis](https://github.com/alexbosworth/balanceofsatoshis)

### Acquiring inbound capacity

To effectively route payments, you will need both local and remote balances. Your local balance, or outbound capacity, are your own funds, e.g. the bitcoin you have deposited into a new channel opened with a quality peer.

Remote balance, or inbound capacity corresponds to your ability to receive payments, or route incoming payments in this channel.  It can be acquired in many ways. As you route payments in the Lightning Network your channel balance may shift, and you may need to add incoming capacity where you are routing payments from, and add outgoing capacity where you are routing payments to.

#### Spending satoshis

As you spend satoshis on the Lightning Network, your local balance becomes your remote balance, and you acquire the ability to route payments. This can happen naturally as you buy goods and services, and over time your personal Lightning node will become a routing node. Some services will also allow you to ‘park’ satoshis on their node by making a deposit, this also increases your inbound liquidity, but may also be an inefficient allocation of capital.

#### Signalling a need

You can convince others to open a channel with you by signalling a need for inbound capacity. Other routing nodes might be enticed by the outlook of routing payments to you, and collecting these routing fees. If you are a merchant, it might be well worth publicizing your need for inbound liquidity. You may also use marked-based tools to signal your need for incoming capacity, such as Pool, as explained below.

#### Loop Out

Loop is a service that allows you to make a Lightning payment to a on-chain address, or make an on-chain Bitcoin payment to refill your channels. Loop Out is useful for sending earnings from your channels to cold storage or refilling your channels without the need to open new channels.

In the context of inbound capacity, Loop Out can be used to empty your Lightning channel into a bitcoin address, then using that new UTXO to open a new channel. After two channel openings you are left with both inbound and outbound capacity, and the ability to route payments.

{% page-ref page="../../lightning-network-tools/loop/" %}

#### Pay for incoming capacity with Pool

Pool is a non-custodial, peer-to-peer marketplace for Lightning node operators to buy and sell channels. You can use Pool to have others to open channels with you and acquire inbound capacity, or collect fees to open channels with others.

### Monitor your channels with Faraday

Faraday is a tool to help you identify non-productive channels and more efficiently allocate capital. It comes bundled with [Lightning Terminal](../../lightning-network-tools/lightning-terminal/) and can be installed separately either on the same machine as your node, or in a remote location.

Using the command `frcli revenue` we can obtain a revenue report for our channels. For each channel you can view how many satoshis have been routed inbound or outbound. If there is a significant imbalance, the channel has been drained and might need to be replenished, either through an incoming transaction, e.g. through Loop In, or by rebalancing with another channel.

The parameter `fees_incoming_msat` might also help you identify channels that contribute to your routing earnings, and which channels see little activity. The report is generated for each channel pair, giving you detailed insights into how funds are flowing through your node. The report can be narrowed down to an individual channel and a limited time frame.

The command `frcli insights` gives a different report for each channel. Here you can see how many satoshis have been routed through each channel, fees generated, and channel metrics comparisons \(measured in `per_conf`, meaning per block that the channel has been alive\).

### Closing channels

Over time, scenarios may arise where you may be inclined to close channels. For example, you might want to deploy capital elsewhere, outside of the Lightning Network. While monitoring channels over time you may choose to close them if they are not routing enough payments, or if you have capital tied up in channels that are frequently offline.

In these cases you can use the `lncli closechannel` command to close channels, in one of two ways:

* Cooperative close: both peers are online at the time of closing
* Force close: unilateral, uncooperative close

`lncli closechannel [command options] funding_txid [output_index]`

In a cooperative close both nodes are signing a new commitment transaction and publishing it to the network. The on-chain funds created in such a transaction will become available for a new channel opening almost immediately. In such a case it is also possible to set the fee with the `--conf_target` or `--sat_per_byte` arguments and define which address the funds should be sent to via `--delivery_addr` \(unless this was already specified at the channel opening\).

When closing a channel unilaterally, known as a force close, the funds will be locked up for a period of time before they can be redeemed by the closer, while the other party can redeem their funds immediately. Unless an anchor channel was created, you are unable to change the transaction fee of the closing transaction. To force close a channel use the `--force` flag.

You can close all channels at once with `lncli closeallchannels` and view all closed channels with `lncli closedchannels`.

Zombie channels are channels that have no activity. This may happen for a variety of reasons. You may try to disconnect from the peer in question and reconnect, or double-check their IP or onion address. The node may no longer be operating or having encountered a failure.

It’s advisable to close Zombie channels as this capital can be allocated more efficiently, especially if they hold your funds.

Private channels may also bind your capital. Typically, they are created by payment-only nodes or mobile clients and are not used for routing. However, they often present a reliable source of fee income as payments from these nodes have a higher chance of being routed through you. Consider how long these channels have been inactive and their chance of being used again before you force close a private channel.

Example usage:

`lncli closechannel --funding_txid 83b5a55b21255915dbc0d005230b2c026a004c839edaa716247b96b66490c66a --output_index 1 --sat_per_byte 20 --delivery_addr bc1q6tcemsjadwgt938gkrmcqyvt79wxla42js8r4l`

