---
id: 980df04b-rotate-signer-before-migrating
title: "0x980df04b: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x980df04b4e8c40bc728198f998459700d97f083b"
  family: "e510516c791a394704b7733b86b0d0df"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 2062
  last_active: 2026-11-17
  recoveries_14d: 71
fix:
  layer: onchain-config
  who_acts: "owner Safe 0xb8A6…deb0"
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
  note: "Setter exists and the owner Safe is live, so LOW holds. The decompile shows an enum-state check (store_b<=2) on adding; I did not fully resolve it. Update: the state value is 0 against a limit of 2 and the delay is 0 at the block, so owner Safe 0xb8A6…deb0 can call addVerifyingSigner now."
---

## Summary

An ERC-1271 validator: isValidSignature accepts signatures from a stored set of verifying signers. A signer whose account holds code stops validating.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addVerifyingSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- addVerifyingSigner(address) (0x451263f4) requires msg.sender == owner (OZ error 0x118cdaa7) and block.timestamp >= a delay getter (0xfb5f3ef1, which reads 0 at the block, so no wait now); the VerifyingSignerRemoved event shows a remove path
- owner() = Safe 0xb8A6…deb0, 2-of-3, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,062 transactions called it in the 90 days before that block; last on 2026-11-17.
- 71 signature recoveries in the study's two-week trace window.

## Remediation

The owner Safe adds a new EOA verifying signer and removes the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
