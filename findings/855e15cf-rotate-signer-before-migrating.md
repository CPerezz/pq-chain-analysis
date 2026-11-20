---
id: 855e15cf-rotate-signer-before-migrating
title: "0x855e15cf: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x855e15cff2a98c3d051f88858e791a4929c17145"
  family: "df4cdaa9ccbde7f6de08db10d582a228"
  upgradeable: "no"
  rating: LOW
  value_usd: 30497
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 271
  last_active: 2026-11-17
  recoveries_14d: 30
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xc1ac…52e1"
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
  note: "Owner is a live EOA and can rotate itself via transferOwnership; withdrawOwner also lets it move funds."
---

## Summary

Contract whose signed paths recover to its owner (single stored address). If the owner key takes code, signed paths fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceOwnership, transferMyContractsOwnership, transferOwnership). Rule: stored-key (the owner).
- Decompile: transferOwnership (0xf2fde38b), setSmartWalletOwner, transferMyContractsOwnership, withdrawOwner all require msg.sender == owner
- owner() = 0xc1ac…52e1, EOA with nonce 3368 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $30,497 (ETH and 49 priced tokens).
- Activity: 271 transactions called it in the 90 days before that block; last on 2026-11-17.
- 30 signature recoveries in the study's two-week trace window.

## Remediation

Owner transfers ownership to a fresh EOA before migrating its key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
