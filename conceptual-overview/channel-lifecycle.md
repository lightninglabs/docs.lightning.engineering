# Channel Lifecycle

To better understand the development workflow around Lightning channels, it is worthwhile to examine step by step the lifecycle of a payment channel. It contains roughly 4 steps:

1. **Adding a peer.** Before a channel can be opened between two Lightning nodes, they must first be able to securely communicate with each other. This is accomplished with the `ConnectPeer` RPC method or `connect` on `lncli`.

   ```text
   lncli connect <PUBKEY>@<HOST>:<PORT>
   ```

2. **Initiating Channel Opening.** The `OpenChannel` method begins the channel opening process with a connected peer. Lightning assumes that this is led by a single party. The opening party can specify a local amount, representing the funds they would like to commit to the channel, and a “push” amount, the amount of money that they would like to give to the other side as part of an initial commitment state. One could imagine that instead of sending a standard Bitcoin transaction to pay a merchant, they could instead open a channel with the push amount representing the amount they want to pay, and optionally add some funds of their own, so that both parties can benefit from having a channel available for payments in the future.

   ```text
   lncli openchannel --node_key=<ID_PUBKEY> --local_amt=<AMOUNT>
   ```

   ![Lightning Wallet App Open Channel](https://i.imgur.com/d5a7DBn.png)

3. **Wait for confirmations.** To prevent double spending attacks on the channel opening transaction, users should specify the `--block` `lncli` command line argument. So after initializing the channel opening process, it is often required to mine a few blocks:

   ```text
   btcctl generate 6
   ```

4. **Close Channel.** If either party in a channel no longer wants to keep it open, they can close it at any time with the `CloseChannel` method.

   ```text
   lncli closechannel --funding_txid=<funding_txid> --output_index=<output_index>
   ```

