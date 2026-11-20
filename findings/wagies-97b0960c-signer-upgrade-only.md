---
id: wagies-97b0960c-signer-upgrade-only
title: "Wagies: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x97b0960c9d7602e8fbd2d299abd7dfa150948c8e"
  family: "35fc1d58ca15748d4bca29aac9232a65"
  name: "Wagies"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Uninitialized implementation with no live proxy using it — refuted."
---

## Summary

Wagies (ERC721A/UUPS NFT, SIGNER is a constant): the dossier facts show addresses_that_run_it=1, how_addresses_come_to_run_it={'direct':1} — this is the bare implementation contract itself (slot0=0xff, _disableInitializers) with no live proxy anywhere delegating to it.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Wagies: signed by SIGNER, a constant in the code. Read (function text).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- dossier facts.json (gate1/readings/35fc1d58ca15748d4bca29aac9232a65): addresses_that_run_it=1, of_those_hold_the_code_themselves=1, how_addresses_come_to_run_it={'direct':1}, eth_at_pinned_block=0
- dossier state.json: slot_0=0xff (disableInitializers marker), owner()=0, eip1967 slots all zero on this address itself

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a — claim is wrong, nothing is live.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
