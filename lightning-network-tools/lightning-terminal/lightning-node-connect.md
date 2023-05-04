---
description: >-
  Lightning Node Connect makes it easy to connect an application to your
  Lightning Network Node.
---

# Lightning Node Connect: Under the hood

Lightning Node Connect (LNC) is a novel mechanism to create an end-to-end encrypted connection between a Lightning Network node (initially just LND, other implementations might follow) and a web browser. It consists of three separate parts:

Lightning Node Connect, which is running as part of the Lightning Terminal Daemon (`litd`), connected to the Lightning node and typically runs on the same machine or network as the node. This is where macaroons are baked, requests and data are forwarded between node and user, and where the connection to the proxy server is made.

A proxy, also called Traversal Using Relays around NAT (TURN), establishes two semi-synchronous pipes through which the user and their node can communicate. This proxy service mainly improves the user experience for nodes set up behind a NAT or firewall.

The application, for instance Lightning Terminal, is delivered by a web server and runs in the user’s browser. It is also conceivable for this application to run as a standalone application, for example on a laptop, smartphone or dedicated device.

To explain the mechanisms behind LNC, we will look at the individual components and the steps taken to establish the connection between the user and their node.

## Connection establishment

The process starts with the user creating a new Lightning Node Connect session in `litd`. This creates a pairing phrase, typically 10 English words from which a 64-byte stream ID can be derived.

`litd` then starts to listen for incoming connections through the proxy, listening on the stream with the derived ID.

## Initial handshake <a href="#docs-internal-guid-74d06d57-7fff-4d90-d90f-37ee70c5e250" id="docs-internal-guid-74d06d57-7fff-4d90-d90f-37ee70c5e250"></a>

The [Noise Protocol Framework](http://noiseprotocol.org/) is already used in the Lightning Network to handle encrypted connections between nodes ([see BOLT 8 for details](https://github.com/lightningnetwork/lightning-rfc/blob/master/08-transport.md)). It leverages the existing public keys that identify Lightning nodes and avoid introducing new complexity or dependencies and does not rely on certificate authorities.

The Noise handshake however is handled differently. The process is initiated by the user generating the pairing phrase in the Lightning Terminal Daemon (litd) as described above. This triggers the generation of a long-term public key for the handshakes in addition to the 64-byte stream ID.

The password-authenticated key exchange (PAKE) is combined in a single step with the Noise handshake. Through it, Lightning Node Connect and the application learn about the other side’s long-term Diffie-Hellman (DH) key and a shared secret, from which other keys can be derived.

LNC will only allow a single attempt to authenticate this key exchange, which allows the mechanism to make use of a low-entropy password that can be more easily typed or remembered.

The user enters the pairing phase into their application, completing the initial handshake. Lightning Node Connect can now forget the pairing phrase and will only communicate using the negotiated keys, preventing brute force attacks.

At this stage, instead of transmitting a zero-value AEAD payload, Lightning Node Connect may also pass a newly baked macaroon to the client, restricting access to the Lightning node, for example by duration, types of actions taken or amount of value being transferred. While only a single pairing phrase may be generated at a time, it is possible to maintain multiple connections with their unique DH key and macaroon, for example for different types of applications or users.

The handshake variant used in LNC for the initial connection:

`XXeke_secp256k1+SPAKE2_CHACHAPOLY1305_SHA256`

## Secondary pairing handshake <a href="#docs-internal-guid-01e17e1f-7fff-aa46-2601-15ea2a346470" id="docs-internal-guid-01e17e1f-7fff-aa46-2601-15ea2a346470"></a>

For each subsequent connection LNC performs a secondary pairing handshake., In this second handshake, the key authentication can be omitted, as long as the long-term DH key is still known to the participants.

This handshake takes the place of the usual TLS handshake in other gRPC calls to LND.

The handshake used for each subsequent connection:

`IK_secp256k1+CHACHAPOLY1305_SHA256`

## Terminal Proxy <a href="#docs-internal-guid-85950d8f-7fff-48ab-28e4-dc2ed92c9829" id="docs-internal-guid-85950d8f-7fff-48ab-28e4-dc2ed92c9829"></a>

Upon initializing Lightning Node Connect using litd, a mailbox is created on the Terminal Proxy, identified with the hash of the pairing phrase. Upon entering the pairing phrase to the Terminal application on the web, the mailbox can be reached by the application, and the initial handshake can be initialized.

The proxy server creates two pipes, one for the application to push data to the Lightning node, and another in the opposite direction. Each pipe is identified with the 64-byte stream ID. Only this stream ID is needed to feed data into the pipe, and pipes can only be created through authentication.

Messages in these pipes are delivered in order, making it easy for the recipient client to make sure they did not miss out on any information.

The mechanisms of Lightning Node Connect make it possible to use Terminal on the web without requiring to trust the proxy.

## WebAssembly Client <a href="#docs-internal-guid-bba880d4-7fff-58ff-a234-38d8a8130eef" id="docs-internal-guid-bba880d4-7fff-58ff-a234-38d8a8130eef"></a>

Instead of implementing the client in Javascript, Lightning Terminal uses WebAssembly (WASM) and readily available libraries such as brondite (the noise implementation in lnd). For gRPC connections, existing clients are used with modifications for the custom transport mechanisms.

The application is fed the pairing phrase by the user, triggering the generation of a public key for the DH handshake, a stream ID as well as allowing it to verify the connection and discard the pairing phrase. The user additionally selects a password, ideally using their password manager, to encrypt the generated secrets locally and prevent unauthorized use.

{% embed url="https://www.youtube.com/watch?v=vZWbydel-bU" %}
Building Lightning Apps with Lightning Node Connect
{% endembed %}

## Future work

To extend the functionalities of Terminal on the web beyond sending and receiving payments, opening and closing channels or inspecting payments in flight, extensions to the LND API are necessary. The API endpoints of Pool and Loop will have to be further abstracted as well to deliver Terminal users the full capabilities of these markets and services.
