---
description: Run litd either in integrated mode or on a separate machine.
---

# Connect to Terminal

If `litd` is already running on your machine, follow this guide. For installation instructions, [follow our guide](get-lit.md). If you are running a bundle such as Umbrel or Start9, Terminal may already be installed on your machine.

Once you have navigated to your local installation of Terminal, click on "Connect to Terminal" to be taken directly to Terminal on the web. Alternatively you may scan the QR code with a smart phone or tablet to open a new session on another device.

You can inspect and revoke all existing sessions under "Lightning Node Connect."

<figure><img src="../../.gitbook/assets/Screenshot 2022-10-12 at 11-27-59 Lightning Terminal.png" alt=""><figcaption><p>Lightning Terminal, as seen when navigating to https://127.0.0.1:8443</p></figcaption></figure>

## Run litd locally

Once you are running `litd` on your machine, navigate to `http://127.0.0.1:8443` in your browser on the same machine to open Lightning Terminal. If you are running `litd` on another machine, you may access it from there or continue with the CLI option below.

## Create a session using the command line

If you cannot access the machine on which you are running `litd` via the browser or prefer to keep port `8443` closed, you may generate a new pairing phrase with `litcli`.

`litcli sessions add --label="default" --type=admin`

Now navigate to [https://terminal.lightning.engineering](https://terminal.lightning.engineering/) and click on 'Connect your Node.'

You will be asked for your 10-word pairing phrase. Enter it and confirm.

You need to choose a secure and unique password. We recommend to use a password manager.

You're now connected to Lightning Terminal! Read more about [Recommended Channels](recommended-channels.md), [Health Checks](health-checks.md), and [how to open channels to the Lightning Network](opening-channels.md).
