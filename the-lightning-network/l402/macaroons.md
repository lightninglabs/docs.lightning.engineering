---
description: Macaroons are fancy cookies for distributed applications.
---

# Macaroons

Macaroons are an advanced authentication mechanism for distributed systems. They are designed to combine the advantages of bearer and identity-based authentication systems in a single token that can quickly be issued and verified without requiring access to a central database.

[Read the Macaroon whitepaper.](https://research.google/pubs/pub41892/)

Cookies are data, typically containing a unique identifier. They may be stored in a user’s browser when they visit a page. As a bearer asset, the pure presence of the cookie authenticates the user.

At first glance, a Macaroon is a bearer asset, similar to a cookie. Unlike a cookie, it can be validated cryptographically by the issuer, or the issuer can delegate verification to someone else. This makes it possible for distributed systems to verify users without access to a central database. An API endpoint, for example, no longer needs to look up a cookie in a central user database before it grants access. Instead, it only requires the root keys to verify the Macaroon, which makes the software architecture more resilient, efficient and safe.

Macaroons can include their own permissions. When presented, the API endpoint can read these permissions, verify the Macaroon and execute the request accordingly, without having to look up externally either whether the Macaroon is valid, nor what permissions it has.

Furthermore, Macaroons can be attenuated by the user with their own restrictions. This allows to delegate permissions and functions in a safe way.

{% embed url="https://www.youtube.com/watch?v=CGBZO5n_SUg" %}
[Watch: Macaroons: Cookies with Contextual Caveats for Decentralized Authorization in the Cloud](https://www.youtube.com/watch?v=CGBZO5n\_SUg)
{% endembed %}

Today, Macaroons are used extensively in Lightning Labs products. Together with preimages obtained through Lightning Network payments, Macaroons form the basis of L402, which are used by Lightning Pool and Lightning Loop to authenticate users.

The main disadvantage of Macaroons over cookie or user-based authentication is that they are harder to revoke, especially in distributed systems. To revoke a Macaroon, the corresponding root key must be deleted, which would also invalidate all other Macaroons signed with that key.

To make revocation of Macaroons easier, we recommend to embed 32-byte user identifiers as part of the Macaroon, as these identifiers can safely be communicated across a distributed architecture. When a Macaroon is revoked, the user identifier is marked as invalid and a new user identifier is issued.

## How to mint a Macaroon

At its most basic level, we can turn a cookie (`id12345678id`) into a Macaroon purely by signing it with a HMAC using our secret key only known to us. This already allows us to validate the Macaroon by only verifying whether the HMAC is correctly signed with our secret key.

| id12345678id              |
| ------------------------- |
| HMAC(secret;4c4ab7a4f7a9) |

More commonly, we will set a location, for instance `api.domain.com` and a publicly visible identifier, such as `your macaroon` in addition to our cookie.

[Also read: Hacking Distributed: My first Macaroon](https://hackingdistributed.com/2014/05/21/my-first-macaroon/)

| id12345678id,api.domain.com,your macaroon              |
| ------------------------------------------------------ |
| HMAC(secret,4c4ab7a4f7a9,api.domain.com,your macaroon) |

To further amend or restrict Macaroons, we will add a “caveat”, which is a further restriction or attribute of our Macaroon. We will amend it in a line below our existing caveat and use the output of our HMAC function as a key to another HMAC function. This can be done by anyone in possession of the Macaroon.

| id12345678id,api.domain.com,your macaroon                                                 |
| ----------------------------------------------------------------------------------------- |
| expires:2023-12-31                                                                        |
| <p>HMAC(HMAC(secret,4c4ab7a4f7a9,api.domain.com,your macaroon)expires:2023-12-31)<br></p> |

We now only need to include each line with caveats in the Macaroon, as well as the final HMAC. The service verifying the Macaroon can now calculate line by line the appropriate HMACs and make sure that the final value matches that provided by the user, meaning the Macaroon is valid, and which caveats to apply. Whether the request conforms with the Macaroon will have to be checked separately.

Such a chain of caveats can be almost endlessly extended.

Example of a Lightning Loop Macaroon:

`identifier:`\
&#x20;   `version = 0`\
&#x20;   `user_id = fed74b3ef24820f440601eff5bfb42bef4d615c4948cec8aca3cb15bd23f1013`\
&#x20;   `payment_hash = 163102a9c88fa4ec9ac9937b6f070bc3e27249a81ad7a05f398ac5d7d16f7bea`\
`caveats:`\
&#x20;   `services = lightning_loop:0`\
&#x20;   `lightning_loop_capabilities = loop_out,loop_in`\
&#x20;   `loop_out_monthly_volume_sats = 200000000`

### Delegation

Macaroons can be used to delegate permissions. For example, Loop could issue a Macaroon to an exchange, which could apply further restrictions before handing it to the end users, who can present it to Loop.

### Third-party caveats

Macaroons can also include third-party caveats, which require some interaction with a third-party, to obtain an additional secret to complete the Macaroon. Lightning API Credentials (L402s) are a form of such caveats, which allow the creation of Macaroons that are only complete upon paying an attached Lightning Network invoice.

{% content-ref url="l402.md" %}
[l402.md](l402.md)
{% endcontent-ref %}

[Try: Guggero's Cryptography Toolkit](https://guggero.github.io/cryptography-toolkit/#!/macaroon)
