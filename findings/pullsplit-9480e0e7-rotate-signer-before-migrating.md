---
id: pullsplit-9480e0e7-rotate-signer-before-migrating
title: "PullSplit: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x9480e0e7e2bb6c4daef1e3d7b8a2f8cbed8dbc46"
  family: "b270d6641ca6ecc2c5806342400f5460"
  copies: 269
  name: "PullSplit"
  upgradeable: "no"
  rating: NONE
  value_usd: 13534
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 111
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
  note: "Refuted: the signer path accepts ERC-1271."
---

## Summary

0xSplits PullSplit (SplitWalletV2): owner signatures are checked with OpenZeppelin SignatureChecker.isValidSignatureNow, which falls back to ERC-1271 when recovery fails, so an owner or signer that has code is still handled.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the stored owner must sign: ECDSA, or its ERC-1271 when the owner is a contract. Read from source.
- src/utils/ERC1271.sol:48-55: isValidSignature uses SignatureChecker.isValidSignatureNow(getSigner(), …)
- OZ SignatureChecker (node_modules) tries ECDSA, then calls isValidSignature on the signer
- the row note itself says 'or its ERC-1271 when the owner is a contract'

## Impact and exposure

- Value held at block 26,438,999: $13,534 (ETH and 49 priced tokens, over 269 addresses).
- Activity: 111 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None needed. A code-bearing owner validates via ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
