---
description: Keep yourself and your Taproot Assets safe
---

# Operational Safety Guidelines

As of version `v0.3.0-alpha`, Taproot Assets can be used on Bitcoin's `mainnet` network. That means in any version after `v0.3.0` there won't be any breaking changes and any assets minted with that version should be future-proof. But signaling readiness for `mainnet` does NOT mean that there won't be any bugs or that all planned safety and backup measures are fully in place yet.

**That means, special care must be taken to avoid loss of funds (both assets and BTC)!**

### How to avoid loss of funds (short version, tl;dr) <a href="#user-content-how-to-avoid-loss-of-funds-short-version-tldr" id="user-content-how-to-avoid-loss-of-funds-short-version-tldr"></a>

In short, there is no recovery mechanism in place yet that allows you to recover assets from only the `lnd` seed. So if you lose your `tapd`'s database, or it gets corrupted, you lose access to all assets minted or received by that `tapd`. In addition, you also cannot spend the BTC used to carry/anchor the assets.

**To avoid loss of funds, make sure you back up your `/home/<user>/.tapd` folder regularly.** If you are using a Postgres database as the database backend, it is enough to make backups of that database.

And of course, you also need `lnd`'s seed phrase which is what all private keys for all assets in a `tapd` instance are derived from.

### How to avoid loss of funds (extended version) <a href="#user-content-how-to-avoid-loss-of-funds-extended-version" id="user-content-how-to-avoid-loss-of-funds-extended-version"></a>

Because the Taproot Assets Protocol is an overlay or off-chain protocol, all data relevant to asset mints, transfers or burns are not stored in the Bitcoin blockchain itself. That means, if access to that data is lost, then the assets cannot be recovered by just using a wallet seed.

So-called Universes (public asset and proof databases) will help with storing and later retrieving that crucial off-chain data, but the mechanisms to query all required data by just using `lnd`'s seed are not yet in place. See [#426](https://github.com/lightninglabs/taproot-assets/issues/426) for more information.

#### What data do I need to back up <a href="#user-content-what-data-do-i-need-to-back-up" id="user-content-what-data-do-i-need-to-back-up"></a>

The following items should be backed up regularly (e.g. hourly or even more frequently depending on the number of users/transactions of a system):

* **If the default SQLite database is used:** Then all data is in the files in the location `<tapddir>/data/<network>/tapd.db*` (usually `tapd.db`, `tapd.db-wal` and `tapd.db-shm`), where `tapddir` is the following by default, depending on your operating system:
  * Linux/Unix: `~/.tapd`
  * MacOS: `~/Library/Application Support/Tapd`
  * Windows: `~/AppData/Roaming/Tapd`
  * Umbrel: `${APP_DATA_DIR}/data/.tapd`
  * Or, if either the `--tapddir` or `--datadir` flags or config options are
  * set, then the file should be located there.
* **If a Postgres database is used**: It is enough to create a backup of the database configured as `--postgres.dbname` flag or config option.

Optionally the copies of the proof files in `<tapddir>/data/<network>/proofs` can be backed up as well, but those are also all contained in the SQLite or Postgres database and are only on the filesystem for faster access.

#### Where are the private keys for assets stored? <a href="#user-content-where-are-the-private-keys-for-assets-stored" id="user-content-where-are-the-private-keys-for-assets-stored"></a>

The `tapd` database does not store any private key material. It exclusively uses `lnd`'s wallet to derive keys for assets and their BTC anchoring transactions. The `tapd` database only stores the public key and derivation information in its database.

The following cryptographic keys are derived from `lnd`'s wallet:

* `internal_key`: The internal keys for BTC-level anchoring transaction outputs that carry asset commitments.
* `script_key`: The raw key for asset ownership keys, by default used as BIP-0086 keys in the asset output.

#### Is it safe to restore from an outdated database backup? <a href="#user-content-is-it-safe-to-restore-from-an-outdated-database-backup" id="user-content-is-it-safe-to-restore-from-an-outdated-database-backup"></a>

Yes. Since there is no penalty mechanism involved as in Lightning, there is no additional risk when restoring an outdated database backup. But of course, if the database backup is out of date, it might not contain the latest assets and access to those could still be lost.

#### Is it safe to open the `tapd` RPC port to the internet? <a href="#user-content-is-it-safe-to-open-the-tapd-rpc-port-to-the-internet" id="user-content-is-it-safe-to-open-the-tapd-rpc-port-to-the-internet"></a>

There is normally no need to open the `tapd` RPC port (10029 by default) to the internet. Unless the intention is to run a public Universe server, then that is the port to expose. By default, all RPC methods (except for some non-sensitive Universe related calls) are protected by macaroon credentials.

There are three flags/config options that should be evaluated though:

* `--allow-public-uni-proof-courier`: If set, then access to the Universe based proof courier methods is allowed without the requirement for a macaroon. That means, any other nodes can use this `tapd` instance to transmit transfer proofs from sender to receiver without needing any sort of permission credential.
* `--allow-public-stats`: If set, then access to Universe statistics RPC calls are allowed without the requirement for a macaroon. This can be useful to directly pull statistics over the REST interface into any website.
* `--universe.public-access`: If set, then proofs can be inserted and synced by other nodes. The difference between this flag and `--allow-public-uni-proof-courier` is that the first controls whether remote proofs should be allowed in general, while the second controls whether one needs an authentication token to do so.

### Important note for Umbrel/Lightning Terminal users <a href="#user-content-important-note-for-umbrellightning-terminal-users" id="user-content-important-note-for-umbrellightning-terminal-users"></a>

If you are using Taproot Assets as part of the "Lightning Terminal" app inside Umbrel (or any comparable node-in-a-box solution), **DO NOT UNDER ANY CIRCUMSTANCE** uninstall (or re-install) the "Lightning Terminal" app without first making a manual backup of all local data of `tapd`. Uninstalling any app on Umbrel will delete that app's data. And in case of Taproot Assets, that data contains information needed to spend both the Taproot Assets **AND** the bitcoin that carry the assets. Just having the `lnd` seed phrase is **NOT** enough to restore assets minted or received.
