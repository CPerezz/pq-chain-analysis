---
id: stash-175a9e11-signer-upgrade-only
title: "Stash: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x175a9e11c265e1ae78f39a24298beecf4adc92c0"
  family: "c9b7ae5d6ebcbeeb56871fe7c1f0f9f3"
  copies: 6
  name: "Stash"
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

- How it was placed: SignatureChecker on the stored owner of the stash (ECDSA or its ERC-1271). Read (function text).
- Update path, read at block 26,438,999: proxy to 0x000000000000e40f60a38736d28a9b21054ce73a: no admin, no upgrade function in the implementation.
- ERC721Stash._isValidSignature: SignatureCheckerLib.isValidSignatureNow(owner, hash, signature) (src/ERC721Stash.sol:670); Stash.sol imports the same library
- the library uses ecrecover only when signer.code.length == 0, otherwise ERC-1271 (lib/solady/src/utils/SignatureCheckerLib.sol:30)
- owner at 26438999: 0xd23b06012790E2D8E01a7607127588b609C27f0C (chain1)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
