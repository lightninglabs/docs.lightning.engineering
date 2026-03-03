---
description: >-
  L402 is the standard for selling and buying digital resources. L402 allows
  services to charge for API endpoints in a way that is easy for AI agents to
  participate.
---

# L402: Lightning HTTP 402 Protocol

L402 is a standard to facilitate the authentication and trade of services such as API endpoints and computational resources. It is built with a focus on agentic commerce, meaning all aspects of the stack are optimized for interaction between AI agents.

## How L402 works

1. **Request:** The client, which may be a user's wallet, a program or an agent, sends an HTTP request to an L402-gated endpoint.
2. **Response:** The server responds with `HTTP 402 Payment Required` and a `WWW-Authenticate` header containing a token and a Lightning invoice. The token commits to the Lightning invoice by containing the invoice's payment hash.
3. **Payment:** The client will confirm the conditions laid out in the response and pay the associated Lightning invoice. There are no restrictions on what wallet or node this payment is coming from, as long as the client obtains the preimage as proof the payment was made.
4. Access: The client presents the token together with the preimage to the API endpoints. The endpoint is able to verify that the token is valid, and that the payment is made, without access to the payment database: Stateless verification.

As the token is a bearer instrument, it can be passed on by the client, for example to other agents and wallets. it can also be further attenuated and restricted. For instance, if the client obtains a token for cloud storage, the client may restrict the token to only read access, or only specific directories, before passing it on to another agent or sub-service.

## Aperture

Aperture is an implementation of the L402 standard. It functions as a reverse HTTP proxy with support for gRPC and REST requests. It allows the safe and efficient creation of paid APIs that separate the logic of payments, permissioning and fulfilling requests. Aperture is used today by Lightning [Loop](../../lightning-network-tools/loop/), a non-custodial swap service for Bitcoin and Lightning.

L402 leverages the following tools and mechanisms:

## Macaroons <a href="#docs-internal-guid-444dcdd8-7fff-4158-aecb-571c65c3d819" id="docs-internal-guid-444dcdd8-7fff-4158-aecb-571c65c3d819"></a>

The L402 specification is compatible with all bearer tokens that can commit to a payment hash. The recommended token format is Macaroons. Unlike cookies, they can be verified using only a root key and basic cryptography. This makes it possible to separate the logic of issuing and verifying Macaroons, which is important for distributed systems where we want to avoid, or are unable to, lookup the validity and permissions of each token presented to us.

Macaroons include permissions, and can be attenuated and delegated by the bearer. They are easier to restrict and fulfill the complex needs of safeguarding cryptographic assets.

{% content-ref url="macaroons.md" %}
[macaroons.md](macaroons.md)
{% endcontent-ref %}

## L402 <a href="#docs-internal-guid-10a6402c-7fff-d1f6-1a90-f2015a91174d" id="docs-internal-guid-10a6402c-7fff-d1f6-1a90-f2015a91174d"></a>

Lightning API keys are tokens that only become valid together with a cryptographic secret obtained as a preimage through payment a Lightning Network invoice tied to the token by its payment hash. They work best with Macaroons, which allow for the separation of issuance, permissioning and validation. L402s allow for the separation of issuance and payment.

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
