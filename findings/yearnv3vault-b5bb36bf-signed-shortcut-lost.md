---
id: yearnv3vault-b5bb36bf-signed-shortcut-lost
title: "YearnV3Vault: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb5bb36bf71edb4f5b5b3ab90ae0540944b8e6a7f"
  family: "c9674fb772bea4be499b9c1f7ec3f3fd"
  copies: 73
  name: "YearnV3Vault"
  label: "created by Yearn: VaultFactory (Ver 3.0.2)"
  upgradeable: "no"
  rating: LOW
  value_usd: 29775
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7555
  last_active: 2026-11-18
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $29775, txs_90d 7555."
---

## Summary

YearnV3Vault exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Yearn v3 vault permit (Vyper): ecrecover must equal the owner named. Read from source.
- YearnV3Vault: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: Yearn v3 vault permit (Vyper): ecrecover must equal the owner named)
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $29,775 (ETH and 49 priced tokens, over 73 addresses).
- Activity: 7,555 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
