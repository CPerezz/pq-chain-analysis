---
id: multisiggenverifier-27d7b391-rotate-signer-before-migrating
title: "MultiSigGenVerifier: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x27d7b391e493bcc7fd81d317b0ac2e013f0b1ad6"
  family: "d2f0a7be8047ae25d5ee860439484078"
  copies: 3
  name: "MultiSigGenVerifier"
  label: "deployed by Franklin Templeton BENJI: Deployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 880
  last_active: 2026-11-18
  recoveries_14d: 186
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: executed
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
  verdict: refuted
  rating: NONE
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`MultiSigGenVerifier` at `0x27d7b391e493bcc7fd81d317b0ac2e013f0b1ad6` (Etherscan tag: deployed by Franklin Templeton BENJI: Deployer), with 2 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (validator, attester, author, oracle), distinct or ordered; a quorum or weight is needed. Read from source. Executed: a real transaction is unaffected by code at the signer.
- Not affected: the reading for this address says the owner is checked through SignatureChecker, so an owner with code is asked through ERC-1271, or that a real transaction was unaffected by code at the signer (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 880 transactions called it in the 90 days before that block; last on 2026-11-18.
- 186 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
