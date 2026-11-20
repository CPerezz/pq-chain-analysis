---
id: escrowfactoryv7-7f1d0b26-rotate-signer-before-migrating
title: "EscrowFactoryV7: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7f1d0b26ed27c64a458b7ef3aaa46c81caa62cc6"
  family: "ef6437f01860377f3cc0b81a5fb57936"
  name: "EscrowFactoryV7"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2726
  last_active: 2026-11-12
  recoveries_14d: 2193
fix:
  layer: onchain-config
  who_acts: "owner 0x78155140 (EOA, nonce 11)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The owner is a live EOA, and the approver-set setter is reachable with a 48h delay."
---

## Summary

EscrowFactoryV7. Escrow actions need approvalsRequired (3) distinct signatures from approvers in a stored set. Under EIP-8151 an approver whose key has code is rejected, so the approval gate cannot be met with that key.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (approver, oracle, attester or author) and distinct; enough of them are needed / returns the recovered address, or whether it equals an…. Read from source. Executed: a real transaction reverts with code at the signer.
- ApproverRegistry.sol:134-152 ecrecover, then isApprover[signer]
- FactoryGovernance.sol: removeApprover (immediate) and scheduleApprovers (48h) are onlyOwner; executeApprovers is permissionless after GOVERNANCE_DELAY
- owner()=0x78155140 EOA nonce 11; approvalsRequired=3 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,726 transactions called it in the 90 days before that block; last on 2026-11-12.
- 2,193 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls scheduleApprovers with fresh EOA approvers; anyone calls executeApprovers after 48h.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
