---
id: c6b97436-rotate-signer-before-migrating
title: "0xc6b97436: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc6b9743624faa056edb7c57b35f2937155c0e425"
  family: "02bda5d1801842a909701ab1a5a3f7fd"
  copies: 8
  upgradeable: "yes"
  rating: NONE
  value_usd: 79401
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 11636
  last_active: 2026-11-18
  recoveries_14d: 3656
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
  note: "Code checks the owner's code first and falls back to ERC-1271, so an owner with code is handled. The row's 'executed revert' would hold only for an owner contract that does not implement ERC-1271."
---

## Summary

Catapultar 0.0.1 single-owner executor account (45-byte clone of 0x93ed9655…3bd); execute and isValidSignature check an EIP-712 signature of the stored owner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceOwnership, transferOwnership). Rule: stored-key (the owner). Executed: a real transaction reverts with code at the signer.
- reading.first.json: the ecrecover site at pc 0x0ec0 is reached only when the stored owner has no code; an owner with code is asked through ERC-1271
- implementation bytecode 0x93ed9655…3bd has EXTCODESIZE at pc 0xefb immediately before the 0x01 STATICCALL at pc 0xf42, plus a 0x1626ba7e (isValidSignature) call path
- owner (slot …74873927) = 0x223b8d08…b695, EOA nonce 0; transferOwnership (0xf2fde38b) is caller-gated, so LOW would hold anyway

## Impact and exposure

- Value held at block 26,438,999: $79,401 (ETH and 49 priced tokens, over 8 addresses).
- Activity: 11,636 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,656 signature recoveries in the study's two-week trace window.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
