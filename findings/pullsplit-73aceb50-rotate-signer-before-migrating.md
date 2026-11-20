---
id: pullsplit-73aceb50-rotate-signer-before-migrating
title: "PullSplit: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x73aceb5025f173aeb7feb7e6d8a3a6090c59b268"
  family: "82bca671470709a3e23605173f9d0d34"
  copies: 7276
  name: "PullSplit"
  label: "created by 0xSplits: Pull Split Factory"
  upgradeable: "no"
  rating: NONE
  value_usd: 76152
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7709
  last_active: 2026-11-18
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
  note: "An owner with code is handled through the ERC-1271 fallback, so the claim does not hold."
---

## Summary

Splits v2 PullSplit: isValidSignature answers for its stored owner through OpenZeppelin SignatureChecker.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the stored owner must sign: ECDSA, or its ERC-1271 when the owner is a contract. Read from source.
- src/utils/ERC1271.sol:50 uses SignatureChecker.isValidSignatureNow(owner, …)
- the bundled OZ SignatureChecker.sol:24-28 does tryRecover and on mismatch falls back to isValidERC1271SignatureNow(signer, …)
- the owner acts directly by msg.sender for everything else (Wallet.sol execCalls)

## Impact and exposure

- Value held at block 26,438,999: $76,152 (ETH and 49 priced tokens, over 7,276 addresses).
- Activity: 7,709 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
