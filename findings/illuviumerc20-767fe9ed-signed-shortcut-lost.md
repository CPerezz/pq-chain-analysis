---
id: illuviumerc20-767fe9ed-signed-shortcut-lost
title: "IlluviumERC20: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x767fe9edc9e0df98e07454847909b5e959d7ca0e"
  family: "0b3aab64e5a4daa7434e709759d208b1"
  name: "IlluviumERC20"
  label: "Illuvium: ILV Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 38854
  last_active: 2026-11-18
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
  note: "Direct twins exist (standard EIP-2612 / Compound-style delegation). Value $3068, txs_90d 38854 (not rating inputs)."
---

## Summary

IlluviumERC20: permit/delegateBySig-style signed shortcuts (ECDSA must equal the named owner/delegator). A holder with code still calls approve and delegate itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegation by signature: whoever signed is the delegator; a holder can call delegate itself. Read from source.
- source (0b3aab64e5a4daa7434e709759d208b1): signed functions [delegateWithSig]; direct approve and delegate(address) present
- no ERC-1271 fallback in the signed path

## Impact and exposure

- Value held at block 26,438,999: $3,068 (ETH and 49 priced tokens).
- Activity: 38,854 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
