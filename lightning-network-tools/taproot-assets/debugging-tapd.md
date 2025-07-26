---
description: Help improve the Taproot Assets Daemon by submitting your logs and issues.
---

# Debugging Tapd

Taproot Assets is alpha software. You can help improve the software by providing feedback, submitting issues and making pull requests.

This guide aims to help you debug issues you might encounter when running `litd` with `tapd` in integrated mode.

## Is Taproot Assets running?

Taproot Assets runs as part of `litd`, and it may not be apparent when `tapd` fails to start as part of the wider bundle. You can always check which subsystems are enabled and running by calling:

`litcli status`

## Logging

The logs provide invaluable clues as to why a system might not be starting, or why a command fails to execute. In integrated mode, all logs are written to `lnd.log`, typically located in `~/.lnd/logs/bitcoin/mainnet/lnd.log`

To adjust the debug level, you may run:

`lncli debuglevel --level trace,SRVR=debug,PEER=info,BTCN=warn,GRPC=error`

Alternatively, you can also add the following to your `lit.conf` to set the debugging level permanently:

`lnd.debuglevel=trace,SRVR=debug,PEER=info,BTCN=warn,GRPC=error`

You can use the following to increase the number of log files and their maximum size, allowing you to look further into the past in search for clues:

`lnd.maxlogfilesize=100`\
`lnd.maxlogfiles=100`

## Profiling

A go profile helps determine the state of a go program. You can enable profiling at any port:

`lnd.profile=9736`

You can then call the profile with:

`curl http://localhost:9736/debug/pprof/goroutine?debug=2 > goprofile.txt`

## Filing issues

All issues may be filed on the project’s Github repository. Please be as clear as possible, and include logs and go profile.

{% embed url="https://github.com/lightninglabs/taproot-assets/issues" %}
