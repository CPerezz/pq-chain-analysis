---
id: pocketdragonscollection-49a102a0-rotate-signer-before-migrating
title: "PocketDragonsCollection: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x49a102a0c04723739f601c158b5d13920ab59d4d"
  family: "9e18e28f183998f05e47d8bed583f2be"
  name: "PocketDragonsCollection"
  upgradeable: "no"
  rating: NONE
  value_usd: 31038
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 368
  last_active: 2026-11-18
  recoveries_14d: 334
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
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
  note: "a signer with code goes through ERC-1271 (the replay failed only because the injected code had no 1271); setSigners onlyGovernance also exists."
---

## Summary

PocketDragonsCollection: presale/reward signatures use OZ SignatureChecker.isValidSignatureNow on stored signers.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source. Executed: a real transaction reverts with code at the signer.
- PocketDragonsCollection.sol:462,667 SignatureChecker.isValidSignatureNow
- OZ SignatureChecker:33-38 code.length==0 → ECDSA, else ERC-1271

## Impact and exposure

- Value held at block 26,438,999: $31,038 (ETH and 49 priced tokens).
- Activity: 368 transactions called it in the 90 days before that block; last on 2026-11-18.
- 334 signature recoveries in the study's two-week trace window.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
