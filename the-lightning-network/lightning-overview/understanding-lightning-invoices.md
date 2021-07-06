---
description: 'Learn how to identify, decode and create Lightning invoices'
---

# Understanding Lightning Invoices

Lightning invoices are defined by the [BOLT 11 standard](https://github.com/lightningnetwork/lightning-rfc/blob/master/11-payment-encoding.md). BOLT stands for ‘Basis of Lightning Technology’ and covers all Lightning Network specifications. BOLT specifications are necessary to allow separate implementations to function and interact on the same network. Thus, with the specification, a Lightning invoice created by any client or tool will be understood by all other implementations.

## Example of a Lightning Invoice

`lnbc20m1pvjluezpp5qqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqypqhp58yjmdan79s6qqdhdzgynm4zwqd5d7xmw5fk98klysy043l2ahrqsfpp3qjmp7lwpagxun9pygexvgpjdc4jdj85fr9yq20q82gphp2nflc7jtzrcazrra7wwgzxqc8u7754cdlpfrmccae92qgzqvzq2ps8pqqqqqqpqqqqq9qqqvpeuqafqxu92d8lr6fvg0r5gv0heeeqgcrqlnm6jhphu9y00rrhy4grqszsvpcgpy9qqqqqqgqqqqq7qqzqj9n4evl6mr5aj9f58zp6fyjzup6ywn3x6sk8akg5v4tgn2q8g4fhx05wf6juaxu9760yp46454gpg5mtzgerlzezqcqvjnhjh8z3g2qqdhhwkj`

## URI Scheme

Lightning invoices may be prefixed with `lightning:` to signal in hyperlinks which software can be used to pay the invoice. Ideally, in the long term, with this URI scheme, if you follow a Lightning link on the web, your browser or operating system will direct you to the Lightning wallet of your choice where you can confirm to pay this invoice. 

## The Lightning Invoice

The Lightning invoice consists of a human readable part and a data part.

### Case sensitivity

Lightning Network invoices, like other bech32 encoded strings, are typically entirely lowercase. However, there are significant space improvements when encoding uppercase characters only in QR codes, which is why you might encounter uppercase Lightning invoices more frequently. This is also why a Lightning invoice QR code might decode as uppercase only.

### Prefix

A Lightning invoice starts with the letters `ln` for Lightning Network. This is followed by the same two-letter code as defined by [BIP173](https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki) for native Segwit addresses, such as `bc` for Bitcoin, `tb` for Testnet Bitcoin, `bs` for Bitcoin signet and `bcrt` for Bitcoin regtest. As the invoice is [Bech32](https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki) encoded, it will also need to include the appropriate checksum at the end.

### Amount

The prefix is followed by the amount. While a typical Lightning invoice will include an amount, it is possible to issue invoices without amounts. Lightning Invoices reference bitcoin, not satoshi. To save space for round invoices, an amount may be followed by a multiplier. A single satoshi Lightning invoice for example would appear as `10n`, a hundred satoshi as `1u`, and a milli-satoshi as `10p`.

| unit | multiplier | satoshi |
| :--- | :--- | :--- |
| m \(milli\) | 0.001 | 100,000 |
| u \(micro\) | 0.000001 | 100 |
| n \(nano\) | 0.000000001 | 0.1 |
| p \(pico\) | 0.000000000001 | 0.0001 |

Prefix and amount together are human-readable, allowing a savvy user to immediately identify it as a Lightning invoice and deduce its amount.

### Timestamp

The first part of the data part is a unix timestamp.

### Tagged

There are a number of tags that may be used to indicate additional data. Some of that data is required, while others can be optionally supplied by the payee.

Currently defined are the following fields: 

* `p` \(1\): The 256-bit SHA256 payment\_hash. This preimage is later revealed as part of the payment process and can act as proof of payment.
* `s` \(16\): A 256-bit secret prevents forwarding nodes from probing the payment recipient.
* `d` \(13\): A short description of purpose of payment may be added here, encoded with UTF-8, e.g. '1 cup of coffee' or '一杯咖啡'. If this field is not set, tag h has to be used instead.
* `n` \(19\): The 33-byte public key of the payee node may be included here.
* `h` \(23\): If field d does not provide space, a hash of the longer description may be included here. How the full description then gets communicated is not defined here.
* `x` \(6\): The expiry time in seconds.
* `c` \(24\): The min\_final\_cltv\_expiry for the last HTLC in the route. Typically defaults to 18.
* `f` \(9\): A fallback on-chain address can be included here in case the Lightning payment fails for whatever reason.
* `r` \(3\): One or more entries containing extra routing information for a private route. These routing hints include a 
  * pubkey \(264 bits\)
  * short\_channel\_id \(64 bits\)
  * fee\_base\_msat \(32 bits, big-endian\)
  * fee\_proportional\_millionths \(32 bits, big-endian\)
  * cltv\_expiry\_delta \(16 bits, big-endian\)
* `9` \(5\): One or more 5-bit values containing features supported or required for receiving this payment.

### Signature <a id="docs-internal-guid-bf1851de-7fff-593c-551b-0470d2c05dad"></a>

Finally, the invoice will include a signature. This signature is verified using the public key provided in the invoice. 

## LNURL

A Lightning Network URL, or LNURL, is a [proposed standard](https://github.com/fiatjaf/lnurl-rfc) for interactions between a Lightning payer and payee.

In short, a LNURL is a bech32 encoded url pre-fixed with lnurl. The Lightning wallet is expected to decode the url, contact the url and await a json object with further instructions, most notably a tag defining the behavior of the lnurl.

LNURLs are most commonly used to initiate withdrawals or create static payment links.

## Decode a Lightning invoice <a id="docs-internal-guid-8ecef058-7fff-d6ea-2918-35bcc276e339"></a>

You can decode any Lightning invoice to inspect its contents with the command `lncli decodepayreq`.

For the above example, the result is the following:

`{  
    "destination": "03e7156ae33b0a208d0744199163177e909e80176e55d97a2f221ede0f934dd9ad",  
    "payment_hash": "0001020304050607080900010203040506070809000102030405060708090102",  
    "num_satoshis": "2000000",  
    "timestamp": "1496314658",  
    "expiry": "3600",  
    "description": "",  
    "description_hash": "3925b6f67e2c340036ed12093dd44e0368df1b6ea26c53dbe4811f58fd5db8c1",  
    "fallback_addr": "1RustyRX2oai4EYYDpQGWvEL62BBGqN9T",  
    "cltv_expiry": "9",  
    "route_hints": [  
        {  
            "hop_hints": [  
                {  
                    "node_id": "029e03a901b85534ff1e92c43c74431f7ce72046060fcf7a95c37e148f78c77255",  
                    "chan_id": "72623859790382856",  
                    "fee_base_msat": 1,  
                    "fee_proportional_millionths": 20,  
                    "cltv_expiry_delta": 3  
                },  
                {  
                    "node_id": "039e03a901b85534ff1e92c43c74431f7ce72046060fcf7a95c37e148f78c77255",  
                    "chan_id": "217304205466536202",  
                    "fee_base_msat": 2,  
                    "fee_proportional_millionths": 30,  
                    "cltv_expiry_delta": 4  
                }  
            ]  
        }  
    ],  
    "payment_addr": null,  
    "num_msat": "2000000000",  
    "features": {  
    }  
}`

## Read more

[BECH32 as defined in BIP173.](https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki)

[BOLT11 specification and examples](https://github.com/lightningnetwork/lightning-rfc/blob/master/11-payment-encoding.md).

[Sample Implementation.](https://github.com/rustyrussell/lightning-payencode)

[Tool to decode Lightning invoices.](https://bitcoincore.tech/apps/bolt11-ui/index.html)

