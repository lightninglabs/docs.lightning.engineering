---
description: Get tips on how to configure LND to get the most out of your routing node
---

# Optimal Configuration of a Routing Node

LND offers a wide range of configuration options that allow deployment in a large variety of platforms, environments and purposes, making use of either btcd, bitcoind or neutrino as a source of blockchain data.

In this article we will discuss various configuration options for LND in the context of a routing node.

## Configuring a routing node <a id="docs-internal-guid-265f4120-7fff-139c-a0f4-e8dd72f3defd"></a>

For a high-performance routing node you will need btcd or bitcoind running without pruning. Ideally both the Bitcoin backend and LND will run on the same machine, but it is also possible to connect them via ssh on separate servers, as long as latency is low enough.

For performance reasons you may also specifically configure your Bitcoin node. For instance, when building bitcoind from source you can use the command 

`./autogen.sh   
./configure CXXFLAGS="--param ggc-min-expand=1 --param ggc-min-heapsize=32768" --enable-cxx --with-zmq --without-gui --disable-shared --with-pic --disable-tests --disable-bench --enable-upnp-default --disable-wallet  
make -j "$(($(nproc)+1))"  
sudo make install`  
The parameters in this command are explained below:

`CXXFLAGS="--param ggc-min-expand=1 --param ggc-min-heapsize=32768"` This allows us to conserve memory.

`--enable-cxx  
--with-zmq` ZMQ is used to stream data from bitcoind to LND.`--without-gui` We will not need the graphical interface for our setup.`--disable-shared   
--with-pic  
--disable-tests  
--disable-bench  
--enable-upnp-default` UPnP allows for automatic port mapping.  
`--disable-wallet` As we will not be using the bitcoind wallet we can disable it.

The command `make -j "$(($(nproc)+1))"` might help to speed up the build on some machines compared to make.

Your routing node will need a static IP with open ports or a version 3 onion address if you want others to be able to connect and open channels with you.

We assume LND is already installed on your server. We recommend using the [signed binaries](https://github.com/lightningnetwork/lnd/releases). You can find more details on how to [install LND in this guide](get-started-with-lnd.md).

If you do not already have a configuration file, you will need to create one and place it in your LND directory. On Linux, that is typically `~/.lnd/lnd.conf` on MacOS `/Users/[username]/Library/Application Support/Lnd/lnd.conf` and in Windows `C:\Users\<username>\AppData\Local\Lnd`

You may also use the lnd.conf sample file and activate the relevant lines by removing the semi-colons at the beginning of the relevant lines.

[See the full lnd.conf sample file.](https://github.com/lightningnetwork/lnd/blob/master/sample-lnd.conf)

### Your node <a id="docs-internal-guid-4f9fc838-7fff-b39a-9b5d-26e767ad9da0"></a>

`alias=YOUR_ALIAS  
color=#000000`

Make your node visible and more easily discoverable with a unique alias. This might be a url to where peers can find out more information about you and your node, the name or your business or something memorable. Anybody can set any name and color without verification, but don’t abuse this!

`externalip=INSTANCE_IP`

Make sure to set the external IP of your LND node here. This IP address should be static. You may remove this line if you are using Tor.

`tor.active=1  
tor.v3=1  
listen=localhost`

If you prefer to make your node available through the Tor network, set these lines in your configuration.

`sync-freelist=1  
stagger-initial-reconnect=1`

This will help our node start up faster by applying randomized staggering when reconnecting to persistent peers. This minimizes the chance of connecting to all non-responsive peers at once.

`debuglevel=CNCT=debug,CRTR=debug,HSWC=debug,NTFN=debug,RPCS=debug`

CNCT, CRTR and HSWV provide channel-related logs, while NTFN provides chain-related logs. RPCS will provide you with RPC-related logs.

### Bitcoin

`bitcoin.active=1  
bitcoin.mainnet=1  
bitcoin.node=bitcoind`

Activate your Lightning node for Bitcoin payments on mainnet. We specify the Bitcoin node of your choice. Other choices are Beutrino and btcd

`bitcoind.rpcpass=  
bitcoind.rpcuser=`

You may freely decide on a RPC password and username, as long as it is long and unique. This also needs to be set in your bitcoin.conf file.

`bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332  
bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333`

We will need to enable ZMQ for our LND node to receive information about the latest blocks from bitcoind.

`bitcoin.minhtlc=1`

Set the smallest HTLC you would like to forward in milli-satoshi.

### Routing

`ignore-historical-gossip-filters=1`

Our routing node will not need historical gossip data, so we can ignore it with this flag.

`bitcoin.feerate=1  
bitcoin.basefee=1000`

This is our base fee in milli-satoshi. Meaning for each payment we forward we expect to be paid at least 1 satoshi. The feerate is the fee we charge per 1 million forwarded satoshi.

`max-channel-fee-allocation=1.0`

We can set the maximum amount of fees in a channel here as a percentage of individual channel capacity. The setting allows for one decimal place and defaults to 0.5.

`maxpendingchannels=10`

We can set the maximum pending channels with this configuration.

`bitcoin.defaultchanconfs=2`

The number of confirmations we expect before a channel is considered active.

`protocol.wumbo-channels=1  
minchansize=5000000`

This allows our node to accept and create channels larger than 0.16777215 BTC.

Similarly the minimum channel size, denominated in satoshis, allows your routing node to reject small channels. This might mean fewer, but more qualitative channels.

`max-cltv-expiry=5000`

A high CLTV expiration value makes it less likely that we have to settle a forwarded payment on chain, but also requires us to maintain a high uptime. In this example, the maximum number of blocks our funds are timelocked is about one month.

### RouterRPC

To make use of the following configurations, make sure you are using the binary release or built lnd from source with the routerrpc tag. The following parameters are important if you are using LND to make payments in the Lightning Network, rather than just routing the payments of others.

`routerrpc.apriorihopprob=0.5`

This sets the default chance of a hop being successful at 50%.

`routerrpc.aprioriweight=0.75`

If a node returns many failures LND will begin to ignore them more and more. To turn off this feature set the value to 1.

`routerrpc.attemptcost=10  
routerrpc.attemptcostppm=10`

LND may try less paths less likely to succeed only if they allow for significant savings. You can set the minimum of these desired savings here.

`routerrpc.maxmchistory=10000`

LND will keep historical routing records to evaluate future routing success. You can set how many records should be kept.

`routerrpc.minrtprob=0.005`

When setting this parameter to a very small number, LND will try paths even when they have a very low chance of success.

`routerrpc.penaltyhalflife=6h0m0s`

This setting allows you to define after how long LND should forget about past routing failures.

### RPC

`rpclisten=0.0.0.0:10009  
tlsautorefresh=1  
tlsdisableautofill=1  
tlsextradomain=YOUR_DOMAIN_NAME`

You may want to manage and monitor your node with remote tools requiring RPC. These configurations help you do that.

## DDoS Protection: <a id="docs-internal-guid-cfab3ba7-7fff-f3b9-ae1f-2a9a937759cb"></a>

We suggest the following iptable rules for network flood protection:

`sudo iptables -N syn_flood  
sudo iptables -A INPUT -p tcp --syn -j syn_flood  
sudo iptables -A syn_flood -m limit --limit 1/s --limit-burst 3 -j RETURN  
sudo iptables -A syn_flood -j DROP  
sudo iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j ACCEPT  
sudo iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j LOG --log-prefix PING-DROP:  
sudo iptables -A INPUT -p icmp -j DROP  
sudo iptables -A OUTPUT -p icmp -j ACCEPT`

