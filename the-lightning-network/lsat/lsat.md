---
description: >-
  Lightning Service Authentication Tokens (LSAT) are Macaroons that include a
  payment hash. For the LSAT to be valid, it must be presented together with the
  preimage corresponding to the payment hash.
---

# LSAT

Lightning Service Authentication Tokens (LSATs) leverage the capabilities of Macaroons and the programmatic characteristics of the Lightning Network to create a mechanism that allows distributed systems to authenticate a user and payment receipt. This authentication occurs without requiring access to a central database of users or invoices.

LSATs are a cornerstone to building metered APIs for the machine-to-machine economy, without logins, e-mail addresses or passwords.

An LSAT is a Macaroon together with the preimage of a Lightning Network payment. The Macaroon is transmitted to the user over HTTP together with a Lightning invoice and contains the payment hash of the invoice as a caveat.

To be a valid LSAT, the user needs to present two pieces of information:

* The partial LSAT, being the Macarloon including the payment hash
* The preimage, which can be obtained by paying the Lightning invoice

As the payment hash is a hash of the preimage, and as the preimage can only be obtained through paying the Lightning invoice in full, it is easy for anyone with the root key to verify:

* That the LSAT was issued by the appropriate authority
* That the LSAT carries the relevant capabilities
* That the Lightning invoice has been paid

| secret,id12345678id,api.domain.com,your macaroon                               |
| ------------------------------------------------------------------------------ |
| payment\_hash=1107feb30b42fd1a1648c9862006452a8092baa3b62fc474cb43bf42066a0b06 |
| HMAC(secret,4c4ab7a4f7a9,api.domain.com,your macaroon)                         |
| preimage=79852a0791225dee00be0a6cf31a1619782c21d35995e118bfc74ad812174035      |

## LSAT specification

To make for a valid LSAT, a Macaroon must adhere to the following characteristics:

Version - A version allows for an iterative macaroon design.

`identifier:`\
&#x20;   `version = 0`

User Identifier - A unique user identifier allows services to track users across distinct macaroons serving useful in the context of service level metering. A user identifier of 32 random bytes is used instead of the macaroon’s identifier because the latter can be revoked, e.g., in the case of a service tier upgrade.

`identifier:`\
&#x20;   `user_id = fed74b3ef24820f440601eff5bfb42bef4d615c4948cec8aca3cb15bd23f1013`

Payment Hash - A payment hash links an invoice’s payment request to the macaroon. Once the payment request is fulfilled, the payer receives its corresponding preimage as proof of payment. This proof can then be provided along with the macaroon to ensure an LSAT has been paid for without checking whether the invoice has been fulfilled.

`identifier:`\
&#x20;   `payment_hash = 163102a9c88fa4ec9ac9937b6f070bc3e27249a81ad7a05f398ac5d7d16f7bea`

### Caveats

There is no limit to what caveats you may define for your service. For Lightning Labs services, three types of caveats are used, which are covered below. Each caveat consists of a key and value pair, separated by an equal (=) sign.

#### Target Services

The caveat ‘services’ lists which services a LSAT is authorized to access. This can be a comma separated list of multiple services, as well as their tier. Tiers allow for separate levels of access, with the basic tier being 0.&#x20;

In this example the LSAT is authorized to access Lightning Loop at tier 0:

`caveats:`\
`services = lightning_loop:0`

#### Service Capabilities

Each service can be restricted in its capabilities. These caveats have ‘`_capabilities`’ amended to the service name, followed by a comma separated list of capabilities that the holder of the LSAT is allowed to access. If this caveat is not present, the holder has full access to the service. If multiple caveats of this service capability exist in the same LSAT, each caveat must be more restrictive than the previous one.

In this example the bearer of the LSAT is authorized to access both Loop Out and Loop In:

`caveats:`\
&#x20;   `lightning_loop_capabilities = loop_out,loop_in`

#### Service Constraints

Each service capability can be further constrained. This is recorded as a separate caveat beginning with the service capability. Similar to capabilities, multiple constraints may be present in a LSAT, but each constraint needs to be more restrictive than the previous.

In the following example the user is allowed to Loop out two million satoshis per month only:

`caveats:`\
&#x20;   `loop_out_monthly_volume_sats = 2000000`

## LSAT Verification <a href="#docs-internal-guid-b1e388f5-7fff-6120-4cca-c24c2c3cbdc3" id="docs-internal-guid-b1e388f5-7fff-6120-4cca-c24c2c3cbdc3"></a>

In verifying the LSAT, the server requires the root key with which the original Macaroon was created. This allows the server to verify, line by line, caveat by caveat, that the Macaroon was issued by the appropriate authority and that each caveat was properly amended.

Finally, the preimage is verified against the payment hash to ensure that all outstanding invoices have been paid.

[Learn how the LSAT is obtained in Pool](https://github.com/lightninglabs/pool/blob/master/server.go#L504)

{% content-ref url="aperture.md" %}
[aperture.md](aperture.md)
{% endcontent-ref %}
