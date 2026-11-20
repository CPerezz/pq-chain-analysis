---
id: b5a89532-signer-upgrade-only
title: "0xb5a89532: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb5a89532472921d765d708600ec2b4936ff5df91"
  family: "e09df2b54b410ce3de91807a4eb6c572"
  upgradeable: "no"
  admin: "0x81f502906a538d4278b9136178d7dda6789c9254"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody: this address holds the implementation code itself"
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
  note: "no update path at this address; value unmeasured, txs_90d=0, so MEDIUM (function dies, nothing shown held)"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Placed by a rule; copy of template ee56db4b, not read on its own.
- Update path, read at block 26,438,999: upgradeTo(address), owner 0x81f502906a538d4278b9136178d7dda6789c9254.
- no EIP-1967 implementation slot at the address
- eth_call upgradeTo/upgradeToAndCall from owner 0x81f50290… (EOA nonce 16) reverts 'Function must be called through delegatecall'
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

redeploy (with a proxy or key setter) and move any users; the signer key must not gain real code meanwhile

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
