---
id: 7a37037c-rotate-signer-before-migrating
title: "0x7a37037c: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7a37037c085584ee7dad50cd6a4ade1181c65b3b"
  family: "0a213e84a40d619ff2b4c0ee4f044926"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 3209
  last_active: 2026-11-17
  recoveries_14d: 1232
fix:
  layer: none
  who_acts: "none"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted on the dossier's bytecode finding of an ERC-1271 fall-through. The study's 'loses its effect' replay used code without 1271. I did not re-decompile this myself."
---

## Summary

Coinflow-like credits contract (unverified), used through proxy 0x853f2c11774bb08031e7dea93803569bbe2058f8. Operator, admin and wallet EIP-712 signatures are checked by ECDSA first and then fall through to ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (changeAuthSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction loses its effect with code at the signer.
- Dossier reading.first.json (bytecode listing): the tryRecover helper at pc 0x4f55; the caller compares the result with the expected signer and otherwise tries ERC-1271.
- Row address is an implementation (slot_0=0xff, DOMAIN_SEPARATOR 0); window traces show a DELEGATECALL from proxy 0x853f2c11… (~160 recoveries in 12k blocks).
- Row note names changeAuthSigner as the stored-signer setter.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3,209 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1,232 signature recoveries in the study's two-week trace window.

## Remediation

None if the signer's new code implements ERC-1271; otherwise rotate with changeAuthSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
