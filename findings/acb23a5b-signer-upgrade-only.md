---
id: acb23a5b-signer-upgrade-only
title: "0xacb23a5b: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xacb23a5b0e1f3fea13530cbf3270ecbdbbce093c"
  family: "0dc6159795d192cbdb4f992325d2a254"
  upgradeable: "no"
  admin: "0x0000000000000000000000000000000000000001"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody: a bare Solady UUPS implementation with owner 0x…0001"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "no update path at this address (bare implementation, owner placeholder); value unmeasured, txs_90d=0, so MEDIUM (function dies, nothing shown held)"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template 553f38a6, not read on its own.
- Update path, read at block 26,438,999: upgradeToAndCall(address,bytes), owner 0x0000000000000000000000000000000000000001.
- no EIP-1967 implementation slot (zero); owner() = 0x0000…0001, a placeholder that disables the implementation
- eth_call upgradeToAndCall from 0x…01 reverts 0x9f03a026 (Solady UnauthorizedCallContext); upgradeTo reverts 0x3c10b94e
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

redeploy (with a proxy or key setter) and move any users; the signer key must not gain real code meanwhile

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
