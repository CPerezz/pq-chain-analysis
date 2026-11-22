---
id: bridge-c578cbaf-rotate-signer-before-migrating
title: "Bridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc578cbaf5a411dfa9f0d227f97dadaa4074ad062"
  family: "17b7191db2bcbe0e28b3d38e9a806905"
  copies: 2
  name: "Bridge"
  label: "Celer Network: cBridge 2.0"
  upgradeable: "no"
  rating: LOW
  value_usd: 110620
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner EOA"
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
  note: "live EOA owner"
---

## Summary

Celer Bridge: signer list with power; updateSigners signed by current set, resetSigners by owner after notice.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Celer bridge: signers ascending, matched against the signer list given in the call, power must reach two thirds plus one; the list is replaced by updateSigners (signed by the current set) or reset by…. Read from source.
- resetSigners/notifyResetSigners onlyOwner (Signers.sol:64-71)
- owner 0x1b9dfc… EOA nonce 832 (node block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $110,620 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

owner notifies then resets signers

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
