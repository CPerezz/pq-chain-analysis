---
id: rfqvaultexecutor-97caca78-rotate-signer-before-migrating
title: "RFQVaultExecutor: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x97caca78ac2a94c67643d07843f85afaa44a3ea5"
  family: "1bd672d4611d0320e75271bae26a05de"
  name: "RFQVaultExecutor"
  upgradeable: "no"
  rating: LOW
  value_usd: 8121
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 47786
  last_active: 2026-11-18
  recoveries_14d: 4573
fix:
  layer: onchain-config
  who_acts: "owner 0xF76e7372…4Bd5 (EOA)"
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
  note: "Owner-only setter, live EOA."
---

## Summary

RFQVaultExecutor quotes must be signed by SOLVER_SIGNER. A signer with code makes execution revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: RFQ vault executor: quotes must be signed by the solver signer, which the owner replaces with setSolverSigner (setter seen by name). Read by hand. Executed: a real transaction reverts with code at the signer.
- RFQVaultExecutor.sol:204 setSolverSigner(address) onlyOwner
- owner() = 0xF76e73720EC93df7E823b755E10C38A877C34Bd5, no code, nonce 328

## Impact and exposure

- Value held at block 26,438,999: $8,121 (ETH and 49 priced tokens).
- Activity: 47,786 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4,573 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setSolverSigner with a key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
