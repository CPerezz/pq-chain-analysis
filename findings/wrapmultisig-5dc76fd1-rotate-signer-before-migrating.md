---
id: wrapmultisig-5dc76fd1-rotate-signer-before-migrating
title: "WrapMultisig: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5dc76fd132354be5567ad617fd1fe8fb79421d82"
  family: "092b8ed6083340f32dc709db33efa5e0"
  name: "WrapMultisig"
  upgradeable: "no"
  rating: LOW
  value_usd: 423169
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "administrator Safe 0x5b64…7698"
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
  note: "Live Safe admin holds setter."
---

## Summary

WrapMultisig custody: execTransaction needs 3 of 5 owners by ECDSA only.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: WrapMultisig: `threshold` owners in ascending order, by ECDSA only. Read from source.
- swapOwner/addOwnerWithThreshold/removeOwner callable by administrator (slot_0) by direct call
- administrator 0x5b64d8b8…7698 is a Safe, threshold 4 at block

## Impact and exposure

- Value held at block 26,438,999: $423,169 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Administrator swaps an owner with code for an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
