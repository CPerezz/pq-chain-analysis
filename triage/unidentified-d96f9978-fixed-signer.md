---
id: unidentified-d96f9978-fixed-signer
title: "CrossL2ProverV2 (2 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-d96f9978
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x95cceae71605c5d97a0ac0ea13013b058729d075"
  name: "CrossL2ProverV2 (study family eec603a3), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x95cceae71605c5d97a0ac0ea13013b058729d075"
  name: "CrossL2ProverV2 (study family eec603a3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families eec603a3"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x95cceae71605c5d97a0ac0ea13013b058729d075` (CrossL2ProverV2, family `eec603a3`, 2 addresses, $0): Polymer CrossL2ProverV2: the signer must be SEQUENCER, fixed in the code. Decided by: read (function text).
