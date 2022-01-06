# Introduction

LSATs are a new standard protocol for authentication and paid APIs developed by Lightning Labs. LSATs can serve both as authentication, as well as a payment mechanism \(one can view it as a ticket\) for paid APIs. By leveraging the LSATs, a service or business is able to offer a new tier of paid APIs that sit between free, and subscription: pay as you go.

One can view LSATs as a fancy authentication token or cookie. They differ from regular cookies in that they're a cryptographically verifiable bearer credential. An LSAT token _encodes_ all its capabilities within a macaroon which can only be created by the end service provider. The LSAT specification uses a combating of `HTTP` as well as the Lightning Network to create a seamless end-to-end payment+authentication flow for the next-generation of paid APIs built on top of the Lightning Network.

The system described above isn't a fantasy, LSATs are used _today_ by Lightning Labs to serve as an authentication+payment solution for Lightning Loop, a non-custodial on/off ramp for the Lightning Network. Lightning Labs, has also open sourced `aperture`, a reference LSAT aware reverse-proxy used in production for all our systems. In the remainder of this section, we'll explore the motivation, lineage, and workflow of LSATs at a high level. For a more detailed speciation, please see the later sections of this specification.

