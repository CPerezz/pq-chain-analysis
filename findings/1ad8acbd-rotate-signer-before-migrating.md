---
id: 1ad8acbd-rotate-signer-before-migrating
title: "0x1ad8acbd: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1ad8acbdb3670c72645b54a7df55dcf70bce057a"
  family: "4d0fff0649f73993f30624f130e1a9e9"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1186
  last_active: 2026-11-18
  recoveries_14d: 588
fix:
  layer: onchain-config
  who_acts: "the current signer set (4 EOAs) by joint signature"
evidence:
  level: bytecode
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
  verdict: confirmed
  rating: LOW
  note: "The key holders themselves can rotate → LOW. Timing matters: rotation must happen before migration."
---

## Summary

Multi-signer verifier (verify(bytes32,bytes32,bytes[]), setSigners(address[],uint256,bytes[]), getSigners). It is static-called by delegate 0xa0bb1ebf…; every stored signer must sign. A signer with code breaks all verifications.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (SET_SIGNERS_TYPEHASH, setSigners). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- Decompiled setSigners: deadline check, at least 2 new signers, a signature count equal to the current signer count, ECDSA for each ('Verifier: invalid signatures'). The current signers rotate themselves.
- getSigners at 26438999: 0x11D5bBc2…, 0x24a996EE…, 0x8a0D488f…, 0xCD1b6756…, all EOAs (no code, nonce 0).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,186 transactions called it in the 90 days before that block; last on 2026-11-18.
- 588 signature recoveries in the study's two-week trace window.

## Remediation

All current signers sign setSigners with a fresh set before any of them takes code. Once one has code, rotation is impossible.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
