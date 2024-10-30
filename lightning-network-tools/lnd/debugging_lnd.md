# Debugging LND

1. [Overview](debugging\_lnd.md#overview)
2. [Debug Logging](debugging\_lnd.md#debug-logging)
3. [Capturing pprof data with `lnd`](debugging\_lnd.md#capturing-pprof-data-with-lnd)

## Overview

`LND` ships with a few useful features for debugging, such as a built-in profiler and tunable logging levels. If you need to submit a bug report for `LND`, it may be helpful to capture debug logging and performance data ahead of time.

## Debug Logging

Logging is useful for security and operating purposes. LND logs can typically be found on Linux at `~/.lnd/logs/bitcoin/mainnet/lnd.log`, on macOS at ​​`~/Library/Application Support/Lnd/logs/bitcoin/mainnet` or in their specified location using the`--logdir` flag at startup.

By default, LND will log 10MB worth of its history, and additionally keep three blocks of logs around, compressed with gzip as `lnd.log.<i>.gz` in the same directory.

You can adjust the location of your log files as well their maximum size (in MB) and how many historical log files you expect LND to keep, in your [`lnd.conf`](lnd.conf.md) file.

`logdir=~/.lnd/logs`\
`maxlogfiles=3`\
`maxlogfilesize=10`\
`debuglevel=debug,PEER=info`

Additionally, the debuglevel can be overridden and adjusted without requiring a restart using the command `lncli debuglevel --level=`

The available debug levels are, in order of descending detail: `trace`, `debug`, `info`, `warn`, `error`, `critical`, `off`

Example usage:

`lncli debuglevel –-level=debug`

Additionally, the log level can be adjusted for each individual subsystem. A list of the subsystem can also be obtained with the command `lncli debuglevel --show`

Varying debug levels for multiple subsystems can be chained together with commands.

Example usage:

`debuglevel --level=BTCN=trace,LNWL=debug`

Subsystems:

| LNWL | lnwallet        | Lightning Wallet      |
| ---- | --------------- | --------------------- |
| DISC | discovery       | Discovery             |
| NTFN | chainntnfs      | Chain Notifications   |
| CHDB | channeldb       | Channel database      |
| HSWC | htlcswitch      | HTLC Switch           |
| CMGR | connmgr         | Connection Manager    |
| BTCN | neutrino        | Neutrino              |
| CNCT | contractcourt   | Contract Court        |
| UTXN | contractcourt   | Contract Court        |
| BRAR | contractcourt   | Contract Court        |
| SPHX | sphinx          | Sphinx                |
| SWPR | sweep           | Sweep Transactions    |
| SGNR | signrpc         | Signature RPC         |
| WLKT | walletrpc       | Wallet RPC            |
| ARPC | autopilotrpc    | Autopilot RPC         |
| INVC | invoices        | Invoices              |
| NANN | netann          | Network Announcements |
| WTWR | watchtower      | Watchtower            |
| NTFR | chainrpc        | Chain RPC             |
| IRPC | invoicesrpc     | Invoices RPC          |
| CHNF | channelnotifier | Channel Notifier      |
| CHBU | chanbackup      | Channel backup        |
| PROM | monitoring      | Monitoring            |
| WTCL | wtclient        | Watch Tower Client    |
| PRNF | peernotifier    | Peer Notifier         |
| CHFD | chanfunding     | Channel Funding       |
| PEER | peer            | Peer                  |
| CHCL | chancloser      | Channel Closer        |

## Capturing pprof data with `lnd`

`lnd` has a built-in feature which allows you to capture profiling data at runtime using [pprof](https://golang.org/pkg/runtime/pprof/), a profiler for Go. The profiler has negligible performance overhead during normal operations (unless you have explicitly enabled CPU profiling).

To enable this ability, start `lnd` with the `--profile` option using a free port or add `profile=9736` to your `lnd.conf`.

```
⛰  lnd --profile=9736
```

Now, with `lnd` running, you can use the pprof endpoint on port 9736 to collect runtime profiling data. You can fetch this data using `curl` like so:

```
⛰  curl http://localhost:9736/debug/pprof/goroutine?debug=1
...
```

#### CPU Profile

A CPU profile can be used to analyze LND's CPU usage. You can specify the time duration as a query parameter.

```
⛰ curl http://localhost:9736/debug/pprof/profile?seconds=10 > cpu.prof
```

#### **Goroutine profile**

The goroutine profile is very useful when analyzing deadlocks and lock contention.

```
⛰ curl http://localhost:9736/debug/pprof/goroutine?debug=2 > goroutine.prof
```

#### **Heap profile**

The heap profile is useful to analyze memory allocations.

```
⛰ curl http://localhost:9736/debug/pprof/heap > heap.prof
```

#### **Visualizing the profile dumps**

It can be hard to make sense of the profile dumps by just looking at them. The Golang ecosystem provides tools to analyze those profile dumps either via the terminal or by visualizing them. One of the tools is `go tool pprof`.

Assuming the profile was fetched via `curl` as in the examples above a nice svg visualization can be generated for the cpu profile like this:

```
⛰ go tool pprof -svg cpu.prof > cpu.svg
```
