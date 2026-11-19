---
id: unidentified-399efa78-fixed-signer
title: "3 contract families (4 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-399efa78
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x509ae18c9b6e58598768b3bddeae2ad915e55f20"
  name: "DynamicRoute (study family 1244851b), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x73b920dc64ab6156f2d22b85ab9a9b06e597e154"
  name: "PMMProtocol (study family 0376819b)"
  upgradeable: "no"
- address: "0x4ecd468e1010e006f768ec034e5a6d8803183469"
  name: "PMMAdapter (study family 2c7a3f1a)"
  upgradeable: "no"
families:
- code: "0x509ae18c9b6e58598768b3bddeae2ad915e55f20"
  name: "DynamicRoute (study family 1244851b)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1244851b, 0376819b, 2c7a3f1a"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 3 code families, 4 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x509ae18c9b6e58598768b3bddeae2ad915e55f20` (DynamicRoute, family `1244851b`, 2 addresses, $0): CallerAuth: the signer must be AUTH_SIGNER, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
- `0x73b920dc64ab6156f2d22b85ab9a9b06e597e154` (PMMProtocol, family `0376819b`, 1 address, $0): PMMProtocol RFQ fill: the maker named in the order is checked by ERC-1271 (flagged) or by ECDSA with ERC-1271 as fallback; the caller authorisation is CallerAuth / CallerAuth: the signer must be AUTH_SIGNER, fixed in… Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
- `0x4ecd468e1010e006f768ec034e5a6d8803183469` (PMMAdapter, family `2c7a3f1a`, 1 address, $0): CallerAuth: the signer must be AUTH_SIGNER, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
