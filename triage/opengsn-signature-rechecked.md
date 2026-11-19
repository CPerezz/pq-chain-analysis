---
id: opengsn-signature-rechecked
title: "RelayHub (3 copies): under EIP-8151 a signature others relied on fails once its signer has code"
project: opengsn
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xd216153c06e857cd7f72665e0af1d7d82172f494"
  name: "RelayHub (study family b356a050), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0xd216153c06e857cd7f72665e0af1d7d82172f494"
  name: "RelayHub (study family b356a050)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 18407
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b356a050"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 3 addresses, $18k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xd216153c06e857cd7f72665e0af1d7d82172f494` (RelayHub, family `b356a050`, 3 addresses, $18k): GSN v1 checkSig: true when the signer its caller names signed / GSN v1 canRelay: the `from` of the relayed call must have signed; a user can always call the recipient itself / GSN v1 penalizeRepeatedNonce: two… Decided by: read (function text).
