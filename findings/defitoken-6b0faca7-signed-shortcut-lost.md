---
id: defitoken-6b0faca7-signed-shortcut-lost
title: "DeFiToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x6b0faca7ba905a86f221ceb5ca404f605e5b3131"
  family: "690ff6b56c7cfaa254da399335a854a6"
  name: "DeFiToken"
  label: "DeFi: DEFI Token"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1525
  last_active: 2026-11-18
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

DeFiToken: a signed shortcut (permit, delegateBySig) recovers the holder's key; under EIP-8151 a holder whose address has non-delegation code can no longer use it, while the same act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call / delegateBySig (OZ 4 ERC20Votes). Read from source. Executed: a real transaction loses its effect with code at the signer.
- Direct functions present in bytecode at block 26438999: approve (0x095ea7b3), transfer (0xa9059cbb), delegate (0x5c19a95c); each acts for msg.sender, so a holder with code calls them itself.
- Signed path(s) lost for a signer with code: permit, delegateBySig; study reading: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call / delegateBySig (OZ 4 ERC20Votes)
- Dossier ~/dev/pq-chain-analysis/goals/eip-8151-analysis/readings/690ff6b56c7cfaa254da399335a854a6 (source + scanner: STATICCALL to precompile 0x01 present).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,525 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Holder with code calls approve/transfer/delegate directly instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
