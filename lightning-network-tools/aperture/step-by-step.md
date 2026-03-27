---
description: Downloading, build, configure and deploy aperture
---

# Step by Step

Aperture can gate any HTTP or gRPC request by a L402 paywall. Aperture will fetch Lightning Network invoices from LND and issue new macaroons to all new incoming unauthenticated requests. To authenticate incoming requests it does not need to communicate with the Lightning node.

This guide will walk you through all steps required to set up Aperture in front of an HTTP service.

## Prerequisites

To follow this guide, you will need:

* A server, ideally Linux with root privileges
* A domain name or its subdomain
* An LND node (port 10009 must be reachable)

### Install Aperture

Aperture requires root access to bind to privileged ports. To simplify this process, we are going to set up everything in the root shell, which you can enter with:

`sudo -i`

Before we can build Aperture, we are going to have to download Go. We can find out what the latest version of Go is by checking [the project's site.](https://golang.org/dl/)

Download the latest go release. Be careful to specify the correct chip architecture, typically amd64::

`wget https://go.dev/dl/go[version].linux-amd64.tar.gz`

We unpack the binaries:

`tar -C /usr/local -xzf go[version].linux-amd64.tar.gz`

We will also define where Go should store the compiled binaries by adding the following lines to `.bashrc`

```bash
export PATH=$PATH:/usr/local/go/bin
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin
```

Don’t forget to reload `bash` by typing bash or opening a new shell.

Next, we are going to clone the Aperture repository:

`git clone https://github.com/lightninglabs/aperture.git`\
`cd aperture`\
`make install`

### Configure aperture

A sample configuration file is provided as part of the code base, you can find it in your aperture folder under the name `sample-conf.yaml`

To simplify the setup, find the compressed configuration file and it’s explanations below. Substitute the values with your own.

In this configuration file, we are setting up a very simple proxy to a service called “l402proxy” running on port 8080. As both services are running on the same machine, we will not configure https between the proxy and the service. The service is meant to be reached through its domain `l402proxy.domain.com`

Only requests to /service are being proxied, everything else is dropped. Each L402 costs 21 satoshis and is valid for one hour (3600 seconds). All calls to the endpoint /service/free are exempt from the fee.

As a bonus we have configured Aperture to service an `index.html` in the folder `/root/.aperture/static` to all requests not matched by the regex. Don’t forget to create the folder and file!

```yaml
# Your proxy will listen to all incoming connections on port 443.
listenaddr: "0.0.0.0:443"
debuglevel: "debug"
configfile: "/root/.aperture/aperture.yaml"
basedir: "/root/.aperture"

# Settings for the lnd node used to generate payment requests.
authenticator:
  network: "mainnet"
  disable: false
  # The IP or domain and port where your LND node can be reached.
  lndhost: "127.0.0.1:10009"
  # The path to lnd's TLS certificate.
  tlspath: "/home/ubuntu/.lnd/tls.cert"
  # The path to lnd's macaroon directory. If your node is on another machine, you may copy the invoice.macaroon file from there and place it in "/root/.aperture", then specify that directory instead.
  macdir: "/home/.lnd/data/chain/bitcoin/mainnet"

# The selected database backend.
dbbackend: "sqlite"

# List of services that should be reachable behind the proxy.  Requests will be
# matched to the services in order, picking the first that satisfies hostregexp
# and (if set) pathregexp. So order is important!
#
# Use single quotes for regular expressions with special characters in them to
# avoid YAML parsing errors!
services:
    # The identifying name of the service. This will also be used to identify
    # which capabilities caveat (if any) corresponds to the service.
  - name: "l402proxy"
    # The regular expression used to match the service host.
    hostregexp: 'l402proxy.domain.com'
    # The regular expression used to match the path of the URL.
    pathregexp: '^/service.*$'
    # The host:port which the service can be reached at.
    address: "127.0.0.1:8080"
    # The HTTP protocol that should be used to connect to the service. Valid
    # options include: http, https.
    protocol: http
    # a caveat will be added that expires the L402 after this many seconds,
    # 31557600 = 1 year.
    timeout: 3600
    # The L402 value in satoshis for the service. It is ignored if
    # dynamicprice.enabled is set to true.
    price: 2
    # A list of regular expressions for path that are free of charge.
    authwhitelistpaths:
      - '^/service/free/*$'


# This option allows us to serve a static HTML page to requests not defined by the above services:
servestatic: true
staticroot: "/root/.aperture/static"

```

### Obtain a TLS certificate <a href="#docs-internal-guid-a3f2d100-7fff-376f-0766-e3d89233b7c1" id="docs-internal-guid-a3f2d100-7fff-376f-0766-e3d89233b7c1"></a>

We will use Certbot to obtain a Let’s Encrypt certificate valid for your domain before we can start up Aperture. You can learn how to [download Certbot here](https://certbot.eff.org/).

To get the certificate, make sure port 80 and 443 are reachable from the outside, and that no other service is binding to it, such as any existing web server. If Aperture is already running, shut it down.

We can now obtain the certificate by running:

`certbot certonly --standalone`

Certbot will install the certificates in its own directory, typically `/etc/letsencrypt/live/l402proxy.domain.com/`

From there, we are going to have to copy and rename them for aperture:

`cp /etc/letsencrypt/live/l402proxy.domain.com/fullchain.pem /root/.aperture/tls.cert`\
`cp /etc/letsencrypt/live/l402proxy.domain.com/privkey.pem /root/.aperture/tls.key`

### Start Aperture

We are now going to start Aperture with:

`aperture`

### Verify

You should now be able to go to your domain using a web browser and see the static page, and the HTTP response “402 Payment Required” when navigating to `/service`

Congratulations! Your API is now behind an L402 gateway.
