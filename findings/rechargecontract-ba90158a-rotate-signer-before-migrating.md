---
id: rechargecontract-ba90158a-rotate-signer-before-migrating
title: "RechargeContract: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xba90158ab116ed37ab0c32128b2809d9b6388013"
  family: "2a030947bb74a53176f5e9efe0a6dce5"
  copies: 2
  name: "RechargeContract"
  upgradeable: "yes"
  rating: NONE
  value_usd: 20752
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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
  note: "Refuted, because the signer path accepts ERC-1271. owner() reads 0 (renounced), so a signer whose new code lacks 1271 could not be rotated."
---

## Summary

RechargeContract withdraw needs two signatures, from signer1 and signer2, checked with OZ SignatureCheckerUpgradeable.isValidSignatureNow.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: two signatures, one from each of two stored signers (SignatureChecker). Read from source.
- RechargeUpgradeable.sol:87-88 SignatureCheckerUpgradeable.isValidSignatureNow(signerN, …)
- OZ 4.5 SignatureChecker falls back to ERC-1271 isValidSignature when ECDSA recovery fails or does not match

## Impact and exposure

- Value held at block 26,438,999: $20,752 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed if a signer's code implements ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
