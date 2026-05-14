---
name: lnd-navigate
description: Navigation guide for the lnd (Lightning Network Daemon) Go codebase — where to find things, key patterns, and how subsystems connect.
---

The user needs help navigating or understanding the lnd codebase at `/home/leo/git/claude-lnd/lnd/`. Use the reference below to locate code quickly and explain how subsystems relate.

---

# lnd Codebase Navigation Guide

## Entry Points

| File | Role |
|---|---|
| `main.go` | Binary entry point. Parses config, calls `lnd.Main()`. |
| `lnd.go` | `Main()` function. Initialises chain backend, wallet, then starts `server`. |
| `server.go` | `server` struct. Owns all subsystem handles. `NewServer()` wires everything together; `Start()` / `Stop()` lifecycle. |
| `rpcserver.go` | `rpcServer` — implements the `LightningServer` gRPC interface. All external API calls enter here. |
| `config.go` | Top-level `Config` struct. Parsed from flags + `lnd.conf`. |
| `subrpcserver_config.go` | Aggregates configs for all gRPC subservers. |
| `accessman.go` | Per-peer slot/rate-limit manager; controls who may open channels or send messages. |

Start reading at `server.go:NewServer()` to understand how the daemon assembles itself.

---

## Key Subsystems

### Payment Routing — `routing/`
- **`routing/router.go`** — `ChannelRouter`: the central router. Pathfinding, mission control, payment lifecycle state machine (`SendPayment`, `SendToRoute`).
- **`routing/pathfind.go`** — Dijkstra-based pathfinder with probability weighting.
- **`routing/missioncontrol.go`** / `missioncontrol_state.go` — tracks per-pair failure history to bias future path choices.
- **`routing/payment_lifecycle.go`** — drives a single payment from initiation through HTLC attempts to settlement or failure.
- **`routing/payment_session.go`** — wraps the pathfinder for one payment attempt; handles fee limits, MPP splitting.
- **`routing/blindedpath/`** — BOLT-12 blinded route construction (`BuildBlindedPaymentPaths`).
- **`routing/route/`** — `Route`, `Hop`, `Vertex` types; `ToSphinxPath` for onion packet construction.
- **`routing/chainview/`** — `FilteredChainView` interface; backends for btcd, bitcoind, neutrino. Feeds channel-close events to the router.

### HTLC Switch — `htlcswitch/`
- **`htlcswitch/switch.go`** — `Switch`: forwards, settles, and fails HTLC packets between links. Maintains the circuit map.
- **`htlcswitch/link.go`** — `channelLink`: per-channel HTLC processor. Commitment update loop, bandwidth tracking, retransmission on reconnect.
- **`htlcswitch/interceptable_switch.go`** — `InterceptableSwitch`: wraps Switch to support HTLC interception hooks (used by routerrpc).
- **`htlcswitch/hop/`** — `Payload`, `Iterator`: TLV hop payload parsing and iteration for onion packets.
- **`htlcswitch/hodl/`** — Flags that let tests hold HTLCs at various pipeline stages.

### Channel Wallet — `lnwallet/`
- **`lnwallet/wallet.go`** — `LightningWallet`: on-chain wallet and channel factory. Coin selection, UTXO management, channel reservation lifecycle.
- **`lnwallet/channel.go`** — `LightningChannel`: low-level channel state machine. Commitment transactions, HTLC updates, revocation, signing.
- **`lnwallet/interface.go`** — `WalletController`, `BlockChainIO`, `Signer`, `MessageSigner`, `Keychain` interfaces.
- **`lnwallet/reservation.go`** — `ChannelReservation`: in-flight channel open negotiation state.
- **`lnwallet/btcwallet/`** — Production `WalletController` backed by btcwallet.
- **`lnwallet/rpcwallet/`** — `RPCKeyRing` remote-signer pattern: all signing delegated to a remote gRPC endpoint; local node is watch-only.
- **`lnwallet/chanfunding/`** — `Assembler`/`Intent` interfaces for funding flows: `WalletAssembler` (normal), `CannedAssembler` (pre-signed), `PsbtAssembler` (PSBT external signing).
- **`lnwallet/chancloser/`** — `ChanCloser` cooperative-close state machine: `closeIdle` → `closingNegotiated` → `closeComplete`.

### Channel Funding — `funding/`
- **`funding/manager.go`** — `Manager`: drives the channel-open state machine from `OpenChannel` RPC through funding tx broadcast and channel ready.

### Channel Database — `channeldb/`
- **`channeldb/db.go`** — Top-level BoltDB/SQL store. Open/close channels, forwarding log, peers.
- **`channeldb/channel.go`** — `OpenChannel`: serialization of all channel state to disk.
- **`channeldb/invoices.go`** — Invoice storage (legacy; SQL path in `invoices/sql_store.go`).
- **`channeldb/migrations/`** — 35 sequential schema migrations (`migration_01_to_11` … `migration35`).

### Routing Graph Database — `graph/db/`
- **`graph/db/`** — `ChannelGraph` + `Store` interface. KV store (BoltDB) and SQL implementations.
- **`graph/db/models/`** — `LightningNode`, `ChannelEdgeInfo`, `ChannelEdgePolicy`, `CachedEdgePolicy`.
- The in-memory `GraphCache` lives in `graph/db/graph_cache.go`; it provides O(1) neighbor lookups during pathfinding.

### Invoice Registry — `invoices/`
- **`invoices/invoiceregistry.go`** — `InvoiceRegistry`: central hub for adding, settling, cancelling invoices and notifying subscribers.
- **`invoices/sql_store.go`** — SQL-backed invoice store.
- **`invoices/resolution.go`** — `HtlcResolution` types returned to the switch on settle/cancel.

### On-Chain Arbitrator — `contractcourt/`
- **`contractcourt/`** — Watches the chain for unilateral closes and breaches. Drives justice and second-level HTLC transactions.
- Key types: `BreachArbitrator`, `ChannelArbitrator`, `ChainWatcher`.

### UTXO Sweeper — `sweep/`
- **`sweep/sweeper.go`** — Batches time-sensitive outputs (HTLC timeout/success, commit outputs). Fee-bumps via CPFP/RBF.
- **`sweep/fee_bumper.go`** — `TxPublisher`: manages bump attempts and monitors confirms.
- **`sweep/txgenerator.go`** — Builds the sweep transaction from a set of inputs.

### Gossip / Network Discovery — `discovery/`
- **`discovery/gossiper.go`** — `AuthenticatedGossiper`: validates and propagates channel announcements, node updates, channel updates.
- **`discovery/syncer.go`** — `GossipSyncer`: per-peer gossip sync state machine.

### Peer Management — `peer/`
- **`peer/brontide.go`** — `Brontide`: per-peer connection handler. Reads/writes wire messages, owns channel links, handles reconnect.

### Chain Notifications — `chainntnfs/`
- **`chainntnfs/txnotifier.go`** — `TxNotifier`: central confirmation/spend notification engine shared by all backends.
- **`chainntnfs/bitcoindnotify/`**, **`btcdnotify/`**, **`neutrinonotify/`** — three `ChainNotifier` implementations.

### Chain Fan-Out — `chainio/`
- **`chainio/`** — `Blockbeat` / `Consumer` interfaces. Delivers new block events to all registered subsystems in priority order before advancing.

### Watchtower — `watchtower/`
- **`watchtower/wtclient/`** — Client-side manager: encrypts and uploads channel state backups, negotiates sessions.
- **`watchtower/lookout/`** — Server-side breach detection: scans each block for breach hints, queues justice txns.
- **`watchtower/blob/`** — `JusticeKit` encrypted breach-remedy data; `BreachHint`/`BreachKey`.
- **`watchtower/wtserver/`** — Tower gRPC server (session create, state update, delete).
- **`watchtower/wtwire/`** — Tower wire protocol message types.

### gRPC Subservers — `lnrpc/`
Each package follows the same pattern:
1. A `ServerShell` struct (holds config/deps, created before wallet unlock).
2. After unlock: `CreateSubServer()` returns the live server.
3. `RegisterWithRootServer(grpc.Server)` and `RegisterWithRestServer(mux)` register the gRPC and REST handlers.

| Subpackage | What it exposes |
|---|---|
| `lnrpc/routerrpc/` | `SendPaymentV2`, `BuildRoute`, `QueryRoutes`, HTLC interceptor, MC reset |
| `lnrpc/walletrpc/` | UTXOs, PSBT flows, addresses, coin selection, bump fee, account import |
| `lnrpc/invoicesrpc/` | `AddHoldInvoice`, `SettleInvoice`, `CancelInvoice`, `SubscribeSingleInvoice` |
| `lnrpc/signrpc/` | `SignMessage`, `ComputeInputScript`, MuSig2 multi-round flows |
| `lnrpc/chainrpc/` | `RegisterConfirmationsNtfn`, `RegisterSpendNtfn`, `RegisterBlockEpochNtfn` |
| `lnrpc/autopilotrpc/` | Autopilot status, scores, enable/disable |
| `lnrpc/peersrpc/` | `UpdateNodeAnnouncement` |
| `lnrpc/neutrinorpc/` | Neutrino chain backend control |
| `lnrpc/watchtowerrpc/` | Tower server info |
| `lnrpc/wtclientrpc/` | Tower client management (add/remove/list towers) |
| `lnrpc/devrpc/` | Dev-only: `ImportGraph`, `Quiesce` |
| `lnrpc/verrpc/` | `GetVersion` |

### Storage Backends — `kvdb/` and `sqldb/`
- **`kvdb/`** — `walletdb`-compatible KV interface; backends: BoltDB (default), etcd (`kvdb/etcd/`), Postgres (`kvdb/postgres/`), SQLite (`kvdb/sqlite/`).
- **`sqldb/`** — SQL connection layer; `sqldb/sqlc/` holds SQLC-generated type-safe query code.
- **`payments/db/`** — `PaymentControl` interface (KV and SQL implementations) for payment/HTLC attempt state.

### Wire Protocol — `lnwire/`
All BOLT wire message structs and their `Encode`/`Decode` live here. If you need to find the Go type for any LN protocol message, start in `lnwire/messages.go`.

---

## Common Navigation Tasks

**"Where does a payment start?"**
`rpcserver.go:SendPaymentSync` → `routing/router.go:SendPayment` → `routing/payment_lifecycle.go`

**"Where is an HTLC forwarded?"**
`htlcswitch/switch.go:forward` → finds outgoing `channelLink` → `htlcswitch/link.go:handleSwitchPacket`

**"Where does a channel open?"**
`rpcserver.go:OpenChannel` → `funding/manager.go:InitFundingWorkflow` → `lnwallet/wallet.go:InitChannelReservation`

**"Where does a channel close cooperatively?"**
`rpcserver.go:CloseChannel` → `server.go:CloseChannel` → `peer/brontide.go` → `lnwallet/chancloser/chancloser.go`

**"Where is channel state persisted?"**
`lnwallet/channel.go` calls into `channeldb/channel.go:OpenChannel.AppendRemoteCommitChain` / `AdvanceCommitChainTip`

**"Where does gossip come in?"**
`peer/brontide.go:msgHandler` dispatches announcement messages → `discovery/gossiper.go:ProcessRemoteAnnouncement`

**"Where is the routing graph updated?"**
`discovery/gossiper.go` validates and writes to `graph/db/` via the `Store` interface; the `GraphCache` is kept in sync.

**"Where does breach detection happen?"**
`contractcourt/breach_arbitrator.go` on the client side; `watchtower/lookout/` on the tower side.

---

## Key Interfaces to Know

| Interface | Defined in | Implemented by |
|---|---|---|
| `WalletController` | `lnwallet/interface.go` | `btcwallet/BtcWallet`, `rpcwallet/RPCKeyRing` |
| `ChainNotifier` | `chainntnfs/interface.go` | `bitcoindnotify`, `btcdnotify`, `neutrinonotify` |
| `FilteredChainView` | `routing/chainview/interface.go` | `btcd`, `bitcoind`, `neutrino` chainviews |
| `MessageSigner` | `lnwallet/interface.go` | `BtcWallet`, `RPCKeyRing` |
| `Blockbeat` / `Consumer` | `chainio/` | All block-consuming subsystems |
| `PaymentControl` | `payments/db/` | `KVStore`, `SQLStore` |
| `Store` (graph) | `graph/db/` | `KVStore`, SQL store |
| `Assembler` / `Intent` | `lnwallet/chanfunding/` | `WalletAssembler`, `CannedAssembler`, `PsbtAssembler` |

---

## Testing

- **Unit tests** — alongside each source file (`*_test.go`).
- **Integration harness** — `lntest/`: `HarnessNode` (wraps a running lnd process), `HarnessRPC` (typed wrappers for every gRPC call), `lntest/mock/` (chain IO, notifier, key ring mocks).
- **Integration test cases** — `itest/`: grouped by feature area (`itest_wallet_test.go`, `itest_channel_test.go`, etc.). Run with `make itest`.
- **Shared wallet test helpers** — `lnwallet/test/`: exercises any `WalletController` implementation against the same suite.
- **Chain notification tests** — `chainntnfs/test/`: shared suite run against all three `ChainNotifier` backends.
- **Mocks**: `lnwallet/mock.go`, `htlcswitch/mock.go`, `routing/mock_test.go`, `lntest/mock/`.

---

## Configuration

- `lncfg/` — one struct per config section (`lncfg/db.go`, `lncfg/tor.go`, etc.). Matches the `[db]`, `[tor]` etc. stanzas in `lnd.conf`.
- `config.go` — top-level `Config` embeds all `lncfg.*` sub-structs.
- `subrpcserver_config.go` — `SubRPCServerConfigs` aggregates the config for every gRPC subserver.

---

## Useful grep patterns

```bash
# Find where an RPC method is implemented
grep -n "func.*rpcServer.*MethodName" lnd/rpcserver.go

# Find all types implementing an interface
grep -rn "func.*WalletController" lnd/

# Find where a channeldb bucket is defined
grep -rn "bucketName\|rootBucket" lnd/channeldb/

# Find all SubServer RegisterWithRootServer implementations
grep -rn "RegisterWithRootServer" lnd/lnrpc/

# Find where a wire message type is handled
grep -rn "case \*lnwire\." lnd/peer/brontide.go
```
