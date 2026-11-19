---
id: unidentified-26fe53b4-fixed-signer
title: "BlockATMEthPayoutV2 (3 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-26fe53b4
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xcd08d8e570378ddb48dd5f7a5a0b702ddaa7e248"
  name: "BlockATMEthPayoutV2 (study family adfd1a78), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0xcd08d8e570378ddb48dd5f7a5a0b702ddaa7e248"
  name: "BlockATMEthPayoutV2 (study family adfd1a78)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 44934
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families adfd1a78"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $45k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xcd08d8e570378ddb48dd5f7a5a0b702ddaa7e248` (BlockATMEthPayoutV2, family `adfd1a78`, 3 addresses, $45k): BlockATM payout: a proxy payout needs a signature that recovers to an address of financeMap; the map is filled only at construction (processList) and has no add or remove, so the finance set is fixed. Finance addresses… Decided by: read. Executed: a real transaction reverts when its signer has code.
