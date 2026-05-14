---
name: lnc-app
description: Guide for building a Lightning Node Connect (LNC) web application using lnc-web
---

The user wants guidance on building an LNC-powered web application. Use the knowledge below to produce clear, accurate advice or code.

---

# Building a Lightning Node Connect (LNC) Web Application

## What is LNC?

Lightning Node Connect lets a browser-based app communicate with an LND node without exposing any ports. The connection is end-to-end encrypted and routed through a mailbox proxy server. The user generates a **pairing phrase** (a BIP39-style mnemonic) in Lightning Terminal (`litd`) that encodes the cryptographic key material for the session. The client derives its keys from this phrase, connects to the mailbox, and performs a Noise protocol handshake with the node.

## Package

```bash
npm install @lightninglabs/lnc-web
```

The package ships a prebuilt UMD bundle. Import it as a default import:

```js
import LNC from '@lightninglabs/lnc-web';
```

**Vite config** — tell Vite to pre-bundle it (converts UMD to ESM):

```js
// vite.config.js
export default {
  optimizeDeps: {
    include: ['@lightninglabs/lnc-web'],
  },
};
```

---

## Key concepts

### The credential store

lnc-web stores everything it needs to reconnect in `window.localStorage`, namespaced to avoid conflicts. The credential store holds:

| Field | Description |
|---|---|
| `pairingPhrase` | The original mnemonic — **one-time use only** |
| `serverHost` | `host:port` of the mailbox proxy (no protocol prefix) |
| `localKey` | Client's private key, generated on first connect |
| `remoteKey` | Node's static public key, received on first connect |
| `password` | Not read/written by LNC itself — exposed for your convenience |

`isPaired` is a read-only getter that returns `true` when `localKey` and `remoteKey` are both stored, meaning the session can reconnect without the pairing phrase.

### What the pairing phrase encodes

The pairing phrase encodes **cryptographic key material only** — it does not encode the mailbox server address. The `serverHost` must be provided separately and is stored in the credential store after first connection.

### Password encryption

The credential store encrypts `localKey` and `remoteKey` at rest using the password. The password is applied transparently inside the getter/setter — you never call encrypt/decrypt yourself. Set it before connecting:

```js
lnc.credentials.password = 'user-chosen-password';
```

---

## Connection flows

### First-time pairing

Pass `pairingPhrase` and `password` in the **constructor** (not as properties afterwards — the WASM module must be initialised with them):

```js
const lnc = new LNC({
  namespace: 'my-app',       // isolates localStorage keys
  pairingPhrase: phrase,     // mnemonic from litcli
  password: 'local-password',
});

// Override the mailbox if the user is not using the default
lnc.credentials.serverHost = 'mailbox.terminal.lightning.today:443';

await lnc.connect();

// IMPORTANT: clear the stored pairing phrase after success.
// On reconnect lnc-web would otherwise try to pair again with a
// one-time-use phrase and get "stream not found" from the mailbox.
lnc.credentials.pairingPhrase = '';
```

### Reconnection (returning user)

When `isPaired` is true the stored `localKey`/`remoteKey` and `serverHost` are all that is needed. Do **not** pass `pairingPhrase` — leave it out of the constructor entirely and clear it explicitly before connecting as a safety measure:

```js
const lnc = new LNC({ namespace: 'my-app' });
lnc.credentials.password = 'local-password';
lnc.credentials.pairingPhrase = ''; // ensure it is never reused
await lnc.connect();
```

### Checking connection state

After `connect()` resolves, check `lnc.isConnected`. If it is `false`, read `lnc.status` for a human-readable reason (e.g. `"Session Not Found"`, `"Wallet Locked"`). Reset the cached instance and throw so the UI can surface the message:

```js
if (!lnc.isConnected) {
  const reason = lnc.status || 'Unknown error';
  lnc = null; // force a fresh instance on next attempt
  throw new Error(reason);
}
```

### Checking whether credentials exist

Use a **throwaway instance** to read `isPaired` — do not cache the result or the instance, as you do not yet have the proxy or password:

```js
function hasPairedCredentials() {
  try {
    return new LNC({ namespace: 'my-app' }).credentials.isPaired;
  } catch {
    return false;
  }
}
```

### Disconnecting / logging out

```js
lnc.disconnect();
lnc.credentials.clear(); // wipes localStorage
lnc = null;
```

---

## Settings to offer the user

| Setting | Default | Notes |
|---|---|---|
| Proxy server | `mailbox.terminal.lightning.today:443` | Show on pairing screen only — stored in credentials, not needed again |
| Local password | — | Required; encrypts keys in localStorage |
| Pairing phrase | — | One-time use; cleared after first connect |

The proxy field should be shown **only on the first-time pairing screen**, not on the returning-user login screen (the stored value is used automatically). Pass the value via `lnc.credentials.serverHost` after constructing the instance, without a protocol prefix (`wss://` is added internally by lnc-web).

---

## Making RPC calls

All LND services are available under `lnc.lnd.*`. Calls are async and return plain JS objects.

### Get node info

```js
const info = await lnc.lnd.lightning.getInfo();
console.log(info.alias, info.numActiveChannels);
```

### Create an invoice

```js
const resp = await lnc.lnd.lightning.addInvoice({
  value: '5000',          // satoshis as string
  memo: 'Coffee',
  expiry: '300',          // seconds as string
});

const { paymentRequest, rHash } = resp;
// paymentRequest is the BOLT11 string — encode it as a QR code
// rHash is the payment hash bytes — keep it to poll for settlement
```

> **Permission note:** `addInvoice` is a write operation. A pure `readonly` LNC session will reject it. The session must have invoice write permission.

### Look up an invoice (poll for payment)

Pass `rHash` back exactly as lnc-web returned it — do not attempt to convert it to hex manually:

```js
const invoice = await lnc.lnd.lightning.lookupInvoice({ rHash: resp.rHash });
if (invoice.settled) {
  // payment received
}
```

Poll on a timer; cancel when settled, timed out, or the user cancels:

```js
function pollInvoice(rHash, timeoutMs, onPaid, onExpired) {
  const deadline = Date.now() + timeoutMs;
  let timer;

  async function tick() {
    if (Date.now() >= deadline) return onExpired();
    const inv = await lnc.lnd.lightning.lookupInvoice({ rHash });
    if (inv.settled) return onPaid(inv);
    timer = setTimeout(tick, 2000);
  }

  timer = setTimeout(tick, 2000);
  return { cancel: () => clearTimeout(timer) };
}
```

### List recent invoices

```js
const resp = await lnc.lnd.lightning.listInvoices({
  reversed: true,          // newest first from LND
  numMaxInvoices: '10',
});
const invoices = resp.invoices ?? [];
```

### Subscribe to invoice events (streaming)

```js
lnc.lnd.lightning.subscribeInvoices(
  {},
  (invoice) => {
    if (invoice.settled) console.log('Paid:', invoice.paymentRequest);
  },
  (err) => console.error('Stream error:', err),
);
```

### Check wallet and channel balances

```js
const wallet  = await lnc.lnd.lightning.walletBalance();
const channel = await lnc.lnd.lightning.channelBalance();
```

---

## Recommended application flow

```
Boot
 └─ hasPairedCredentials()?
     ├─ No  → Show pairing screen (phrase + password + proxy)
     │         → pair() → clear pairingPhrase → show settings → main screen
     └─ Yes → Show login screen (password only)
               → login() → main screen
```

On logout: `disconnect()` + `credentials.clear()` + redirect to pairing screen.
