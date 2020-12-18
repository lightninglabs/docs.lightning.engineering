# Wrap Up

Hopefully, this tutorial has taught you the basics of how to integrate Lightning features into an existing application. You’ve only scratched the surface on what’s possible. 

To take the next step, you should familiarize yourself with [Lightning Service Authentication Tokens \(LSATs\)](https://lsat.tech). Future additions to the guide will focus heavily on these. Additional resources include our [Developer Slack](https://lightning.engineering/slack.html), [Github organization](https://github.com/lightninglabs), and API documentation for [`lnd`](https://api.lightning.community/), [`loop`](https://lightning.engineering/loopapi/), and [`pool`](https://lightning.engineering/poolapi/). 

If you’d like to extend this example app to add more features, here are some ideas to explore:

* Use a hodl invoice to ensure that the payment isn’t settled until the upvote is completed on the backend successfully.
* Use keysend to make the payment instead of creating an invoice first.
* Add support for webln + Joule to avoid showing the payment request modal.
* Only notify the sender and receiver of paid invoices, instead of all connected browsers
* Prevent multiple upvotes being submitted for a single payment hash

