---
id: cellarwithoraclewithbalancerflas-c47bb288-signed-shortcut-lost
title: "CellarWithOracleWithBalancerFlashLoansWithMultiAssetDepositWithNativeSupport: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc47bb288178ea40bf520a91826a3dee9e0dbfa4c"
  family: "12548c87fb47e68d4ddb0aefeeb6e17c"
  copies: 9
  name: "CellarWithOracleWithBalancerFlashLoansWithMultiAssetDepositWithNativeSupport"
  upgradeable: "no"
  rating: LOW
  value_usd: 22196
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-10-31
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $22196, txs_90d 3."
---

## Summary

CellarWithOracleWithBalancerFlashLoansWithMultiAssetDepositWithNativeSupport exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read from source.
- CellarWithOracleWithBalancerFlashLoansWithMultiAssetDepositWithNativeSupport: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here)
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $22,196 (ETH and 49 priced tokens, over 9 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-31.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
