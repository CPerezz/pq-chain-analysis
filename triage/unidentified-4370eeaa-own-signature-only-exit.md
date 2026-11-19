---
id: unidentified-4370eeaa-own-signature-only-exit
title: "ZecSwap: under EIP-8151 a party whose account has code can no longer act on its funds"
project: unidentified-4370eeaa
status: candidate
severity: CRITICAL
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xeb3a00bcb6c9ff626fe57a5dbbdcf01730e7898f"
  name: "ZecSwap (study family d805e954)"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d805e954"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract lets a party act on its funds or rights only with its own ECDSA signature. 1 code family, 1 address, $180 held. To settle the rating: is a direct way out missing for every party.

## Evidence

- `0xeb3a00bcb6c9ff626fe57a5dbbdcf01730e7898f` (ZecSwap, family `d805e954`, 1 address, $180): ZecSwap: user and maker authorise steps with ECDSA only (ecrecover == signer, no ERC-1271). A swap that pays into a shielded note can be paid only through payout, which needs the user's signature even when the user… Decided by: read. Executed: a real transaction reverts when its signer has code.
