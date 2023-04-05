---
description: >-
  Understand how LND attempts routes through the Lightning Network and configure
  pathfinding to suit your needs.
---

# Pathfinding

Lightning Network payments may not succeed on the first attempt. LND will prioritize routes that have a good tradeoff between the highest probability of succeeding and the ones that pay the lowest fees. There are two distinct ways LND can calculate the probability of a channel being able to successfully forward the payment: _A priori_ and _Bimodal_.

## Mission Control <a href="#docs-internal-guid-96b072ec-7fff-f2ab-6d6f-4923ddd81fbc" id="docs-internal-guid-96b072ec-7fff-f2ab-6d6f-4923ddd81fbc"></a>

The core of LND’s pathfinding mechanism is mission control (mc). This is where data on past routing successes and failures is kept and configurations are set.

`lncli getmccfg`

`{`\
`"config": {`\
`     `~~`"half_life_seconds": "3600",`~~\
&#x20;    ~~`"hop_probability": 0.6,`~~\
&#x20;    ~~`"weight": 0.5,`~~\
`     `**`"maximum_payment_results": 1000,`**\
&#x20;    **`"minimum_failure_relax_interval": "60",`**\
&#x20;    `"Model": "APRIORI",`\
&#x20;    `"apriori": {`\
&#x20;        `"half_life_seconds": "3600",`\
&#x20;        `"hop_probability": 0.6,`\
&#x20;        `"weight": 0.5,`\
&#x20;        `"capacity_fraction": 0.9999`\
&#x20;    `}`\
`}`\
`}`

Note: Half life, hop probability and weight are deprecated and marked with ~~strikethrough~~ here, while payment results and the failure relax interval are most relevant to mission control.

Mission control keeps a record of node id pairs through which payments have been attempted. This allows the data to be useful for cases where nodes have multiple channels between each other. For each pair, it records the timestamp and amount of the last successful or failed payment attempted through this connection.

`lncli querymc`

&#x20;    {\
&#x20;        "node\_from": \
035e4ff418fc8b5554c5d9eea66396c227bd429a3251c8cbc711002ba215bfc226",\
&#x20;        "node\_to": 03676f530adb4df9f7f4981a8fb216571f2ce36c34cbefe77815c33d5aec4f2638",\
&#x20;        "history": {\
&#x20;            "fail\_time": "0",\
&#x20;            "fail\_amt\_sat": "0",\
&#x20;            "fail\_amt\_msat": "0",\
&#x20;            "success\_time": "1652150758",\
&#x20;            "success\_amt\_sat": "1211490",\
&#x20;            "success\_amt\_msat": "1211490000"\
&#x20;        }\
&#x20;    }

LND makes a tradeoff between likelihood that a route succeeds, and the cost of sending through that route. This trade-off can be tuned by the attempt cost proportionality factors and is expressed in terms of fees. Only the most recent payment is considered for the probability metric.

Cost = base\_fee + fee\_rate \* amt + (attemptcost + attemptcostppm \* amt) / P

The higher the attempt costs factors are chosen, the more we favor routes that we know will succeed (they have a lower virtual cost), but at higher fees compared to untried channels. To only optimize for cheapest fees for example, one would need to set the attempt costs to zero. There are two distinct ways on how to calculate the probability: A priori and Bimodal.

You can adjust the cost parameters yourself:

`routerrpc.attemptcost=100`\
`routerrpc.attemptcostppm=1000`

## A Priori estimator <a href="#docs-internal-guid-8f12c930-7fff-eef3-b64e-912845921926" id="docs-internal-guid-8f12c930-7fff-eef3-b64e-912845921926"></a>

A priori, meaning “from the previous,” is the original metric used to determine the probability of a successful payment through a given route.

It carries the assumption that each hop has a base success likelihood of 60% (this is adjustable via routerrpc.apriori.hopprob and represents a default value). If a previous payment through a hop was successful, then any new and smaller payment is expected to succeed with 95%.

If a previous payment was unsuccessful, then any payment larger is considered to be impossible to route through this hop as well. As a payment size approaches the capacity of a channel, the probability with which it is expected to succeed also diminishes.

Over time, the failure probabilities will converge back to 60% as the balance is expected to change over time. Channels are assumed to keep a high success probability until proven otherwise.

Previous attempts for a node are also used to calculate a reputational score that extends the a priori probability. This score can then be used to focus on channels of well-managed routing nodes under the assumption that its other channels are similarly liquid as those for which their reliability is known.

## Bimodal estimator <a href="#docs-internal-guid-d4234be7-7fff-4a09-fdbb-2c7e451ed1db" id="docs-internal-guid-d4234be7-7fff-4a09-fdbb-2c7e451ed1db"></a>

The bimodal estimator is experimental and available to LND users starting from version 0.16. Note that the bimodal estimator is considered experimental.

It makes an assumption about how balances are distributed among Lightning channels. The bimodal estimator assumes that most channels are skewed, meaning the liquidity in them has flowed to either of two sides. The mathematical framework is based on [research led by Rene Pickhardt](https://arxiv.org/abs/2103.08576).

In the absence of historical data, or where historical data is outdated, the bimodal estimator will assign a high chance of success to payments with low amounts (relative to a configurable scale), \~50% of success for payments of medium size, and low to zero chance of success as the payment size approaches the capacity of a payment.

To calculate the chance of success of a payment in cases where some data is available, the bimodal estimator will use mission control to look at whether a previous payment was successful or not. If it was unsuccessful, future payments are also expected to be unsuccessful unless they are very small compared to the total channel capacity.

If a previous payment was successful, any future payment routed through this hop is expected with certainty unless they exceed the total channel capacity. The bimodal estimator is also able to estimate a probability for a previous success and failure.

## Switch between A priori and Bimodal estimators <a href="#docs-internal-guid-fac9a1ff-7fff-9f3c-3938-3bf936c2ab0c" id="docs-internal-guid-fac9a1ff-7fff-9f3c-3938-3bf936c2ab0c"></a>

To enable or specify an estimator, you can either edit your lnd.conf file, or interact with LND over RPC or LNCLI.

**lnd.conf**

`routerrpc.estimator=[apriori|bimodal]`

[**RPC**](https://lightning.engineering/api-docs/api/lnd/router/get-mission-control-config#routerrpcmissioncontrolconfigprobabilitymodel)

`routerrpc.MissionControlConfig.ProbabilityModel`

**LNCLI**

`lncli setmccfg --estimator apriori`\
`lncli setmccfg --estimator bimodal`

## Comparing estimators <a href="#docs-internal-guid-b8538924-7fff-3522-b8a8-8c678c946e2e" id="docs-internal-guid-b8538924-7fff-3522-b8a8-8c678c946e2e"></a>

It may be difficult to directly compare both pathfinding models without resorting to highly controlled simulations that may not correctly reflect the reality of the network. The state of the Lightning Network changes with every successful payment, and so will your mission control.

A priori and bimodal estimators use different base probabilities, which result in different fee-probability tradeoffs. In practice, bimodal payments are expected to be more likely to succeed, but at [higher fees](https://github.com/lightningnetwork/lnd/issues/7559).
