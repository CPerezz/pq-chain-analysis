---
id: 7561deaf-fixed-signer
title: "0x7561deaf: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7561deaf4ecf96dc9f0d50b4136046979acdad3e"
  family: "645c43903f825a78733e73fe0b7d0adb"
  copies: 3
  upgradeable: "no"
  rating: NONE
  txs_90d: 225
  last_active: 2026-11-17
  recoveries_14d: 1
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
  note: "The comparison is against an owner-settable registry, so refuted."
---

## Summary

Staking-NFT contract whose only ecrecover checks optional staking-partner signatures against a partner registry that the owner sets with e0fdb1c0. Staking works without partners, and claim(uint256[]) is unsigned.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: an NFT burn-claim contract (1 recovery); inferred: claims signed by a fixed party. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile 0x2518b8b3 (stake): the recovered address must be an active partner in storage_map_r ('Staking partner is not active'); the partner signature array may be empty
- e0fdb1c0 starts with SLOAD(0) == CALLER (onlyOwner) at pc 7092; owner 0x62728292… is an EOA with nonce 9
- claim(uint256[]) pays the NFT owner from the token with no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 225 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
