---
id: managedvalidator-d4228481-rotate-signer-before-migrating
title: "ManagedValidator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd42284814389978dc43c53f8807e8bc0ac6bd5fe"
  family: "b18535c7cb904fbc04557a781d897812"
  copies: 4
  name: "ManagedValidator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1019
  last_active: 2026-11-18
  recoveries_14d: 3146
fix:
  layer: onchain-config
  who_acts: "the current validator set (BFT quorum), by signing updateValidators"
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
  note: "The key holders (the set) can replace keys. Not read at block 26438999, because the RPC timed out: getValidatorCount(). The verdict rests on source only."
---

## Summary

Chromia ManagedValidator. A BFT quorum of the validator set must sign; a signature that fails is not counted. Under EIP-8151 a validator that takes non-7702 code stops counting toward the quorum.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: ManagedValidator: a BFT number of the validator set must sign; a signature that does not verify is not counted; the set is replaced with updateValidators. Read by hand.
- BaseManagedValidator.sol:108-111: a signature counts only if recover equals signer; _calculateBFTRequiredNum sets the quorum
- BaseManagedValidator.sol:26-60: updateValidators replaces the set when proven by the current validators' signatures; there is no owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,019 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,146 signature recoveries in the study's two-week trace window.

## Remediation

The validators sign an updateValidators that swaps the affected key while a quorum still has EOA keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
