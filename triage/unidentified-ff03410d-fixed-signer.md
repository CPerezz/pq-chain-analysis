---
id: unidentified-ff03410d-fixed-signer
title: "2 contract families (2 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-ff03410d
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe33ab493249a2df0d8c4a71ac54f46d1f7778367"
  name: "HamsterHour (study family a0e2759b)"
  upgradeable: "no"
- address: "0x83fcaef2230ec6f36d84717c2222817431e9b377"
  name: "unverified code (study family de4f706d)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a0e2759b, de4f706d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 2 code families, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xe33ab493249a2df0d8c4a71ac54f46d1f7778367` (HamsterHour, family `a0e2759b`, 1 address, $0): HamsterHour: the result must be signed by ATTESTER, fixed in the code. Decided by: read (function text). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
- `0x83fcaef2230ec6f36d84717c2222817431e9b377` (unverified, family `de4f706d`, 1 address, $0): attestations signed by an oracle signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
