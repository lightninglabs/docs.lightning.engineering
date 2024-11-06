---
description: Learn how to run a universe and connect to other universes.
---

# Universes

## What are universes?

The Taproot Assets protocol strives to minimize the data that needs to be stored publicly in the bitcoin blockchain. This is done by design in order to increase bitcoin's scalability, improve privacy, and reduce the cost of using Taproot Assets. However, some of the proof data that is not stored on the bitcoin blockchain needs to be used by those interacting with Taproot Assets. Universes are a datastore that allows users to publish proofs that are generated and allows others to fetch the proofs that they need to validate. For more information see <a href="#docs-internal-guid-81622115-7fff-548d-5594-a7c4b43b97b3" id="docs-internal-guid-81622115-7fff-548d-5594-a7c4b43b97b3"></a> .


## Running a universe <a href="#docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f" id="docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f"></a>

Running a universe is as simple as running `tapd` and amending your configuration file. To run a universe, set your instance to listen on the gRPC TCP port (10029) and/or REST TCP port (8089). If necessary, ensure this port is open on your machine's firewall. Being publicly reachable is not a requirement for a universe, however. Your universe may only serve resources on a private network, or be otherwise restricted. Note, public universe RPC calls use the same gRPC and REST TCP ports as all other `tapd` RPC calls, the public universe RPC calls just don't require authentication with a macaroon to receive a response.

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

When running `litd` in integrated mode, your universe may also be available at port `:8443`

The contents of the default universe are also available via a public REST API:

{% embed url="https://universe.lightning.finance/v1/taproot-assets/universe/roots" %}

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
