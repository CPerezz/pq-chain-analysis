---
id: erc721stash-1acd5898-signer-upgrade-only
title: "ERC721Stash: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x1acd5898dc1e513be966b38e599a883c57e518c1"
  family: "352ebf3b9c703b9368b59e5e625e460c"
  copies: 2
  name: "ERC721Stash"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  note: "Refuted: the check accepts ERC-1271 for that signer."
---

## Summary

Stash: bids are checked with Solady SignatureCheckerLib.isValidSignatureNow(owner, hash, sig), which uses ERC-1271 on the owner once the owner has code, so the owner keeps signing after migrating.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SignatureChecker on the stored owner of the stash (ECDSA or its ERC-1271). Rule: same text up to names.
- Update path, read at block 26,438,999: proxy to 0x49fd54adcec364cf36fa45bb0180d41338b2e543: no admin, no upgrade function in the implementation.
- ERC721Stash._isValidSignature: SignatureCheckerLib.isValidSignatureNow(owner, hash, signature) (src/ERC721Stash.sol:670); Stash.sol imports the same library
- the library uses ecrecover only when signer.code.length == 0, otherwise ERC-1271 (lib/solady/src/utils/SignatureCheckerLib.sol:30)
- owner at 26438999: 0x67B1eBaF847BE5050272b174be2713D81b08dCF4 (chain1)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
