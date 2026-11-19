---
id: unidentified-b8679037-fixed-signer
title: "Unverified contract 0x4f3c3a…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-b8679037
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4f3c3a8c6777bdb879b92ea8eec2be9232e43ae7"
  name: "unverified code (study family d23dad95)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d23dad95"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x4f3c3a8c6777bdb879b92ea8eec2be9232e43ae7` (unverified, family `d23dad95`, 1 address, $0): a Cosmos-address airdrop (7 recoveries); inferred: claims carry a signature checked against a fixed party; no setter by name. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
