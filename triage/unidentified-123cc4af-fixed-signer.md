---
id: unidentified-123cc4af-fixed-signer
title: "RedStonePullOracle (2 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-123cc4af
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x470139efeee7c481d08eb0898af87ee9a8b0a0ea"
  name: "RedStonePullOracle (study family 703ac7e9), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x470139efeee7c481d08eb0898af87ee9a8b0a0ea"
  name: "RedStonePullOracle (study family 703ac7e9)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 703ac7e9"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x470139efeee7c481d08eb0898af87ee9a8b0a0ea` (RedStonePullOracle, family `703ac7e9`, 2 addresses, $0): RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed / Tokemak AutopoolToken permit: ECDSA.recover must… Decided by: read (function text).
