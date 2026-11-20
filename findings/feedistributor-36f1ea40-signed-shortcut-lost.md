---
id: feedistributor-36f1ea40-signed-shortcut-lost
title: "FeeDistributor: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x36f1ea408451fe291117770e788061d49c66893e"
  family: "38eab0cbc7ecc9e460599393aa779c4e"
  copies: 2
  name: "FeeDistributor"
  upgradeable: "no"
  rating: LOW
  value_usd: 12812
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 24
  last_active: 2026-11-16
fix:
  layer: offchain
  who_acts: "user with code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Direct twin exists. Value $12812, txs_90d 24 (not rating inputs)."
---

## Summary

Balancer-style FeeDistributor (with solmate ERC20 in its bundle): setOnlyCallerCheckWithSignature uses an EOA-only validator. A user with code sets the flag by a direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here / Balancer EOASignaturesValidator: the account named must have signed (ECDSA…. Read from source.
- source src/lib/OptionalOnlyCaller.sol: setOnlyCallerCheck(bool) → _setOnlyCallerCheck(msg.sender, …)
- src/lib/EOASignaturesValidator.sol: ecrecover only, no ERC-1271

## Impact and exposure

- Value held at block 26,438,999: $12,812 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 24 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

Call setOnlyCallerCheck directly (and approve for permit).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
