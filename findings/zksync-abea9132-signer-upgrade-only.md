---
id: zksync-abea9132-signer-upgrade-only
title: "ZkSync: signer replaceable only by an upgrade"
project: zksync
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xabea9132b05a70803a4e85094fd0e1800777fbef"
  family: "6d8cc566d5674cc89447a00e343b86d7"
  name: "ZkSync"
  label: "zkSync"
  upgradeable: "yes"
  admin: "0x38a43f4330f24fe920f943409709fc9a6084c939"
  rating: LOW
  value_usd: 23281
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 58
  last_active: 2026-11-16
fix:
  layer: contract-upgrade
  who_acts: "a council member directly, or the zkSync Lite network governor via the UpgradeGatekeeper"
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
  rating: LOW
  note: "The direct per-member call path (not a signature) already satisfies LOW on its own; the governor contract being live production code backs it further. I did not individually verify each council member's key is uncompromised."
---

## Summary

zkSync Lite cutUpgradeNoticePeriodBySignature: a fixed list of security-council members approve a notice-period cut by signature, but (per the row's source read) a member can also approve the same act with a direct call, not a signature.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: zkSync Lite cutUpgradeNoticePeriodBySignature: members of the security council, a list fixed in the code, approve by signature; a member can also approve by its own call / zkSync Lite…. Read from source.
- Update path, read at block 26,438,999: proxy to 0x803b96fa3ce086a722cb6c1e2c79d304c8a263ff, admin 0x38a43f4330f24fe920f943409709fc9a6084c939.
- row note (read from source): 'a member can also approve by its own call' — a direct, non-ecrecover path for the same act stays open to any council member whose key has no code
- UpgradeGatekeeper admin 0x38a43f43… only accepts calls from getMaster (the zkSync main contract 0xE24f4870…); that master's slot0 points to a governor contract 0x34cfac64… with 48KB of code and nonce 1 at 26438999, i.e. live deployed infrastructure, not an empty/dead address

## Impact and exposure

- Value held at block 26,438,999: $23,281 (ETH and 49 priced tokens).
- Activity: 58 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

A live council member approves directly, or the governor drives the upgrade gatekeeper.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
