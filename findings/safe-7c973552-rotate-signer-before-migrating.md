---
id: safe-7c973552-rotate-signer-before-migrating
title: "Safe: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7c9735521ad7d81f57bc56bc85b5bc885d4748ae"
  family: "f108e396f23f4e198579b2cc563e2fb7"
  copies: 126
  name: "Safe"
  label: "created by Safe: Proxy Factory 1.4.1"
  upgradeable: "yes"
  rating: NONE
  value_usd: 273030
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-02
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
  note: "Signer with code handled."
---

## Summary

Safe 1.4.1 singleton: owners confirm by ECDSA, contract signature (v=0) or approved hash (v=1).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Safe 1.4.1 checkNSignatures: each signer must be an owner, in ascending order; besides ECDSA an owner can be a contract (v=0) or pre-approve by its own call (v=1). Read from source.
- checkNSignatures accepts ERC-1271 owners (v=0) and approveHash/msg.sender (v=1) (reading note)

## Impact and exposure

- Value held at block 26,438,999: $273,030 (ETH and 49 priced tokens, over 126 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
