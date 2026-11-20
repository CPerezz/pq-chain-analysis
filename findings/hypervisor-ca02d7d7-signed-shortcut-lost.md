---
id: hypervisor-ca02d7d7-signed-shortcut-lost
title: "Hypervisor: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xca02d7d726eff80e391fa62ad65676b19e994c94"
  family: "ca32b0e783819b2f6a9a30ed7eca9f9f"
  copies: 13
  name: "Hypervisor"
  label: "Gamma : Vault  WBTC-renBTC-500"
  upgradeable: "no"
  rating: LOW
  value_usd: 16782
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $16782, txs_90d 0."
---

## Summary

Hypervisor exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.
- Hypervisor: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: permit: the owner named in the call must equal the recovered address; the holder can call approve itself)
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $16,782 (ETH and 49 priced tokens, over 13 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
