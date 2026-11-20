---
id: 4080eba7-rotate-signer-before-migrating
title: "0x4080eba7: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4080eba7392e3a1824b5a4eba09d7307a5c51b2d"
  family: "2425f847fcde0fdfbc620fa29e0f383d"
  upgradeable: "no"
  rating: LOW
  value_usd: 48362
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 755
  last_active: 2026-11-17
  recoveries_14d: 148
fix:
  layer: onchain-config
  who_acts: "owner 0x88f2d303 (EOA)"
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
  note: "Setter is owner-gated and the owner is a live EOA."
---

## Summary

Claim contract: claims need a signature from a key in a stored signer map. If that key gets code, claims revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (authorizedSigner, setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- Decompile: setSigner(address,bool) (0x31cb6105) requires msg.sender==owner, writes the signer map, emits SignerUpdated
- owner() at block 26438999 = 0x88f2d3031de86b8c09ea7209e32cc04eba5d88b8, no code, nonce 2418
- Ownable2Step (acceptOwnership 0x79ba5097) and pause also owner-gated

## Impact and exposure

- Value held at block 26,438,999: $48,362 (ETH and 49 priced tokens).
- Activity: 755 transactions called it in the 90 days before that block; last on 2026-11-17.
- 148 signature recoveries in the study's two-week trace window.

## Remediation

Owner adds a new EOA signer with setSigner(new,true) and removes the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
