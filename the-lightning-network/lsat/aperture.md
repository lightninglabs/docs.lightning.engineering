---
description: Aperture is an implementation of LSATs as a reverse HTTP proxy.
---

# Aperture

Aperture is a reverse proxy that acts as a payment and authentication gateway for Lightning Network powered APIs. It can handle gRPC requests over HTTP/2 as well as REST over HTTP/1 and 2.

Aperture receives incoming connections, verifies the validity of the LSAT and either forwards the request to the appropriate end point, or obtains a Macaroon and sends it together with a Lightning invoice and the HTTP status code 402 Payment Required.

Aperture is currently used in production in Lightning [Loop](../../lightning-network-tools/loop/) and [Pool](../../lightning-network-tools/pool/).

## Install Aperture

Requirements: go 1.13 or later

`git clone` [`https://github.com/lightninglabs/aperture.git`](https://github.com/lightninglabs/aperture.git)``\
`cd aperture`\
`make install`\
`cp sample-conf.yaml aperture.yaml`

By default Aperture uses port 8081. This port needs to be reachable from the outside.

Aperture will create a TLS key and self-signed certificate. To run Aperture in production, it will need a valid TLS certificate for the domain it is running on.

## Run Aperture

To run Aperture, simply run the following command from within aperture's directory.

`./aperture`

## LSAT demo

A demonstration of LSATs can be found at [https://lsat-playground-bucko.vercel.app/](https://lsat-playground-bucko.vercel.app/) ([Testnet version here](https://testnet-lsat-playground.vercel.app/))

Here you can go through the process of minting a Macaroon, turning it into an LSAT, restricting and validating it as well as see code snippets.

[See how the client interceptor is coded in Aperture](https://github.com/lightninglabs/aperture/blob/master/lsat/client\_interceptor.go)
