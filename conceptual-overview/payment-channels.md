# Payment Channels

Payment channels are the main workhorse of the Lightning Network. They allow multiple transactions to be aggregated into just a few on-chain transactions.

In the vast majority of cases, someone only needs to broadcast the first and last transaction in the channel.

* The Funding Transaction creates the channel. During this stage, funds are sent into a multisig address controlled by both Alice and Bob, the counterparties to the channel. This address can be funded as a single-payer channel or by both Alice and Bob.
* The Closing Transaction closes the channel. When broadcast, the multisig address spends the funds back to Alice and Bob according to their agreed-upon channel amount.

![Commitment transaction Alice 5BTC Bob 5BTC](https://imgur.com/rqHWEoC.png)

In the case where either party attempts to defraud the other, a third transaction, which punishes the attacker, will end up being broadcasted on-chain. Let’s investigate how this is possible by the way Lightning does channel updates.

## **Channel Updates**

In between the opening and closing transactions broadcast to the blockchain, Alice and Bob can create a near infinite number of intermediate closing transactions that gives different amounts to the two parties.

For example, if the initial state of the channel credits both Alice and Bob with 5BTC out of the 10BTC total contained in the multisig address, Alice can make a 1BTC payment to Bob by updating the closing transaction to pay 4BTC/6BTC, where Alice is credited with 4BTC and Bob with 6BTC. Alice will give the signed transaction to Bob, which is equivalent to payment, because Bob can broadcast it at any time to claim his portion of the funds. Similarly, Alice is also able to broadcast the closing transaction at any time to claim her funds.

![Channel Update Alice 4BTC Bob 6BTC](https://imgur.com/auACasH.png)

To prevent an attack where Alice voids her payment by broadcasting the initial state of 5BTC/5BTC, there needs to be a way to revoke prior closing transactions. Payment revocation roughly works like the following.

When Alice broadcasts a closing transaction to the blockchain, she is attesting to the current state of the chain. But since there may be millions of closing transactions in a channel, all of which are valid, the blockchain itself can’t tell if what Alice attested to was indeed the correct state. Therefore, Alice must wait 3 days after broadcasting the closing transaction before she can redeem her funds. During this time, Bob is given a chance to reveal a secret that will allow him to sweep Alice’s funds immediately. Alice can thus revoke her claim to the money in some state by giving Bob the secret to the closing transaction. This allows Bob to take all of Alice’s money, but only if Alice attest to this old state by broadcasting the corresponding closing transaction to the blockchain.

Channel updates are thus fully trustless. When making an update, both parties exchange the secrets for the prior state, so that all prior states will have been revoked except for the current state. Both parties will never broadcast an old state, because they know the other party can take all their money if they do so.

