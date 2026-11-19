---
id: unidentified-f09899ab-signature-rechecked
title: "Vault (18 copies): under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-f09899ab
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x13166407e8738cc6f25844d11c4a431777ac99c9"
  name: "Vault (study family ec3bbcc8), 1 of 18 addresses running it"
  upgradeable: "no"
families:
- code: "0x13166407e8738cc6f25844d11c4a431777ac99c9"
  name: "Vault (study family ec3bbcc8)"
  instances: 18
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ec3bbcc8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 18 addresses, $180 held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x13166407e8738cc6f25844d11c4a431777ac99c9` (Vault, family `ec3bbcc8`, 18 addresses, $180): per-trade Vault (18 clones): settlement pays out only with a presign of coreAddrs[1] and an MPC signature of coreAddrs[0], both fixed in the vault; after the timeout anyone can send the amount to coreAddrs[3]. If the… Decided by: read.
