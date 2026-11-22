---
id: stakedrouterreceiver-5d84f33b-rotate-signer-before-migrating
title: "StakedRouterReceiver: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5d84f33b7c9214df23fd86a0861ac923af99954d"
  family: "e93fad3e59d53acd527637fd13f7bf44"
  name: "StakedRouterReceiver"
  upgradeable: "no"
  rating: LOW
  value_usd: 4
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 19
  last_active: 2026-11-04
fix:
  layer: onchain-config
  who_acts: "owner (EOA)"
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
  note: "Setter exists, owner is a live EOA."
---

## Summary

StakedRouterReceiver: solver actions need a signature from SOLVER_SIGNER; under EIP-8151 the signed path fails if the stored signer gets code, until the owner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSolverSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setSolverSigner(address) is onlyOwner (Sourcify verified source (line 3429))
- owner() at 26438999 = 0xF76e73720EC93df7E823b755E10C38A877C34Bd5, no code, nonce 328 (node)

## Impact and exposure

- Value held at block 26,438,999: $4 (ETH and 49 priced tokens).
- Activity: 19 transactions called it in the 90 days before that block; last on 2026-11-04.

## Remediation

Owner calls the setter to replace the signer with an EOA key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
