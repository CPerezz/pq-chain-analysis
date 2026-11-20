---
id: 4b60dcea-signer-upgrade-only
title: "0x4b60dcea: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4b60dcea1e23a46a4c371c0a982e11236ad13259"
  family: "9f055c73180b4dc4c8be463fbc7725b2"
  upgradeable: "no"
  admin: "0x996213ed4099707059b8b5d7489fff23dac9770d"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-10-14
fix:
  layer: new-deployment
  who_acts: "nobody: this address is a bare UUPS implementation, not a proxy"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "the row's 'Update path' doesn't apply: OZ UUPS upgrades work only through a proxy. No setter either, so no update path; value unmeasured and txs_90d=1, nothing shown held, so MEDIUM (function dies). Fixed in proxies that use this impl, not here"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), owner 0x996213ed4099707059b8b5d7489fff23dac9770d.
- no EIP-1967 implementation slot at the address (zero at block 26438999); it holds the code itself
- eth_call upgradeToAndCall(self,'') from owner 0x996213ed… (EOA nonce 104) reverts 0xe07c8dba = UUPSUnauthorizedCallContext (onlyProxy), so the code at this address can never be upgraded
- txs_90d=1, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-14.

## Remediation

redeploy (with a proxy or key setter) and move any users; the signer key must not gain real code meanwhile

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
