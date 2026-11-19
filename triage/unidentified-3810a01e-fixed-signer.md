---
id: unidentified-3810a01e-fixed-signer
title: "2 contract families (3 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-3810a01e
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc6df985b9a20bc7e645c1abc847f732e53d6e815"
  name: "TapEthHTLC (study family fcdbcc1e)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xccb376a78e1c563be01659f8597390d9e89f94fb"
  name: "unverified code (study family 398e53d1), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0xccb376a78e1c563be01659f8597390d9e89f94fb"
  name: "unverified code (study family 398e53d1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fcdbcc1e, 398e53d1"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 2 code families, 3 addresses, $180 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc6df985b9a20bc7e645c1abc847f732e53d6e815` (TapEthHTLC, family `fcdbcc1e`, 1 address, $180): swaps created by signature of the maker named: code first, then ERC-1271 (read); certificates of its escrow must be signed by a stored operator with no setter name. Decided by: read. Executed: a real transaction reverts when its signer has code, before any recovery returned nothing: the code changed…
- `0xccb376a78e1c563be01659f8597390d9e89f94fb` (unverified, family `398e53d1`, 2 addresses, $0): claims checked against an operator that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
