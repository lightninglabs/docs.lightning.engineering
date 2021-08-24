---
description: >-
  In the Lightning Network, payments pass from node to node through payment
  channels. These routing nodes earn fees for this service.
---

# Routing

The Lightning Network is a network of payment channels, each secured on the Bitcoin Blockchain with [2-of-2 multisignature addresses](../payment-channels/). These payment channels connect two parties and allow them to update their channel balances in tiny increments as frequently as they need.

To allow a large number of participants to transact through payment channels, transactions need to be sent through a large network of these channels. Each participant between a payer and a payee is considered a router. Ideally, there are many possible routes between any two network participants, though they might differ in length, fee and reliability.

These routing nodes need to fulfill their role in passing on payments from their peers. Routing nodes require specific hardware, skills, and capital, and thus, they are rewarded for their efforts and investment with routing fees.

