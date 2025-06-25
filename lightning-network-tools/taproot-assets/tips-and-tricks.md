---
description: >-
  Taproot Assets on the Lightning Network allow you to pay any Lightning
  invoice, and get paid from any Lightning wallet. Consult this document when
  running into issues.
---

# Tips and Tricks

## Incorrect payment details <a href="#docs-internal-guid-093c427d-7fff-af5a-175d-4b4b644efb50" id="docs-internal-guid-093c427d-7fff-af5a-175d-4b4b644efb50"></a>

`FAILURE_REASON_INCORRECT_PAYMENT_DETAILS`

When generating an invoice for Taproot Assets, the receiving node expects the payment to come through a channel that holds this specific asset. Such channels are not announced and cannot be found in the graph.

Instead, they are added as hop hints to the invoice. Not every sender might honor these hop hints, and they may try to pay through any existing public channel instead, if they exist. When paying to the wrong channel, the sender will see the “incorrect payment details” error.

They can instead try again or force the payment to go through the hop hint by passing the `--last_hop` when paying the invoice.

## No route found

`FAILURE_REASON_NO_ROUTE`

When a channel along the route is disabled or doesn’t have liquidity, the sender might see the “no route” error. It might make sense to check if your local channels are active and have enough capacity. It is important to check not only for sufficient Taproot Assets capacity, but also satoshi capacity, as every HTLC that passes through a Taproot Asset channel still requires some satoshis.

A typical Taproot Asset channel has a capacity of 100,000 satoshis, of which 1,000 are unspendable on each side as the channel reserve. Each open HTLC requires a balance of 345 satoshis, so at least 2035 satoshis are required as inbound capacity to have three pending incoming HTLCs. The 345 satoshis do not change owners once the HTLC settles.

## Satoshi denomination

At the LND level, all transactions remain denominated in satoshis. At this point, the output of many RPC commands such as `lncli listinvoices` or `lncli fwdinghistory` shows only satoshi amounts for Taproot Asset events.
