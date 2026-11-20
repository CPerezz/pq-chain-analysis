---
id: mfpurrs-76089822-fixed-signer
title: "MFPurrs: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x76089822d5cac5f9971392360f343dae6a8724d5"
  family: "0d31c04fa5d61f7f9de8391586caf521"
  name: "MFPurrs"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1635
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "MFPurrs deployer (OWNER)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path. Only the signed mint dies; claimers hold nothing here. The held ETH cannot leave by any path even today, so EIP-8151 locks nothing new → MEDIUM."
---

## Summary

claimPurr accepts only an ECDSA signature by OWNER, which is set to msg.sender in the constructor and has no setter. If OWNER's address takes code, claims stop for good.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: MFPurrs: claim mints need a signature of OWNER, set in the constructor; nothing is held for claimers, so only the mint stops (MEDIUM: a core function, no funds locked). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- MFPurrs.sol: claimPurr requires ECDSA.recover(...) == OWNER; only the constructor writes OWNER
- slot 2 at block 26438999 = 0xacbde2489cc65a753e3b38dea50bf513f754a3a3, code 0x today (EOA)
- TOTAL_SUPPLY slot 0 = 9878 < MAX_SUPPLY 10000, so claims are still reachable
- no withdraw or ETH-moving function exists at all: the $1,635 is stuck today whatever EIP-8151 does

## Impact and exposure

- Value held at block 26,438,999: $1,635 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

OWNER signs claims only while it is an EOA; afterwards deploy a new claim contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
