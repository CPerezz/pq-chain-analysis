---
id: unidentified-fcbd1802-fixed-gas-recovery
title: "OraclizeRng: under EIP-8151 every valid signature fails on activation day"
project: unidentified-fcbd1802
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x814a3bd43973ef7740934cef3aaf16b81bf43995"
  name: "OraclizeRng (study family b1938396)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b1938396"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x814a3bd43973ef7740934cef3aaf16b81bf43995` (OraclizeRng, family `b1938396`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
