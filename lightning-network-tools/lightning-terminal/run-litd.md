---
description: Run litd in integrated or remote mode.
---

# Run litd

We recommend running litd in integrated mode. This lets you run LND, Loop, Pool, Faraday and in the future, Taproot Assets, in a single binary. You can also run litd alongside your existing LND, Loop, Pool or installation. Generally, litd makes it easy for you to selectively switch between integrated and remote mode for each component, allowing you to selectively upgrade each component, apply patches, or run your own forks.

## Integrated mode

Running litd in integrated mode allows the user to run everything in a single binary. To run litd in integrated mode, we will first need to configure our Bitcoin backend and LND.

### Configure Bitcoin

If you have not run LND on this machine before, you will need to configure a Bitcoin backend. You may refer to the [Configuration section in our Run LND guide.](../lnd/run-lnd.md) If you intend to run with a Neutrino backend, no action needs to be taken in this step.



{% embed url="https://www.youtube.com/watch?v=lopHP_nF0tE" %}
Video: RUN LITD: Building a Node from Scratch
{% endembed %}

### Configure litd <a href="#docs-internal-guid-59891e79-7fff-362e-d160-3ba75a10db52" id="docs-internal-guid-59891e79-7fff-362e-d160-3ba75a10db52"></a>

To configure litd, we will first create the .lit directory and place a configuration file in it.

`mkdir ~/.lit`\
`nano ~/.lit/lit.conf`

We need to place the following information into this configuration file:

`lnd-mode=integrated`\
`uipassword=<a random password of your choosing>`

We will also need to configure LND here. If you have run LND before on this machine or have an existing configuration that you would like to use, you can copy it into the lit.conf file. Don’t forget to prefix every option with `lnd.`, for instance:

`lnd.bitcoin.active=1`\
`lnd.bitcoin.node=bitcoind`\
`lnd.bitcoind.rpchost=127.0.0.1`\
`lnd.bitcoind.rpcuser=youruser`\
`lnd.bitcoind.rpcpass=yourpass`\
`lnd.bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332`\
`lnd.bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333`

### Run litd <a href="#docs-internal-guid-d4c709ea-7fff-ae21-a456-a53125a9d147" id="docs-internal-guid-d4c709ea-7fff-ae21-a456-a53125a9d147"></a>

You can now run litd, LND, Loop, Pool and Faraday together by executing litd. You will have to unlock LND with lncli unlock, or create a new wallet if this is your first time starting LND.

`litd`

[Next: Connect to Terminal](connect.md)

[Learn: Command Line Interface](command-line-interface.md)

## Remote mode <a href="#docs-internal-guid-aaab01ad-7fff-a741-d263-1ff312b564b0" id="docs-internal-guid-aaab01ad-7fff-a741-d263-1ff312b564b0"></a>

Remote mode refers to a litd installation that runs separately from LND. By default, such an installation does not need configuration beyond passing a UI password.

### Configure LND

To make use of litd's [Accounts](accounts.md) and [Autofees](autofees.md) features, you will need to enable the [RPC Middleware interceptor](../lnd/rpc-middleware-interceptor.md). This can be done by adding the following line to your `lnd.conf`:

`rpcmiddleware.enable=true`

### Run litd

We can start litd with the command:

`litd --uipassword=<your secure and unique password>`

If litd is unable to connect to LND, you might have to manually pass the location of the macaroon and RPC port or generate a litd configuration file, `~/.lit/lit.conf`

`lnd-mode=remote`\
`remote.lnd.rpcserver=127.0.0.1:10009`\
`remote.lnd.macaroonpath=/home/user/.lnd/data/chain/bitcoin/mainnet/admin.macaroon`\
`remote.lnd.tlscertpath=/home/user/.lnd/tls.cert`

It is also possible to run `litd` in either integrated or remote mode and swap Loop, Pool or Faraday between remote and integrated mode.

For example:

`lnd-mode=remote`\
`faraday-mode=integrated`\
`loop-mode=integrated`\
`pool-mode=remote`

[Next: Connect to Terminal](connect.md)

[Learn: Command Line Interface](command-line-interface.md)

## Regtest and Signet

To run `litd` on regtest or signet, the autopilot has to be disabled.

`autopilot.disable=true`

## Access the litd user interface <a href="#docs-internal-guid-cc49c7b2-7fff-c1e9-7d7a-d93120d77804" id="docs-internal-guid-cc49c7b2-7fff-c1e9-7d7a-d93120d77804"></a>

Once litd is running, you should be able to navigate to `localhost:8443` and access the user interface of litd.

To access the interface from a remote machine, don’t forget to launch litd with the flag `--httpslisten=0.0.0.0:8443` or add `httpslisten=0.0.0.0:8443` to your `lit.conf` file.
