# Linux - Remote Mode

## Assumptions

1. You have a remote Ubuntu server **already running** `lnd`.
2. Your server has a local firewall with OpenSSH allowed, alongside ports 9735 and 10009.
3. Your Ubuntu server has `bitcoind` installed, synced on mainnet, and running as a daemon.
   1. To install `bitcoind` on Ubuntu, follow [the official bitcoin.org guide](https://bitcoin.org/en/full-node#linux-instructions).
4. Your `bitcoin.conf` file has ZMQ publishing turned on.
   1. Txindex is not required, but pruned mode is not supported.
5. 
## Install Lightning Terminal

Because we assume you are not already running `lnd`, we will be configuring LiT with [integrated `lnd` mode](https://github.com/lightninglabs/lightning-terminal/blob/master/doc/config-lnd-integrated.md). This means that `lnd` is started within the same process as `litd`, alongside the UI server, `faraday`, `pool`, and `loop`.

Crucially, `faraday`, `pool`, and `loop` **do not** start nor connect to `lnd` until after an `lnd` wallet has been created and unlocked.

Download the version of the latest [Lightning Terminal release](https://github.com/lightninglabs/lightning-terminal/releases/latest) that matches your local configuration \(likely linux-amd64\). Extract the compressed files, and install the binaries using the below instructions.

```text
# Extract the compressed files, and install them in your GOPATH
tar -xvf lightning-terminal-<YOUR_LOCAL_VERSION>.tar.gz --strip 1 -C $GOPATH/bin

# Linux requires this in order for LiT to listen on a port below 1024
sudo setcap 'CAP_NET_BIND_SERVICE=+eip' $GOPATH/bin/litd

mkdir ~/.lit
vi ~/.lit/lit.conf
```

Storing the configuration in a persistent `~/.lit/lit.conf` file means you do not need to type in the command line arguments every time you start the server. Make sure you don't add any section headers \(the lines starting with \[ and ending with \], for example \[Application Options\]\) as these don't work with the additional levels of sub configurations.

Example `~/.lit/lit.conf`:

```text
# Application Options
httpslisten=0.0.0.0:443
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

Once you've ensured that inbound ports 443, 9735, and 10009 are allowed, both using `ufw` and your cloud provider's configuration tools, it's time to get LiT!

`litd --uipassword=<YOUR_UI_PASSWORD>`

The very last step is to create your new `lnd` wallet. Open a new Terminal window and type the command:

`lncli create`

Once you have secured your passwords and your seed phrase, Lightning Terminal is easy to browse to either on [https://localhost:8443](https://localhost:8443) if using a local machine or to your public URL if using a remote machine.

