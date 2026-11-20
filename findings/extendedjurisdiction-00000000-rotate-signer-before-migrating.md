---
id: extendedjurisdiction-00000000-rotate-signer-before-migrating
title: "ExtendedJurisdiction: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0000000000c5fd1aef1a9421626cf804086185e9"
  family: "faee1deea1b6d2f15485df77a698ddd3"
  copies: 2
  name: "ExtendedJurisdiction"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "validator / owner (EOA)"
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
  note: "Key holder (validator) rotates its own key; owner is a live EOA as backup."
---

## Summary

ExtendedJurisdiction (TPL): attribute issuance checks a signature from a validator's signingKey; EIP-8151 breaks it if a signing key takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template a6020f29: the recovered address must be the stored signer, or be in a stored set or role of signers. Template.
- setValidatorSigningKey(newSigningKey): callable by the validator itself (verified source line 1454)
- addValidator/removeValidator onlyOwner; owner() at 26438999 = 0x0734d56DA60852A03e2Aafae8a36FFd8c12B32f1, no code, nonce 864 (node)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls the setter to replace the signer with an EOA key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
