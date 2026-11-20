---
id: ecdsarewards-c5ac5a88-signature-rechecked
title: "ECDSARewards: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xc5ac5a8892230e0a3e1c473881a2de7353ffca88"
  family: "817f8ad3f9c0f54e51f3f181129a1327"
  name: "ECDSARewards"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "No signature check in this contract"
---

## Summary

ECDSARewards (Keep reward distribution) does not call ecrecover; ecrecover appears only in AbstractBondedECDSAKeep.sol, a separate contract present in the verified bundle. The flag matched on a word.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Keep ManagedGrant.recoverStake: no signature (matched on a word) / Keep TokenGrant.recoverStake: no signature / Keep TokenGrantStake.recoverStake: no signature / Keep BondedECDSAKeep submitSignature:…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ecrecover only in source/solidity/contracts/AbstractBondedECDSAKeep.sol L242,529; ECDSARewards imports BondedECDSAKeep only as an external interface
- ECDSARewards inherits keep-core Rewards; no signature verification in its functions
- EIP-1967 slots zero at 26438999; txs_90d 0, last_active null (measured)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
