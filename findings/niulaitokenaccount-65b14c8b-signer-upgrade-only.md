---
id: niulaitokenaccount-65b14c8b-signer-upgrade-only
title: "NiuLaiTokenAccount: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x65b14c8be72df29d8d093ada87f9467daa1d5113"
  family: "41c779b6f80da312ae12b9a6a2b396b1"
  name: "NiuLaiTokenAccount"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1
  last_active: 2026-08-21
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "accepts ERC-1271 for the expected signer"
---

## Summary

NiuLaiTokenAccount (Solady ERC6551) implementation: the signer is checked with SignatureChecker or Solady SignatureCheckerLib, which falls back to that same signer's ERC-1271 once it has code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Solady account ERC-1271: SignatureCheckerLib on the account's signer. Read (function text).
- Update path, read at block 26,438,999: upgradeToAndCall(address,bytes), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- The signature check goes through SignatureChecker(Lib).isValidSignatureNow(signer, …), with an ERC-1271 fallback on the signer (dossier source)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-08-21.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
