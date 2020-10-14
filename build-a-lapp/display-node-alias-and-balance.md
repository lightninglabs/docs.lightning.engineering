# Feature 2 - Display Node Alias and Balance

The goal of this feature is pretty straight-forward. When a user connects their node to the site, we want them to be able to see their alias and channel balance, so that it is clear to them how much funds they have available to pay for upvotes.

To implement this feature, we first updated the backend to make this data available from our API. Then we updated the frontend to fetch this info from the backend.

Let’s go to the `feat-2` branch to see what’s changed.

```
git checkout feat-2
```

## Added API endpoint to return node alias and channel balance

To update our backend, we’ll need to add a new route to handle requests to fetch the node’s info.

`source: /backend/routes.ts`

```
/**
* GET /api/info
*/
export const getInfo = async (req: Request, res: Response) => {
 const { token } = req.body;
 if (!token) throw new Error('Your node is not connected!');
 // find the node that's making the request
 const node = db.getNodeByToken(token);
 if (!node) throw new Error('Node not found with this token');
 
 // get the node's pubkey and alias
 const rpc = nodeManager.getRpc(node.token);
 const { alias, identityPubkey: pubkey } = await rpc.getInfo();
 const { balance } = await rpc.channelBalance();
 res.send({ alias, balance, pubkey });
};
```

In the **routes.ts** file, we added a new route handler function `getInfo()` which receives the user’s token, and first validates that it is valid. Then it uses the `NodeManager` class to get the RPC connection to the `lnd` node. With the rpc, we can not make two calls to lnd to fetch the alias and pubkey from getInfo() and the balance from channelBalance(). Finally, we return this data to the client.

source: /backend/index.ts
app.get('/api/info', catchAsyncErrors(routes.getInfo));

We updated the backend entrypoint file to instruct express to use the getInfo() route handler for GET requests to /api/info.


