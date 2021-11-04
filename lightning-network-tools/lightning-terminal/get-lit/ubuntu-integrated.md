# Linux - Integrated Mode

## Assumptions

1. You have a Ubuntu server.
2. Your Ubuntu server has `bitcoind` installed, synced on mainnet, and running as a daemon.
3. 1. To install `bitcoind` on Ubuntu, follow [the official bitcoin.org guide](https://bitcoin.org/en/full-node#linux-instructions).
4. Your `bitcoin.conf` file has ZMQ publishing turned on.
   1. Txindex is not required, but pruned mode is not supported.

## Get LiT

Download the version of the latest [Lightning Terminal release](https://github.com/lightninglabs/lightning-terminal/releases/latest) that matches your local configuration \(likely linux-amd64\). Extract the compressed files, and install the binaries using the below instructions.

```text
# If you have go installed...
# Extract the compressed files, and install them in your GOPATH
tar -xvf lightning-terminal-<YOUR_LOCAL_VERSION>.tar.gz --strip 1 -C $GOPATH/bin

# Linux requires this in order for LiT to listen on a port below 1024
sudo setcap 'CAP_NET_BIND_SERVICE=+eip' $GOPATH/bin/litd

# If you do not have go installed...
# Extract and install the compressed files, and add their location to your PATH
tar -xvf lightning-terminal-darwin-amd64-<YOUR_LOCAL_VERSION>.tar.gz
cd lightning-terminal-darwin-amd64-<YOUR_LOCAL_VERSION>
PATH=$PATH:$PWD
sudo setcap 'CAP_NET_BIND_SERVICE=+eip' ./litd
```

Ensure that your server has only the required ports open for outbound communication with the Lightning Network.

```text
sudo ufw logging on
sudo ufw enable
# PRESS Y
sudo ufw status
sudo ufw allow OpenSSH
sudo ufw allow 9735
sudo ufw allow 10009
sudo ufw allow 8443
```

If you are not already running `lnd` on this server, continue to the next section. If you are looking to upgrade an existing `lnd` instance, [skip ahead.](ubuntu-integrated.md#install-lightning-terminal-upgrade-lnd-to-litd)

### Fresh lnd Install

Because we assume you are not already running `lnd`, we will be creating a fresh configuration file for `lnd` to start within the same process as `litd`, alongside the UI server, `faraday`, `pool`, and `loop`.  

```text
# Create the Lightning Terminal directory and configuration file
mkdir ~/.lit
vi ~/.lit/lit.conf
```

Storing the configuration in a persistent `~/.lit/lit.conf` file means you do not need to type in the command line arguments every time you start the server. Make sure you don't add any section headers \(the lines starting with \[ and ending with \], for example \[Application Options\]\) as these don't work with the additional levels of sub configurations.

Paste this example `lit.conf` file into your terminal, and fill in the placeholders with your specific information.

```text
# Application Options
httpslisten=0.0.0.0:8443
lnd-mode=integrated

# Let's Encrypt
# You can configure the HTTPS server to automatically install a free SSL certificate provided by Let's Encrypt. 
# This is recommended if you plan to access the website from a remote computer, but does require extra setup.
#letsencrypt=true
#letsencrypthost=<YOUR_DOMAIN>

# Lnd
lnd.lnddir=~/.lnd
lnd.alias=<YOUR_ALIAS>
lnd.externalip=<YOUR_IP>
lnd.rpclisten=0.0.0.0:10009
lnd.listen=0.0.0.0:9735
lnd.debuglevel=debug

# Lnd - bitcoin
lnd.bitcoin.active=true
lnd.bitcoin.mainnet=true
lnd.bitcoin.node=bitcoind

# Lnd - bitcoind
lnd.bitcoind.rpchost=localhost
lnd.bitcoind.rpcuser=<YOUR_RPCUSER>
lnd.bitcoind.rpcpass=<YOUR_RPCPASSWORD>
lnd.bitcoind.zmqpubrawblock=localhost:28332
lnd.bitcoind.zmqpubrawtx=localhost:28333

# Loop
loop.loopoutmaxparts=5

# Pool
pool.newnodesonly=true

# Faraday
faraday.min_monitored=48h

# Faraday - bitcoin
faraday.connect_bitcoin=true
faraday.bitcoin.host=localhost
faraday.bitcoin.user=<YOUR_RPCUSER>
faraday.bitcoin.password=<YOUR_RPCPASSWORD>
```

If you are using a cloud provider, double check using their configuration tools that inbound ports 8443, 9735, and 10009 are allowed. Once you've done that, it's time to get LiT!

```text
litd --uipassword=<YOUR_UI_PASSWORD>
```

The very last step is to create your new `lnd` wallet. Crucially, `faraday`, `pool`, and `loop` **do not** start nor connect to `lnd` until after an `lnd` wallet has been created and unlocked. Open a new Terminal window and type the command:

```text
lncli create
```

Once you have secured your passwords and your seed phrase, Lightning Terminal is easy to browse to either on [https://localhost:8443](https://localhost:8443) if using a local machine or to your public URL if using a remote machine.

In the next major section of this guide, we've included example commands for interacting with the command line. See you there!

### Upgrade Existing lnd

If you already have existing `lnd`, `loop`, or `faraday` nodes, you can easily upgrade them to the LiT single executable while keeping all of your past data. 

Assuming you use an `lnd.conf` file for configurations, copy that file to your LiT directory  and rename it to `lit.conf`. 

```text
# Create the Lightning Terminal directory and configuration file
mkdir ~/.lit
cp ~/.lnd/lnd.conf ~/.lit/lit.conf
```

Then edit `lit.conf` and add the `lnd.` prefix to each of the configuration parameters. You also have to remove any section headers \(the lines starting with `[` and ending with `]`, for example `[Application Options]`\) as these don't work with the additional levels of sub configurations. You can replace them with a comment \(starting with the `#` character\) to get the same grouping effect as before. Additionally, you'll need to add any configuration parameters for `loop`, `pool` , and `faraday` to your new lit.conf file as well, with prefixes added for each parameter, respectively. 

When finished, your new `lit.conf` should look like this:

```text
# Application Options
httpslisten=0.0.0.0:8443
lnd-mode=integrated

# Let's Encrypt
# You can configure the HTTPS server to automatically install a free SSL certificate provided by Let's Encrypt. 
# This is recommended if you plan to access the website from a remote computer, but does require extra setup.
#letsencrypt=true
#letsencrypthost=<YOUR_DOMAIN>

# Lnd
lnd.lnddir=~/.lnd
lnd.alias=<YOUR_ALIAS>
lnd.externalip=<YOUR_IP>
lnd.rpclisten=0.0.0.0:10009
lnd.listen=0.0.0.0:9735
lnd.debuglevel=debug

# Lnd - bitcoin
lnd.bitcoin.active=true
lnd.bitcoin.mainnet=true
lnd.bitcoin.node=bitcoind

# Lnd - bitcoind
lnd.bitcoind.rpchost=localhost
lnd.bitcoind.rpcuser=<YOUR_RPCUSER>
lnd.bitcoind.rpcpass=<YOUR_RPCPASSWORD>
lnd.bitcoind.zmqpubrawblock=localhost:28332
lnd.bitcoind.zmqpubrawtx=localhost:28333

# Loop
loop.loopoutmaxparts=5

# Pool
pool.newnodesonly=true

# Faraday
faraday.min_monitored=48h

# Faraday - bitcoin
faraday.connect_bitcoin=true
faraday.bitcoin.host=localhost
faraday.bitcoin.user=<YOUR_RPCUSER>
faraday.bitcoin.password=<YOUR_RPCPASSWORD>
```

If you are using a cloud provider, double check using their configuration tools that inbound ports 8443, 9735, and 10009 are allowed. Once you've done that, it's time to get LiT!

```text
litd --uipassword=<YOUR_UI_PASSWORD>
```

Crucially, `faraday`, `pool`, and `loop` **do not** start nor connect to `lnd` until after an `lnd` wallet has been unlocked. Open a new Terminal window and type the command:

```text
lncli unlock
```

Once unlocked, Lightning Terminal is easy to browse to either on [https://localhost:8443](https://localhost:8443) if using a local machine or to your public URL if using a remote machine.

## Example commands for interacting with the command line

Because not all functionality of `lnd` \(or `loop`/`faraday` for that matter\) is available through the web UI, it will still be necessary to interact with those daemons through the command line.

We are going through an example for each of the command line tools and will explain the reasons for the extra flags. The examples assume that LiT is started with the following configuration \(only relevant parts shown here\):

```text
lnd-mode=integrated

lnd.lnddir=~/.lnd
lnd.rpclisten=0.0.0.0:10009

lnd.bitcoin.testnet=true
```

Because all components listen on the same gRPC port and use the same TLS certificate, some command line calls now need some extra options that weren't necessary before.

**NOTE**: All mentioned command line tools have the following behavior in common: You either specify the `--network` flag and the `--tlscertpath` and `--macaroonpath` are implied by looking inside the default directories for that network. Or you specify the `--tlscertpath` and `--macaroonpath` flags explicitly, then you **must not** set the `--network` flag. Otherwise, you will get an error like: `[lncli] could not load global options: unable to read macaroon path (check the network setting!): open /home/<user>/.lnd/data/chain/bitcoin/testnet/admin.macaroon: no such file or directory`

#### Example `lncli` command

The `lncli` commands in the "integrated" mode are the same as if `lnd` was running standalone. The `--lnddir` flag does not need to be specified as long as it is the default directory \(`~/.lnd` on Linux\).

```text
$ lncli --network=testnet getinfo
```

#### Example `loop` command

This is where things get a bit tricky. Because as mentioned above, `loopd` also runs on the same gRPC server as `lnd`. That's why we have to both specify the `host:port` as well as the TLS certificate of `lnd`. But `loopd` verifies its own macaroon, so we have to specify that one from the `.loop` directory.

```text
$ loop --rpcserver=localhost:10009 --tlscertpath=~/.lnd/tls.cert \
  --macaroonpath=~/.loop/testnet/loop.macaroon \
  quote out 500000
```

You can easily create an alias for this by adding the following line to your `~/.bashrc` file:

```text
alias lit-loop="loop --rpcserver=localhost:10009 --tlscertpath=~/.lnd/tls.cert --macaroonpath=~/.loop/testnet/loop.macaroon"
```

#### Example `pool` command

Again, `poold` also runs on the same gRPC server as `lnd` and we have to specify the `host:port` and the TLS certificate of `lnd` but use the macaroon from the `.pool` directory.

```text
$ pool --rpcserver=localhost:10009 --tlscertpath=~/.lnd/tls.cert \
  --macaroonpath=~/.pool/testnet/pool.macaroon \
  accounts list
```

You can easily create an alias for this by adding the following line to your `~/.bashrc` file:

```text
alias lit-pool="pool --rpcserver=localhost:10009 --tlscertpath=~/.lnd/tls.cert --macaroonpath=~/.pool/testnet/pool.macaroon"
```

#### Example `frcli` command

Faraday's command line tool follows the same pattern as loop. We also have to specify the server and TLS flags for `lnd` but use `faraday`'s macaroon:

```text
$ frcli --rpcserver=localhost:10009 --tlscertpath=~/.lnd/tls.cert \
  --macaroonpath=~/.faraday/testnet/faraday.macaroon \
  audit
```

You can easily create an alias for this by adding the following line to your `~/.bashrc` file:

```text
alias lit-frcli="frcli --rpcserver=localhost:10009 --tlscertpath=~/.lnd/tls.cert --macaroonpath=~/.faraday/testnet/faraday.macaroon"
```

