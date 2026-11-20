---
id: aavetokenv3-d72e94e1-signed-shortcut-lost
title: "AaveTokenV3: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd72e94e13e4208ec878e35b19012ffa8f4bb6061"
  family: "9c13eaed7eb02260be64f044e6aa57bb"
  copies: 6
  name: "AaveTokenV3"
  label: "Aave: AAVE Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 11008
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 585339
  last_active: 2026-11-18
  recoveries_14d: 517
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
  note: "Direct twins exist (standard EIP-2612 / Compound-style delegation). Value $11008, txs_90d 585339 (not rating inputs)."
---

## Summary

AaveTokenV3: permit/delegateBySig-style signed shortcuts (ECDSA must equal the named owner/delegator). A holder with code still calls approve and delegate itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / metaDelegateByType: the delegator named must equal the recovered address; it can call…. Read from source. Executed: a real transaction reverts with code at the signer.
- source (9c13eaed7eb02260be64f044e6aa57bb): signed functions [permit]; direct approve and delegate(address) present
- no ERC-1271 fallback in the signed path

## Impact and exposure

- Value held at block 26,438,999: $11,008 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 585,339 transactions called it in the 90 days before that block; last on 2026-11-18.
- 517 signature recoveries in the study's two-week trace window.

## Remediation

Call approve / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
