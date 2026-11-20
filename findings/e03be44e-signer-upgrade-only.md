---
id: e03be44e-signer-upgrade-only
title: "0xe03be44e: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe03be44e00ba0b05bf02741f8be96eaf1cda6747"
  family: "efd09872941e7701827c6f358f8d12ba"
  copies: 2
  upgradeable: "no"
  admin: "0x996213ed4099707059b8b5d7489fff23dac9770d"
  rating: MEDIUM
  txs_90d: 2
  last_active: 2026-11-11
fix:
  layer: new-deployment
  who_acts: "nobody: a bare UUPS implementation"
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
  note: "same template as 0x4b60dcea: no update path at this address; value unmeasured, txs_90d=2, so MEDIUM (function dies, nothing shown held)"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), owner 0x996213ed4099707059b8b5d7489fff23dac9770d.
- no EIP-1967 implementation slot at the address
- eth_call upgradeToAndCall(self,'') from owner 0x996213ed… (EOA nonce 104) reverts 0xe07c8dba = UUPSUnauthorizedCallContext
- txs_90d=2, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-11.

## Remediation

redeploy (with a proxy or key setter) and move any users; the signer key must not gain real code meanwhile

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
