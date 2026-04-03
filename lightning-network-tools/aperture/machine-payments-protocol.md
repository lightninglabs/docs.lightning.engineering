---
description: >-
  The Machine Payments Protocol is a proposed protocol for machine-to-machine
  payments over Lightning and other payment rails
---

# Machine Payments Protocol

Unlike L402, the Machine Payments Protocol (MPP, not to be confused with Multi-path Payments) allows for payments over multiple payment rails, and is not limited to Lightning Network payments.&#x20;

Instead of macaroons, it uses credentials, which can either be for a single or multiple uses.

Instead of payment hashes, it uses payment receipts, which are issued by the service upon successful payment, and are passed together with the credential when requesting the resource.

[Read more: MPP](https://mpp.dev/)

## Enable MPP <a href="#docs-internal-guid-e28c0235-7fff-e9b1-4f1b-555c22663108" id="docs-internal-guid-e28c0235-7fff-e9b1-4f1b-555c22663108"></a>

Aperture implements MPP alongside L402.

To enable MPP, amend your `aperture.yaml` file in the authenticator and services sections. You may serve and authenticate L402 and MPP in parallel.

```yaml
authenticator:
  # Enable the Payment HTTP Authentication Scheme (MPP) alongside L402.
  # When enabled, 402 responses include both L402 and Payment challenges.
  # enablempp: true

  # Realm string used in MPP challenge headers. Defaults to the server's
  # listen address.
  # mpprealm: "api.example.com"

  # Enable MPP session intent for prepaid sessions with deposit, bearer,
  # top-up, and close operations. Requires enablempp to be true.
  # enablesessions: true

services:
   # Payment auth scheme for this service. Valid values: "l402" (default),
   # "mpp" (Payment HTTP Auth only), or "l402+mpp" (both schemes).
   # authscheme: "l402"

```
