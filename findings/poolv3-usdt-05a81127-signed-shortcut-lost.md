---
id: poolv3-usdt-05a81127-signed-shortcut-lost
title: "PoolV3_USDT: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x05a811275fe9b4de503b3311f51edf6a856d936e"
  family: "a7ea9dc98575ebc35a72961301cdbafa"
  copies: 2
  name: "PoolV3_USDT"
  upgradeable: "no"
  rating: LOW
  value_usd: 16421
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-11-05
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $16421, txs_90d 4."
---

## Summary

PoolV3_USDT exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- PoolV3_USDT: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call)
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $16,421 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-05.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
