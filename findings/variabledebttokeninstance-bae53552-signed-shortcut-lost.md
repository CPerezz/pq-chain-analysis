---
id: variabledebttokeninstance-bae53552-signed-shortcut-lost
title: "VariableDebtTokenInstance: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xbae535520abd9f8c85e58929e0006a2c8b372f74"
  family: "a630078ea4e1cbe9b977fb1a8262cd0b"
  copies: 35
  name: "VariableDebtTokenInstance"
  label: "Aave: Ethereum Variable Debt AAVE"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 406995
  last_active: 2026-11-18
  recoveries_14d: 1017
fix:
  layer: offchain
  who_acts: "the credit delegator (calls approveDelegation)"
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
  note: "signed shortcut lost, same act open by a direct call to the same party → LOW."
---

## Summary

Aave v3 VariableDebtToken: delegationWithSig needs ECDSA.recover == delegator; a delegator with code cannot delegate credit by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Aave debt token delegationWithSig: the delegator named must have signed. Read from source. Executed: a real transaction reverts with code at the signer.
- DebtTokenBase.delegationWithSig: require(delegator == ECDSA.recover(...)) (dossier source)
- approveDelegation 0xc04a8a10 present in implementation 0xb27c…e330: the delegator can call it directly

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 35 addresses).
- Activity: 406,995 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,017 signature recoveries in the study's two-week trace window.

## Remediation

the affected party uses the direct call instead of the signed path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
