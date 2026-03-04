---
description: >-
  Turn any HTTP endpoint into a profit center. Buy resources from any L402-gated
  API.
---

# L402 Quickstart

## As a client <a href="#docs-internal-guid-4160a800-7fff-d235-f2d4-b0c3e644cffb" id="docs-internal-guid-4160a800-7fff-d235-f2d4-b0c3e644cffb"></a>

To buy L402-gated resources, you do not need specialized software, At a minimum, you only need [Curl](https://curl.se/docs/manpage.html) and access to a Lightning wallet or API. This makes it easy to implement L402 functionality into any client, such as a web browser, a wallet, a python script or your application.

<br>

1.  Request a resource\
    Requesting a resource is as simple as:\
    `curl https://lightningfaucet.com/api/l402/headers`\
    <br>

    ```
    import requests
    resource_url = "https://lightningfaucet.com/api/l402/headers"
    requests.get(resource_url)
    ```
2.  Extract the macaroon and Lightning invoice

    In the response, you should see the invoice and the macaroon. Save the macaroon and pass the Lightning invoice to your Lightning payment service.
3.  Pay the Lightning invoice

    The invoice may be paid [by your node](https://lightning.engineering/api-docs/api/lnd/router/send-payment-v2/), a service you run, a wallet API or another service you subscribe to. The only requirement is that the service you are using is able to provide you with the preimage once the payment is successful.
4.  Assemble the L402 from the macaroon and preimage

    Once you have obtained the preimage, assembling the L402 is straightforward:\
    `<macaroon>:<preimage>`
5.  Re-request the resource

    You may now re-request the resource while passing the L402 as part of the header:

    `curl -X POST -H {"Authorization": L402 <macaroon>:<preimage>"} https://lightningfaucet.com/api/l402/headers`\
    <br>

    ```
    import requests
    headers = {"Authorization": f"L402 {macaroon}:{preimage}"}
    new_response = requests.get(resource_url, headers=headers)
    ```



You should now be able to download or access the gated resource.

[See also: Py402, a command line demonstration tool written in Python](https://github.com/Liongrass/Py402)<br>

## As a server <a href="#docs-internal-guid-11e919f7-7fff-535b-4bae-6182d58bc30a" id="docs-internal-guid-11e919f7-7fff-535b-4bae-6182d58bc30a"></a>

As a server, you will need an L402 proxy, such as [Aperture](../../lightning-network-tools/aperture/). This proxy will need a connection to a Lightning Network node or service to generate invoices. Whether an L402 is valid can be verified using only the root key of the macaroon, without checking with the node whether the payment was received.

{% content-ref url="../../lightning-network-tools/aperture/get-aperture.md" %}
[get-aperture.md](../../lightning-network-tools/aperture/get-aperture.md)
{% endcontent-ref %}
