---
description: Learn how to spin up a new Lightning Network node in less than 15 minutes
---

# Demo: Litd Speed Run

Using `litd` in integrated mode and the Neutrino backend, we are able to spin up a Lightning Network node, fully synced to chain and graph within 15 minutes on a fresh Ubuntu Virtual Private Server.

{% embed url="https://www.youtube.com/watch?v=9svP0Fpp1ZQ" %}
LND Speed Run
{% endembed %}

## Step by step instructions

### Hardware:

We are using a VPS with 2GB of RAM and 1 vCPU running Ubuntu 22.04 LTS. It has 20GB of space on an SSD. We make sure the device is up to date with:

`sudo apt update`\
`sudo apt upgrade`

### Downloading and verifying litd

We will download the latest litd binaries from [their release page](https://github.com/lightninglabs/lightning-terminal/). Check for the latest version, manifest and gpg signatures as well as the key used to sign them.

First we will download the necessary files:

`gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 187F6ADD93AE3B0CF335AA6AB984570980684DCC`\
`wget https://github.com/lightninglabs/lightning-terminal/releases/download/v0.11.0-alpha/lightning-terminal-linux-amd64-v0.11.0-alpha.tar.gz`\
`wget https://github.com/lightninglabs/lightning-terminal/releases/download/v0.11.0-alpha/manifest-v0.11.0-alpha.sig`\
`wget https://github.com/lightninglabs/lightning-terminal/releases/download/v0.11.0-alpha/manifest-v0.11.0-alpha.txt`

Finally we will verify whether the manifest is properly signed and whether the sha256 sum in the manifest matches the one we calculate.

`gpg --verify manifest-v0.11.0-alpha.sig manifest-v0.11.0-alpha.txt`\
`cat manifest-v0.11.0-alpha.txt`\
`sha256sum lightning-terminal-linux-amd64-v0.11.0-alpha.tar.gz`

### Installing litd

Installing the binaries is as easy as moving them to a location where your operating system can find them.

cd `lightning-terminal-linux-amd64-v0.11.0-alpha/`\
`sudo mv * /usr/local/bin`

### Prepare configuration files

We will have to create a directory and make a new configuration file

mkdir \~/.lit\
nano \~/.lit/lit.conf

A sample configuration file might look like this. **Don't forget to create a new password**!

```
httpslisten=0.0.0.0:8443
uipassword=dont use this password you will use all your coins
lnd-mode=integrated
lnd.bitcoin.active=1
lnd.bitcoin.mainnet=1
lnd.bitcoin.node=neutrino
lnd.feeurl=https://nodes.lightning.computer/fees/v1/btc-fee-estimates.json
lnd.protocol.option-scid-alias=true
lnd.protocol.zero-conf=true
```

### Start litd

We can start litd with the command `litd`. Alternatively we can also use `nohup` to push the process into the background and observe its logs.

`nohup litd > /dev/null 2> /home/ubuntu/.lit/err.log &`

`tail -f ~/.lit/logs/mainnet/litd.log`

### Create a wallet

We will create a new wallet with the command:

`lncli create`

Follow the instructions on the screen, create a new seed phrase and write it down somewhere securely, ideally with a pencil on paper.

### Sync litd

We will now wait for `litd` to sync. This should only take a few minutes. We can check on the progress with:

`lncli getinfo`\
`lncli getnetworkinfo`

We will wait for "synced to chain" and "synced to graph" to both appear as `true`

### Connect to Lightning Terminal

Finally, we will navigate to your node's IP address at port `8443` to access the litd UI and connect to Lightning Terminal. This will require the password set in the `litd.conf` file, as well as a second, new password generated with your password manager.

### Open channels

We are now ready to deposit funds into our node, open channels and make payments. Congratulations!
