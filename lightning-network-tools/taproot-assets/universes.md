---
description: Learn how to run a universe and connect to other universes.
---

# Universes

## Running a universe <a href="#docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f" id="docs-internal-guid-a793947b-7fff-5e06-ddbf-f64bd25da85f"></a>

Running a universe is as simple as running `tapd` and amending your configuration file. To run a universe, set your instance to listen on the RPC port (10029) and ensure this port is open on your machine. Being publicly reachable is not a requirement for a universe, however. Your universe may only serve resources on a private network, or be otherwise restricted.

Sample`tapd.conf` file:

`rpclisten=0.0.0.0:10029`\
`allow-public-uni-proof-courier=true`\
`allow-public-stats=true universe.public-access=true`

## The default universe

By default, your `tapd` will connect to the default universe, for instance `testnet.universe.lightning.finance:10029` for testnet, or `universe.lightning.finance:10029` on mainnet.

You can add and remove universes from your local federation with `tapcli universe federation add` or `del`.

The contents of the default universe are also available via a public API:

{% embed url="https://universe.lightning.finance/v1/taproot-assets/universe/roots" %}

## Syncing to a universe

By default, your `tapd` will sync to universes for which have configured in your local federation, and only for assets which you either hold or have created a taproot address for. You may also manually sync specific asset IDs or group keys.

`tapcli universe sync --universe_host <universe_ip:port> --group_key <group key>`

To configure your `tapd` to regularly sync to other asset IDs or group keys, you may use the universe federation configuration. The `config global` options will apply to all assets, while the `config local` options will only apply to specific assets.

`tapcli universe federation config global --proof_type issuance --allow_insert true`

`tapcli universe federation config local --proof_type transfer --allow_insert true --group_key <group key>`
