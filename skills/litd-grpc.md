# litd gRPC — Accounts & LNC Sessions

Reference for interacting with litd (Lightning Terminal daemon) gRPC API: managing accounts and LNC sessions, baking account-scoped macaroons, and listing account payments.

---

## Connection Setup

litd exposes a single TLS gRPC endpoint (default `localhost:8443`). Authentication uses macaroon hex in the `macaroon` request metadata header.

### Bootstrap connection (supermacaroon)

```go
import (
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials"
    "github.com/lightninglabs/lightning-terminal/litrpc"
    "github.com/lightningnetwork/lnd/lnrpc"
)

// 1. Load TLS cert
tlsCreds, _ := credentials.NewClientTLSFromFile("~/.lit/tls.cert", "")

// 2. Wrap the lit.macaroon as a per-RPC credential
creds := &macaroonCredentials{hex: hex.EncodeToString(macBytes)}

// 3. Dial
conn, _ := grpc.NewClient(
    "localhost:8443",
    grpc.WithTransportCredentials(tlsCreds),
    grpc.WithPerRPCCredentials(creds),
)

// 4. Immediately bake a supermacaroon so one credential covers all sub-services
proxy := litrpc.NewProxyClient(conn)
resp, _ := proxy.BakeSuperMacaroon(ctx, &litrpc.BakeSuperMacaroonRequest{})
creds.update(resp.Macaroon)          // swap in supermacaroon; lit.macaroon no longer sent

// 5. Create sub-clients on the same connection
lightning := lnrpc.NewLightningClient(conn)
accounts  := litrpc.NewAccountsClient(conn)
sessions  := litrpc.NewSessionsClient(conn)
```

### macaroonCredentials helper (thread-safe, swappable)

```go
type macaroonCredentials struct {
    mu  sync.RWMutex
    hex string
}
func (m *macaroonCredentials) GetRequestMetadata(_ context.Context, _ ...string) (map[string]string, error) {
    m.mu.RLock(); defer m.mu.RUnlock()
    return map[string]string{"macaroon": m.hex}, nil
}
func (m *macaroonCredentials) RequireTransportSecurity() bool { return true }
func (m *macaroonCredentials) update(h string) { m.mu.Lock(); m.hex = h; m.mu.Unlock() }
```

---

## Account Management

All account RPCs go through `litrpc.AccountsClient`.

### List all accounts

```go
resp, err := accounts.ListAccounts(ctx, &litrpc.ListAccountsRequest{})
// resp.Accounts []*litrpc.Account
// Account fields: Id, Label, CurrentBalance, InitialBalance, ExpirationDate, Payments []*AccountPayment
```

### Get single account

```go
resp, err := accounts.AccountInfo(ctx, &litrpc.AccountInfoRequest{Id: accountID})
// resp is *litrpc.Account directly
```

### Create account

```go
resp, err := accounts.CreateAccount(ctx, &litrpc.CreateAccountRequest{
    AccountBalance: 100_000,      // satoshis; 0 = empty account is valid
    Label:          "My Budget",  // optional
    ExpirationDate: 0,            // 0 = never; unix timestamp otherwise
})
// resp.Account *litrpc.Account
```

### Update account (balance, expiry, label)

`UpdateAccountRequest` uses sentinel `-1` for `AccountBalance` to mean "do not change balance".
Always pass the **current** `ExpirationDate` when only changing the label (protobuf 0 = unset = may reset expiry).

```go
// Credit (add sats)
resp, err := accounts.CreditAccount(ctx, &litrpc.CreditAccountRequest{
    Account: &litrpc.AccountIdentifier{
        Identifier: &litrpc.AccountIdentifier_Id{Id: accountID},
    },
    Amount: 50_000,
})

// Debit (remove sats)
resp, err := accounts.DebitAccount(ctx, &litrpc.DebitAccountRequest{
    Account: &litrpc.AccountIdentifier{
        Identifier: &litrpc.AccountIdentifier_Id{Id: accountID},
    },
    Amount: 10_000,
})

// Update expiry only
resp, err := accounts.UpdateAccount(ctx, &litrpc.UpdateAccountRequest{
    Id:             accountID,
    AccountBalance: -1,          // do not touch balance
    ExpirationDate: newExpiry,
})

// Update label only — pass current expiry to avoid clearing it
resp, err := accounts.UpdateAccount(ctx, &litrpc.UpdateAccountRequest{
    Id:             accountID,
    AccountBalance: -1,
    ExpirationDate: currentAccount.ExpirationDate,
    Label:          "New Label",
})
```

### Remove account

```go
_, err := accounts.RemoveAccount(ctx, &litrpc.RemoveAccountRequest{Id: accountID})
```

---

## Macaroon Baking (Account-Scoped)

Macaroons are baked via `lnrpc.LightningClient.BakeMacaroon`, then a first-party caveat ties them to an account:

```go
// 1. Bake base macaroon with desired permissions
resp, _ := lightning.BakeMacaroon(ctx, &lnrpc.BakeMacaroonRequest{
    Permissions: []*lnrpc.MacaroonPermission{
        {Entity: "info",     Action: "read"},
        {Entity: "invoices", Action: "read"},
        {Entity: "offchain", Action: "read"},
        {Entity: "onchain",  Action: "read"},
    },
    AllowExternalPermissions: true,
})

// 2. Decode, add account caveat, re-encode
macBytes, _ := hex.DecodeString(resp.Macaroon)
mac, _ := macaroon.New(nil, nil, "", macaroon.LatestVersion)
mac.UnmarshalBinary(macBytes)
mac.AddFirstPartyCaveat([]byte("lnd-custom account " + accountID))
constrained, _ := mac.MarshalBinary()
accountMacHex := hex.EncodeToString(constrained)
```

**Predefined permission sets:**

| Type | Permissions |
|------|-------------|
| Account (full) | info:read, invoices:r/w, offchain:r/w, onchain:read, address:r/w |
| Readonly | info:read, invoices:read, offchain:read, onchain:read |
| Invoice | invoices:r/w, address:r/w |

---

## Account-Scoped Payment Listing

**Critical**: Do NOT use `grpc.PerRPCCredentials(...)` as a per-call option on an existing connection — litd will reject the request with `"expected 1 macaroon, got 2"` because both the connection-level supermacaroon AND the per-call credential are sent.

**Correct pattern**: Open a **dedicated short-lived connection** with only the account macaroon:

```go
func ListAccountPayments(ctx context.Context, accountMacHex, rpcServer string, tlsCreds credentials.TransportCredentials) ([]*lnrpc.Payment, []*lnrpc.Invoice, error) {
    creds := &macaroonCredentials{hex: accountMacHex}
    conn, err := grpc.NewClient(
        rpcServer,
        grpc.WithTransportCredentials(tlsCreds),
        grpc.WithPerRPCCredentials(creds),
    )
    if err != nil {
        return nil, nil, err
    }
    defer conn.Close()

    lightning := lnrpc.NewLightningClient(conn)

    // Outgoing payments
    payResp, err := lightning.ListPayments(ctx, &lnrpc.ListPaymentsRequest{
        Reversed:          true,
        IncludeIncomplete: true,
    })

    // Incoming invoices
    invResp, err := lightning.ListInvoices(ctx, &lnrpc.ListInvoiceRequest{
        Reversed: true,
    })

    return payResp.Payments, invResp.Invoices, nil
}
```

The litd middleware intercepts these calls, validates the `lnd-custom account <id>` caveat, and returns only the payments/invoices belonging to that account.

### Payment fields of interest

```go
// lnrpc.Payment
p.PaymentHash      // hex string
p.ValueSat         // amount sent in satoshis
p.FeeSat           // routing fee in satoshis
p.CreationTimeNs   // creation time in UNIX nanoseconds (divide by 1e9 for seconds)
p.Status           // Payment_UNKNOWN | Payment_IN_FLIGHT | Payment_SUCCEEDED | Payment_FAILED
p.PaymentRequest   // bolt11 invoice string (decode with zpay32 for description/memo)
p.PaymentPreimage  // hex preimage
p.FailureReason    // set if Status == FAILED

// lnrpc.Invoice
inv.RHash          // []byte payment hash
inv.Value          // requested amount in satoshis
inv.AmtPaidSat     // actual paid amount (use this; may differ from Value for flexible invoices)
inv.CreationDate   // UNIX seconds
inv.SettleDate     // UNIX seconds (0 if not settled)
inv.State          // Invoice_OPEN | Invoice_SETTLED | Invoice_CANCELED | Invoice_ACCEPTED
inv.Memo           // description set by invoice creator
inv.PaymentRequest // bolt11 invoice string
```

### Decoding bolt11 memo (zpay32)

```go
import (
    "github.com/btcsuite/btcd/chaincfg"
    "github.com/lightningnetwork/lnd/zpay32"
)

func decodeMemo(payReq, network string) string {
    if payReq == "" { return "" }
    params := &chaincfg.MainNetParams // or TestNet3Params, SigNetParams, RegressionNetParams
    inv, err := zpay32.Decode(payReq, params)
    if err != nil || inv.Description == nil { return "" }
    return *inv.Description
}
```

---

## LNC Session Management

All session RPCs go through `litrpc.SessionsClient`.

### List sessions

```go
resp, err := sessions.ListSessions(ctx, &litrpc.ListSessionsRequest{})
// resp.Sessions []*litrpc.Session

// Session fields:
s.Label                   // human-readable name
s.LocalPublicKey          // []byte — unique identifier for this session
s.RemotePublicKey         // []byte — set once a wallet has paired (len > 0 = connected)
s.SessionType             // see types below
s.SessionState            // STATE_CREATED | STATE_IN_USE | STATE_REVOKED | STATE_EXPIRED
s.ExpiryTimestampSeconds  // uint64 unix timestamp
s.PairingSecretMnemonic   // LNC pairing phrase (show to user before wallet connects)
s.AccountId               // non-empty for account-tied sessions
```

### Session types

```go
litrpc.SessionType_TYPE_MACAROON_READONLY  // read-only node access
litrpc.SessionType_TYPE_MACAROON_ADMIN     // full node access
litrpc.SessionType_TYPE_MACAROON_CUSTOM    // custom permission set
litrpc.SessionType_TYPE_MACAROON_ACCOUNT   // tied to a specific account
litrpc.SessionType_TYPE_AUTOPILOT          // autopilot / automated
```

### Create a general session (Admin / Readonly / Custom)

```go
req := &litrpc.AddSessionRequest{
    Label:                  "My Wallet",
    SessionType:            litrpc.SessionType_TYPE_MACAROON_READONLY,
    MailboxServerAddr:      "mailbox.terminal.lightning.today:443",
    ExpiryTimestampSeconds: uint64(time.Now().Add(365 * 24 * time.Hour).Unix()),
    // For TYPE_MACAROON_CUSTOM only:
    MacaroonCustomPermissions: []*litrpc.MacaroonPermission{
        {Entity: "offchain", Action: "read"},
        {Entity: "invoices", Action: "write"},
    },
}
resp, err := sessions.AddSession(ctx, req)
// resp.Session *litrpc.Session — contains PairingSecretMnemonic for LNC pairing
```

**Invoice session** (predefined custom permissions):
```go
invoicePerms := []*litrpc.MacaroonPermission{
    {Entity: "address",  Action: "read"},
    {Entity: "address",  Action: "write"},
    {Entity: "invoices", Action: "read"},
    {Entity: "invoices", Action: "write"},
    {Entity: "onchain",  Action: "read"},
}
req := &litrpc.AddSessionRequest{
    Label:                     "Invoice Session",
    SessionType:               litrpc.SessionType_TYPE_MACAROON_CUSTOM,
    MailboxServerAddr:         "mailbox.terminal.lightning.today:443",
    ExpiryTimestampSeconds:    expiryUnix,
    MacaroonCustomPermissions: invoicePerms,
}
```

### Create an account-tied session

```go
resp, err := sessions.AddSession(ctx, &litrpc.AddSessionRequest{
    Label:                  "Alice's Wallet",
    SessionType:            litrpc.SessionType_TYPE_MACAROON_ACCOUNT,
    AccountId:              accountID,        // ties session to account
    MailboxServerAddr:      "mailbox.terminal.lightning.today:443",
    ExpiryTimestampSeconds: expiryUnix,
})
// User scans/pastes resp.Session.PairingSecretMnemonic in an LNC-compatible wallet
```

### Revoke session

```go
_, err := sessions.RevokeSession(ctx, &litrpc.RevokeSessionRequest{
    LocalPublicKey: session.LocalPublicKey,
})
```

### Check session state

```go
// Is session connected (wallet has paired)?
connected := len(session.RemotePublicKey) > 0

// Is session still active?
active := session.SessionState == litrpc.SessionState_STATE_CREATED ||
          session.SessionState == litrpc.SessionState_STATE_IN_USE
```

---

## Parsing Custom Permissions

Parse a comma-separated `"entity:action"` string into `[]*litrpc.MacaroonPermission`:

```go
func ParsePermissions(s string) ([]*litrpc.MacaroonPermission, error) {
    var perms []*litrpc.MacaroonPermission
    for _, part := range strings.Split(s, ",") {
        part = strings.TrimSpace(part)
        if part == "" { continue }
        kv := strings.SplitN(part, ":", 2)
        if len(kv) != 2 || kv[0] == "" || kv[1] == "" {
            return nil, fmt.Errorf("invalid permission %q: want entity:action", part)
        }
        perms = append(perms, &litrpc.MacaroonPermission{
            Entity: strings.TrimSpace(kv[0]),
            Action: strings.TrimSpace(kv[1]),
        })
    }
    if len(perms) == 0 {
        return nil, fmt.Errorf("no permissions provided")
    }
    return perms, nil
}
```

---

## go.mod Requirements

```
require (
    github.com/lightninglabs/lightning-terminal/litrpc v1.0.2
    github.com/lightningnetwork/lnd v0.20.1-beta
    github.com/btcsuite/btcd v0.24.x           // for chaincfg (bolt11 decoding)
    gopkg.in/macaroon.v2 v2.x                  // for adding caveats
    google.golang.org/grpc vX.Y.Z
)

// Critical — lnd and litrpc use a protobuf fork:
replace google.golang.org/protobuf => github.com/lightninglabs/protobuf-go-hex-display v1.33.0-hex-display
```

---

## Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| `"expected 1 macaroon, got 2"` | Never add a per-call `grpc.PerRPCCredentials` option to a connection that already has `WithPerRPCCredentials`. Open a new dedicated connection instead. |
| Label update clears expiry | `UpdateAccountRequest.ExpirationDate = 0` may reset expiry. Always pass the account's current `ExpirationDate` when updating other fields. |
| `AccountBalance: 0` in UpdateAccount | Use `-1` to signal "do not change balance". `0` may zero out the balance. |
| bolt11 memo empty | The `Memo` field on `lnrpc.Invoice` may be populated directly, or the description may only be in the bolt11 `PaymentRequest`. Try both. |
| Session pairing phrase visibility | Only show `PairingSecretMnemonic` when `len(session.RemotePublicKey) == 0`. Once a wallet has connected the phrase is no longer needed and exposing it is misleading. |
| `CreationTimeNs` vs `CreationDate` | `lnrpc.Payment.CreationTimeNs` is nanoseconds; `lnrpc.Invoice.CreationDate` / `SettleDate` are seconds. |
