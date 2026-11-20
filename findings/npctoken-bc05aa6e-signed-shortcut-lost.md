---
id: npctoken-bc05aa6e-signed-shortcut-lost
title: "NPCToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xbc05aa6ec416684555a97d9a1d9e1eaf3a7ccc63"
  family: "2ca88cd9420d74d92c736c5d1afd6f68"
  copies: 67
  name: "NPCToken"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1705
  last_active: 2026-11-16
  recoveries_14d: 1
fix:
  layer: offchain
  who_acts: "the affected holder (calls the direct function itself)"
evidence:
  level: bytecode
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
  note: "Direct path exists for the same party (msg.sender-based approve/transfer/delegate); only a way of signing is lost, so LOW."
---

## Summary

NPCToken: a signed shortcut (permit) recovers the holder's key; under EIP-8151 a holder whose address has non-delegation code can no longer use it, while the same act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction loses its effect with code at the signer.
- Direct functions present in bytecode at block 26438999: approve (0x095ea7b3), transfer (0xa9059cbb); each acts for msg.sender, so a holder with code calls them itself.
- Signed path(s) lost for a signer with code: permit; study reading: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call
- Dossier ~/dev/pq-chain-analysis/goals/eip-8151-analysis/readings/2ca88cd9420d74d92c736c5d1afd6f68 (source + scanner: STATICCALL to precompile 0x01 present).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 67 addresses).
- Activity: 1,705 transactions called it in the 90 days before that block; last on 2026-11-16.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Holder with code calls approve/transfer/delegate directly instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
