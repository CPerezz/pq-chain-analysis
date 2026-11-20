---
id: stabledebttoken-b80af100-signed-shortcut-lost
title: "StableDebtToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb80af10082c304ea2f0591647a532fb94f6d8842"
  family: "388deafd397575f4575a24bbd21f55ae"
  copies: 256
  name: "StableDebtToken"
  label: "created by Aave: Pool Configurator V3"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 27009
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the affected holder, by calling approveDelegation itself"
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
  note: "LOW: same act open by approveDelegation to the same party; only a signing convenience is lost."
---

## Summary

StableDebtToken: Aave debt token delegationWithSig needs the delegator's ECDSA signature; EIP-8151 fails it for a delegator with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Aave v2 debt token delegationWithSig: the delegator named must have signed. Read from source.
- DebtTokenBase.sol approveDelegation(delegatee, amount) external: the delegator calls it directly
- delegationWithSig is the signed shortcut for the same credit delegation
- row note: Aave v2 debt token delegationWithSig: the delegator named must have signed. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 256 addresses).
- Activity: 27,009 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approveDelegation directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
