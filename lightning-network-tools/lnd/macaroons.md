---
description: >-
  Macaroons are fancy cookies. You use LND to create custom macaroons that limit
  their permissions with great granularity, down to the exact RPC calls.
---

# Macaroons

LND, Loop, Pool and litd all use macaroons to authenticate RPC calls. Macaroons are similar to cookies in that they are bearer instruments, but they can be more easily verified by the server using HMACs and a root key alone. They can also be attenuated, both by the server and by the user. This greatly simplifies how LND authenticates RPC calls while expanding the detail in which authority over specific RPC calls is permissioned.

[Learn more about Macaroons here.](../../the-lightning-network/l402/macaroons.md)

## The default macaroons <a href="#docs-internal-guid-ad1fdcaf-7fff-adcf-644d-0f14be97523e" id="docs-internal-guid-ad1fdcaf-7fff-adcf-644d-0f14be97523e"></a>

By default, LND will generate eight macaroons, created for specific purposes. You can inspect the permissions of each macaroon with the command `lncli printmacaroon --macaroon_file ~/path/to/macaroon`

| admin.macaroon         | permissions: all                                                                   |
| ---------------------- | ---------------------------------------------------------------------------------- |
| chainnotifier.macaroon | onchain: read                                                                      |
| invoices.macaroon      | invoices: read & write                                                             |
| invoice.macaroon       | address, invoice: read & write; onchain: read                                      |
| readonly.macaroon      | address, info, invoices, macaroon, message, offchain, onchain, peers, signer: read |
| router.macaroon        | offchain: read & write                                                             |
| signer.macaroon        | signer: generate & read                                                            |
| walletkit.macaroon     | address, onchain: read & write                                                     |

## Baking custom macaroons <a href="#docs-internal-guid-7b736a99-7fff-4c6f-a308-73da0d74c992" id="docs-internal-guid-7b736a99-7fff-4c6f-a308-73da0d74c992"></a>

The process of creating a custom macaroon is called “baking.” For this process, LND includes the LND macaroon bakery that can be invoked with `lncli bakemacaroon`

For instance, a macaroon that is only allowed to manage peers could be created with the command:

`lncli bakemacaroon peers:read peers:write`

For even more granularity, it is possible to specify individual RPC calls.&#x20;

`lncli bakemacaroon uri:/lnrpc.Lightning/GetInfo uri:/verrpc.Versioner/GetVersion`

To get a list of all available restrictions, run `lncli listpermissions`

By default, LND will generate new macaroons with the root key 0. You can specify another root key ID, even one that does not yet exist, using the flag `--root_key_id`. To save your macaroon to a file rather than returning its hex value, use the `--save_to flag`. Additionally, macaroons can be bound by IP address as well.

LND supports adding external permissions, even if LND does not understand these permissions, with the `--allow_external_permissions` flag.

LND does not include a tool to convert a macaroon back to its hex value, but you may run the `xxd` utility if it is installed on your system.

`xxd -ps -u -c 1000 /path/to.macaroon`

## Restraining macaroons <a href="#docs-internal-guid-72a94d15-7fff-b0ec-4dea-59af64fc5590" id="docs-internal-guid-72a94d15-7fff-b0ec-4dea-59af64fc5590"></a>

Using the macaroon bakery, you can take any existing macaroon and restrain it further, even if the macaroon was not issued by you.

For example, we can limit our admin macaroon to only be valid for calls made from localhost, as well as take away its authority to perform on-chain actions:

`lncli constrainmacaroon --ip_address 127.0.0.1 --custom_caveat_name onchain --custom_caveat_condition read admin.macaroon constrained.macaroon`

We can now inspect the permissions of this new macaroon with:

`lncli printmacaroon --macaroon_file constrained.macaroon`

```json
{
    "version": 2,
    "location": "lnd",
    "root_key_id": "0",
    "permissions": [
   	 "address:read",
   	 "address:write",
   	 "info:read",
   	 "info:write",
   	 "invoices:read",
   	 "invoices:write",
   	 "macaroon:generate",
   	 "macaroon:read",
   	 "macaroon:write",
   	 "message:read",
   	 "message:write",
   	 "offchain:read",
   	 "offchain:write",
   	 "onchain:read",
   	 "onchain:write",
   	 "peers:read",
   	 "peers:write",
   	 "signer:generate",
   	 "signer:read"
    ],
    "caveats": [
   	 "ipaddr 127.0.0.1",
   	 "lnd-custom onchain read"
    ]
}

```

## Revoking macaroons <a href="#docs-internal-guid-4f633f92-7fff-afb3-60dd-c5a7847990a5" id="docs-internal-guid-4f633f92-7fff-afb3-60dd-c5a7847990a5"></a>

To revoke a macaroon, it is not sufficient to delete the macaroon. Instead, its root key has to be deleted. Which root key is used for a macaroon can be found out using the `lncli printmacaroon` command above.

`lncli deletemacaroonid root_key_id`

## Using Macaroons with GRPC clients

When interacting with `lnd` using the GRPC interface, the macaroons are encoded as a hex string over the wire and can be passed to `lnd` by specifying the hex-encoded macaroon as GRPC metadata:

```
GET https://localhost:8080/v1/getinfo
Grpc-Metadata-macaroon: <macaroon>
```

Where `<macaroon>` is the hex encoded binary data from the macaroon file itself.

A very simple example using `curl` may look something like this:

```
⛰  curl --insecure --header "Grpc-Metadata-macaroon: $(xxd -ps -u -c 1000  $HOME/.lnd/data/chain/bitcoin/simnet/admin.macaroon)" https://localhost:8080/v1/getinfo
```

Have a look at the [Java GRPC example](../../docs/lnd/grpc/java.md) for programmatic usage details.

## Stateless initialization

As mentioned above, by default `lnd` creates several macaroon files in its directory. These are unencrypted and in case of the `admin.macaroon` provide full access to the daemon. This can be seen as quite a big security risk if the `lnd` daemon runs in an environment that is not fully trusted.

The macaroon files are the only files with highly sensitive information that are not encrypted (unlike the wallet file and the macaroon database file that contains the root key, these are always encrypted, even if no password is used).

To avoid leaking the macaroon information, `lnd` supports the so called `stateless initialization` mode:

*   The three startup commands `create`, `unlock` and `changepassword` of `lncli`

    all have a flag called `--stateless_init` that instructs the daemon **not**

    to create `*.macaroon` files.
*   The two operations `create` and `changepassword` that actually create/update

    the macaroon database will return the admin macaroon in the RPC call.

    Assuming the daemon and the `lncli` are not used on the same machine, this

    will leave no unencrypted information on the machine where `lnd` runs on.

    *   To be more precise: By default, when using the `changepassword` command, the

        macaroon root key in the macaroon DB is just re-encrypted with the new

        password. But the key remains the same and therefore the macaroons issued

        before the `changepassword` command still remain valid. If a user wants to

        invalidate all previously created macaroons, the `--new_mac_root_key` flag

        of the `changepassword` command should be used!
*   An user of `lncli` will see the returned admin macaroon printed to the screen

    or saved to a file if the parameter `--save_to=some_file.macaroon` is used.
*   **Important:** By default, `lnd` will create the macaroon files during the

    `unlock` phase, if the `--stateless_init` flag is not used. So to avoid

    leakage of the macaroon information, use the stateless initialization flag

    for all three startup commands of the wallet unlocker service!

Examples:

*   Create a new wallet stateless (first run):

    ```
      ⛰  lncli create --stateless_init --save_to=/safe/location/admin.macaroon
    ```
*   Unlock a wallet that has previously been initialized stateless:

    ```
      ⛰  lncli unlock --stateless_init
    ```
*   Use the created macaroon:

    ```
      ⛰  lncli --macaroonpath=/safe/location/admin.macaroon getinfo
    ```
