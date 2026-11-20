---
id: rewards-086b9734-rotate-signer-before-migrating
title: "Rewards: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x086b9734d33783bbe4fbc8249df4c686aae27054"
  family: "deae066672bdf829873b54643e8fc36a"
  name: "Rewards"
  label: "Tokemak: AccToke Rewards"
  upgradeable: "no"
  rating: LOW
  value_usd: 43851
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-11-16
  recoveries_14d: 1
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x90b6c61b (5 of 11)"
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
  note: "Setter exists and the owner is a working Safe."
---

## Summary

Tokemak accToke Rewards: claim needs an ECDSA signature from rewardsSigner. A signer with code makes claims revert (replayed by the study).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- Rewards.sol:97-98 recover(v,r,s)==rewardsSigner; :80 setSigner onlyOwner
- owner() at block 26438999 = 0x90b6c61b102ea260131ab48377e143d6eb3a9d4b, a Safe with threshold 5 of 11 owners

## Impact and exposure

- Value held at block 26,438,999: $43,851 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-11-16.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

The Safe calls setSigner with an EOA signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
