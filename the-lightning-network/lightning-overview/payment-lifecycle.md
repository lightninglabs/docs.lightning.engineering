# Payment Lifecycle

Because Lightning payments are instant, its API tends to be much simpler, since there is no need to wait for block confirmations before a payment is considered accepted. It resembles a fairly standard payment flow, but there are a few additional things to keep in mind.

## **Payment Requests**

Payment requests, often also referred to as Invoices, are a simple, extensible protocol compatible with QR-codes. It includes a 6-character checksum in case there is a mistake with copy/paste or manual entry.

Payment requests are composed of two sections:

1. **Human readable part:** Contains a prefix `ln` followed by an optional amount.
2. **Data part**: Contains a UTC Unix timestamp and optionally some tagged parts, as well as a signature over the human readable and data parts.
   * Tagged parts include a payment hash, the pubkey of the payee node, a description of the purpose of payment, an expiration time (default to 1 hour if not specified), and extra routing information. Some tagged parts are required and others are not.

Because the payment request contains the payment hash, **payment requests must be strictly single use**. After an invoice is fulfilled, the hash preimage becomes publicly known. An attacker could save the preimages they’ve seen and reuse it for another payment that is reusing the invoice. Therefore, **failure to generate new payment requests means that an on-path attacker can steal the payment en route.**

Another detail worth noting is that payees should not accept payments after the payment request has expired (`timestamp` + `expiry`), and payers likewise should not attempt them. This will affect any web application with `lnd` integration, since if an invoice for a good or service is not fulfilled within the given timeframe, a new one should be generated.

Other possibly unexpected rules include that the payee should accept up to twice the amount encoded in the transaction, so that the payer can make payments harder to track by adding in small variations.

A full specification of the payment request data format, required and optional parts, and required behavior can be found in [BOLT 11](https://github.com/lightningnetwork/lightning-rfc/blob/master/11-payment-encoding.md).

## **Payment Flow**

Let’s now see what an ideal payment flow looks like.

1.  **Create Invoice:** The recipient creates an invoice with a specified value, expiration time, and an optional memo. If there was already an invoice created for this good and it expired, or a sufficient amount of time has elapsed, a fresh invoice should be generated.

    ```
    lncli addinvoice --amt=6969 --memo="A coffee for Roger"
    ```

    ![Lightning Wallet Generate Payment Request](https://i.imgur.com/1xYB9Yq.png)
2.  **Check invoice:** The payer decodes the invoice to see the destination, amount and payment hash. This way, they can validate that the invoice was legitimate, and that they aren’t being defrauded or overcharged. At this stage, the user should also check that the expiration time of the invoice has not passed

    ```
    lncli decodepayreq --pay_req=<PAY_REQ>
    ```
3.  **Send payment:** The payer sends their payment, possibly routed through the Lightning Network. Developers can do this through an `lnd` interface and end users can use the desktop or mobile app.

    ```
    lncli sendpayment --pay_req=<PAY_REQ>
    ```

    ![Lightning Wallet send payment screen](https://i.imgur.com/AQMRsZ3.png)
4.  **Check payment:** The recipient checks that their invoice has been fulfilled. They make a call to the `LookupInvoice` command, which returns this information in the `settled` field.

    ```
    lncli lookupinvoice --rhash=<R_HASH>
    ```

    ![Lightning Wallet 5BTC Received](https://i.imgur.com/Yu8EaBf.png)

We have now covered the basic workflow for generating invoices and sending/receiving payments.\
