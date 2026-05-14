---
name: taproot-assets-rpc
description: Working guide for LND + Taproot Assets gRPC in Go — authentication, asset amounts, channel data, pagination, and common gotchas discovered building a real wallet.
---

Use this guide when writing Go code that calls LND (`lnrpc`) or Taproot Assets (`taprpc`, `tapchannelrpc`) via gRPC through a `litd` instance.

---

# LND + Taproot Assets gRPC — Working Guide

## Authentication

Taproot Assets lives behind `litd`, which wraps `lnd` and `tapd` behind a single gRPC endpoint. Authentication requires two steps:

1. Connect with `lit.macaroon` and call `BakeSuperMacaroon`.
2. Close that connection and reconnect with the supermacaroon — it grants access to all subservers.

```go
// Step 1: bake supermacaroon
litMac, _ := loadMacaroon(cfg.MacaroonPath)   // binary macaroon file
tlsCreds, _ := credentials.NewClientTLSFromFile(cfg.TLSCertPath, "")
macCred, _ := newMacaroonCredential(litMac)

conn, _ := grpc.Dial(cfg.RPCServer,
    grpc.WithTransportCredentials(tlsCreds),
    grpc.WithPerRPCCredentials(macCred),
)
proxy := litrpc.NewProxyClient(conn)
resp, _ := proxy.BakeSuperMacaroon(ctx, &litrpc.BakeSuperMacaroonRequest{RootKeyIdSuffix: 0})
conn.Close()

// Step 2: reconnect with supermacaroon
superMac, _ := parseMacaroonHex(resp.Macaroon)
superCred, _ := newMacaroonCredential(superMac)
mainConn, _ := grpc.Dial(cfg.RPCServer,
    grpc.WithTransportCredentials(tlsCreds),
    grpc.WithPerRPCCredentials(superCred),
    grpc.WithDefaultCallOptions(grpc.MaxCallRecvMsgSize(200 * 1024 * 1024)),
)
```

The macaroon credential satisfies `credentials.PerRPCCredentials`:

```go
func (m *macaroonCredential) GetRequestMetadata(_ context.Context, _ ...string) (map[string]string, error) {
    data, _ := m.mac.MarshalBinary()
    return map[string]string{"macaroon": hex.EncodeToString(data)}, nil
}
func (m *macaroonCredential) RequireTransportSecurity() bool { return true }
```

**Default litd data dirs:**

| OS | Path |
|---|---|
| Linux | `~/.lit/` |
| macOS | `~/Library/Application Support/Lit/` |
| Windows | `%LOCALAPPDATA%\Lit\` |

Default macaroon: `<litdir>/<network>/lit.macaroon`. Default TLS cert: `<litdir>/tls.cert`. Default port: `8443`.

---

## Asset Amounts and Decimal Display

Taproot Assets stores amounts as raw integers. The `DecimalDisplay` field tells you how many decimal places to shift for human display.

**Proto field is double-nested:**
```go
var dd uint32
if asset.DecimalDisplay != nil {
    dd = asset.DecimalDisplay.DecimalDisplay  // note: field name repeated
}
```

**Display (raw → human):**
```go
func formatAssetAmount(amount uint64, decimalDisplay uint32) string {
    if decimalDisplay == 0 {
        return fmt.Sprintf("%d", amount)
    }
    div := uint64(1)
    for i := uint32(0); i < decimalDisplay; i++ { div *= 10 }
    whole := amount / div
    frac  := amount % div
    return fmt.Sprintf("%d.%0*d", whole, int(decimalDisplay), frac)
}
```

**Parse (human input → raw):**
```go
func parseScaledAmount(s string, decimalDisplay uint32) (uint64, error) {
    // Split on '.', scale integer part, pad/truncate fractional part.
    // multiply intPart by 10^decimalDisplay, add fracPart (zero-padded to decimalDisplay digits)
}
```

BTC: treat as satoshis with `decimalDisplay = 3` to get millisatoshis (matching `lnrpc.Invoice.ValueMsat`).

---

## Group Keys vs Asset IDs

Assets can be grouped (fungible across mints) or ungrouped (unique to a single issuance).

| Concept | Field | Size | Use when |
|---|---|---|---|
| Asset ID | `asset.AssetGenesis.AssetId` | 32 bytes | Ungrouped asset or specific UTXO |
| Tweaked group key | `asset.AssetGroup.TweakedGroupKey` | 33 bytes (compressed EC) | Grouped asset; identifies the whole group |

**Deduplication pattern** — when building a picker or aggregating balances:
```go
dedupeKey := groupKeyHex
if dedupeKey == "" {
    dedupeKey = assetIDHex
}
if seen[dedupeKey] { continue }
seen[dedupeKey] = true
```

**Sending/invoicing** — prefer group key over asset ID for grouped assets:
```go
req := &tapchannelrpc.AddInvoiceRequest{AssetAmount: scaledAmt}
if groupKeyHex != "" {
    req.GroupKey, _ = hex.DecodeString(groupKeyHex)
} else {
    req.AssetId, _ = hex.DecodeString(assetIDHex)
}
```

---

## Script Key Types (Filtering Assets)

`ListAssets` can filter by script key type — this tells you where the asset lives:

| Constant | Value | Meaning |
|---|---|---|
| `SCRIPT_KEY_BIP86` | 1 | Wallet asset — spendable onchain |
| `SCRIPT_KEY_CHANNEL` | 5 | Locked in a Lightning channel |
| `SCRIPT_KEY_UNKNOWN` | 0 | Unclassified |

To get all types:
```go
resp, _ := tap.ListAssets(ctx, &taprpc.ListAssetRequest{
    ScriptKeyType: &taprpc.ScriptKeyTypeQuery{
        Type: &taprpc.ScriptKeyTypeQuery_AllTypes{AllTypes: true},
    },
})
for _, a := range resp.GetAssets() {
    if a.ScriptKeyType == taprpc.ScriptKeyType_SCRIPT_KEY_BIP86 { /* wallet asset */ }
}
```

**Critical gotcha:** Channel assets may NOT be tagged `SCRIPT_KEY_CHANNEL` in `ListAssets`. If you need channel assets, source from `ListChannels` + `CustomChannelData` instead (see next section).

---

## Channel Custom Data

`lnrpc.Channel.CustomChannelData` is **JSON-encoded** (not TLV). Unmarshal it to get asset details:

```go
type jsonAssetChannel struct {
    LocalBalance  uint64          `json:"local_balance"`
    RemoteBalance uint64          `json:"remote_balance"`
    GroupKey      string          `json:"group_key,omitempty"`       // hex tweaked group key
    FundingAssets []jsonAssetUtxo `json:"funding_assets,omitempty"`
}
type jsonAssetUtxo struct {
    AssetGenesis   jsonAssetGenesis `json:"asset_genesis"`
    DecimalDisplay uint8            `json:"decimal_display"`
}
type jsonAssetGenesis struct {
    Name    string `json:"name"`
    AssetID string `json:"asset_id"`   // hex genesis ID
}

for _, ch := range chResp.GetChannels() {
    if len(ch.CustomChannelData) == 0 { continue }  // BTC-only channel
    var data jsonAssetChannel
    if err := json.Unmarshal(ch.CustomChannelData, &data); err != nil { continue }
    if data.GroupKey == "" { continue }              // BTC channel (no asset data)

    // data.FundingAssets[i].AssetGenesis.Name  → asset name
    // data.FundingAssets[i].AssetGenesis.AssetID → hex asset ID
    // data.FundingAssets[i].DecimalDisplay → decimal display
    // data.GroupKey → hex tweaked group key
    // data.LocalBalance / data.RemoteBalance → asset units (not sats)
}
```

To build a receive-invoice picker from channel assets (the correct approach):
```go
seen := make(map[string]bool)
for _, ch := range channels {
    var data jsonAssetChannel
    json.Unmarshal(ch.CustomChannelData, &data)
    for _, fa := range data.FundingAssets {
        key := data.GroupKey; if key == "" { key = fa.AssetGenesis.AssetID }
        if seen[key] { continue }
        seen[key] = true
        // add to options list: name, assetID, groupKey, decimalDisplay
    }
}
```

---

## HTLC Custom Data (Different from Channel Data!)

`lnrpc.HTLCAttempt.Route.CustomChannelData` and `lnrpc.InvoiceHTLC.CustomChannelData` are **TLV-encoded**, not JSON. Do not try to `json.Unmarshal` them.

Decode via RPC:
```go
decoded, err := tapChannel.DecodeAssetPayReq(ctx, &tapchannelrpc.AssetPayReq{
    PayReqString: bolt11String,
})
// decoded.AssetId, decoded.AssetAmount, decoded.GroupKey
```

Classify a payment as an asset payment by checking whether any HTLC attempt carries non-empty `CustomChannelData`:
```go
for _, htlc := range p.Htlcs {
    if htlc.Status == lnrpc.HTLCAttempt_SUCCEEDED {
        if len(htlc.Route.GetCustomChannelData()) > 0 {
            // asset payment — decode with DecodeAssetPayReq
        }
    }
}
```

For settled invoices, check `invoice.Htlcs[i].CustomChannelData` the same way.

---

## Payment Pagination

### `ListPayments` (outgoing)

```go
var offset uint64
var done bool
const pageSize = uint64(50)

loadPage := func() {
    resp, err := ln.ListPayments(ctx, &lnrpc.ListPaymentsRequest{
        IncludeIncomplete: true,
        Reversed:          true,          // newest first
        IndexOffset:       offset,        // exclusive
        MaxPayments:       pageSize,
    })
    batch := resp.GetPayments()
    if err != nil || len(batch) == 0 {
        done = true
        return
    }
    // process batch...
    offset = resp.GetLastIndexOffset()   // next cursor
    if uint64(len(batch)) < pageSize {
        done = true                      // last page
    }
}
```

Dedup by `PaymentHash` (safety net against repeated cursor values):
```go
seen := make(map[string]struct{})
for _, p := range batch {
    if _, ok := seen[p.PaymentHash]; ok { continue }
    seen[p.PaymentHash] = struct{}{}
    // append entry
}
```

### `ListInvoices` (incoming)

Same cursor semantics. Settled filter must be applied client-side:
```go
resp, _ := ln.ListInvoices(ctx, &lnrpc.ListInvoiceRequest{
    Reversed:    true,
    IndexOffset: offset,
    NumMaxInvoices: pageSize,
})
for _, inv := range resp.GetInvoices() {
    if inv.State != lnrpc.Invoice_SETTLED { continue }
    // process
}
offset = resp.GetLastIndexOffset()
if uint64(len(resp.GetInvoices())) < pageSize { done = true }
```

Dedup by `hex(inv.RHash)`.

---

## Bolt11 Memo Parsing

`lnrpc.Payment` has no direct memo field. The memo is in the bolt11 `PaymentRequest` string and must be decoded locally (no extra RPC call needed):

```go
import (
    "github.com/btcsuite/btcd/chaincfg"
    "github.com/lightningnetwork/lnd/zpay32"
)

func bolt11Desc(payReq string) string {
    nets := []*chaincfg.Params{
        &chaincfg.MainNetParams,
        &chaincfg.TestNet3Params,
        &chaincfg.RegressionNetParams,
        &chaincfg.SimNetParams,
        &chaincfg.SigNetParams,
    }
    for _, net := range nets {
        inv, err := zpay32.Decode(payReq, net)
        if err == nil {
            if inv.Description != nil { return *inv.Description }
            return ""
        }
    }
    return ""
}
```

Try all network params because you may not know which network the invoice was issued on. Do NOT use `DecodePayReq` RPC for this — it can return empty results or silently fail.

Apply to both BTC and asset LN payments (both carry a bolt11 string in `p.PaymentRequest`).

---

## Opening Asset Channels

```go
assetIDBytes, err := hex.DecodeString(assetIDHex)
if err != nil || len(assetIDBytes) != 32 {
    // invalid — show error
}
resp, err := tapChannel.FundChannel(ctx, &tapchannelrpc.FundChannelRequest{
    AssetId:          assetIDBytes,
    AssetAmount:      rawAmount,   // NOT scaled — raw integer units
    PeerPubkey:       peerPubkeyBytes,
    FeeRateSatPerVbyte: feeRate,
})
```

The `AssetId` must be exactly 32 bytes. Use the genesis asset ID (not group key) here.

---

## Creating Asset Invoices

```go
req := &tapchannelrpc.AddInvoiceRequest{
    AssetAmount: scaledAmount,  // multiply user input by 10^decimalDisplay first
    InvoiceRequest: &lnrpc.Invoice{Memo: memo},
}
if groupKeyHex != "" {
    req.GroupKey, _ = hex.DecodeString(groupKeyHex)
} else {
    req.AssetId, _ = hex.DecodeString(assetIDHex)
}
resp, err := tapChannel.AddInvoice(ctx, req)
payReq := resp.InvoiceResult.PaymentRequest
```

---

## Common Gotchas

| Gotcha | Fix |
|---|---|
| `DecodePayReq` RPC returns empty or fails silently | Use `zpay32.Decode` locally with all network params |
| Channel assets missing from `ListAssets(SCRIPT_KEY_CHANNEL)` | Source from `ListChannels` + `CustomChannelData` JSON |
| `DecimalDisplay` is nil | Always nil-check; default to 0 |
| `DecimalDisplay.DecimalDisplay` — field name repeated | The proto wraps it in a message; access with `.DecimalDisplay.DecimalDisplay` |
| `CustomChannelData` on channels is JSON | Use `json.Unmarshal` |
| `CustomChannelData` on HTLCs/routes is TLV | Use `DecodeAssetPayReq` RPC |
| `data.GroupKey == ""` means BTC channel | Always guard before treating as asset channel |
| Asset LN payments also have bolt11 strings | Don't filter memo parsing by `assetName == "BTC"` |
| Pagination loops repeating entries | Dedup by `PaymentHash` / `hex(RHash)`; use `done` flag, not empty cursor |
| `AssetId` in `FundChannel` must be exactly 32 bytes | Validate length after `hex.DecodeString` |
