---
id: forth-77fba179-signed-shortcut-lost
title: "Forth: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x77fba179c79de5b7653f68b5039af940ada60ce0"
  family: "c93e7e2d0feb4a9f359e27f5f3e934de"
  name: "Forth"
  label: "Ampleforth Governance: FORTH Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 51971
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 22513
  last_active: 2026-11-18
  recoveries_14d: 3
fix:
  layer: offchain
  who_acts: "the holder"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $51971, txs_90d 22513."
---

## Summary

Forth exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / Compound delegateBySig (variant). Read from source. Executed: a real transaction reverts with code at the signer.
- Forth: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / Compound delegateBySig (variant))
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $51,971 (ETH and 49 priced tokens).
- Activity: 22,513 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
