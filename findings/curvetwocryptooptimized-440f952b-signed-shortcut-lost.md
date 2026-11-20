---
id: curvetwocryptooptimized-440f952b-signed-shortcut-lost
title: "CurveTwocryptoOptimized: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x440f952bc4aea933113817b79f8c746fb0a38b34"
  family: "93c78b912dbd9f4da8687679b78675b1"
  name: "CurveTwocryptoOptimized"
  label: "deployed by Prospective LLC: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 28151
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 887
  last_active: 2026-11-17
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $28151, txs_90d 887."
---

## Summary

CurveTwocryptoOptimized exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Vyper permit (Curve pools): ecrecover must equal _owner, which may not be zero. Read from source.
- CurveTwocryptoOptimized: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: Vyper permit (Curve pools): ecrecover must equal _owner, which may not be zero)
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $28,151 (ETH and 49 priced tokens).
- Activity: 887 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
