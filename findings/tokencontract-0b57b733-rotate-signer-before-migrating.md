---
id: tokencontract-0b57b733-rotate-signer-before-migrating
title: "TokenContract: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0b57b7333c43fe900d17a81bddc67c88c825afd6"
  family: "e3ba62c492565f62a2c8dafcbe64f7ac"
  copies: 2
  name: "TokenContract"
  label: "Doma: SDLR Token"
  upgradeable: "no"
  rating: NONE
  txs_90d: 33444
  last_active: 2026-11-18
  recoveries_14d: 329
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  note: "contract-signer branch handles a signer with code."
---

## Summary

TokenContract: mint/burn signatures must come from a role holder; ECDSA first, then an ERC-1271 path for a role holder that has code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- TokenContract.sol:881-915 _isValidSignature: ECDSA.tryRecover, else signature[:20] names a wallet holding the role with code.length>0 and its isValidSignature is asked
- role admin (role-0 member) 0x9178c5ec… EOA nonce 20 could also rotate

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 33,444 transactions called it in the 90 days before that block; last on 2026-11-18.
- 329 signature recoveries in the study's two-week trace window.

## Remediation

Role holder that takes code signs in the EIP-1271 format (wallet address prefix).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
