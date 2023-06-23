---
description: Use Aperture to dynamically price resources using L402s.
---

# Pricing

Aperture can be easily configured to price resources, such as files or API access. There are two pricing configurations: Fixed and dynamic pricing.

## User flow <a href="#docs-internal-guid-d027d658-7fff-096b-9e27-d92e4dae3fc4" id="docs-internal-guid-d027d658-7fff-096b-9e27-d92e4dae3fc4"></a>

In both fixed and dynamic pricing, the Aperture server acts as a proxy between the user and the content server. The user requests the resource and, without the requisite L402, is served the HTTP error response “402 Payment Required,” together with a Macaroon and a Lightning Network invoice.

By paying the Lightning Network invoice, the user obtains the preimage, which together with the Macaroon forms the valid L402, which the user can present to Aperture in order to obtain the desired resource.

[Read more: How the L402 is constructed and passed as part of the header](../../the-lightning-network/l402/protocol-specification.md#http-specification)

## Fixed Pricing <a href="#docs-internal-guid-865d3c77-7fff-00af-0102-b61a5964f14a" id="docs-internal-guid-865d3c77-7fff-00af-0102-b61a5964f14a"></a>

In fixed pricing, a resource is offered for a fixed price, expressed in satoshis. Multiple resources can be configured, each with their own price.

```
  - name: "service2"
	hostregexp: "service2.com:8083"
	pathregexp: '^/.*$'
	address: "123.456.789:8082"
	protocol: https
	constraints:
    	"valid_until": "2020-01-01"
	price: 1
```

For each service, a valid L402 will allow its holder to access unlimited resources on this service. To price for each resource individually, we will have to make use of dynamic pricing.

## Dynamic pricing

For dynamic pricing, you will need to configure Aperture to connect to a separate service over gRPC. This for example allows for resources to be priced in fiat currency, sell a large repository of items, each with their own pricing, or adjust prices based on demand.

```
  - name: "service3"
	hostregexp: "service3.com:8083"
	pathregexp: '^/.*$'
	address: "123.456.789:8082"
	protocol: https
	constraints:
    	"valid_until": "2020-01-01"
	dynamicprice:
  	enabled: true
  	grpcaddress: 123.456.789:8083
  	insecure: false
  	tlscertpath: "path-to-pricer-server-tls-cert/tls.cert"
```

{% embed url="https://www.youtube.com/watch?v=Y2ZG-qcw7Sw" %}
Also watch: Aperture Dynamic Pricing Demo
{% endembed %}

[https://github.com/ellemouton/aperture-demo](https://github.com/ellemouton/aperture-demo)
