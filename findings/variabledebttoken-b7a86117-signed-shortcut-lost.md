---
id: variabledebttoken-b7a86117-signed-shortcut-lost
title: "VariableDebtToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb7a86117426c342ca355162c6bd80d234bd5bd7a"
  family: "70e9fee6c3247e8fd6ab88f4e215fab5"
  copies: 223
  name: "VariableDebtToken"
  label: "created by Spark: Pool Configurator"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 26016
  last_active: 2026-11-18
  recoveries_14d: 1
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

VariableDebtToken: Aave debt token delegationWithSig needs the delegator's ECDSA signature; EIP-8151 fails it for a delegator with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Aave v2 debt token delegationWithSig: the delegator named must have signed. Read from source.
- DebtTokenBase.sol approveDelegation(delegatee, amount) external: the delegator calls it directly
- delegationWithSig is the signed shortcut for the same credit delegation
- row note: Aave v2 debt token delegationWithSig: the delegator named must have signed. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 223 addresses).
- Activity: 26,016 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approveDelegation directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
