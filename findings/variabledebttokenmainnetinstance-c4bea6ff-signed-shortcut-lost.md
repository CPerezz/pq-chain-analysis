---
id: variabledebttokenmainnetinstance-c4bea6ff-signed-shortcut-lost
title: "VariableDebtTokenMainnetInstanceGHO: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc4bea6ff17879e27f266909397e5e0ad3d301946"
  family: "57459c678fb91e7c6932ee366e3c118d"
  copies: 2
  name: "VariableDebtTokenMainnetInstanceGHO"
  label: "Aave: Ethereum Variable Debt GHO"
  upgradeable: "no"
  rating: LOW
  txs_90d: 15016
  last_active: 2026-11-18
  recoveries_14d: 30
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

VariableDebtTokenMainnetInstanceGHO: Aave debt token delegationWithSig needs the delegator's ECDSA signature; EIP-8151 fails it for a delegator with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Aave debt token delegationWithSig: the delegator named must have signed. Read from source. Executed: a real transaction reverts with code at the signer.
- DebtTokenBase.sol approveDelegation(delegatee, amount) external: the delegator calls it directly
- delegationWithSig is the signed shortcut for the same credit delegation
- row note: Aave debt token delegationWithSig: the delegator named must have signed. Read from source. Executed: a real transaction reverts with code at the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 15,016 transactions called it in the 90 days before that block; last on 2026-11-18.
- 30 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approveDelegation directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
