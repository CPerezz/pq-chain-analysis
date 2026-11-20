---
id: heroesofvaldir-5a2a792e-rotate-signer-before-migrating
title: "HeroesOfValdir: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5a2a792ede6eb1f0eccd5f6b7ee5a8aaae64e08c"
  family: "c311c642d93d08f5b4ad4b454811c267"
  name: "HeroesOfValdir"
  upgradeable: "no"
  rating: LOW
  txs_90d: 7866
  last_active: 2026-11-17
  recoveries_14d: 22
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x5755…16c3"
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
  verdict: confirmed
  rating: LOW
  note: "setter callable by a live EOA."
---

## Summary

HeroesOfValdir NFT: mints signed by the stored signer (the owner).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- setOwner(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x5755e82d… EOA, nonce 8

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 7,866 transactions called it in the 90 days before that block; last on 2026-11-17.
- 22 signature recoveries in the study's two-week trace window.

## Remediation

Owner hands over to a new key with setOwner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
