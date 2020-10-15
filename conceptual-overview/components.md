# Components

## **Network Layers**

The Lightning Network is an _overlay_ network on top of another blockchain. To avoid confusion it is crucial to differentiate between the following network layers we encounter when reasoning about `lnd`:

* Bitcoin/Litecoin Network: This is the underlying blockchain that `lnd` rests on top of. `lnd` needs a way to communicate with the underlying blockchain in order to send on-chain payments, create channel open/close transactions, and watch for events on the blockchain.
* P2P Network: This is the peer layer where `lnd` nodes add each other as peers so they can send messages between one another via an [encrypted connection](https://github.com/lightningnetwork/lightning-rfc/blob/master/08-transport.md). For example, the `lncli connect` adds a peer, which are identified by identity pubkey and IP address.
* Payment channel network: This is the layer where nodes are connected by payment channels. For example, the `lncli openchannel` command opens a channel with a node that was already connected at the peer layer, and the `lncli describegraph` command returns the list of edges and vertices of the payment channel graph.

## **Software Components**

There are distinct software components we should be aware of when developing on

* [`btcd`](https://github.com/btcsuite/btcd) or [`bitcoind`](https://github.com/bitcoin/bitcoin) is used by `lnd` to interface with the underlying blockchain.
* `lnd` / `lncli`: LND stands for Lightning Network Daemon and serves as the main software component driving the Lightning Network. It manages a database, connects to peers, opens / closes channels, generates payment invoices, sends, forwards, and revokes payments, responds to potential breaches, and more. `lncli` opens up a command line interface for driving `lnd`.
* [Neutrino](https://github.com/lightninglabs/neutrino) is an experimental Bitcoin light client designed to support Lightning mobile clients. This is a wallet UI usable with `lnd`. Neutrino is not required from an application development standpoint, but can be regarded as the primary way for an end-user of `lnd` to interact with the Bitcoin Network and the applications built on top of it.

## **LND Interfaces**

There are several ways to drive `lnd`.

* `lncli` is the `lnd` command line tool. All commands are executed instantaneously. A full list of commands can be viewed with `lncli --help`. To see a breakdown of the parameters for a particular command, run `lncli <command> --help`
* gRPC is the preferred programmatic way to interact with `lnd`. It includes simple methods that return a response immediately, as well as response-streaming and bidrectional streaming methods. Check out the guides for working with gRPC for [Python](https://dev.lightning.community/guides/python-grpc/) and [Javascript](https://dev.lightning.community/guides/javascript-grpc/)
* LND also features a REST proxy someone can use if they are accustomed to standard RESTful APIs. However, REST does not have full streaming RPC coverage.

All of these LND interfaces are documented in the [API Reference](https://api.lightning.community/), featuring a description of the parameters, responses, and code examples for Python, Javascript, and command line arguments if those exist.

