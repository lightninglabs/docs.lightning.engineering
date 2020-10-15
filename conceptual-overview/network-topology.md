# Network Topology

The expected shape / network topology of the Lightning Network will depend on behavior implemented in the varying Lightning implementations as well as actual usage. Users do not have to manually manage their channels, since `lnd` has an ‘autopilot’ feature including settings optimizing for both everyday use and fee revenue. And of course, channels can be opened on demand via the standard command line, gRPC, and REST interfaces.

## Integration guidelines

When integrating `lnd`, hot and cold storage must be considered. To maximize security, we generally want to keep as little as possible in hot wallets, and as much as possible in cold wallets.

It is possible to construct Lightning channels where the keys are cold, but they would need to be brought back online to conduct a channel update. Only with hot wallets can the Lightning Network attain a high volume of transactions.

This is only a surface level introduction to Lightning integration. For a more illustrative example of how Lightning Network may work in production, check out the “Integration Components” and “Security Considerations” sections of the [Exchange Integration Document](https://docs.google.com/document/d/1r38-_IgtfOkhJh4QbN7l6bl7Rol05qS-i7BjM3AjKOQ/edit) maintained by Bryan Vu.

