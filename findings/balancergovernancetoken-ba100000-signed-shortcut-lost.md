---
id: balancergovernancetoken-ba100000-signed-shortcut-lost
title: "BalancerGovernanceToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xba100000625a3754423978a60c9317c58a424e3d"
  family: "f3a98732be38268fd10125c96d29b2f9"
  name: "BalancerGovernanceToken"
  label: "Balancer: BAL Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 6677
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 17144
  last_active: 2026-11-18
  recoveries_14d: 5
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
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
  note: "Permit has a direct twin. Value $6677, txs_90d 17144 (not rating inputs)."
---

## Summary

BalancerGovernanceToken: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit or an approval by signature: the owner named in the call must equal the recovered address; the holder can call approve itself / returns the recovered signer to permit, which compares it with…. Read from source. Executed: a real transaction reverts with code at the signer.
- source (f3a98732be38268fd10125c96d29b2f9): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $6,677 (ETH and 49 priced tokens).
- Activity: 17,144 transactions called it in the 90 days before that block; last on 2026-11-18.
- 5 signature recoveries in the study's two-week trace window.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
