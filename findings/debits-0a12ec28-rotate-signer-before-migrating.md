---
id: debits-0a12ec28-rotate-signer-before-migrating
title: "Debits: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0a12ec2889dd4f523ce433a760e07f08ea9c64b2"
  family: "d080f67e089f093603bd210f048a6de7"
  name: "Debits"
  upgradeable: "no"
  rating: LOW
  txs_90d: 5409
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner 0x02b1…9626 (EOA with 7702 delegation)"
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
  rating: LOW
  note: "setter callable by a live EOA."
---

## Summary

Debits: the stored operator signs.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setOperator). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setOperator(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x02b16514… EOA (7702-delegated), nonce 2035; operator() = 0xe89b1f1b…

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 5,409 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Owner calls setOperator.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
