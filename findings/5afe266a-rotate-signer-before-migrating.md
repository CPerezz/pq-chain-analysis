---
id: 5afe266a-rotate-signer-before-migrating
title: "0x5afe266a: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5afe266ab4e43c32bad5459fe8df116dd5541222"
  family: "5c55c4d132d4a9aa2e7c2db6fe20d782"
  copies: 6
  upgradeable: "no"
  rating: LOW
  value_usd: 19670
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "operations"
evidence:
  level: bytecode
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
  note: "There is a setter and a live EOA operator."
---

## Summary

Minimal-proxy clone of HPool impl 0x4832…f22f: ecrecover is compared to a stored signer, and updateSigner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (updateSigner, updateXChainPoolAuthorization). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- decompiled impl: updateSigner requires msg.sender == operations
- operations() = 0x0bF0…B31d, an EOA with nonce 219

## Impact and exposure

- Value held at block 26,438,999: $19,670 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operations calls updateSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
