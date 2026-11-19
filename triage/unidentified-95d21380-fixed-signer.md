---
id: unidentified-95d21380-fixed-signer
title: "Degens: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-95d21380
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8888888883585b9a8202db34d8b09d7252bfc61c"
  name: "Degens (study family 279c46a2)"
  upgradeable: "no"
  value_usd: 39700
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 279c46a2"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $40k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x8888888883585b9a8202db34d8b09d7252bfc61c` (Degens, family `279c46a2`, 1 address, $40k): Degens (sports betting): every order must recover to its maker (no ERC-1271), so a maker with code cannot have orders matched; withdrawals are direct. A match is graded by the graders committed in its matchId, each… Decided by: read.
