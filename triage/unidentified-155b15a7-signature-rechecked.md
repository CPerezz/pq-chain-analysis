---
id: unidentified-155b15a7-signature-rechecked
title: "TransactionManager: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-155b15a7
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x31efc4aeaa7c39e54a33fdc3c46ee2bd70ae0a09"
  name: "TransactionManager (study family 3d46cadf)"
  upgradeable: "no"
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 3d46cadf"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 1 address, $5k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x31efc4aeaa7c39e54a33fdc3c46ee2bd70ae0a09` (TransactionManager, family `3d46cadf`, 1 address, $5k): Connext NXTP fulfill: on the sending chain the router takes the user's locked funds by presenting the user's signature; on the receiving chain the same signature releases the router's funds to the user / Connext NXTP… Decided by: read (function text).
