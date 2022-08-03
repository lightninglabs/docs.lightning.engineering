---
description: >-
  Learn how to send messages to anyone in the Lightning Network from the command
  line
---

# Send messages with keysend

Keysend allows users in the Lightning network to send payments to others , directly to their public key, as long as their node has public channels and has keysend enabled. Keysend does not require the payee to issue an invoice.

This payment type can also be used to attach messages and other data.

Keysend is currently implemented in LND in two ways, the widely accepted “`--keysend`” and the newer “[`--amp`](amp.md)”

## Enable your node to receive keysend

To make sure you are able to receive spontaneous payments, add the following lines to your `lnd.conf` file:

```
accept-amp=true
accept-keysend=true
```

Then restart your node with `lncli stop` and `lnd`.

If you want to accept spontaneous payments using AMP, you may also create an invoice with routing hints and distribute it to prospective payers. You can use the command:

`lncli addinvoice –amp`

You can optionally also specify an amount (`--amt`), expiry (`--expiry`), a memo (`--memo`) routing hints are needed if your node only has private channels (`--private`).

## Send a spontaneous payment

To send a spontaneous payment, you can craft a command like this:

`lncli sendpayment --dest <destination public key> --amt <amount> --keysend`

or using AMP (recommended):

`lncli sendpayment --dest <destination public key> --amt <amount> --amp`

### Paying AMP invoices

If the payee has a private node without public channels, they can create an AMP invoice and include routing hints as explained above. The payer can then pay this invoice with the command:

`lncli payinvoice <invoice>`

If an amount is not set in the invoice, it can be set by the payer with

`lncli payinvoice <invoice> –amt <amount>`

## Send a message to other nodes

You can include messages into your spontaneous payments with the `–data` flag. It must follow the convention `<record_id>=<hex_value>,<record_id>=<hex_value>,..`

Messages are typically sent with the record ID `34349334`. You can find a registry for such records [here](https://github.com/satoshisstream/satoshis.stream/blob/main/TLV\_registry.md). You may also submit your own suggestions.

You can encode any data in hex, either using your favorite command line or web tool.

The phrase “`Happy Genesis Block Day!`” becomes `48617070792047656E6573697320426C6F636B2044617921`

The full command below will send this message together with 10 satoshis to [Amboss.space](https://amboss.space), where it is displayed publicly.

`lncli sendpayment --dest 03006fcf3312dae8d068ea297f58e2bd00ec1ffe214b793eda46966b6294a53ce6 --amt 10 --data 34349334=48617070792047656E6573697320426C6F636B2044617921 --keysend`

If the payee has created an AMP invoice, the data can also be appended to the command:

`lncli payinvoice <invoice> --data 34349334=486170707920477265676F7269616E204E6577205965617220746F2065766572796F6E65206174204C696768746E696E67204C61627321`

## Send keysend messages using RPC <a href="#docs-internal-guid-5736b677-7fff-7369-1bb3-cf686146b756" id="docs-internal-guid-5736b677-7fff-7369-1bb3-cf686146b756"></a>

Below you can find some sample python code courtesy of [@brianoflondon](https://github.com/brianoflondon) showing how to send keysend messages using LND’s REST API.

When using the RPC, it is important to remember to generate a random 32 byte preimage and pass this to LND, as without it LND would not be able to settle a failed HTLC.

The actual message is sent with record `34349334`. Depending on the purpose of the message, [other records](https://github.com/satoshisstream/satoshis.stream/blob/main/TLV\_registry.md) may be used.

```python
def send_keysend(
    amt: int,
    dest_pubkey: str = "",
    keysend_message: str = "sample message",
)

    my_node = "https://127.0.0.1:8080/"
    headers, cert = get_lnd_headers_cert(admin=True, node=node)
    if not dest_pubkey:
        dest_pubkey = destination_public_key
# Base 64 encoded destination bytes
    dest = b64_hex_transform(dest_pubkey)
# We generate a random 32 byte Hex pre_image here.
    pre_image = token_hex(32)
# This is the hash of the pre-image
    payment_hash = sha256(bytes.fromhex(pre_image))
# The record 5482373484 is special: it carries the pre_image to the destination so it can be compared with the hash we pass via the payment_hash
    dest_custom_records = {
        5482373484: b64_hex_transform(pre_image),
        34349334: b64_transform(keysend_message),
    }
    url = f"{node}v1/channels/transactions"
    data = {
        "dest": dest,
        "amt": amt,
        "payment_hash": b64_hex_transform(payment_hash.hexdigest()),
        "dest_custom_records": dest_custom_records,
    }

    response = httpx.post(
        url=url, headers=headers, data=json.dumps(data), verify=cert
        )
```
