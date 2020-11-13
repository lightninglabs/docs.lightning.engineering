# Multihop Payments

#### Multihop payments <a id="multihop-payments"></a>

Single channels work well if you have a financial relationship with some entity where you make payments frequently or in metered amounts. But most payments, like purchasing an umbrella from a corner store because you lost it again, are one-off. For Lightning to help Bitcoin scale for general use cases, there needs to be a way for the whole network to forward payments through channels that already exist. Furthermore, this process should retain the trustless nature of individual channels, otherwise it becomes too hard to identify dishonest actors amongst a large number of hops.

Once you don’t have to trust the intermediaries, you no longer even care who they are. This allows Lightning nodes to be fully anonymous, which is a huge win for privacy.

Concretely, suppose Alice has a channel with Bob, who has a channel with Carol, who has a channel with Dave: `A<->B<->C<->D`. How can Alice pay Dave?

Alice first notifies Dave that she wants to send him some money.

In order for Dave to accept this payment, he must generate a random number `R`. He keeps `R` secret, but hashes it and gives the hash `H` to Alice.

![Dave gives hash H to Alice](https://imgur.com/sXuL8Tn.png)

Alice tells Bob: “I will pay you if you can produce the preimage of `H` within 3 days.” In particular, she signs a transaction where for the first three days after it is broadcast, only Bob can redeem it with knowledge of R, and afterwards it is redeemable only by Alice. This transaction is called a Hash Time-Locked Contract \(HTLC\) and allows Alice to make a conditional promise to Bob while ensuring that her funds will not be accidentally burned if Bob never learns what R is. She gives this signed transaction to Bob, but neither of them broadcast it, because they are expecting to clear it out later.

![Alice creates HTLC with Bob](https://imgur.com/aNQoA9Z.png)

Bob, knowing that he can pull funds from Alice if he knows R, now has no issue telling Carol: “I will pay you if you can produce the preimage of H within 2 days.”

Carol does the same, making an HTLC that will pay Dave if Dave can produce R within 1 day. However, Dave does in fact know R. Because Dave is able to pull the desired amount from Carol, Dave can consider the payment from Alice completed. Now, he has no problem telling R to Carol and Bob so that they are able to collect their funds as well.

![Dave distributes R](https://imgur.com/nTLWBbm.png)

Now, everyone can clear out, because they have a guaranteed way to pull their deserved funds by broadcasting these HTLCs onto Bitcoin’s network \(i.e. on-chain\). They would prefer not to do that though, since broadcasting on-chain is more expensive, and instead settle each of these hops off chain. Alice knows that Bob can pull funds from her since he has `R`, so she tells Bob: “I’ll pay you, regardless of `R`, and in doing so we’ll terminate the HTLC so we can forget about R.” Bob does the same with Carol, and Carol with Dave.

![Everyone terminates their HTLCs](https://imgur.com/iRx4bf5.png)

Now, what if Dave is uncooperative and refuses to give `R` to Bob and Carol? Note that Dave must broadcast the transaction from Carol within 1 day, and in doing so must reveal R in order to redeem the funds. Bob and Carol can simply look at the blockchain to determine what R is and settle off-chain as well.

We have shown how to make a payment across the Lightning Network using only off-chain transactions, without requiring direct channel links or trusting any intermediaries. As long as there is a path from the payer to the payee, payments can be routed, just like the Internet.

