---
id: b8e82dd6-signed-shortcut-lost
title: "0xb8e82dd6: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb8e82dd64aedec7e92750de5a6dc7ae224418b78"
  family: "88cc8f1e2de22673462729a55fd87c6e"
  copies: 154
  upgradeable: "yes"
  rating: LOW
  txs_90d: 3372
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "the shed owner (user)"
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
  note: "pre-sign by direct call covers the same act → LOW. Decompiled bytecode, no verified source"
---

## Summary

COWShed hook executor proxy (154 copies): executeHooks runs calls on a user-signed message; with code at the user the signature path fails.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: 154 hook executors (COWShed pattern by names). Bytecode and names.
- implementation 0xf0d40008…7cffb selectors: preSignHooks, executePreSignedHooks, trustedExecuteHooks, revokeNonce, updateImplementation, isValidSignature
- preSignHooks/revokeNonce/setPreSignStorage are gated to the shed admin (decompiled: msg.sender check), so the owner can pre-sign the same hooks by direct call and anyone executes them without ecrecover
- proxy upgradeable by the shed owner via updateImplementation

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 154 addresses).
- Activity: 3,372 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

owner pre-signs hooks onchain (preSignHooks) instead of an off-chain signature

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
