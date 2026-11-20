---
id: lightaccount-067a989e-rotate-signer-before-migrating
title: "LightAccount: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x067a989e2156ae3cd6e4d0242a6f7026bd6c758e"
  family: "15f7750bf50d733d6887116eea238f9b"
  copies: 1574
  name: "LightAccount"
  label: "created by Alchemy: Light Account Factory V1.1.0"
  upgradeable: "yes"
  rating: NONE
  value_usd: 54678
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7779
  last_active: 2026-11-18
  recoveries_14d: 1331
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "An ERC-1271 fall-through for the stored owner handles an owner with code. The 'executed revert' holds only for an owner contract without ERC-1271."
---

## Summary

Alchemy LightAccount v1 (ERC-4337 single-owner account, UUPS): owner signatures for UserOps and isValidSignature.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the stored owner must sign: ECDSA, or its ERC-1271 when the owner is a contract. Read from source. Executed: a real transaction reverts with code at the signer.
- LightAccount.sol:278 isValidSignature uses SignatureChecker.isValidSignatureNow(owner, …): tryRecover, then ERC-1271 on the owner
- LightAccount.sol:326 user-op validation also falls through to isValidERC1271SignatureNow(_owner, …)
- owner 0x44a7af26…8451 can also act by direct call and transferOwnership

## Impact and exposure

- Value held at block 26,438,999: $54,678 (ETH and 49 priced tokens, over 1,574 addresses).
- Activity: 7,779 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,331 signature recoveries in the study's two-week trace window.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
