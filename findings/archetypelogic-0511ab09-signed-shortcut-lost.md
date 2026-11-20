---
id: archetypelogic-0511ab09-signed-shortcut-lost
title: "ArchetypeLogic: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x0511ab0979b10fb40ee32a97140182727f06c643"
  family: "53bfe340bdc71fee1db7a27743c05a4a"
  copies: 67
  name: "ArchetypeLogic"
  upgradeable: "no"
  rating: LOW
  value_usd: 178
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5668
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "minters (mint without an affiliate)"
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

Archetype NFT (EIP-1167 clone): mints with an affiliate need a voucher signed by config.affiliateSigner; if that signer has code, affiliate mints fail.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Archetype validateAffiliate: mints with an affiliate need the affiliate signer's voucher; mints without an affiliate need none. Read.
- ArchetypeLogic.validateAffiliate: ECDSA.recover == config.affiliateSigner, no ERC-1271 (dossier source)
- mint without an affiliate needs no signature (ArchetypeLogic line 221: validation only on the affiliate path)

## Impact and exposure

- Value held at block 26,438,999: $178 (ETH and 49 priced tokens, over 67 addresses).
- Activity: 5,668 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

the affected party uses the direct call instead of the signed path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
