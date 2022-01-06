---
description: >-
  Lightning Terminal bundles Loop to make it easy for you to manage your channel
  liquidity.
---

# Loop and Lightning Terminal

Lightning Terminal offers a graphical interface for Loop, making it easy and intuitive to make submarine swaps. [Lightning Loop](../loop/) is a service that allows users to make a Lightning transaction to an on-chain Bitcoin address (Loop Out), or send on-chain Bitcoin directly into a Lightning channel (Loop In).\
Loop can help manage channel liquidity, for example, by emptying out a channel and [acquiring inbound capacity](../../the-lightning-network/liquidity/how-to-get-inbound-capacity-on-the-lightning-network.md) (or refilling a depleted channel).

[Learn more about how Submarine Swaps work.](../../the-lightning-network/lightning-overview/understanding-submarine-swaps.md)

## How to use Loop in Lightning Terminal <a href="#docs-internal-guid-eae8e6fb-7fff-9fc5-7155-0aae66bbe668" id="docs-internal-guid-eae8e6fb-7fff-9fc5-7155-0aae66bbe668"></a>

On the left side of Lightning Terminal you see ‘Loop.’ Clicking on it shows an overview over your history, current capacity, your channels and their balances.&#x20;

You can select the ‘Loop’ button below the field ‘history’, at which point you can select which channel you would like to Loop In or Out of, meaning the channel that you would like to fill or empty. You can also skip this selection and let Loop decide. This option is preferable if you primarily want to move some of your funds into cold storage, for example, as opposed to balancing a specific channel. You can select multiple channels, too!

Once you select a channel, you will also be informed of the minimum swap amount. Upon selecting Loop In or Out, you can use the slider to choose how many satoshis you want to swap.

In the additional options, you can choose your confirmation speed (as measured in blocks, more blocks meaning lower fees). If your goal is to send funds into cold storage or an external wallet, enter your address here.

In the next step, you are provided with a summary of your order. Have a look at whether the correct channel(s) are selected, the amount looped in or out, and whether the fees are acceptable. Upon clicking “Confirm”, your Loop is submitted.

#### Loop In

If you perform a Loop In, the Loop server will probe whether it is able to make an off-chain payment of the selected size to your node. If such a probe is successful, Lightning Terminal will instruct your node to send on-chain funds to the swap address. Once this payment is confirmed, the off-chain payment is made to your node. From your perspective the Loop In is now complete.

#### Loop Out

If you perform a Loop Out, your node will probe whether it can reach the Loop node with a payment of the chosen size. If it can reach it, the Loop server will send the funds to a 2-of-2 multisignature contract.

Once confirmed, Lightning Terminal will instruct your node to make the off-chain payment. As soon as the payment succeeds and Terminal has obtained the preimage, your node will automatically sweep the funds from the multisignature contract and have them on its disposal.

In your Dashboard, you should now be able to see three new transactions. One, over 30,000 satoshis is the prepayment, which will be forfeited if the off-chain transaction is not being made, another over the full amount and a third on-chain transaction sending the funds to your wallet. If you specified an external address, this third transaction will be visible in the corresponding wallet.

[Learn more about Loop fees](../loop/the-loop-cli.md).

#### Loop failures <a href="#docs-internal-guid-322553ac-7fff-f559-9670-7d14f9cf1697" id="docs-internal-guid-322553ac-7fff-f559-9670-7d14f9cf1697"></a>

Loops primarily fail because of missing liquidity between you and the Loop node. For example, the peer whose channel you want to Loop Out of might not have enough outgoing capacity to Loop themselves. If you experience a failure, you may try Loop In or Out with a different channel, or lower the amount of your swap.

### Loop status <a href="#docs-internal-guid-386c8c7b-7fff-759e-997e-a636a509508e" id="docs-internal-guid-386c8c7b-7fff-759e-997e-a636a509508e"></a>

The process of your Loop In or Loop Out is structured into three different steps:

#### Initiated

When initiating a Loop, your node or Loop verifies that it has the ability to make an off-chain payment to the other side. If a swap fails, it is most commonly at this stage, due to lack of liquidity along the route. You may try again with a different channel or a smaller amount. If your swap fails at this stage, you are not charged any fees.

#### Preimage revealed

Once a path has been found for the off-chain funds, the on-chain transaction is made to the submarine swap contract. Once it is confirmed, the recipient of the off-chain payment reveals the preimage and claims the off-chain funds irreversibly for themselves. This in return allows the recipient to claim the on-chain funds from the swap contract. If your Loop fails at this stage, the sender of the on-chain funds will have to sweep the funds back to themselves. If you are performing a Loop In, this will cost you in transaction fees, if you are performing a Loop Out, you are charged a fee by Loop through a Lightning payment. This most commonly happens if the user goes offline or turns off litd or loopd during the swap.

#### Success

Once both parties have received their funds, the Loop is complete.
