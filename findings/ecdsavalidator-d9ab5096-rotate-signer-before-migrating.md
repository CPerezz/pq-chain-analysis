---
id: ecdsavalidator-d9ab5096-rotate-signer-before-migrating
title: "ECDSAValidator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd9ab5096a832b9ce79914329daee236f8eea0390"
  family: "af33ec96c5b49f11ad5d7294beb2f5a9"
  copies: 3
  name: "ECDSAValidator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 12702
  last_active: 2026-11-18
  recoveries_14d: 3517
fix:
  layer: account-migration
  who_acts: "each Kernel account"
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
  note: "Per-account setter callable by the account itself."
---

## Summary

Kernel v2 ECDSAValidator. Each account's stored owner must ECDSA-sign; there is no ERC-1271 path.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Kernel v2 ECDSA validator (source read): the owner recorded for the calling account must sign; the account can set another owner (enable), and the owner may also call the account itself (validCaller). Read by hand. Executed: a real transaction reverts with code at the signer.
- enable(bytes) sets ecdsaValidatorStorage[msg.sender].owner (ECDSAValidator.sol:23-27), so the account itself rotates its owner
- Validation uses ECDSA.recover only (lines 38-53)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 12,702 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,517 signature recoveries in the study's two-week trace window.

## Remediation

Before the owner key's account takes code, the Kernel account calls enable with a new owner (or the owner calls the account directly via validCaller).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
