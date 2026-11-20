---
id: stakedfrax-03cb4438-signed-shortcut-lost
title: "StakedFrax: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x03cb4438d015b9646d666316b617a694410c216d"
  family: "aaa3e817c2c75ac10e3d6519c9853d54"
  name: "StakedFrax"
  upgradeable: "no"
  rating: LOW
  value_usd: 28693
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $28693, txs_90d 0."
---

## Summary

StakedFrax exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read from source.
- StakedFrax: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here)
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $28,693 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
