---
description: >-
  Use the Tor network to make your node reachable behind your home router or
  firewall.
---

# Quick Tor Setup

In order to automatically accept incoming channels, your node needs to be reachable. This can be done via IPv4/6 or via Tor. The Tor Network is a global volunteer-run proxy network. Inside of the Tor Network, services are identified using their public keys and the postfix `.onion`.

LND can be easily configured to be reachable over the Tor network. Typically, Lightning nodes set up through a software bundle such as Umbrel, RaspiBlitz or myNode are set up through Tor by default. In these situations, the first paragraph might help understand the implications of such a setup, while the actual configuration might differ from the one below.

## Why Tor

If you want to connect to other Lightning nodes using Tor, you will need to enable the Tor proxy on your node as well. You will still be able to connect to non-Tor nodes with this setup.

If you are behind Network Address Translation \(NAT\), you may find it difficult or impossible to configure port forwarding on IPv4, while IPv6 may not be available or appropriately configured on all networks. In these situations,Tor may be the only way to make your node reachable to others.

Configuring Tor is useful if you prefer to not publicly disclose the physical location of your node, particularly in the context of a node in your home or office. While it may be trivial to assess the physical location of a device reachable via IPv4/6, this is more difficult.

At the moment, it is not possible to configure LND for both the Tor network and IPv4/6 in a way that lets you be reachable via IPv4/6 while also reaching Tor nodes.

**Your node on Tor:**  
Can reach all nodes, but only reachable by Tor nodes.

**Your node on IPv4/6:**  
Can only reach IPv4/6 nodes, but reachable by all nodes.

## Configuring Tor

First, we will need to install Tor. You can find the [installation instructions here](https://community.torproject.org/onion-services/setup/install/). The Tor SOCKS proxy used by LND will be running by default. Alternatively, you can configure it in the Tor configuration file, typically found in `/etc/tor/torrc`

### Set the Tor proxy

Next we will need to instruct LND to make use of the Tor proxy. In your `lnd.conf` file, amend the following line:

`tor.active=true`

If you are bootstrapping your node over Tor, you will also need to specify a Tor DNS service. A default service will be used if you do not specify this option.

`tor.dns=nodes.lightning.directory`

Optionally, you may specify your socks proxy with the following command:

`tor.socks=127.0.0.1:9050`

This command enables Tor stream isolation, meaning each connection will use a separate Tor circuit. This can prevent other Tor traffic from being mixed with LND’s Tor traffic. Set this option to `false` if you have a lot of channels or prefer your channels to go online quickly, rather than privately.

`tor.streamisolation=true`

If we next restart LND, we are now able to reach out to Lightning nodes in the Tor network as well as all other reachable nodes. If that’s all you wanted to do with Tor, you can stop after these steps. 

### Create a Tor hidden service

To make our node reachable over Tor, we will need to configure a Tor hidden service. This will trigger LND to generate a .onion hostname and announce it to the network.

The best way to do this is to enable the Tor control port. In your Tor configuration file \(`etc/tor/torrc`\), find the line ControlPort 9051 and ‘uncomment’ it, e.g. remove all leading pound symbols \(`#`\).

Now we will need to create a good password. Make it long and unique, for example using a password manager. Add this password to your LND configuration file as follows:

`tor.password=dontusethisyouwillbehacked`

You will be able to obtain the hash of this password with the command 

`tor --hash-password dontusethisyouwillbehacked`

It will look something like this:

`16:2BE4E06082494B84607C7C2264E8EFFC4600DE2A28DFE5142519FF87AF`

We will need to add this hashed password in our `torrc` file under ControlPort, e.g.:

`HashedControlPassword 16:2BE4E06082494B84607C7C2264E8EFFC4600DE2A28DFE5142519FF87AF`

We will specify that we want LND to create a Tor version 3 \(secure\) hidden service by adding the following to our `lnd.conf`:

`tor.v3=true`

Optionally we may also specify the IP and port of Tor and LND, as well as the paths to the generated keys. By default the keys will be placed in your `~/.lnd` folder.

`tor.control=localhost:9091  
tor.targetipaddress=  
tor.privatekeypath=/path/to/torkey  
tor.watchtowerkeypath=/other/path/`

