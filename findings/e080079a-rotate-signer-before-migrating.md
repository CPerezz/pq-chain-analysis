---
id: e080079a-rotate-signer-before-migrating
title: "0xe080079a: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe080079ac12521d57573f39543e1725ea3e16dcc"
  family: "8543ea65e45552cb3afd274f3f70e8f8"
  upgradeable: "no"
  rating: LOW
  value_usd: 21835
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "validator quorum"
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
  note: "The setter is called by the validators themselves, so the key holders can rotate. Validators sign off-chain, so their liveness cannot be read on chain."
---

## Summary

Unverified validator-quorum vault: withdrawals need signatures from a share of the stored validators. A validator key with code stops counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addValidator, removeValidator). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- decompiled: addValidator/removeValidator take validator signatures and need 'Not enough votes' quorum; no owner gate
- owner 0x6201…163 (EOA, nonce 58) has no control over validators in the decompile

## Impact and exposure

- Value held at block 26,438,999: $21,835 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Validators remove a migrating validator and add a fresh key by quorum signatures, while quorum is still reachable.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
