---
id: uchilderc20-cf97bc85-signed-shortcut-lost
title: "UChildERC20: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcf97bc85b670494a47f99452228e2b5e501ab6bd"
  family: "2a4b92f98c482e00072a6441d4cbe929"
  copies: 7
  name: "UChildERC20"
  upgradeable: "no"
  rating: LOW
  value_usd: 47640
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 17
  last_active: 2026-11-11
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $47640, txs_90d 17."
---

## Summary

UChildERC20 exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: meta-transaction relay (NativeMetaTransaction): the user named in the call must have signed; the relayed functions are open to the user's own call. Read from source.
- UChildERC20: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: meta-transaction relay (NativeMetaTransaction): the user named in the call must have signed; the relayed functions are open to the user's own call)
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $47,640 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 17 transactions called it in the 90 days before that block; last on 2026-11-11.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
