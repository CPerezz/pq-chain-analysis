---
id: unidentified-420fda2c-wallet-fixed-signers
title: "Mintpass: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-420fda2c
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x116fe2334fca73afee28c71f68b3ee6b679858b2"
  name: "Mintpass (study family c1fe78de)"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c1fe78de"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 1 address, $2k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x116fe2334fca73afee28c71f68b3ee6b679858b2` (Mintpass, family `c1fe78de`, 1 address, $2k): Mintpass: signed by MSO_SIGNER_WALLET, fixed in the code. Decided by: read (function text).
