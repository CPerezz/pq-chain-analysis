---
id: dexbluesettlementmodule-00000000-signed-shortcut-lost
title: "dexBlueSettlementModule: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x000000000000541e251335090ac5b47176af4f7e"
  family: "955f52416e5620de3d9ba64d6b15991e, 5f1e19fa2926116305eaa1656b9b06cd"
  copies: 2
  name: "dexBlueSettlementModule"
  label: "dex.blue"
  upgradeable: "no"
  rating: LOW
  value_usd: 24181
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-28
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $24181, txs_90d 1."
---

## Summary

dexBlueSettlementModule exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a settlement module of dexBlue: orders are signed by the trader or its delegate; an account can also withdraw alone after a waiting period (read in the dexBlue exchange contract). Read by hand.
- dexBlueSettlementModule: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: a settlement module of dexBlue: orders are signed by the trader or its delegate; an account can also withdraw alone after a waiting period (read in the dexBlue exchange contract))
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $24,181 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-28.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
