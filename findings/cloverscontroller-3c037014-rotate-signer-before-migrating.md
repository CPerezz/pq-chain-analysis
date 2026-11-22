---
id: cloverscontroller-3c037014-rotate-signer-before-migrating
title: "CloversController: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3c037014486aaa5d509c5171d413c8b3022f1072"
  family: "6abab02427655cccf3db19509b1bb2b2"
  name: "CloversController"
  label: "Clovers: Controller"
  upgradeable: "no"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6777
  last_active: 2026-11-18
  recoveries_14d: 18
fix:
  layer: onchain-config
  who_acts: "owner"
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
  note: "Setter callable by a live EOA owner."
---

## Summary

CloversController; signed clover claims need the oracle's signature. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: CloversController.checkSignature: true when the signer its caller names, the oracle, signed / CloversController.recover: returns the signer. Read from source. Executed: a real transaction reverts with code at the signer.
- CloversController.sol:1088 updateOracle(address) onlyOwner
- owner() = 0xe7d134c2…; owner is an EOA (no code, nonce 214) at block 26438999
- oracle() = 0xaB0F3326…

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens).
- Activity: 6,777 transactions called it in the 90 days before that block; last on 2026-11-18.
- 18 signature recoveries in the study's two-week trace window.

## Remediation

Owner sets a new oracle.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
