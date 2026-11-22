---
id: 6338afee-rotate-signer-before-migrating
title: "0x6338afee: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6338afee3ff32599bff2ce3d8b7604bd6d6a41a7"
  family: "79ad262f9aa141e9655a8e0e6e45aca6"
  upgradeable: "no"
  rating: LOW
  txs_90d: 14537
  last_active: 2026-11-18
  recoveries_14d: 116
fix:
  layer: onchain-config
  who_acts: "any owner (e.g. 0xe3d5…73ad)"
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
  note: "The setter is callable by a live EOA owner."
---

## Summary

Unverified contract (22 KB). bc73ddf0 is NOT_OWNER-gated, and the recovered signer is checked against the owners mapping (slot 0).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: owners added and removed by functions. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- addOwner 0x7065cb48 / removeOwner 0x173825d9 require owners[msg.sender]==1 (heimdall x6338)
- The recovered signer 0x33e5…9f53 in a real tx is an owner (checkOwner=true, nonce 0)
- Owner 0xe3d5e8d7…73ad: checkOwner=true, EOA, nonce 36095 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 14,537 transactions called it in the 90 days before that block; last on 2026-11-18.
- 116 signature recoveries in the study's two-week trace window.

## Remediation

A live owner adds a new owner key and removes the migrating one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
