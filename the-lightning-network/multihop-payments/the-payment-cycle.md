# The Payment Cycle

Payments in the Lightning network require interaction between sender and receiver, meaning both parties need to be online at the same time. Lightning payments also require both the sender and receiver to be either connected to each other with a payment channel, or for a route through the wider network to exist that connects the two.

[Read more: Lifecycle of a payment channel](../payment-channels/lifecycle-of-a-payment-channel.md)

## Create invoice <a href="#docs-internal-guid-f74494d8-7fff-80ba-c779-e56ea5e58769" id="docs-internal-guid-f74494d8-7fff-80ba-c779-e56ea5e58769"></a>

The payment cycle begins with an interaction between the sender and receiver, for example a buyer and seller of goods. Upon agreeing on an amount, the recipient generates an invoice on their node, which will contain basic information, such as amount, destination and validity.

Most importantly, the recipient generates a preimage, a random number and provides its hash as part of the invoice. All invoices are cryptographically signed.

`lncli addinvoice –amt 10101 –memo “my first invoice”`

The whole invoice is passed to the payer out of band, for example by displaying it on a website, on a smartphone, or point of sale terminal. Commonly, invoices are encoded as QR codes, but can also be transmitted by NFC or even sound.

When creating an invoice, you may keep its payment hash (r\_hash) around, to later be able to conveniently check whether it has been paid.

[Read more: Understanding Lightning invoices](../payment-lifecycle/understanding-lightning-invoices.md)

## Make the payment <a href="#docs-internal-guid-d31049a1-7fff-0832-9dbe-bcae185f668a" id="docs-internal-guid-d31049a1-7fff-0832-9dbe-bcae185f668a"></a>

The payer passes this invoice to their Lightning Network node and confirms the instructions to pay it. The node will create multiple routes to the destination node, and attempt them. The more invoices you pay, the more your node learns about the reliability of its peers to pass on payments in certain directions.

`lncli payinvoice <bolt 11 invoice>`

To make the payment, the node will create an HTLC over the amount to be forwarded to one of its peers, who will pass it on to the next peer, and so on until it reaches its destination.

The recipient node will release the preimage to its peers, which are used to settle the HTLCs inside the channels. The sender can use the preimage together with the signed invoice to prove the payment was made.

Invoices can be decoded using any Lightning node. This makes their contents human readable.

`lncli decodepayreq --pay_req=<bolt 11 invoice>`

[Read more: Hash Time-lock Contracts](hash-time-lock-contract-htlc.md)

## Check the payment <a href="#docs-internal-guid-1da31097-7fff-7bb1-0f09-482ca46bdde3" id="docs-internal-guid-1da31097-7fff-7bb1-0f09-482ca46bdde3"></a>

The recipient can now look up whether the payment was made using the payment hash.

lncli lookupinvoice --rhash=\<r\_hash>

## Other payment types <a href="#docs-internal-guid-74d3ba56-7fff-f52b-693c-9a7814c908f6" id="docs-internal-guid-74d3ba56-7fff-f52b-693c-9a7814c908f6"></a>

Lightning Network invoices also exist for situations where the payment amount is not known ahead of time, for example donations. It is also possible to create static invoices that can be reused multiple times [using AMP](../../lightning-network-tools/lnd/amp.md). In addition, there are alternative proposals on how to handle Lightning Network payments, such as LNURL or BOLT12.

It’s also possible to attach messages to Lightning payments or send payments over multiple paths at once.

[Read more: Payment etymology](../payment-channels/etymology.md)
