---
id: zksync-signer-upgrade-only
title: "2 contract families (4 addresses): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: zksync
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xabea9132b05a70803a4e85094fd0e1800777fbef"
  name: "ZkSync (study family 6d8cc566), 1 of 3 addresses running it"
  upgradeable: "yes"
- address: "0x8e972b354e6933275513c355ee14d44a832ad2d9"
  name: "ZkSync (study family cfbfb417)"
  upgradeable: "yes"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
families:
- code: "0xabea9132b05a70803a4e85094fd0e1800777fbef"
  name: "ZkSync (study family 6d8cc566)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 23279
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6d8cc566, cfbfb417"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 2 code families, 4 addresses, $26k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xabea9132b05a70803a4e85094fd0e1800777fbef` (ZkSync, family `6d8cc566`, 3 addresses, $23k): zkSync Lite cutUpgradeNoticePeriodBySignature: members of the security council, a list fixed in the code, approve by signature; a member can also approve by its own call / zkSync Lite registerNFTFactoryCreator: the… Decided by: read (function text).
- `0x8e972b354e6933275513c355ee14d44a832ad2d9` (ZkSync, family `cfbfb417`, 1 address, $3k): zkSync Lite cutUpgradeNoticePeriodBySignature: members of the security council, a list fixed in the code, approve by signature; a member can also approve by its own call / zkSync Lite registerNFTFactoryCreator: the… Decided by: read (function text).
