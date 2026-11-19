---
id: unidentified-dead652e-fixed-signer
title: "2 contract families (10 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-dead652e
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb748a1e81033a1c7e6dbbdb421bf8867f73fcbec"
  name: "unverified code (study family d46ae549), 1 of 4 addresses running it, 2 by 7702 delegation"
  upgradeable: "no"
- address: "0xbc376f8d9ec9a5ebe24bbd2b48a9ff98847965fd"
  name: "unverified code (study family 3d80697e), 1 of 6 addresses running it, 2 by 7702 delegation"
  upgradeable: "no"
families:
- code: "0xb748a1e81033a1c7e6dbbdb421bf8867f73fcbec"
  name: "unverified code (study family d46ae549)"
  instances: 4
  list: "every address running this code at block 26,438,999 (2 by 7702 delegation)"
  upgradeable: "no"
- code: "0xbc376f8d9ec9a5ebe24bbd2b48a9ff98847965fd"
  name: "unverified code (study family 3d80697e)"
  instances: 6
  list: "every address running this code at block 26,438,999 (2 by 7702 delegation)"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d46ae549, 3d80697e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 2 code families, 10 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb748a1e81033a1c7e6dbbdb421bf8867f73fcbec` (unverified, family `d46ae549`, 4 addresses, $0): forwarding addresses (4) whose sweeps need a fixed party's signature; inferred. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
- `0xbc376f8d9ec9a5ebe24bbd2b48a9ff98847965fd` (unverified, family `3d80697e`, 6 addresses, $0): small sweep contracts (6); inferred: withdrawals signed by a fixed party. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code, before any recovery returned nothing: the code changed…
