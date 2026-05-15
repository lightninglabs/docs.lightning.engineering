---
description: Agentic skills that save you time and tokens
---

# Skills

We have compiled a list of agentic skills that may save you time and token when developing applications and features on Lightning Labs products.

All of these guides can also be found in the `/skills` sub-directory of the raw [Builder's Guide on Github](https://github.com/lightninglabs/docs.lightning.engineering/).

To make use of them, ideally place them in the `/skill` directory of your preferred agentic model, such as `~/.claude/skills`.

### Install Skills

To install a skill in Claude, clone the directory, then either install selected or all skills:

`git clone https://github.com/Liongrass/lightning-skills.git`\
`cd lightning-skills` \
`/skills install <path-to-skill-directory>`&#x20;

To install skills using Vercel skills, run:

`npx skills add liongrass/lightning-skills`

## Available Skills

#### LND

Navigate the LND code base:\
[lnd-navigate.md](https://raw.githubusercontent.com/lightninglabs/docs.lightning.engineering/refs/heads/master/skills/lnd-navigate.md)

#### Lightning Terminal

Make use of the Litd RPC:\
[litd-grpc.md](https://raw.githubusercontent.com/lightninglabs/docs.lightning.engineering/refs/heads/master/skills/litd-grpc.md)

Develop apps using the LNC NodeJS package:\
[lnc-app.md](https://raw.githubusercontent.com/lightninglabs/docs.lightning.engineering/refs/heads/master/skills/lnc-app.md)

#### Taproot Assets

Make use of the Taproot Assets RPC:\
[taproot-assets-rpc.md](https://raw.githubusercontent.com/lightninglabs/docs.lightning.engineering/refs/heads/master/skills/taproot-assets-rpc.md)
