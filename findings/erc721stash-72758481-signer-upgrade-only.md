---
id: erc721stash-72758481-signer-upgrade-only
title: "ERC721Stash: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7275848146be02fd166ad26aace757cef30a82ef"
  family: "1d05536f5534ea399c1f786153f4d07a"
  copies: 5
  name: "ERC721Stash"
  upgradeable: "no"
  rating: NONE
  value_usd: 12
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 45
  last_active: 2026-09-30
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
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "accepts ERC-1271 for the expected signer"
---

## Summary

ERC721Stash clone (impl 0x3f99c48d…); SignatureCheckerLib on the stash owner: the signer is checked with SignatureChecker or Solady SignatureCheckerLib, which falls back to that same signer's ERC-1271 once it has code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SignatureChecker on the stored owner of the stash (ECDSA or its ERC-1271). Rule: same text up to names.
- Update path, read at block 26,438,999: proxy to 0x3f99c48d8a518de1a5e1c2c850bdfa868ea443f8: no admin, no upgrade function in the implementation.
- The signature check goes through SignatureChecker(Lib).isValidSignatureNow(signer, …), with an ERC-1271 fallback on the signer (dossier source)

## Impact and exposure

- Value held at block 26,438,999: $12 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 45 transactions called it in the 90 days before that block; last on 2026-09-30.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
