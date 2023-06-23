---
description: >-
  Install your own Lightning Node Connect relay proxy server, the mailbox, which
  comes bundled in Aperture.
---

# LNC Mailbox

Lightning Node Connect (LNC) is a protocol that establishes a connection between your Lightning Network node (LND) and a remote application, such as Lightning Terminal or Zeus.

To traverse firewalls and Network Address Translation (NAT), LNC makes use of a mailbox proxy. This proxy is part of the open-source aperture and can be installed freely by anybody.

LNC is most useful when both the client and the Lightning node are behind a firewall or NAT, but it can also be useful when only the Lightning node is unreachable. In this case, aperture may be installed on the same machine as the client application.&#x20;

## Requirements <a href="#docs-internal-guid-3a0b9987-7fff-a39a-eec7-f046b22bd334" id="docs-internal-guid-3a0b9987-7fff-a39a-eec7-f046b22bd334"></a>

To run our LNC mailbox, we are going to need Aperture. [You can learn how to install Aperture here](get-aperture.md).

## Configure aperture <a href="#docs-internal-guid-b757d186-7fff-3163-6ef9-f86657a3772a" id="docs-internal-guid-b757d186-7fff-3163-6ef9-f86657a3772a"></a>

Aperture needs to run as root to be able to permanently bind to the port where it will be listening.

Depending on your go path, you may have to move aperture to where the root user can find it too.

`sudo cp $GOPATH/bin/aperture /usr/local/bin/aperture`

Next, we are going to switch to the superuser and create our configuration file.

`sudo -i`\
`mkdir ~/.aperture`\
`nano ~/.aperture/aperture.yaml`

Use this template and don’t forget to swap the domain name with your own. This domain name should also point to the server on which you are setting up aperture!

```
listenaddr: "lnc.yourlightning.app:443"
debuglevel: "trace"
autocert: true
servername: lnc.yourlightning.app
authenticator:
  disable: true
hashmail:
  enabled: true
  messagerate: 1ms
  messageburstallowance: 99999999
prometheus:
  enabled: false
```

## Run aperture <a href="#docs-internal-guid-680bd854-7fff-6acd-1c94-e2b1fb86f9ed" id="docs-internal-guid-680bd854-7fff-6acd-1c94-e2b1fb86f9ed"></a>

To run aperture, we only need to execute one command.

`aperture`

The logs may show that aperture is now listening for connections.

`[INF] APER: Configuring autocert for server lnc.yourlightning.app with cache dir /root/.aperture/autocert`\
`[INF] APER: Starting the server, listening on lnc.yourlightning.app:443.`

## Connect to Terminal <a href="#docs-internal-guid-6d497483-7fff-ccdd-3290-061a74b72572" id="docs-internal-guid-6d497483-7fff-ccdd-3290-061a74b72572"></a>

We can now connect our LND node to Lightning Terminal using our own mailbox. You will need litd running alongside LND. Learn how to [install litd here](../lightning-terminal/get-lit.md).

`litcli sessions add --label="My own mailbox" --type admin --mailboxserveraddr lnc.yourlightningapp:443`

Next we type the generated 10-word connection string into Lightning Terminal, together with the url and port number of our mailbox.

<figure><img src="../../.gitbook/assets/Screenshot 2022-12-06 at 16-05-51 Lightning Terminal.png" alt=""><figcaption><p>Connect your node to Lightning Terminal via LNC and your own proxy server</p></figcaption></figure>

We can now connect, select and confirm a password and control our Lightning node remotely!

## Troubleshooting <a href="#docs-internal-guid-6f5d734c-7fff-7276-2045-8790bdb8ac96" id="docs-internal-guid-6f5d734c-7fff-7276-2045-8790bdb8ac96"></a>

On some VPS providers, aperture fails to correctly bind to the address and port it listens on.

`root@mailbox:~# aperture`\
`[INF] APER: Configuring autocert for server lnc.yourlightningapp.com with cache dir /root/.aperture/autocert`\
`[INF] APER: Starting the server, listening on lnc.yourlightningapp.com:443.`\
`[ERR] APER: Error while running aperture: listen tcp 172.81.180.188:443: bind: cannot assign requested address`\
`[INF] APER: Shutdown complete`

## Optional: Set up aperture with systemd <a href="#docs-internal-guid-c5eb0a5d-7fff-f101-6d30-c1275e8be639" id="docs-internal-guid-c5eb0a5d-7fff-f101-6d30-c1275e8be639"></a>

We navigate to the systemd directory and create a new service.

`cd /etc/systemd/system`\
`sudo nano aperture.service`

Here we may paste the following template

`[Unit]`\
`Description=LNC mailbox service`

`[Service]`\
`User=root`\
`WorkingDirectory=/root`\
`ExecStart=/usr/local/bin/aperture`\
`Restart=on-failure`\
`RestartSec=10`

`[Install]`\
`WantedBy=multi-user.target`

To reload the list of services

`sudo systemctl daemon-reload`

To start the aperture service

`sudo systemctl start aperture.service`

To check the status of the service

`sudo systemctl status aperture.service`
