---
id: unidentified-88516b29-signature-rechecked
title: "VirtualPaymentManager: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-88516b29
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x07bfa78d66d104fe9936201427400b0d78a2284c"
  name: "VirtualPaymentManager (study family 95f1dddb)"
  upgradeable: "no"
  value_usd: 13895
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 95f1dddb"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $14k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x07bfa78d66d104fe9936201427400b0d78a2284c` (VirtualPaymentManager, family `95f1dddb`, 1 address, $14k): Archanova verifyOwnerSignature: the signer must be an owner device of the account / Archanova virtual payment: the payment must be signed by a device of the paying account; the recipient withdraws with it from the… Decided by: read (function text).
