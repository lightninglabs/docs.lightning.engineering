---
description: Understand fees in Lightning Loop and get the most out of it
---

# The Loop CLI

## Using Loop <a href="#docs-internal-guid-0588c9ab-7fff-a9c6-0c68-1ad299980217" id="docs-internal-guid-0588c9ab-7fff-a9c6-0c68-1ad299980217"></a>

As soon as Loop is running, you will be able to make use of the CLI. Depending on your installation, you will be able to run it simply by typing loop into your console, or navigate to where the binaries are stored and execute with `./loop`

### Get a quote

We can start by requesting the latest Loop terms. The command `loop terms` should give us information about the minimum and maximum amounts of satoshis we can Loop In or Loop Out. Additionally, it will give us the CLTV Delta, which is the number of blocks our bitcoin would be locked up in the event our Loop In is unsuccessful (i.e. due to lack of inbound liquidity).

You can also use the command `loop getparams` to see current fees, prepaid amounts and [autoloop](autoloop.md) settings.



### Loop In fees

We can also use the command `loop quote in 500000` to get a more precise quote for how much a swap would cost. For Loop In, we are making an on-chain transaction, for which we will have to pay the on-chain transaction fees. If we have enough satoshis in our on-chain LND wallet, Loop can give us a good estimate of these transaction fees as well. Either way, we can Loop In from our internal or external Bitcoin wallet.

In addition we will have to pay a fee for our swap, which is quoted in satoshi as `swap_fee_sat`.

### Loop Out fees

We can request a quote for Loop Out with `loop quote out <amount in satoshi>`. As you perform Loop Out, the on-chain transaction will be made to a Bitcoin smart contract, called a Hash Time-lock Contract, or HTLC). Once your Lightning payment was made successfully to Loop, you will be able to sweep the funds from the smart contract using the secret obtained in the payment. If your Lightning payment fails, for example due to insufficient outbound liquidity, the funds in the smart contract will be returned back to Loop.

The cost of sweeping the smart contract is quoted in satoshi as `htlc_sweep_fee_sat`. This is an estimate based on the amount of data required to sweep the funds as well as the current level of on-chain fees necessary to have your transaction confirmed within the CLTV window.

### Loop In

You can customize the command `loop in <amount in satoshis>`. For example, you could specify the channel that the Lightning payment should arrive in using the `--last_hop` parameter. The last hop is identified by the public key of a node. Make sure that you have an active channel with this node and plenty of incoming capacity. You can also specify a label with `--label`.

You may set the transaction fees separately using this command, or use the `--conf_target` value to a higher number for lower fees and longer processing times.

`loop in --last_hop 02e7a7d3c1e6055b7b7457d95e04d9bbd24f200fd4a58daca7beee7bc776e17440 --amt 295916`\
Once you run the command, you are quoted the upper bound of the fees for this transaction. Loop will now obtain a LSAT for 1 satoshi and initiate the swap.

You can monitor the status of your Loop In with the command loop monitor. It will give you updates about your transaction. As soon as your on-chain transaction has one confirmation on the Blockchain, you should receive your off-chain transaction into the channel you specified.

### External Loop In

You can fund your Loop In with funds from any external wallet using the command line interface using the `--external` flag.

Once you execute the `loop in` command, you are presented with two HTLC smart contract addresses in addition to the swap ID. You may make your on-chain transaction to either of these two addresses, though P2WSH (starting with bc1) is recommended for maximum efficiency. **The payment needs to be the exact amount and carry an appropriate transaction fee**. There is no time limit with regard to when the on-chain payment has to confirm, but keep in mind that if you specify a channel into which the off-chain funds are to be deposited, the state of that channel might change over the next day or two.

### Loop Out

The Loop Out command requires a minimum amount of satoshis, typically around 250,000 satoshis. This value may increase in times of high on-chain fees and can be obtained using the `loop terms` command. You can optionally also specify which channel you want to loop out of using the `--channel` flag together with the short channel ID.

The speed of your swap is highly influenced by your willingness to pay with regard to fees. You can influence these fees in various ways. If you specify the `--fast` flag, the Loop server will publish its on-chain transaction quickly, but at a higher fee.

Once this transaction is confirmed, you will need to sweep its address to your own wallet. This is usually done within 9 blocks, but can be done faster or slower by specifying the desired number of blocks with the `--conf_target` setting.

There are also off-chain fees to consider. You may set yourself an upper bound in satoshi using the `--max_swap_routing_fee` setting.

We can initiate a Loop Out with a transaction as follows:

`loop out --channel 735057608151793668 --conf_target 250 --label ‘Guide to Loop’ --max_swap_routing_fee 2500 --addr bc1qvnfuf2zvg6mrfyjhc8h4c7ge9a7ywfrav52qru --amt 1000000`

We are being presented with a detailed fee overview before we begin the swap:

`Estimated on-chain sweep fee:        7372 sat`\
`Max on-chain sweep fee:            737200 sat`\
`Max off-chain swap routing fee:       2500 sat`\
`Max no show penalty (prepay):       30000 sat`\
`Max off-chain prepay routing fee:      610 sat`\
`Max swap fee:                        3260 sat`

The estimated on-chain sweep fee is the payment required to sweep the Bitcoin once the Loop server has made its on-chain transaction to the HTLC smart contract. This transaction is made first, before we make our Lightning transaction, and the smart contract acts as a trustless arbiter. If we fail for whatever reason to make our Lightning payment to Loop, the server will be able to claim these funds back for itself, and charge us a penalty fee.

As soon as the swap is confirmed, you can use `loop monitor` to follow the status of your transaction. You can view the Bitcoin smart contract using a block explorer and the address provided in the output.

Transactions are batched. While you wait for the Loop Out on-chain transaction to the smart contract to confirm, you may notice that the overall capacity of your node, and more precisely the channel you are Looping Out of is decreasing by the amount of your Loop Out. Once this transaction confirms, the capacity of your channel will go back to its full amount, while your local and remote balances will change by the Loop Out amount.

As soon as the on-chain transaction from Loop Out to the HTLC smart contract is confirmed, our Loop instance will sweep its funds into our internal wallet or the specified external address, for which we will have to pay the miner fee.

For the 1 million satoshi Loop Out in the above example, we are presented with the following fees upon completion:

`cost: server 3260, onchain 6802, offchain 2524`

In total we paid 12,586 satoshi in fee, of which 6802 went to Bitcoin miners, 3260 to Loop and 2524 to the Lightning nodes routing our off-chain payment.

We can also query our specific outgoing Lightning payments with `lncli listpayments`.

We will see two payments, first our 30,000 satoshi prepayment as specified in the quote above. This payment will cover the sweep fee for Loop in case we aren’t able to make the full off-chain payment for the swap. Next, we paid 973,260 satoshi, which includes the remaining 970,000 satoshi of our 1 million satoshi swap plus the 3,260 satoshi swap fee.

We received 993,198 satoshi in our on-chain address.

### External Loop Out

By default, the on-chain transaction will arrive in your LND’s wallet. Alternatively, you can specify the Bitcoin address of any external wallet with the `--addr` flag.

## Use parameters as a frequent user

We can set various parameters for our swaps with the command loop `setparams <options>`

These include:

`--sweeplimit value`      the limit placed on our estimated sweep fee in sat/vByte. (default: 0)

`--maxswapfee value`      the maximum percentage of swap volume we are willing to pay in server fees. (default: 0)

`--maxroutingfee value`   the maximum percentage of off-chain payment volume that we are willing to pay in routing fees. (default: 0)

`--maxprepayfee value`    the maximum percentage of off-chain prepay volume that we are willing to pay in routing fees. (default: 0)

`--maxprepay value`       the maximum no-show (prepay) in satoshis that swap suggestions should be limited to. (default: 0)

`--maxminer value`        the maximum miner fee in satoshis that swap suggestions should be limited to. (default: 0)

`--sweepconf` value       the number of blocks from htlc height that swap suggestion sweeps should target, used to estimate max miner fee. (default: 0)

`--failurebackoff` value  the amount of time, in seconds, that should pass before a channel that previously had a failed swap will be included in suggestions. (default: 0)

Please note that these parameters are not persistent and need to be specified again upon restart. For more information about the fees set in `setparams` visit the [Autoloop documentation](autoloop.md).

## Get detailed information about past Loops

You can use the `loop listswaps` command to get detailed information about past Loops, including their amounts, on-chain addresses, associated fees and eventual failure messages.

You can also query the status of an individual swap with the command `loop swapinfo <swap id>`.&#x20;
