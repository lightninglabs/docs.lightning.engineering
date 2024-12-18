---
description: >-
  A static Loop In Address is a special form of a timeout contract that backs a
  submarine swap. It allows for the onchain transaction to occur independently
  of the offchain transaction.
---

# Static Loop In Addresses

A static Loop In Address is the timeout address that holds the funds to a new type of [onchain to offchain submarine swap](../../the-lightning-network/multihop-payments/understanding-submarine-swaps.md). It allows the user to deposit funds onchain at any time before initiating the Loop In. This has multiple advantages over a traditional swap without compromising its trustless nature:

1. Lower onchain fees: Fees may be set more conservatively, as their inclusion in a block is not time sensitive.
2. Instant liquidity deployment: A Loop In from a static address no longer requires confirmations, allowing for capital to be deployed offchain instantly at low cost.
3. Flexible amounts: You may deposit any amount in multiple transactions to your address, and Loop In all or any combination of your deposits.  In the future you may Loop In fractions of your deposit as well.
4. Change your mind: You may withdraw your onchain funds from a Loop In Address at any time. This allows you to use such an address in lieu of your primary hot wallet without losing control of your funds.
5. Send change to static addresses: To avoid small UTXOs in your wallet, you may send change to a Loop In Address. Channels may also be cooperatively closed directly into a Loop In Address.

Due to these advantages we expect Static Addresses to become the default for performing Loop Ins. There will still be a minimum swap size (currently 250,000 satoshis), but any UTXO held in a Loop In Address may be smaller.

## Under the hood <a href="#docs-internal-guid-a3c97746-7fff-60c9-e374-62c32f4f7fd3" id="docs-internal-guid-a3c97746-7fff-60c9-e374-62c32f4f7fd3"></a>

Loop In Addresses are two-of-two multisignature taproot addresses. One key is held by the user, the other by Loop. They allow the user to recover their funds unilaterally after a pre-defined time-out, set at 14,400 blocks, or about 100 days.

The user may initiate a Loop In from this address for one or multiple UTXOs at any time. This will prompt the user to generate a Lightning invoice which is transmitted to the Loop service. Before this invoice is paid, Loop will request the user to sign a transaction paying one or multiple UTXOs into a traditional submarine swap HTLC. This HTLC transaction is held but not published by the Loop service.

Once this transaction is signed, both the user and the Loop service are satisfied they at no point can lose their funds in the swap, and the Lightning invoice is paid. The user will be able to recover their funds from the Loop In Address after a timeout if the invoice is not paid, and the service is able to recover the onchain funds with the preimage obtained from successfully paying the invoice.

To increase chain efficiency and reduce costs, the service will now request the user to sign a replacement transaction, paying the funds directly into the onchain wallet of the service. If successful, only this second transaction is published.

The user may also request a withdrawal from their Loop In Address any time before its expiration.

> ⚠️Do not delete your L402 token, as this is used to identify you to the service. If the L402 token is lost, the only way to exit the contract is to wait for the timeout to pass.⚠️

## Create a static Loop In Address <a href="#docs-internal-guid-1eab9bca-7fff-e6b8-0708-10e49e4d18f1" id="docs-internal-guid-1eab9bca-7fff-e6b8-0708-10e49e4d18f1"></a>

You may generate one or multiple Loop In Addresses with the command:

`loop static new`

It’s important to know that you will need to carefully guard your L402 token (located in `~/.loop/mainnet`) in order to perform Loop ins or withdrawals. If the L402 token is lost, you will have to wait for the timeouts to expire, which may take up to three months.

The command `listunspent` will show you all the Loop In Address deposits that are still unspent.

`loop static listunspent`

```
{
	"utxos": [
    	{
        	"static_address": "tb1pzma6vqegy5qja3tkepwyuyvzkkcqt8lqgsmvmdvl7zc3rnr3qhdqrwj5cw",
        	"amount_sat": "30000",
        	"outpoint": "3491527904bc67f061648f31d650e5bae22c677dc2886ed6b410e9115ac2f489:1",
        	"confirmations": "0"
    	},
    	{
        	"static_address": "tb1pzma6vqegy5qja3tkepwyuyvzkkcqt8lqgsmvmdvl7zc3rnr3qhdqrwj5cw",
        	"amount_sat": "300000",
        	"outpoint": "f815a9026002af831c8bc80139d78f5e683cecccf57d93197628f82f1cebe8f0:1",
        	"confirmations": "13"
    	}
	]
}
```

Similarly, `loop static listdeposits` will show you all available and completed Loop In actions with sufficient confirmations. A deposit will show up in this list once it has six confirmations on the Bitcoin blockchain. Withdrawn or expired deposits, completed Loop Ins, as well as various error messages will also appear here.&#x20;

```
{
	"filtered_deposits": [
    	{
        	"id": "0b8685ba301344958f8a690c0aee3ad2c5a1632f7ebd05ec08ae880d81048a0f",
        	"state": "DEPOSITED",
        	"outpoint": "f815a9026002af831c8bc80139d78f5e683cecccf57d93197628f82f1cebe8f0:1",
        	"value": "300000",
        	"confirmation_height": "226220",
        	"blocks_until_expiry": "1482"
    	},
    	{
        	"id": "6ee4ca923872bd65a6da339535989b60026a834891cfb2d17acb182dcfe915d4",
        	"state": "DEPOSITED",
        	"outpoint": "3491527904bc67f061648f31d650e5bae22c677dc2886ed6b410e9115ac2f489:1",
        	"value": "30000",
        	"confirmation_height": "226233",
        	"blocks_until_expiry": "1495"
    	}
	]
}

```

You are also able to use your static Loop In Address as a regular onchain wallet. As any static address deposit is just a pay-to-taproot output, transactions from these addresses are not more or less expensive than transactions from your internal LND wallet. The command `loop static withdraw` allows you to spend all or specific UTXOs to a specified address.

You can perform the swap into your Lightning channel balance with `loop static in`. You will be able to select which UTXOs to swap and optionally which channel you wish the payment to arrive in.

```
{
	"swap_hash": "bb229e862182ed912025d0ea68dc4295dc717f5b2693b5bfcc28a85363bffbd8",
	"state": "SignHtlcTx",
	"amount": "300000",
	"htlc_cltv": 226738,
	"quoted_swap_fee_satoshis": "1450",
	"max_swap_fee_satoshis": "1450",
	"initiation_height": 226238,
	"protocol_version": "V0",
	"label": "",
	"initiator": "loop-cli",
	"payment_timeout_seconds": 60
}

```

The command `loop static listswaps` will show all swaps.

```
{
	"swaps": [
    	{
        	"swap_hash": "bb229e862182ed912025d0ea68dc4295dc717f5b2693b5bfcc28a85363bffbd8",
        	"deposit_outpoints": [
            	"f815a9026002af831c8bc80139d78f5e683cecccf57d93197628f82f1cebe8f0:1"
        	],
        	"state": "SUCCEEDED",
        	"swap_amount_satoshis": "300000",
        	"payment_request_amount_satoshis": "298550"
    	},
    	{
        	"swap_hash": "ca70b1b9e367b37e7a1fab903bc16e0f2778a8becf53d8083524c94f5d785b6d",
        	"deposit_outpoints": [
            	"3491527904bc67f061648f31d650e5bae22c677dc2886ed6b410e9115ac2f489:1",
            	"45415516dfcc0bc9d4185ed900888b2d3b6731d12e1cdcabd47c8b67121b74db:1"
        	],
        	"state": "SUCCEEDED",
        	"swap_amount_satoshis": "360000",
        	"payment_request_amount_satoshis": "357725"
    	}
	]
}

```

The command `loop static summary` will show you the number of deposits, the timelock and your static address.

```
{
	"static_address": "tb1pzma6vqegy5qja3tkepwyuyvzkkcqt8lqgsmvmdvl7zc3rnr3qhdqrwj5cw",
	"relative_expiry_blocks": "1500",
	"total_num_deposits": 3,
	"value_unconfirmed_satoshis": "0",
	"value_deposited_satoshis": "0",
	"value_expired_satoshis": "0",
	"value_withdrawn_satoshis": "0",
	"value_looped_in_satoshis": "660000",
	"value_htlc_timeout_sweeps_satoshis": "0"
}
```

At this point in time only one static Loop In Address is available per user, and each UTXO has to be swapped in its entirety. Loop will expand its offerings in the future to allow for multiple static addresses and partial swaps.
