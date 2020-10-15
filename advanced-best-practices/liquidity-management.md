# Liquidity Management

## Receive Heavy

This section covers Liquidity management for operators that are primarily concerned with receiving funds over Lightning, feel free to skip it if your use case is send-heavy.  

## Inbound Liquidity

When you open a channel from your node to another, your node contributes all the funds for the channel, so the whole channel balance sits on your side of the channel. This means that you cannot receive on this channel, because there are no funds to shift in your direction in the channel. Only once you have sent some payments out over the channel, shifting balance to the other side, will you be able to receive over it. 

The practice of managing inbound liquidity solves the problem of needing balance on the opposite side of the channel in the case where you do not have a use-case for sending money out to acquire it. If you are running a receives-focused application on Lightning, managing incoming liquidity is an essential part of operating your node. 

## Lightning Loop

Lightning Loop is an atomic swap service which allows users to acquire incoming liquidity on a channel of their choice through the use of its Loop Out functionality. This service allows your node to send payment off-chain, thereby acquiring incoming liquidity, and reclaim those funds on chain. If you are running [Lightning Terminal](https://github.com/lightninglabs/lightning-terminal), you can easily initiate swaps using the UI, or via rpc because the loop daemon is packaged with terminal. Alternatively, you will need to setup [loopd](https://github.com/lightninglabs/loop) as a standalone service. 

![](https://lh5.googleusercontent.com/SWvhTgNWEjkFkmWDF86rIWhb0mNwcSKsxpO6YQMyufCfD0BH8GDrFzZeA809tewkA0m1ovOV1KrF3Up24v50kEgY17ZxjGlWh9BhnaQSgRrnCqDTLt5kj4dFiXoYeA2xqxyvOgYY)

If you would like to learn more about loop, please reach out to us at hello@lightning.engineering.

## Circular Rebalance

Circular rebalance provides an off-chain only approach for balancing channels. A circular rebalance is a payment made to yourself, which pushes balance out on one channel, but pays the balance back to yourself on another channel. Note that this option is zero-sum, because you require incoming liquidity to route the payment back to yourself. 

To perform a circular rebalance:

* Get your node’s public key from _GetInfo_
* Call _QueryRoutes_ with _dest_ set to your own pubkey, or manually construct a route using the channels you would like to use
* Dispatch the payment with the _allow\_self\_payment_ boolean set to true

  


