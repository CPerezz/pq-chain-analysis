---
id: uni-448a9c8a-signed-shortcut-lost
title: "Uni: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x448a9c8a25dc1ec8af43c351bdd0919acbc5be7e"
  family: "d927799d742eda92c4d62ff1373d5ce2"
  copies: 7
  name: "Uni"
  label: "Uniswap Protocol: UNI Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 448975
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1042809
  last_active: 2026-11-18
  recoveries_14d: 76
fix:
  layer: account-migration
  who_acts: "the token holder"
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
  note: "Standard signed shortcut; same act open by direct call → LOW."
---

## Summary

Uni (Uniswap Protocol: UNI Token): a signed shortcut (permit/authorization) requires the recovered address to equal the named owner; EIP-8151 makes it fail for an owner whose address holds non-delegation code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / Compound delegateBySig (variant). Read from source. Executed: a real transaction reverts with code at the signer.
- the dossier source has the standard approve (and transfer) the holder calls directly
- code at block has approve selector 0x095ea7b3 or source defines approve; no signature needed
- study note: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / Compound delegateBySig (variant). Read from source. Executed: a real tran

## Impact and exposure

- Value held at block 26,438,999: $448,975 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 1,042,809 transactions called it in the 90 days before that block; last on 2026-11-18.
- 76 signature recoveries in the study's two-week trace window.

## Remediation

Holder calls approve (or the direct function) itself instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
