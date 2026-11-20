---
id: accountableasyncredeemvault-b9c317ca-rotate-signer-before-migrating
title: "AccountableAsyncRedeemVault: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xb9c317cae7dd05ecb0c0925020e529934c96f84d"
  family: "dd38ba2af1ecb2d7697a22fd032e684e"
  copies: 27
  name: "AccountableAsyncRedeemVault"
  upgradeable: "no"
  rating: NONE
  value_usd: 9203
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4006
  last_active: 2026-11-18
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
  note: "The ERC-1271 fallback handles a signer with code."
---

## Summary

AccountableAsyncRedeemVault checks the stored signer through OZ SignatureChecker, which falls back to ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Read from source.
- Authorizable.sol:84 and :158 use SignatureChecker.isValidSignatureNow(signer_, digest, signature)
- SignatureChecker.sol:22-26: ECDSA match
- ERC-1271
- setSigner exists (Authorizable.sol:40, AccountableVault.sol:235)

## Impact and exposure

- Value held at block 26,438,999: $9,203 (ETH and 49 priced tokens, over 27 addresses).
- Activity: 4,006 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
