---
description: >-
  LND Accounts lets you create custodial accounts on top of your LND node
  enforced with custom macaroons.
---

# LND Accounts

Using litd, users are able to create virtual off-chain accounts on top of their LND node, each with their own [macaroon](../../the-lightning-network/l402/macaroons.md) and spending rules, such as spending limits or an expiration date.

The accounts feature does not validate whether the sum of all account balances is smaller or equal to the channel balance held in the underlying LND node. A user issued such an account enters a trust relationship with the node operator regarding availability of the funds and the node. The account balances are tracked and enforced by LND.

To expose these accounts via the gRPC interface, the [RPC Middleware Interceptor](../lnd/rpc-middleware-interceptor.md) is used together with individually baked macaroons for each account. This allows for easy integration of the accounts feature into existing gRPC-based applications.

How to make use of accounts for your existing application:

* Generate account in litd
* Pass newly created macaroon to the user

As litd is used to create and manage accounts, access to a new account can be granted using a [Lightning Node Connect](lightning-node-connect.md) pairing phrase, removing the need for the LND node to be directly accessible from the web.

At this point, it is not possible to pay invoices between two accounts using the same LND node.

## Features <a href="#docs-internal-guid-4dd1448a-7fff-b044-815c-f042b0885742" id="docs-internal-guid-4dd1448a-7fff-b044-815c-f042b0885742"></a>

When an account-restricted macaroon is used, the RPC middleware interceptor

enforces the following rules on the RPC interface.

* Any payment made by a custodial/restricted user account is deducted from an account's virtual balance (the full amount, including off-chain routing fees).
* If a payment (or the sum of multiple in-flight payments) exceeds the account's virtual balance, it is denied.
* The on-chain balance of any RPC responses such as the \`WalletBalance\` RPC is always shown as \`0\`. A custodial/restricted user shouldn't be able to see what on-chain balance is available to the node operator as an account can only spend off-chain balances.
* The off-chain balance (e.g. the response returned by the \`ChannelBalance\` RPC) always reflects the account's virtual balance and not the node's overall channel balance (and any remote balances are always shown as \`0\`).
* The list of active/pending/closed channels is always returned empty. The custodial/restricted user should not need to care (or even know) about channels and their internal workings.
* The list of payments and invoices is filtered to only return payments/invoices created or paid by the account.
* Invoices created by an account are mapped to that account. If/when such a mapped invoice is paid, the amount is credited to that account's virtual balance.

## Use cases <a href="#docs-internal-guid-69172a1f-7fff-fd6c-17ca-dcf7d9939389" id="docs-internal-guid-69172a1f-7fff-fd6c-17ca-dcf7d9939389"></a>

The following use cases is made possible by the accounts system:

* The community model: The tech-savvy person of the community operates a Lightning node. She manages the liquidity of the node and provides the capital for the channels. She can onboard her community members by creating an account, locking a macaroon to that account and then scanning a QR code with an app like [Zeus](https://github.com/ZeusLN/zeus) on the community member's smartphone.
* The "spend up to a certain amount automatically" model: A web user has a browser extension like [Alby](https://getalby.com/) installed and wants to allow that extension to pay invoices for paywalls automatically up to a certain amount per month. That amount could be enforced by the account so the browser extension doesn't have to keep track of its spending actions. And an account can be shared between extensions installed in different browsers.
* The "allowance" model: A parent wants to give their child their allowance in satoshis. They create an account over the allowance amount and top up the account each week/month.
* The “enhanced security” model: A service running multiple applications on top of a single LND node, to limit the damage from a single application being faulty

## Create an account <a href="#docs-internal-guid-587703e5-7fff-5b2b-8389-3bd9e7bf6d0b" id="docs-internal-guid-587703e5-7fff-5b2b-8389-3bd9e7bf6d0b"></a>

To create an account, the node operator (e.g. access to `litd` using `litcli` or gRPC via the lit.macaroon) creates an account with 50,000 satoshis.

`litcli accounts create 50000 --save_to /tmp/user.macaroon`

They can now pass the `user.macaroon` to the user.

More conveniently, an account can also be created from the litd user interface. Create a new session under "Lightning Node Connect," give it a name and select "Custom" under permissions, then choose "Custodial Account" in the next window.

This will create a custom pairing phrase that can be passed to wallets like Alby or Zeus.

<figure><img src="../../.gitbook/assets/Screenshot 2023-02-16 at 13-09-47 Lightning Terminal.png" alt=""><figcaption></figcaption></figure>

## Use the macaroon <a href="#docs-internal-guid-865e004c-7fff-dfcd-f889-35d1e9a271b2" id="docs-internal-guid-865e004c-7fff-dfcd-f889-35d1e9a271b2"></a>

The user or application can now make use of the macaroon and make calls to the LND’s gRPC interface as they otherwise would.

This could be done via LNDconnect (as used by Zeus Wallet), lncli, Alby or your LNbits installation.

`lncli --macaroonpath=/tmp/user.macaroon channelbalance`

The permissions of the macaroon can be inspected with lncli:

`lncli printmacaroon --macaroon_file /tmp/user.macaroon`

`{`\
&#x20;    `"version": 2,`\
&#x20;    `"location": "lnd",`\
&#x20;    `"root_key_id": "0",`\
&#x20;    `"permissions": [`\
&#x20;            `"info:read",`\
&#x20;            `"invoices:read",`\
&#x20;            `"invoices:write",`\
&#x20;            `"offchain:read",`\
&#x20;            `"offchain:write",`\
&#x20;            `"onchain:read"`\
&#x20;    `],`\
&#x20;    `"caveats": [`\
&#x20;            `"lnd-custom account d64dbc31b28edf66"`\
&#x20;    `]`\
`}`

## Create an LNC session <a href="#docs-internal-guid-ab4cf5c6-7fff-a5cd-6b10-9e8cca0c543e" id="docs-internal-guid-ab4cf5c6-7fff-a5cd-6b10-9e8cca0c543e"></a>

LNC sessions can be created for specific LND accounts. This is useful when connecting external wallets to this specific account, or when creating a new LND session in cases where this is needed. Using this technique we can also create multiple LNC sessions for the same LND account.

First, we will need to obtain the account ID. We can get this account ID directly from a macaroon, as seen above, or by looking through the accounts with `litcli accounts list`.

`litcli sessions add --label pointofsale --type account --account_id d64dbc31b28edf66`

This will return all relevant information, most importantly the mnemonic required to connect.

## Recreating LND Account macaroons <a href="#docs-internal-guid-d0641bc1-7fff-0871-8cd4-de3e495890fc" id="docs-internal-guid-d0641bc1-7fff-0871-8cd4-de3e495890fc"></a>

If you for some reason have lost access to an LND Account macaroon, or need to issue a new one, you can do so with the following steps:

First, we will need the LND account ID for which we want to make a new macaroon. Account IDs can be obtained through the command litcli accounts list and look like this: `07a4a3d12462b52e`

Next, we will bake a generic macaroon with the minimal permissions required and save it.

`lncli bakemacaroon info:read invoices:read invoices:write offchain:read offchain:write onchain:read peers:read --save_to tmp.macaroon`

Now we are going to add a custom caveat to the macaroon, making it useful only for the above account.

`lncli constrainmacaroon --custom_caveat_name account --custom_caveat_condition 07a4a3d12462b52e tmp.macaroon accounts.macaroon`

Don’t forget to delete the temporary macaroon!

`rm tmp.macaroon`

We can now inspect the permissions of this macaroon.

`lncli printmacaroon --macaroon_file zeus.macaroon`

To test the macaroon, we can make a call to LND using the restricted macaroon. For example the `getinfo` command should return zero channels, while the `channelbalance` command should only return the balance associated with that account.

`lncli --macaroonpath accounts.macaroon getinfo`
