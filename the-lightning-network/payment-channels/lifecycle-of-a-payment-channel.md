# Lifecycle of a Payment Channel

At its core, a payment channel is a 2-of-2 multisignature contract between two parties holding bitcoin. While this bitcoin is held cooperatively by the two parties from the perspective of the Blockchain, each party owns a portion of it, and maintains a record of this ownership locally.

For example, a payment channel of over 1 million satoshis can represent 100,000 satoshis in the hands of Alice, and 900,000 satoshis in the hands of Bob. The two can cooperate to update their balances as frequently as they like, without the need for making an on-chain Bitcoin transaction or incurring costs beyond the electricity and bandwidth they consume.

To ensure that Alice and Bob do not have to trust each other, each payment channel is secured by a commitment transaction signed by both Alice and Bob that allows each of them to unilaterally exit the agreement at any time, spending their respective share of the funds back to their own wallet. Such an event is called a “force close.”

## Opening a channel <a href="#docs-internal-guid-9d39ae87-7fff-839a-c0ec-60c6ea73aa0b" id="docs-internal-guid-9d39ae87-7fff-839a-c0ec-60c6ea73aa0b"></a>

To open a channel to Alice, her node needs to be reachable over the internet. Alice may also place restrictions on new channels, such as a minimum channel size or gating for specific peers.

For Bob to open such a channel, he also needs funds in the form of bitcoin on-chain, either in his Lightning node or another wallet he controls. Upon his command, his node will connect to Alice and offer a channel. Alice and Bob will combine their keys to generate a 2-of-2 multisignature contract, which will act as the channel’s address.

To ensure that at no point Bob finds his funds stuck in this contract, he creates his funding transaction, but does not broadcast it to the network. He creates an additional transaction, the commitment transaction, that spends his funds back to him, and asks Alice to co-sign it.

Now Bob may broadcast his first transaction and fund the payment channel, and keep the second refund transaction in memory. Alice cannot take his funds without his cooperation, and if she were to become unresponsive, he could then broadcast the commitment transaction. The payment channel is now open and available for use.

## Sending funds through a payment channel <a href="#docs-internal-guid-21304ebc-7fff-daf8-133a-d55c4ba78638" id="docs-internal-guid-21304ebc-7fff-daf8-133a-d55c4ba78638"></a>

The latest commitment transaction always represents the channel balances between Alice and Bob. They can transfer this balance to each other by updating their commitment transaction. They can do this as frequently as needed in increments of one millisatoshi.

These updates can be made in both directions, and there is no upper limit to how many updates can be made inside a single payment channel. As these payments are not announced to the network and the funds never move on-chain, they are only known to each party.

At each payment, Alice and Bob invalidate each other’s previous commitment transaction, ensuring that only the most recent transaction can be used to recover their balance in the event of a non-cooperative channel closure.

[Read more: Hash Time-lock Contracts (HTLC)](../multihop-payments/hash-time-lock-contract-htlc.md)

## Closing a channel <a href="#docs-internal-guid-05067e10-7fff-49ae-141e-183d040b5b8c" id="docs-internal-guid-05067e10-7fff-49ae-141e-183d040b5b8c"></a>

There are two ways of closing a channel: Cooperatively and non-cooperatively

### Cooperatively

In a cooperative close, both Alice and Bob are online, agree on their balance and on the terms of a channel closure (e.g. fees) proposed by either party. They will both sign a new transaction that spends the funds back to their respective wallets immediately and no longer process transactions between them.

As soon as their closure transaction is confirmed on the blockchain, they can use it to open new channels, move the funds elsewhere or leave them in their wallet.

Cooperative channel closures are the norm in the Lightning Network.

### Non-cooperatively <a href="#docs-internal-guid-e76a073d-7fff-80ed-f488-6c7de3c1e09f" id="docs-internal-guid-e76a073d-7fff-80ed-f488-6c7de3c1e09f"></a>

Either Alice or Bob may not be available, or may for other reasons be unable or unwilling to sign their closure transaction. In this case, the party aiming to close the channel will have to publish their commitment transaction. This will result in a non-cooperative close, also called a force close.

These commitment transactions are asymmetrical, as they spend the balance of the peer initiating the force close to an arbitration contract, while the funds of the other party are sent to their wallet immediately. This allows the peer that is not initiating the force closure to contest it.

In the event that one party were to attempt to “cheat” by publishing an older commitment transaction, their peer is able to use the previously exchanged revocation secret to claim the funds of the malicious actor, providing a valuable incentive to remain honest, securing the network overall.
