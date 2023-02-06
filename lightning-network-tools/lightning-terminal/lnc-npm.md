---
description: >-
  Use NPM to download and install the LNC node package and enable your
  application to connect directly to your users' nodes via Lightning Node
  Connect.
---

# LNC Node Package

Lightning Node Connect (LNC) is a protocol that allows a node operator to safely and easily connect to a web or mobile application. LNC does not require the node to expose any ports. Instead, the application and the node are connected through a proxy server called the mailbox. The connection between node and application are end-to-end encrypted.

[Read more: Lightning Node Connect: Under the hood](lightning-node-connect.md)

## A smooth user experience <a href="#docs-internal-guid-d86359ec-7fff-ba4d-a9d1-c9400470faef" id="docs-internal-guid-d86359ec-7fff-ba4d-a9d1-c9400470faef"></a>

**1. User generates pairing phrase in their node**

The user may be behind a NAT or firewall and does not need to expose ports. They may specify limited conditions, such as ‘read-only’ or ‘administrator.’

It is also possible to select a custom mailbox. This will then also have to be specified in the application.

**2. User enters pairing phrase into the application they want to connect to and chooses a password**

A pairing phrase typically consists of 10 English words which can be copied, written or scanned via a QR code. The password is used to encrypt the connection details in the browser’s storage or the device

**3. A persistent connection is established directly between the node and the application**

All connections are end-to-end encrypted and the mailbox is unable to see the contents of the packages transmitted between node and application

**4. Subsequent connections require only the user’s password**

The long-term Diffie-Hellman key is decrypted using the password and a second handshake is used to reestablish and verify the connection

### Additional Features <a href="#docs-internal-guid-086a99ad-7fff-a86d-947c-8109829e674c" id="docs-internal-guid-086a99ad-7fff-a86d-947c-8109829e674c"></a>

Through Lightning Node Connect a user may access their node in addition to liquidity services like Loop and Pool.&#x20;

## Make use of LNC in your application

LNC works natively with WebAssembly applications (Wasm). To make use of LNC on the web, set up the open source NPM module [available here](https://github.com/lightninglabs/lnc-web) by configuring it with a pairing phrase (supplied by the user), a mailbox and your application’s Wasm binary.

{% embed url="https://www.youtube.com/watch?t=19376s&v=LlTCipHKTCs" %}
Watch: Introducing LNC-web
{% endembed %}

#### lnc-web

This package is right for you if you are developing a web application, such as WebAssembly. Your users will typically navigate to a website, where the lnc package and wasm are loaded into their browser. Have a look at [Lightning Terminal](https://github.com/lightninglabs/lightning-terminal) for references.

### Install NPM package <a href="#docs-internal-guid-22e5aa55-7fff-3732-e284-e9bdf1667134" id="docs-internal-guid-22e5aa55-7fff-3732-e284-e9bdf1667134"></a>

`npm install @lightninglabs/lnc-web`

### Import package

`import LNC from ‘@lightninglabs/lnc-web’`

### Best practices <a href="#docs-internal-guid-dc6638ee-7fff-b897-3785-effb281d0ec0" id="docs-internal-guid-dc6638ee-7fff-b897-3785-effb281d0ec0"></a>

The credentials, such as the long-term Diffie-Hellman keys should be encrypted at rest with a solid password of the user’s choosing.

## Demo application

The LNC-web demo React application can be quickly installed on your local machine using NPM. It lets you connect to your own node via Lightning Node Connect by providing only the Pairing Phrase from litd. The app shows you basic information obtained through the “getinfo” RPC call, showing alias, pubkey, active and inactive channels as well as synchronization status.

### Install the demo application <a href="#docs-internal-guid-c3c9467a-7fff-e67d-185a-12f3fe2961ed" id="docs-internal-guid-c3c9467a-7fff-e67d-185a-12f3fe2961ed"></a>

**1. We will fetch the lnc-web repository from github and navigate into the directory with the command:**

`git clone https://github.com/lightninglabs/lnc-web.git`

`cd lnc-web/demos/connect-demo`

**2. We will install the demo app with the command:**

`npm install`

**3. We can run the app now and navigate to it in our browser**

`npm start`

### Connect your node <a href="#docs-internal-guid-845c2f8c-7fff-21dc-e522-a48f2913e996" id="docs-internal-guid-845c2f8c-7fff-21dc-e522-a48f2913e996"></a>

To connect your node, your node needs to run LND and litd. You can [get litd](https://docs.lightning.engineering/lightning-network-tools/lightning-terminal/get-lit) from [source here](https://github.com/lightninglabs/lightning-terminal/releases), or install it using your Lightning software bundle of choice, for example Lightning Terminal in Umbrel.

1\. We will obtain the pairing phrase through litd. This can be done through the command line or the GUI

`litcli --lndtlscertpath ~/.lit/tls.cert sessions add --label="LNC Demo" --type admin`

![](<../../.gitbook/assets/Screenshot from 2022-06-14 12-59-06.png>)



1\. We will copy the pairing phrase and keep it ready for the next step

2\. Finally, we can connect the LNC Demo by opening the app in our browser at localhost:3000, click on the ‘Connect’ button at the top right and enter our pairing phrase. We will also have to specify a password.

![](<../../.gitbook/assets/image (1).png>)

4\. We can close this page and come back to it anytime. Our credentials are stored locally in encrypted form. Upon reconnection our password is used to decrypt our connection details and re-authenticate the session with litd on our node.

## Things to do: <a href="#docs-internal-guid-85ae9888-7fff-8f73-b16d-e75e375f089f" id="docs-internal-guid-85ae9888-7fff-8f73-b16d-e75e375f089f"></a>

* Check out the relevant code in the project’s [readme](https://github.com/lightninglabs/lnc-web/blob/main/demos/connect-demo/README.md)
* Enable LNC as a connection method in your app or wallet
