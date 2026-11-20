---
id: gnosissafe-02479bfc-rotate-signer-before-migrating
title: "GnosisSafe: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x02479bfc7dce53a02e26fe7baea45a0852cb0909"
  family: "f15632f51822929a9fbf0492ef338d70"
  copies: 749
  name: "GnosisSafe"
  label: "created by Safe: Proxy Factory 1.1.1"
  upgradeable: "yes"
  rating: NONE
  value_usd: 377694
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 85
  last_active: 2026-11-10
  recoveries_14d: 3
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
  note: "A signer with code is handled by the v=0/v=1 paths."
---

## Summary

Safe 1.1.1 master copy: owners confirm by ECDSA, eth_sign, contract signature (v=0) or approvedHash/msg.sender (v=1).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Safe 1.1.1 checkSignatures: owners in ascending order; ECDSA, eth_sign, a contract owner (v=0) or a hash the owner approved by its own call (v=1) / old Safe SignatureDecoder.recoverKey: returns the…. Read from source.
- checkSignatures accepts v=0 ERC-1271 for contract owners and v=1 approveHash by the owner's own call (reading note)
- owners also rotate via Safe self-call

## Impact and exposure

- Value held at block 26,438,999: $377,694 (ETH and 49 priced tokens, over 749 addresses).
- Activity: 85 transactions called it in the 90 days before that block; last on 2026-11-10.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Owner with code confirms via approveHash or ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
