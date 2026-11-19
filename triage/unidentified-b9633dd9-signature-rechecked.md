---
id: unidentified-b9633dd9-signature-rechecked
title: "TokenNetwork: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-b9633dd9
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xa5c9ecf54790334b73e5dfa1ff5668eb425dc474"
  name: "TokenNetwork (study family 5f8034f7)"
  upgradeable: "no"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5f8034f7"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $4k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xa5c9ecf54790334b73e5dfa1ff5668eb425dc474` (TokenNetwork, family `5f8034f7`, 1 address, $4k): Raiden ECVerify: returns the signer, zero rejected / Raiden closeChannel: the closing party presents the partner's signed balance proof / Raiden updateNonClosingBalanceProof: balance proofs signed by both channel… Decided by: read (function text).
