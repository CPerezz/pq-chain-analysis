---
id: archetype-2c20bae7-fixed-signer
title: "ArchetypeLogic: signer fixed in code"
project: archetype
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2c20bae74c8f16f5d393a9501449e9b4f9347083"
  family: "4782398d42f4b197f26045a2739891e4"
  copies: 68
  name: "ArchetypeLogic"
  upgradeable: "no"
  rating: LOW
  value_usd: 2648
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 266
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "none (mint without affiliate)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: the same mint stays open with no affiliate; only the referral shortcut dies."
---

## Summary

The same Archetype pattern as 0xfed1… (clone of impl 0x00b13579…022b, 'Lil Skribblers'): only affiliate mints need the fixed affiliateSigner 0x1f285dd5…9383. Plain mints, owner withdraw and affiliate balance withdraws need no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Archetype (older): affiliate signer of the fixed configuration. Read by hand.
- Update path, read at block 26,438,999: delegates to a fixed address.
- ArchetypeLogic.validateAffiliate runs only when affiliate != 0 (lines 177-181, 306-308)
- The impl 0x00b1… selector scan finds no affiliate-signer setter
- config() at 26438999: affiliateSigner 0x1f285dd5…, which has no code; owner 0x2Db5…4088

## Impact and exposure

- Value held at block 26,438,999: $2,648 (ETH and 49 priced tokens, over 68 addresses).
- Activity: 266 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
