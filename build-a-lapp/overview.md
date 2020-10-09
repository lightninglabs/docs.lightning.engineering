# Overview

The goal of this guide is to get you familiar with adding payments functionality to your app using the lnd Lightning Network node software.

This application will be written in [Typescript](https://www.typescriptlang.org/) with a small amount of HTML+CSS. On the frontend we will use [ReactJS](https://reactjs.org/) to render the UI and [mobx](https://mobx.js.org/) for managing the application state. On the backend we will use [expressjs](https://expressjs.com/) to host our API server and serve the app's data to multiple web clients.

To easily create a local Lightning Network, which exists solely on your computer, we will be using the [Polar](https://lightningpolar.com/) development tool.

We'll be making use of the `lnd` gRPC [API](https://api.lightning.community/) to interface with the `lnd` node. A few of the API endpoints that we will be using throughout this application are:

| Endpoint | Description |
| ----------- | ----------- |
| getinfo | returns general information concerning the lightning node |
| channelbalance | returns the total funds available across all open channels in satoshis |
| signmessage | signs a message with this node's private key |
| verifymessage | verifies a signature of a message |
| addinvoice | creates a new invoice which can be used by another node to send a payment |
| lookupinvoice | look up an invoice according to its payment hash |

The sample app we'll be starting with is a basic Reddit clone with this small list of features:
- view a list of posts on the home page sorted by votes
- click on the Upvote button for a post should increment its number of votes
- create a post containing a username, title, and description

We'll add Lightning Network integration in this tutorial by implementing the following features:
- connect your node to the app by providing your node's host, certificate and macaroon
- display your node's alias and channel balance
- create posts and sign them using your lnd node's pubkey
- verify posts made by other users
- upvote a post by paying 100 satoshis per vote to the user that created the post

Note: **at no point in time will our app take possession of any user funds or have the power to send payments on the user’s behalf.** We will take advantage of `lnd`‘s granular macaroon permissions to only request access to perform the specific actions listed above. When payment is required, the payer will be prompted with an invoice, which is created by the node of the post’s author. When the invoice is paid, it is routed over the Lightning Network from the upvoter’s node to the post author’s node. Our application is not in the middle of the payment. Once the invoice is paid, the frontend will be notified and the upvote will be submitted to the backend.

Also please be aware that this is a **contrived *sample* application**. It is not a robust and secure app ready for production use. The primary objective was to keep the code as simple as possible while showcasing how to integrate Lightning Network features into an existing application with `lnd`. There are plenty of shortcuts taken to keep the codebase small and focused.
