---
id: unidentified-5ef9585e-fixed-signer
title: "8 contract families (476 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-5ef9585e
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6e653024fe23e4a7f2a1c8e14c388f71dd44668f"
  name: "unverified code (study family dd3f0ebb), 1 of 204 addresses running it"
  upgradeable: "no"
- address: "0xb5bdde8f6072e48d0eae9944342552c85da314ae"
  name: "unverified code (study family 62976f20), 1 of 91 addresses running it"
  upgradeable: "no"
- address: "0xc807beca85f2bcdf292336c929ed6ea3829ae687"
  name: "unverified code (study family 14908bd7), 1 of 31 addresses running it"
  upgradeable: "no"
- address: "0xf9f4ba80606cd2ac0ceb16d47fdacb9843ce6ff5"
  name: "unverified code (study family 3df2bfd6), 1 of 47 addresses running it"
  upgradeable: "no"
- address: "0xbe95329b0882b2a6e95a0092483a131d63c9de18"
  name: "unverified code (study family 5339ac41), 1 of 20 addresses running it"
  upgradeable: "no"
- address: "0xb7f56b1b16f33610aad3f2591aa2f80f20590d62"
  name: "unverified code (study family 155e1666), 1 of 12 addresses running it"
  upgradeable: "no"
- address: "0x4826f615cdd26999d45b5f02c1be2ebff67ae57f"
  name: "unverified code (study family e3740397), 1 of 58 addresses running it"
  upgradeable: "no"
- address: "0xb77ccaad4c9b80b8464ef46a6a794a56a77cd830"
  name: "unverified code (study family a808d4cd), 1 of 13 addresses running it"
  upgradeable: "no"
families:
- code: "0x6e653024fe23e4a7f2a1c8e14c388f71dd44668f"
  name: "unverified code (study family dd3f0ebb)"
  instances: 204
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 133537
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb5bdde8f6072e48d0eae9944342552c85da314ae"
  name: "unverified code (study family 62976f20)"
  instances: 91
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 74528
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xc807beca85f2bcdf292336c929ed6ea3829ae687"
  name: "unverified code (study family 14908bd7)"
  instances: 31
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 40242
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xf9f4ba80606cd2ac0ceb16d47fdacb9843ce6ff5"
  name: "unverified code (study family 3df2bfd6)"
  instances: 47
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 12993
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbe95329b0882b2a6e95a0092483a131d63c9de18"
  name: "unverified code (study family 5339ac41)"
  instances: 20
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 12632
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb7f56b1b16f33610aad3f2591aa2f80f20590d62"
  name: "unverified code (study family 155e1666)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 6316
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4826f615cdd26999d45b5f02c1be2ebff67ae57f"
  name: "unverified code (study family e3740397)"
  instances: 58
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb77ccaad4c9b80b8464ef46a6a794a56a77cd830"
  name: "unverified code (study family a808d4cd)"
  instances: 13
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families dd3f0ebb, 62976f20, 14908bd7, 3df2bfd6, 5339ac41, 155e1666, e3740397, a808d4cd"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 8 code families, 476 addresses, $287k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x6e653024fe23e4a7f2a1c8e14c388f71dd44668f` (unverified, family `dd3f0ebb`, 204 addresses, $134k): 204 clones holding 74 ETH: a signer that is a constant in the code, next to a signer named in the call. Decided by: bytecode and names (no source).
- `0xb5bdde8f6072e48d0eae9944342552c85da314ae` (unverified, family `62976f20`, 91 addresses, $75k): 91 clones holding 41 ETH: a signer that is a constant in the code. Decided by: bytecode and names (no source).
- `0xc807beca85f2bcdf292336c929ed6ea3829ae687` (unverified, family `14908bd7`, 31 addresses, $40k): 31 clones holding 22 ETH: a signer that is a constant in the code. Decided by: bytecode and names (no source).
- `0xf9f4ba80606cd2ac0ceb16d47fdacb9843ce6ff5` (unverified, family `3df2bfd6`, 47 addresses, $13k): 47 clones: a signer that is a constant in the code. Decided by: bytecode and names (no source).
- `0xbe95329b0882b2a6e95a0092483a131d63c9de18` (unverified, family `5339ac41`, 20 addresses, $13k): 20 clones: a signer that is a constant in the code. Decided by: bytecode and names (no source).
- `0xb7f56b1b16f33610aad3f2591aa2f80f20590d62` (unverified, family `155e1666`, 12 addresses, $6k): 12 clones: a signer that is a constant in the code. Decided by: bytecode and names (no source).
- `0x4826f615cdd26999d45b5f02c1be2ebff67ae57f` (unverified, family `e3740397`, 58 addresses, $4k): 58 clones: a signer that is a constant in the code. Decided by: bytecode and names (no source).
- `0xb77ccaad4c9b80b8464ef46a6a794a56a77cd830` (unverified, family `a808d4cd`, 13 addresses, $3k): 13 clones: a signer that is a constant in the code. Decided by: bytecode and names (no source).
