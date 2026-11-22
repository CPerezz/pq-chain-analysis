---
id: apebond-b781595b-rotate-signer-before-migrating
title: "ApeBond: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb781595ba4dd7ae937a7b7890fae10662be653ee"
  family: "62e00230ce3b42556e4e898725306094"
  copies: 14
  name: "ApeBond"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1093
  last_active: 2026-11-18
  recoveries_14d: 39
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x76E0…2AbF or OPERATIONS_ROLE"
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
  verdict: confirmed
  rating: LOW
  note: "Live Safe owner can replace the signer."
---

## Summary

ApeBond (EIP-1167 clone of 0x57ee…a090): tier-access and tier-discount proofs are ECDSA-signed by a stored authorizedSigner. If it gets code, tier purchases revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- source TierProof.sol:75-77 ecrecover == authorizedSigner; ApeBond inherits TierAccessExtension and TierBoostedDiscountExtension
- TierAccessExtension.sol:78 setTierAccessExtensionData(..., _authorizedSigner, ...) onlyOwnerOrRole(OPERATIONS_ROLE); same for setTierBoostedDiscountExtensionData
- owner at block 26438999 = 0x76E01075…2AbF, Safe 3-of-6 (probed); code is a minimal proxy, not upgradeable

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 14 addresses).
- Activity: 1,093 transactions called it in the 90 days before that block; last on 2026-11-18.
- 39 signature recoveries in the study's two-week trace window.

## Remediation

Owner Safe calls the setters with a new authorizedSigner before the old one migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
