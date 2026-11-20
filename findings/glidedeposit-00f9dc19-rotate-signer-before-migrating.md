---
id: glidedeposit-00f9dc19-rotate-signer-before-migrating
title: "GlideDeposit: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x00f9dc19fae6c913cd60e215acaf39853d2dfb61"
  family: "feca8a6c7b6e84858287bfe5f3794828"
  copies: 51541
  name: "GlideDeposit"
  upgradeable: "no"
  rating: NONE
  value_usd: 45475
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 43283
  last_active: 2026-11-18
  recoveries_14d: 8282
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
  note: "A signer with code is handled through ERC-1271, so the claim does not hold."
---

## Summary

GlideDeposit clone (45-byte proxy to 0x7474bb06, 51,541 copies): call requests must be signed by allocator, checked with Solady SignatureCheckerLib.isValidSignatureNow, which falls back to ERC-1271 when ECDSA fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Glide deposit address: the call request must be signed by `allocator`, checked with SignatureChecker (ECDSA, then ERC-1271); the owner replaces it with setAllocator. Read from source.
- GlideDeposit.sol:84 allocator.isValidSignatureNow(eip712Hash, signature) (SignatureCheckerLib: ECDSA, then ERC-1271)
- GlideDeposit.sol:63 setAllocator onlyOwner also exists

## Impact and exposure

- Value held at block 26,438,999: $45,475 (ETH and 49 priced tokens, over 51,541 addresses).
- Activity: 43,283 transactions called it in the 90 days before that block; last on 2026-11-18.
- 8,282 signature recoveries in the study's two-week trace window.

## Remediation

None needed beyond the allocator account implementing ERC-1271 if it becomes a contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
