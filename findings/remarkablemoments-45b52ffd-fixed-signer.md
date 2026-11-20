---
id: remarkablemoments-45b52ffd-fixed-signer
title: "RemarkableMoments: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x45b52ffdeaf10401e4bb2b8e3627aa40c2e85bac"
  family: "1cd27a0025bbe4a171f40d5b6a4a5f5a"
  name: "RemarkableMoments"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
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
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Every path that reaches the check is a view; nothing relies on it on-chain."
---

## Summary

RemarkableMoments: isAllowlisted (constant ALLOWLIST_SIGNER) is a public pure helper that no state-changing function calls. Minting is restricted to the minter or owner, and the allowlist uses a Merkle root.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: isAllowlisted is defined at line 124 and referenced nowhere else
- mintNFT requires msg.sender == ownerAddr
- minter

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
