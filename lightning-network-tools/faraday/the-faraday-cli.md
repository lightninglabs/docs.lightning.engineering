---
description: Learn how to use the Faraday command line interface
---

# The Faraday CLI

As soon as Faraday is running, you will be able to make use of frcli. Depending on your installation, you will be able to run it simply by typing `frcli` into your console or navigating to where the binaries are stored and executing with `./frcli`

### Getting an initial overview

The reports Faraday generates can sometimes appear intimidating, especially if your node has a large number of older channels which have already seen plenty of activity.

The command `frcli insights` gives us a list of all our channels with detailed information about each of them. LND tracks the uptime of each channel since your last restart. Thus, you will be able to see the `uptime_ratio` calculated as part of the output. You can see the age of the channel measured in blocks \(confirmations\), the total fees earned through this channel, as well as various metrics that can help you compare the activity of your channels.  


`{`      `"chan_point": "d77dcaccc8db72cf90b48e8d51b9e153f5854ac38d56cd5c496a798406d2d1b4:0",  
       "monitored_seconds": 23531,  
       "uptime_seconds": 23526,  
       "volume_incoming_msat": 103615746,  
       "volume_outgoing_msat": 46662747,  
       "fees_earned_msat": 624,  
       "confirmations": 980,  
       "uptime_ratio": 0.9997875143427819,  
       "revenue_per_conf_msat": 0.636734693877551,  
       "volume_per_conf_msat": 153345.40102040817,  
       "incoming_vol_per_conf_msat": 105730.3530612245,  
       "outgoing_vol_per_conf_msat": 47615.04795918367  
    }`

### More detail with revenue reports

The command frcli revenue will give us more detail. For each channel we can get pair reports, which shows in detail where capital is coming from and going as it passes through our node.  


`{  
            "target_channel": "b0fe65328fd6b42163c26ce39e3e9752e65fe26a096240387a6b3927834f0756:1",  
            "pair_reports": {  
                "513204def516e5e8ad07539cc45da4c769a6a3e15d041740eda4ea549b92880f:0": {  
                    "amount_outgoing_msat": "51007151",  
                    "fees_outgoing_msat": "1051",  
                    "amount_incoming_msat": "0",  
                    "fees_incoming_msat": "0"  
                },  
                "6a3db67a5131cb9dea3fef7789a0e3fc4a9a45533e11dda5fda02b58e44b640f:1": {  
                    "amount_outgoing_msat": "1275345969",  
                    "fees_outgoing_msat": "3274",  
                    "amount_incoming_msat": "0",  
                    "fees_incoming_msat": "0"  
                },  
                "ba3564949f71aeeac45ef30b4fde0c9f229c4458cc6a794838dfa653f2f38e99:1": {  
                    "amount_outgoing_msat": "21235584",  
                    "fees_outgoing_msat": "1021",  
                    "amount_incoming_msat": "0",  
                    "fees_incoming_msat": "0"  
                },  
                "ccdb1a6165fa89a5aa965f4ca0ae843a2c6c2ea03382521787eda131410eb3e4:1": {  
                    "amount_outgoing_msat": "688761000",  
                    "fees_outgoing_msat": "2688",  
                    "amount_incoming_msat": "0",  
                    "fees_incoming_msat": "0"  
                }  
            }  
}`

For each channel, you can see how many milli-satoshi \(msat\) were routed to and from each peer. This can help you assess how capital is flowing through the network to and from your node with highest granularity.

Information like this can be vital to deciding which channels to keep, which to rebalance, and which to close. Based on the information provided in this output you may be able to identify bottlenecks, such as channels that would route a lot more payments if other channels were better balanced, or had higher capacity.

The output from frcli revenue is high in detail, but can also be overwhelming in range. You can further narrow the command down, for example by only looking at a specific channel \(`--chan_points`\), or limiting the query to specific dates.

Example usage:

`frcli --rpcserver=localhost:8443 revenue --chan_points=”b046a363855185962e0bd3b86beefa1480c6ac0d3f0c0b41f6eecf4acd6c0b1f:1” --start_time 1615680000 --end_time 1615766400`

### Set thresholds

Faraday allows us to set thresholds for the metrics of our channels and generate recommendations for when these thresholds are not met by certain channels. You can use the output of the above commands to get an idea of how your channels are generally performing, then make decisions on what performance metrics you are willing to accept.

You can set any of the possible thresholds below for the command `frcli threshold`:

`--uptime value`    Ratio of uptime to time monitored, expressed in \[0;1\]. \(default: 0\)  
`--revenue value`    Threshold revenue \(in msat\) per confirmation beneath which channels will be identified for close. \(default: 0\)  
`--incoming value`    Threshold incoming volume \(in msat\) per confirmation beneath which channels will be identified for close \(default: 0\)  
`--outgoing value` Threshold outgoing volume \(in msat\) per confirmation beneath which channels will be identified for close \(default: 0\)  
`--volume value`    Threshold total volume \(in msat\) per confirmation beneath which channels will be identified for close \(default: 0\)  
`--min_monitored value`    Amount of time in seconds a channel should be monitored for to be eligible for close \(default: 2419200\)

### Identify outliers

Alternatively we can also use Faraday to help us identify outliers, meaning channels that significantly underperform your average channel. We can choose what we consider as significant with the `--outlier_mult` flag, followed by the number of inter quartile ranges a channel should be from quartiles to be considered an outlier. We recommend values between 1.5 for aggressive recommendations and 3 for conservative ones.

We will also need to decide what to base this recommendation on uptime, revenue or volume using the same flags and defaults as above.

Example usage:

`frcli --rpcserver=localhost:8443 outliers --revenue --outlier_mult 2.5`

### Get reports on closed channels

We can use Faraday to get more information about closed channels. First, we will have to obtain the funding transaction IDs of our closed channels from lnd, which we can do with  `lncli closedchannels`

Next, we will use this information to obtain a report on the channel from Faraday with the command `frcli closereport`. This will require a connection to your Bitcoin node. We will be able to see how the channel was closed and which fees were paid to close it.

`frcli closereport --funding_txid 4fc297d20fa41d62ccb2acecf2ed6cc0b1ce3c6f274c6cb661e0e97bb65a640f --output_index 1`

`frcli closereport 4fc297d20fa41d62ccb2acecf2ed6cc0b1ce3c6f274c6cb661e0e97bb65a640f 1`

`{  
    "channel_point": "4fc297d20fa41d62ccb2acecf2ed6cc0b1ce3c6f274c6cb661e0e97bb65a640f:1",  
    "channel_initiator": true,  
    "close_type": "Cooperative",  
    "close_txid": "8f1be0671113423fa19546fae5456b824728a415afd800e759e38bb34794cd1b",  
    "open_fee": "305",  
    "close_fee": "1812"  
}`

### Get the full picture

The command frcli audit can be used to generate a full report of all activity on your node. It can also be written to csv with the `--csv_path` flag. It requires Faraday to be connected to your Bitcoin node.

There are multiple ways to narrow down such a comprehensive report, most conveniently the `--start_time` and `--end_time` flags, expressed in unix time. If you are using [Loop](../loop/) or Pool, you can identify these transactions in the output once you include the flags `--loop-category` and `--pool-category`.

For more granular insights, we may also pass a json array to the command with the `--categories` flag.

### Get fiat values

The command `frcli fiat` can also help you convert the milli-satoshi values into USD, including for historical values. This feature is also integrated into the `frcli audit` command when enabling it with the `--enable_fiat` flag.

Example usage:

`frcli --rpcserver=localhost:8443 fiat --amt_msat 21000000`

