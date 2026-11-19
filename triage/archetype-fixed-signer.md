---
id: archetype-fixed-signer
title: "4 contract families (1,047 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: archetype
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x47c6ac05cf695748e02a7a2685a0b3801dceb57a"
  name: "ArchetypeLogic (study family 95ca9b27), 1 of 621 addresses running it"
  upgradeable: "no"
- address: "0x13b58991ded462090229427ecbbb7e7f99571a6d"
  name: "ArchetypeLogic (study family bcb4c5f0), 1 of 346 addresses running it"
  upgradeable: "no"
- address: "0xfed18c828277e3bd8610f9bae432e65a651706f7"
  name: "ArchetypeLogic (study family 3ef19333), 1 of 12 addresses running it"
  upgradeable: "no"
- address: "0x2c20bae74c8f16f5d393a9501449e9b4f9347083"
  name: "ArchetypeLogic (study family 4782398d), 1 of 68 addresses running it"
  upgradeable: "no"
families:
- code: "0x47c6ac05cf695748e02a7a2685a0b3801dceb57a"
  name: "ArchetypeLogic (study family 95ca9b27)"
  instances: 621
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 21294
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x13b58991ded462090229427ecbbb7e7f99571a6d"
  name: "ArchetypeLogic (study family bcb4c5f0)"
  instances: 346
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 20752
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xfed18c828277e3bd8610f9bae432e65a651706f7"
  name: "ArchetypeLogic (study family 3ef19333)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3248
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x2c20bae74c8f16f5d393a9501449e9b4f9347083"
  name: "ArchetypeLogic (study family 4782398d)"
  instances: 68
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 95ca9b27, bcb4c5f0, 3ef19333, 4782398d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 4 code families, 1,047 addresses, $48k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x47c6ac05cf695748e02a7a2685a0b3801dceb57a` (ArchetypeLogic, family `95ca9b27`, 621 addresses, $21k): Archetype (older): affiliate signer of the collection's fixed configuration; it only decides affiliate fees. Decided by: read.
- `0x13b58991ded462090229427ecbbb7e7f99571a6d` (ArchetypeLogic, family `bcb4c5f0`, 346 addresses, $21k): Archetype (older): as above. Decided by: read.
- `0xfed18c828277e3bd8610f9bae432e65a651706f7` (ArchetypeLogic, family `3ef19333`, 12 addresses, $3k): Archetype (older): affiliate signer of the fixed configuration. Decided by: read.
- `0x2c20bae74c8f16f5d393a9501449e9b4f9347083` (ArchetypeLogic, family `4782398d`, 68 addresses, $3k): Archetype (older): affiliate signer of the fixed configuration. Decided by: read.
