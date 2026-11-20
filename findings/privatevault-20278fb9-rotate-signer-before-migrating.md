---
id: privatevault-20278fb9-rotate-signer-before-migrating
title: "PrivateVault: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x20278fb9de54d037391b26532f3227fe224ab595"
  family: "61d5cfca2b1795c5da96cdcaad45f609"
  copies: 245
  name: "PrivateVault"
  upgradeable: "no"
  rating: NONE
  value_usd: 9925
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6279
  last_active: 2026-11-17
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
  note: "The code checks for code first and falls back to ERC-1271, so EIP-8151's no-result-for-code never applies."
---

## Summary

PrivateVault (minimal clone) validates through OZ SignatureChecker.isValidSignatureNow(vaultOwner,...). A vaultOwner with code goes through ERC-1271, not ecrecover.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source.
- PrivateVault.sol:262 SignatureChecker.isValidSignatureNow(vaultOwner, hash, signature)
- SignatureChecker.sol:23-27 uses ECDSA only when signer.code.length==0, else isValidERC1271SignatureNow; vaultOwner()=0x0F9A…785d

## Impact and exposure

- Value held at block 26,438,999: $9,925 (ETH and 49 priced tokens, over 245 addresses).
- Activity: 6,279 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

None: a vaultOwner with code is handled by ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
