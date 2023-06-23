---
description: Aperture is an implementation of L402s as a reverse HTTP proxy.
---

# Aperture

Aperture is a reverse proxy that acts as a payment and authentication gateway for Lightning Network powered APIs. It can handle gRPC requests over HTTP/2 as well as REST over HTTP/1 and 2.

Aperture receives incoming connections, verifies the validity of the [L402](../../the-lightning-network/l402/) and either forwards the request to the appropriate end point, or obtains a [Macaroon](../../the-lightning-network/l402/macaroons.md) and sends it together with a Lightning invoice and the HTTP status code 402 Payment Required.

Aperture is currently used in production in Lightning [Loop](../loop/) and [Pool](../pool/).
