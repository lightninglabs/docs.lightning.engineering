---
description: Run Wavelength, deposit funds over Lightning or onchain, and send them out.
---

# First Steps

When using the CLI, you may have to define the network your `waved` instance is running on, e.g.:

`wavecli --network=signet/testnet getinfo`

## Create a wallet

When using the `btcwallet` (neutrino) or `lwwallet` (esplora) backend, you will first have to create a wallet.

`wavecli create`

This will prompt you to choose a password that will be used to encrypt your keys. After you confirm this password, you will be shown your seed phrase. Write it down carefully, ideally with pencil on paper, and store that paper somewhere securely.

## Unlock your wallet

After an eventual restart of waved, you may unlock your wallet using the password with:

`wavecli unlock`

## Receive

You can receive over Lightning, or onchain.

`wavecli recv --offchain --amt 2100 --memo ‘my first payment’`

You will be given a Bolt11 invoice, which you can pay from any Lightning wallet.

`wavecli recv --onchain`

You will be given an onchain address, to which you can send any amount. After one confirmation it will be swept and appear in your balance. Onchain fees and liquidity fees will be deducted.

## Activity

You can always inspect your balance.

`wavecli balance`

You can also check your activity log.

`wavecli activity`

## Send

You can send over Lightning or onchain.

`wavecli send --offchain <bolt11 invoice>`

Additionally, you can define a maximum offchain fee with `--max_fee <max fee in satoshis>`

`wavecli send --onchain <onchain address> --amt <amount>`

Alternatively, you can also sweep all funds with `--sweep-all` and define a maximum fee with `--max_fee`
