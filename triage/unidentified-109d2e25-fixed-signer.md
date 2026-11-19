---
id: unidentified-109d2e25-fixed-signer
title: "ArchetypeLogicErc721a (511 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-109d2e25
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x9743fa6fce7e50e182951dcfdac65c9d95494f97"
  name: "ArchetypeLogicErc721a (study family b05115a9), 1 of 511 addresses running it"
  upgradeable: "no"
families:
- code: "0x9743fa6fce7e50e182951dcfdac65c9d95494f97"
  name: "ArchetypeLogicErc721a (study family b05115a9)"
  instances: 511
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b05115a9"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 511 addresses, $5k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x9743fa6fce7e50e182951dcfdac65c9d95494f97` (ArchetypeLogicErc721a, family `b05115a9`, 511 addresses, $5k): Archetype (older): the affiliate signature must come from the affiliate signer of the collection's fixed configuration; it only decides affiliate fees. Decided by: read.
