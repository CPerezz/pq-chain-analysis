---
id: unidentified-a1be220e-fixed-signer
title: "EthereumMergedAdapterWithRoundsEurspkccNavV1 (6 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-a1be220e
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x14449cc3185dec0421c3cb37074215f1aacb97f9"
  name: "EthereumMergedAdapterWithRoundsEurspkccNavV1 (study family 566ee547), 1 of 6 addresses running it"
  upgradeable: "no"
families:
- code: "0x14449cc3185dec0421c3cb37074215f1aacb97f9"
  name: "EthereumMergedAdapterWithRoundsEurspkccNavV1 (study family 566ee547)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 566ee547"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 6 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x14449cc3185dec0421c3cb37074215f1aacb97f9` (EthereumMergedAdapterWithRoundsEurspkccNavV1, family `566ee547`, 6 addresses, $0): RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
