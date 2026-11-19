---
id: unidentified-2269bc4b-fixed-signer
title: "HolderOptimized: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-2269bc4b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8077c429401a25d6aa1029ee502ac0d0af3ff0f7"
  name: "HolderOptimized (study family 9b30fdf5)"
  upgradeable: "no"
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9b30fdf5"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $5k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x8077c429401a25d6aa1029ee502ac0d0af3ff0f7` (HolderOptimized, family `9b30fdf5`, 1 address, $5k): HolderOptimized: the only way to hand the holder over is setNewOwner, which needs a signature of the current owner: a rotation that needs the retiring key. Decided by: read.
