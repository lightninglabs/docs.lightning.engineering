---
description: Learn how to run a universe and connect to other universes.
---

# Universes

In the context of Taproot Assets, a universe is a service that acts as a repository for publicly minted assets. It contains knowledge of assets, mints, metadata, public transfers and their proofs. A universe is required for users to fetch data necessary to validate transfers, and may be public or private.

Anyone may run a universe, or use one or multiple universes provided by others, such as Lightning Labs. In addition to universes, mailboxes are used to transfer proofs from sender to receiver. For help with running your own mailbox, please refer to [the Aperture guides](../aperture/).

## Running a universe <a href="#docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f" id="docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f"></a>

Running a universe is as simple as running `tapd` and amending your configuration file. You may run a universe over RPC or REST. By default, `tapd` is expected to listen on port (`10029`), so ensure this port is open on your machine if you would like others to connect to you. Being publicly reachable is not a requirement for a universe, however. Your universe may only serve resources on a private network, or be otherwise restricted.

When running `tapd` as part of `litd`, you may also use port `8443` or define your own port. For example, as the REST universe is also usable through a browser over HTTPS, you may configure it over port `443` or set up a proxy.

Sample`tapd.conf` file:

`rpclisten=0.0.0.0:10029`\
`restlisten=0.0.0.0:8089`\
`allow-public-uni-proof-courier=true`\
`allow-public-stats=true`\
`universe.public-access=rw`

You can verify whether your universe is accepting proofs with the command `tapcli universe federation config info`

```
{
    "global_sync_configs": [
        {
            "proof_type": "PROOF_TYPE_ISSUANCE",
            "allow_sync_insert": true,
            "allow_sync_export": true
        },
        {
            "proof_type": "PROOF_TYPE_TRANSFER",
            "allow_sync_insert": true,
            "allow_sync_export": true
        }
    ],
    "asset_sync_configs": []
}
```

You can change the configuration from the CLI using `tapcli universe federation config global --proof_type issuance --allow_insert true` and `--proof_type transfer`

## The default universe

By default, your `tapd` will connect to the default universe, for instance `testnet.universe.lightning.finance:10029` for testnet, or `universe.lightning.finance:10029` on mainnet.

The contents of the default universe are also available via a public API:

{% embed url="https://universe.lightning.finance/v1/taproot-assets/universe/roots" %}

You may also make use of the UI available through Lightning Terminal

{% embed url="https://terminal.lightning.engineering/assets/" %}

## Federations

By default, your tapd instance will connect to a default universe. You can manually add additional universes to sync to and from, called a federation. You can see this federation with `tapcli universe federation list`.

If you would like to add a universe to this federation, you can do this on with `tapcli universe federation add --universe_host <universe_ip:port>`

Similarly, you can remove universes from this federation with `tapcli universe federation del --universe_host <universe_ip>:port`

{% embed url="https://www.youtube.com/watch?v=o6U812eSE_Q" %}
Tapping into Taproot Assets #4: Join a Universe Federation
{% endembed %}

## Syncing to a universe

By default, your `tapd` will sync to universes which have configured in your local federation, and only for assets which you either hold or have created a taproot address for. You may also manually sync specific asset IDs or group keys.

`tapcli universe sync --universe_host <universe_ip:port> --group_key <group key>`

To configure your `tapd` to regularly sync to other asset IDs or group keys, you may use the universe federation configuration. The `config global` options will apply to all assets, while the `config local` options will only apply to specific assets.

`tapcli universe federation config global --proof_type issuance --allow_insert true`

`tapcli universe federation config local --proof_type transfer --allow_insert true --group_key <group key>`

## The Universe APIs

A Taproot Asset Universe is available over [gRPC](https://lightning.engineering/api-docs/api/taproot-assets/#grpc) and [REST](https://lightning.engineering/api-docs/api/taproot-assets/#rest). You may run your own universe or interact with a public universe. Public universes are unauthenticated, the macaroon checks are skipped.

For instance, when making a transfer, the proofs may be pushed to one or multiple universes using the REST Api. This requires the asset ID, the leaf key index and script key.

`/v1/taproot-assets/universe/proofs/asset-id/{key.id.asset_id_str}/{key.leaf_key.op.hash_str}/{key.leaf_key.op.index}/{key.leaf_key.script_key_str}`

A detailed list of all available fields as well as code examples can be found under the [Taproot Assets API documentation.](https://lightning.engineering/api-docs/api/taproot-assets/universe/insert-proof)
