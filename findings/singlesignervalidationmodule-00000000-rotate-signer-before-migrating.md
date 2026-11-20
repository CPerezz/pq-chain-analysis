---
id: singlesignervalidationmodule-00000000-rotate-signer-before-migrating
title: "SingleSignerValidationModule: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x00000000000099de0bf6fa90deb851e2a2df7d83"
  family: "1bdef8984a70df09b8bb3862c28d38e0"
  name: "SingleSignerValidationModule"
  label: "Alchemy: Single Signer Validation Module"
  upgradeable: "no"
  rating: NONE
  txs_90d: 7414
  last_active: 2026-11-18
  recoveries_14d: 1087
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
  note: "The signer with code is handled through ERC-1271 by choosing the signature type. If the main reviewer prefers it, this is LOW (the account's own transferSigner)."
---

## Summary

Alchemy ERC-6900 SingleSignerValidationModule: the stored signer per account and entity can sign as type EOA (ecrecover) or CONTRACT_OWNER (ERC-1271), and the account can also replace it with transferSigner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: ERC-6900 single signer module: the stored signer is replaced by transferSigner; a contract signer is asked through ERC-1271. Read by hand. Executed: a real transaction reverts with code at the signer.
- SingleSignerValidationModule.sol:166-180 _checkSig: SignatureType.EOA → tryRecover; SignatureType.CONTRACT_OWNER → SignatureChecker.isValidERC1271SignatureNow(owner,…)
- line 72 transferSigner(entityId,newSigner) stores under msg.sender (the account), so the account itself rotates

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 7,414 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,087 signature recoveries in the study's two-week trace window.

## Remediation

Sign with the CONTRACT_OWNER type prefix once the signer has code, or transferSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
