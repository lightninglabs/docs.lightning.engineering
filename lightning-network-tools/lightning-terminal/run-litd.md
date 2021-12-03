---
description: Run litd either in integrated mode or on a separate machine.
---

# Connect to Terminal

If you are running a software bundle such as Umbrel, `litd` might already be running on your machine. Navigate to Lightning Terminal to access it.

## Integrated mode

1.  To run `litd`, you will need to specify a password of your own, ideally using a password manager

    `litd --uipassword=dontusethisyouwillgethacked`

    If your `litd` binary could not be found, you may need to specify its location, such as:

    `~/go/bin/litd --uipassword=dontusethisyouwillgethacked`
2. You can navigate to `http://127.0.0.1:8443` in your browser on the same machine to open Lightning Terminal. If you are running `litd` on another machine, you may access it from there or continue with the CLI option below
3. Next, click on the Lightning Node Connect link in the side navigation

Finally, we will navigate to [https://terminal.lightning.engineering](https://terminal.lightning.engineering) and enter our pairing phrase after clicking on ‘Connect my Node’

### Running litd together with lnd on a remote machine? <a href="#docs-internal-guid-fa69f7a0-7fff-8b6a-aadb-a1932e40738b" id="docs-internal-guid-fa69f7a0-7fff-8b6a-aadb-a1932e40738b"></a>

1.  You might want to run `litd` continuously on the same machine as `lnd`, and manage it through Terminal remotely. In this case, you can use `litcli` to generate the connection phrase in the terminal directly. We start `litd` regularly

    `litd --uipassword=dontusethisyouwillgethacked`
2. You can now run `litcli --lndtlscertpath ~/.lit/tls.cert sessions add --label="default"` to generate a new session and obtain the pairing phrase.

## Connect to Lightning Terminal

Navigate to [https://terminal.lightning.engineering](https://terminal.lightning.engineering) and click on 'Connect your Node.'

You will be asked for your 10-word pairing phrase. Enter it and confirm.

You need to choose a secure and unique password. We recommend to use a password manager.

You're now connected to Lightning Terminal! Read more about [Recommended Channels](recommended-channels.md), [Health Checks](health-checks.md), and [how to open channels to the Lightning Network](opening-channels.md).
