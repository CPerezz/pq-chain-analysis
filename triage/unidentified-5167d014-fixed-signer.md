---
id: unidentified-5167d014-fixed-signer
title: "3 contract families (3 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-5167d014
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x070e0603737242b01abc1d223f7c92d63e86ec97"
  name: "PriceFeed (study family abaa5193)"
  upgradeable: "no"
- address: "0x77e1684402869bf2b7c70b8bf21e1c7ca7104951"
  name: "SpotFeed (study family e99e561c)"
  upgradeable: "no"
- address: "0x014dabf6f940c9c383d9ef48636f70d842f65d7a"
  name: "NhiFeed (study family 85bd6605)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families abaa5193, e99e561c, 85bd6605"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 3 code families, 3 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x070e0603737242b01abc1d223f7c92d63e86ec97` (PriceFeed, family `abaa5193`, 1 address, $0): SwarmFeed: the attestation must be signed by `attester`, fixed in the code / SwarmFeed._recover: returns the signer. Decided by: read (function text). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
- `0x77e1684402869bf2b7c70b8bf21e1c7ca7104951` (SpotFeed, family `e99e561c`, 1 address, $0): SwarmFeed: the attestation must be signed by `attester`, fixed in the code / SwarmFeed._recover: returns the signer. Decided by: read (function text). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
- `0x014dabf6f940c9c383d9ef48636f70d842f65d7a` (NhiFeed, family `85bd6605`, 1 address, $0): SwarmFeed: the attestation must be signed by `attester`, fixed in the code / SwarmFeed._recover: returns the signer. Decided by: read (function text). Executed: a real transaction ends without error but with other logs when its signer has code: the failure is caught…
