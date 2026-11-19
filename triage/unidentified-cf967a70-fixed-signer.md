---
id: unidentified-cf967a70-fixed-signer
title: "MintRich20NFTContract (25 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-cf967a70
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0c0c75cc2e7a157ed22232044a4007fac8070fc3"
  name: "MintRich20NFTContract (study family f156689a), 1 of 25 addresses running it"
  upgradeable: "no"
families:
- code: "0x0c0c75cc2e7a157ed22232044a4007fac8070fc3"
  name: "MintRich20NFTContract (study family f156689a)"
  instances: 25
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f156689a"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 25 addresses, $5k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x0c0c75cc2e7a157ed22232044a4007fac8070fc3` (MintRich20NFTContract, family `f156689a`, 25 addresses, $5k): MintRich: rewards claims are signed by a signer the scanner sees as a constant; plus a permit. Decided by: read.
