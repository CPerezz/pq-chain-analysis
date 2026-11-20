---
id: ac7b3467-signer-upgrade-only
title: "0xac7b3467: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xac7b34674c2fe64bde910567a2d318457e0d3c14"
  family: "c2e61109c5001388f91f8c973c0f78ab"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: bytecode
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
  note: "The signer is settable, and the same act (airdrop of the operator's own tokens) stays open by direct owner call. The signature-path bytecode decompiled poorly, so the owner comparison is inferred from the eq_storage flow plus the thirdweb layout."
---

## Summary

Plain ERC-1967 proxy with no upgrade function, running thirdweb-style Airdrop 0x982f81af. The signer check compares against the stored owner, setOwner can replace it, and the owner can also airdrop directly.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x982f81af34d0789cba8b35d1d051821f33768e00: no admin, no upgrade function in the implementation.
- 0xac7b34674c: impl slot = 0x982f81af, slot0 owner = 0xd7147aD6 (EOA n=2) @26438999; heimdall: fallback-only proxy
- 0x982f81af selectors: setOwner(address) (requires msg.sender == owner, emits OwnerUpdated), airdropERC20/721/1155 (owner-only), airdropERC20WithSignature/airdropERC721WithSignature
- scanner: both ecrecover sites flow into eq_storage; the only stored address role found is owner (packed slot 0) [INFERENCE: matches thirdweb Airdrop _isAuthorizedSigner == owner()]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner rotates with setOwner, or airdrops directly with the owner-only functions.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
