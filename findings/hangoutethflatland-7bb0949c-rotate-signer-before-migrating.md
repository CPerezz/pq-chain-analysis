---
id: hangoutethflatland-7bb0949c-rotate-signer-before-migrating
title: "HangOutETHFlatland: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7bb0949ce7d3dee05b08ce182ee69c134b904433"
  family: "5f11075b7786824103751f9309a85d1d"
  copies: 2
  name: "HangOutETHFlatland"
  label: "HangOut Ethereum Flatland: HOETHFLAND Token"
  upgradeable: "no"
  rating: NONE
  value_usd: 16241
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25
  last_active: 2026-10-12
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
  note: "ERC-1271 fallback handles a signer with code."
---

## Summary

HangOutETHFlatland verifies with OZ SignatureChecker.isValidSignatureNow(signer, …), which falls back to ERC-1271 for a signer with code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source.
- HangOutETHFlatland.sol:1903: SignatureChecker.isValidSignatureNow(signer, digest, signature)
- SignatureChecker v4.5 (lines 1505-1518) tries ECDSA, then IERC1271.isValidSignature
- setSigner onlyOwner (line 1694); owner 0x882f7d71…: EOA, nonce 27

## Impact and exposure

- Value held at block 26,438,999: $16,241 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 25 transactions called it in the 90 days before that block; last on 2026-10-12.

## Remediation

None needed; a migrated signer that implements ERC-1271 keeps working (or the owner calls setSigner).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
