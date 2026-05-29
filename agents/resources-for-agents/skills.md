---
description: Agentic skills that save you time and tokens
---

# Skills

We have compiled a list of agentic skills that may save you time and token when developing applications and features on Lightning Labs products.

All of these guides can also be found in the `/skills` sub-directory of the raw [Builder's Guide on Github](https://github.com/lightninglabs/docs.lightning.engineering/).

To make use of them, ideally place them in the `/skill` directory of your preferred agentic model, such as `~/.claude/skills`.

### Install Skills

To install a skill in Claude, clone the directory, then either install selected or all skills:

`git clone https://github.com/lightninglabs/lightning-agent-tools.git`\
`cd lightning-agent-tools/skills` \
`/skills install <path-to-skill-directory>`&#x20;

To install skills using Vercel skills, run:

`npx skills add lightninglabs/lightning-agent-tools/skills`

## Available Skills

#### Aperture

[Install and run Aperture](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/aperture/SKILL.md)

#### Commerce

[End-to-end agentic commerce workflow](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/commerce/SKILL.md)

#### Lightning MPC Server

[Build and configure the MCP server for Lightning Node Connect (LNC)](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/lightning-mcp-server/SKILL.md)

#### Lightning Security Module

[Set up an lnd remote signer container that holds private keys separately from the agent.](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/lightning-security-module/SKILL.md)

#### LND

[Navigate the LND code base.](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/lnd-navigate/SKILL.md)

[Bake, inspect, and manage lnd macaroons for least-privilege agent access.](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/macaroon-bakery/SKILL.md)

#### Lightning Terminal

[Install and operate a litd node in docker.](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/lnd/SKILL.md)

[Install and operate a litd node with neutrino backend.](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/run-litd/SKILL.md)

[Make use of the Litd RPC, specifically LND Accounts and LNC Sessions.](https://github.com/lightninglabs/lightning-agent-tools/tree/main/skills/litd-grpc)

[Build an LNC Wasm](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/lnc-app/SKILL.md)

#### Taproot Assets

[Make use of the Taproot Assets RPC.](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/taproot-assets-rpc/SKILL.md)

#### Lnget

[Install and use lnget, a Lightning-native HTTP client with automatic L402 payment support.](https://github.com/lightninglabs/lightning-agent-tools/blob/main/skills/lnget/SKILL.md)
