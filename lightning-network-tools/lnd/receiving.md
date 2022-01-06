# Receiving Payments

Your node may receive payments over Lightning by providing an invoice to payees, or spontaneously through the use of the experimental Keysend feature. Please see the comparison table below to assess suitability for your use case. Note that there is a similar table in the sends chapter, expressed from the perspective of the sending entity.&#x20;

|                                   | Invoice                                                                             | Keysend                                                                                                                 |
| --------------------------------- | ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| <p>Interaction with Payer<br></p> | Party paying must request an invoice from your service.                             | No interaction required                                                                                                 |
| Support                           | BOLT 11 compliant invoices should be payable by all implementations.                | The sending node requires understanding of Feature Bit 9, TLV Onion - lnd must be run with the -_-accept-keysend_ flag. |
| Proof of Payment                  | Recipient sets preimage, providing cryptographically verifiable proof of payment    | Sender sets preimage, no proof of payment.                                                                              |
| Control of Receive Flow           | Invoices can only be paid once, and a node without an invoice cannot pay your node. | Any node can send to your node, which may result in unexpected receipts.                                                |

## Invoices

The _AddInvoice_ endpoint adds an invoice to your node, and returns the _add\_index_ and a payment request for the invoice. The payment request encodes all of the information that sending nodes need to pay your node, and can be encoded into QR codes.&#x20;

The following parameters are useful when adding an invoice:

| Parameter   | Description                                                                                                                                                                                                                                                                                                                                      |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| value\_msat | The amount to be paid, expressed in millisatoshis. Payment will fail if the invoice is underpaid.                                                                                                                                                                                                                                                |
| expiry      | The time after which the invoice will expire.                                                                                                                                                                                                                                                                                                    |
| private     | <p>If you have private channels set up, and would like the payer to be able to utilize them, this boolean must be set to include hints that they will use in routing (since your private channels are not advertised). <br></p><p>Note: this field must be set if your node only has private channels, payments will not succeed otherwise. </p> |
| memo        | A string describing the invoice which will be shared with the payee. This field is not required to be unique.                                                                                                                                                                                                                                    |

## Monitoring

`lnd` maintains two indexes on the invoices that it stores:

* Add index: a monotonically increasing index which indicates the order in which invoices were added.&#x20;
* Settle index: a monotonically increasing index which indicates the order in which invoices were settled.&#x20;

The _SubscribeInvoices_ endpoint provides a stream of updates for lnd’s invoices, informing you about newly added invoices and sending notifications when they are settled. This endpoint supports historical streams, and can be queried with an add\_index to query all invoices that were added after the index provided, or a settle\_invoice to query all invoices that were settled after the invoice provided. This can be helpful for syncing up your program’s state after a restart. If you would like to subscribe to individual invoices, _SubscribeSingleInvoice_ can be queried with the invoice’s payment hash as an identifier.&#x20;

Alternatively, the invoices that your node has can be polled using the _ListInvoices_ endpoint. The output of this call is paginated using _add\_index_ to order payments, and can be queried in reverse to list invoices from most to least recent.
