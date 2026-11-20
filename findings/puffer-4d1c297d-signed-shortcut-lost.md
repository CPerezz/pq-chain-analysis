---
id: puffer-4d1c297d-signed-shortcut-lost
title: "PUFFER: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x4d1c297d39c5c1277964d0e3f8aa901493664530"
  family: "7e3aa9a02dc402890d2e00ee5bd96b9e"
  name: "PUFFER"
  label: "Puffer Finance: PUFFER Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 58930
  last_active: 2026-11-18
  recoveries_14d: 6
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
  note: "Direct twins exist (standard EIP-2612 / Compound-style delegation). Value $2526, txs_90d 58930 (not rating inputs)."
---

## Summary

PUFFER: permit/delegateBySig-style signed shortcuts (ECDSA must equal the named owner/delegator). A holder with code still calls approve and delegate itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (OZ 5 Votes): whoever signed is the account that delegates / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at the signer.
- source (7e3aa9a02dc402890d2e00ee5bd96b9e): signed functions [delegateBySig,permit]; direct approve and delegate(address) present
- no ERC-1271 fallback in the signed path

## Impact and exposure

- Value held at block 26,438,999: $2,526 (ETH and 49 priced tokens).
- Activity: 58,930 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Call approve / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
