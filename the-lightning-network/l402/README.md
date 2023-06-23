---
description: >-
  Lightning API keys cleverly combine the capabilities of macaroons with that of
  a Lightning payment, making it easy to charge satoshis for API requests.
---

# L402: Lightning HTTP 402 Protocol

L402, formerly known as LSAT, is a standard to support the use case of charging for services and authenticating users in distributed networks. It combines the strengths of Macaroons for better authentication with the strengths of the Lightning Network for better payments.

Aperture is an implementation of this standard. It functions as a reverse HTTP proxy with support for gRPC and REST requests. It allows the safe and efficient creation of paid APIs that separate the logic of payments, permissioning and fulfilling requests. Aperture is used today by Lightning [Loop](../../lightning-network-tools/loop/), a non-custodial swap service for Bitcoin and [Pool](../../lightning-network-tools/pool/), a non-custodial marketplace for channel liquidity.

L402 leverages the following tools and mechanisms:

## Macaroons <a href="#docs-internal-guid-444dcdd8-7fff-4158-aecb-571c65c3d819" id="docs-internal-guid-444dcdd8-7fff-4158-aecb-571c65c3d819"></a>

Macaroons are bearer authentication tokens. Unlike cookies, they can be verified using only a root key and basic cryptography. This makes it possible to separate the logic of issuing and verifying Macaroons, which is important for distributed systems where we want to avoid, or are unable to, lookup the validity and permissions of each token presented to us.

Macaroons include permissions, and can be attenuated and delegated by the bearer. They are easier to restrict and fulfill the complex needs of safeguarding cryptographic assets.

{% content-ref url="macaroons.md" %}
[macaroons.md](macaroons.md)
{% endcontent-ref %}

## L402 <a href="#docs-internal-guid-10a6402c-7fff-d1f6-1a90-f2015a91174d" id="docs-internal-guid-10a6402c-7fff-d1f6-1a90-f2015a91174d"></a>

Lightning API keys are Macaroons that only become valid together with a cryptographic secret obtained as a preimage through payment a Lightning Network invoice tied to the Macaroon by its payment hash. Where Macaroons allow the separation of issuance, permissioning and validation, L402s allow the separation of issuance and payment.

In practice, a service can hand out Macaroons together with Lightning Network invoices to their potential customers, but does not need to validate specifically whether these invoices have been paid. The mere cryptographic validity of the Macaroon guarantees that the payer has obtained the preimage through their payment.

{% content-ref url="l402.md" %}
[l402.md](l402.md)
{% endcontent-ref %}

## The Aperture proxy <a href="#docs-internal-guid-2415a258-7fff-3d3d-25b9-4e3b0c38b8ca" id="docs-internal-guid-2415a258-7fff-3d3d-25b9-4e3b0c38b8ca"></a>

The Aperture proxy is a reverse proxy that will forward a request with a valid L402 to their relevant API endpoint, while issuing Macaroons and Lightning Network invoices to new users.

Aperture allows for pricing for API endpoints on the fly, including automatic tier upgrades, per-request pricing or surge pricing. In another light, this can be viewed as a global HTTP 402 reverse proxy at the load balancing level for web services and APIs.

{% content-ref url="../../lightning-network-tools/aperture/get-aperture.md" %}
[get-aperture.md](../../lightning-network-tools/aperture/get-aperture.md)
{% endcontent-ref %}
