---
id: 1d0308c9-signer-upgrade-only
title: "0x1d0308c9: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1d0308c96cb36e22c9b9ec261f009a05533690d2"
  family: "8da22808c25bb611a6ea7bb4cd29f808"
  copies: 2
  upgradeable: "no"
  admin: "0x1e6779dc8618e1e0e332247f3bbd0f23cba59bc1"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody: a bare UUPS implementation (the row's 'proxy to itself')"
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

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template 4a2c7a03, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x1d0308c96cb36e22c9b9ec261f009a05533690d2 with UPGRADE_INTERFACE_VERSION(), owner 0x1e6779dc8618e1e0e332247f3bbd0f23cba59bc1.
- no EIP-1967 implementation slot; the row lists the proxy target as the address itself
- eth_call upgradeToAndCall(self,'') from owner 0x1E6779dC… (7702-delegated EOA, nonce 61) reverts 0xe07c8dba = UUPSUnauthorizedCallContext
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

redeploy (with a proxy or key setter) and move any users; the signer key must not gain real code meanwhile

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
