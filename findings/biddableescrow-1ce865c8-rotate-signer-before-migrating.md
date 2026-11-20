---
id: biddableescrow-1ce865c8-rotate-signer-before-migrating
title: "BiddableEscrow: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1ce865c81e76aafd2003e69acd2d196d19aac144"
  family: "8f0881d3e368ae65c7e3909dd8bbf169"
  name: "BiddableEscrow"
  upgradeable: "no"
  rating: LOW
  value_usd: 41866
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0x084a7b13 (EOA)"
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
  note: "Setter exists and the owner is an EOA with nonce > 0."
---

## Summary

BiddableEscrow: deposit needs an ECDSA signature from the arbitrator. If the arbitrator gets code, new deposits revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be one stored signer of the contract (an affiliate, system, consensus, updater, admin or whitelist key). Read from source.
- BiddableEscrow.sol:265-275 ecrecover(...)==arbitrator; :228 setArbitrator onlyOwner
- owner() at block 26438999 = 0x084a7b13c968b3326242c1a33c380f3e1c39de58, no code, nonce 1

## Impact and exposure

- Value held at block 26,438,999: $41,866 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls setArbitrator with an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
