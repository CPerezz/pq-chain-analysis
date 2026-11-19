---
id: unidentified-ca707dfb-fixed-signer
title: "BridgeMinterTL: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-ca707dfb
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd8878a2ec434d1661940d4b2591b03cbef486ca8"
  name: "BridgeMinterTL (study family 8a84620c)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 8a84620c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xd8878a2ec434d1661940d4b2591b03cbef486ca8` (BridgeMinterTL, family `8a84620c`, 1 address, $0): BridgeMinter: bridge() needs the signatures of `approver` and of `notary`, two addresses in storage that no function of the contract can change / BridgeMinter.recoverSigner: returns the signer / BridgeMinter.tryRecover:… Decided by: read (function text).
