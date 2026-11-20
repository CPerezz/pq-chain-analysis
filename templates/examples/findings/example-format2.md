---
id: example-format2
format: 2
title: An example exchange trusts signed orders to move deposits
status: confirmed
severity: HIGH
justification: Deposits can be taken with a forged signature, and nobody can change the contract.
category: quantum-exposure
pattern: PQ-4
study: example-study
as_of: 2026-11-18
block: 26438999
contract:
  address: "0x5555555555555555555555555555555555555555"
  name: ExampleExchange
  project: example-project
  label:
  code: verified
  code_url: https://etherscan.io/address/0x5555555555555555555555555555555555555555#code
  proxy_of:
  copies: 1
  family:
  upgradeable: "no"
  admin: none
value:
  usd: 1000
  whose: users
  basis: held
activity:
  txs_90d: 12
  last: 2026-11-17
impact: funds-loss
action: Ask depositors to withdraw; the contract cannot be changed.
evidence_level: source
sources:
- study: example-study
  who: someone
  date: 2026-11-18
  by: other
  verdict: reported
reviews: []
related: []
---

## What happens

The exchange fills an order when one operator key signs it. Someone who forges that key can sign orders that move
any deposit.

## Evidence

- `fill()` in the [verified source](https://etherscan.io/address/0x5555555555555555555555555555555555555555#code)
  accepts an order when the recovered signer is the operator.

## Reviewer notes

### Mechanism

`fill()` recovers the order's signer and compares it with the stored operator; no other path fills an order.

### Checks

- Code and state read at the block above; no proxy, no upgrade function.

### History

- 2026-11-18: filed from study example-study.
