---
description: >-
  Pool is a market place for channel liquidity. It is bundled with Lightning
  Terminal through a handy user interface.
---

# Pool and Lightning Terminal

Lightning Terminal offers a graphical interface for Pool, making it easy and intuitive to buy, sell or redeem channels. [Lightning Pool](../pool/) is a non-custodial marketplace for channels. You can use Pool to buy channels, or sell your extra liquidity to others.

### How to use Pool in Lightning Terminal

Navigate to ‘Pool’ in [Lightning Terminal](https://terminal.lightning.engineering/#/). You will need to create and fund your account. To open it, you will need funds in your LND’s on-chain wallet.

### Open an Account

To open the account, click on ‘Open an Account’ on the left bar of Lightning Terminal. You can define how much of your funds you want to commit to the account, how long you are willing to lock them up and how fast you want to open the account. A longer lock-up period and slower confirmation times will save you in on-chain fees.

If you want to primarily sell channels, the funds in your Pool account need to be able to cover the capacity of the channels you intend to sell. If you are only buying channels, you only need to commit enough to cover the fees.

To authenticate your account to the Pool server, your node will purchase an [LSAT](../../the-lightning-network/lsat/) for 1000 satoshis. This transaction is made over the Lightning Network and you will be able to see it in your Dashboard.

### Custody

Your pool account is a 2-of-2 multisignature contract secured on the bitcoin blockchain. Similar to how Lightning Network channels are force-closed, you are creating a refund transaction from your pool account, signed by the Pool auctioneer, before committing any funds into your account.

This refund transaction allows you to retrieve your funds at the end of the lockdown period, but an account can be closed cooperatively anytime before.

### The auction

Pool performs a batched, sealed-bid, uniform clearing-price auction. That means that all bids and asks are collected every ten minutes and cleared at the same price. The bids are not visible to participants.

You can place a bid (meaning you want to buy a channel lease or get inbound) or an ask (selling a channel lease or earn yield). For each, you can define the liquidity you intend to trade, the fee you want to charge or pay as well as define on-chain fees and minimum channel size. For bids you can also specify whether you are willing to accept channels from nodes not ranked on Lightning Terminal.

Pool will calculate the expected fees or earnings for you, including the annual rate. In the Pool dashboard you are able to see the clearing prices, volumes and number of orders of the recent batches. A batch can happen at most once per block, but not every block needs to have a batch in it.

### Bids

When placing a bid, you are offering to pay for inbound liquidity. You can define how much incoming liquidity you desire and how much you are willing to pay for it. Pool will calculate your fees for you, including the fees for using Pool, chain fees and an annualized rate. Review these parameters carefully before you place your bid!

As soon as you place your bid, it will appear in the ‘Orders’ list. Once somebody else has placed an ‘Ask’ for less or equal than your bid, you will be matched at a lower or equal rate and the channel is opened to you. You can see all channels opened through Pool on the right under ‘Filled channel leases.’

### Asks

If you have liquidity that you want to sell on Pool, you will need to be ‘ranked,’ meaning considered a Tier 1 (T1) node. You can see your node tier on the top right corner.

Similar to bids, state how much liquidity you are willing to provision at what rate, as well as your desired minimum channel size and on-chain fees.

Your asks will appear in the ‘Orders’ list together with your bids. You can filter by open and filled orders and see how much of the channel duration has already elapsed. Be careful not to close your channels before then!

### Register a Sidecar channel

It is not yet possible to buy [Sidecar channels](../pool/sidecar\_channels.md) through Terminal yet. However, it is possible to redeem Sidecar channels that others have ordered for you.

\


Return to the dashboard and click on ‘Loop.’ To the right of the Loop symbol and button you should see the option to ‘Register a Sidecar channel.’ Enter your sidecar ticket into the user interface and confirm before the channel is opened to your node.
