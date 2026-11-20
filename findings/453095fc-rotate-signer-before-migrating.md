---
id: 453095fc-rotate-signer-before-migrating
title: "0x453095fc: signer key to rotate before its account takes code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x453095fc585c5fda2756ed16990463038a6d8a17"
  family: "643a74e6c4169d97a08938ed6a811316"
  copies: 3
  upgradeable: "no"
  rating: HIGH
  value_usd: 150861
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the key holder or owner rotates the key"
evidence:
  level: bytecode
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
  rating: HIGH
  note: "no setter for the checked keys (weights fixed at deploy); if holders above half the weight take code, held tokens are locked. Holders' identity not read."
---

## Summary

Unverified wallet: withdrawBySigns needs signatures weighed by voteWeight; under EIP-8151 weight holders with code can't sign.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: withdrawals by signatures weighed by vote weights. Bytecode and names.
- heimdall decompile + PUSH4 scan: selectors only deposit/withdrawBySigns/views/transferOwnership(f2fde38b); no function writes voteWeight
- owner 0xecba1d… EOA (nonce 456) can only transfer ownership
- totalVoteWeight 445000000; ETH balance 0.35 (node block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $150,861 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

weight holders must not move to code; no on-chain fix

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
