---
id: imdfrensstrategy-0000198c-signer-upgrade-only
title: "IMDFrensStrategy: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0000198c940d8cd70cb9acec5e3af8216ac57d2f"
  family: "dac79c251e9a864fb8666aca45326ab8"
  name: "IMDFrensStrategy"
  upgradeable: "yes"
  admin: "0xbd3ed9f4abd9946ca6f59c8f13a3ebebde1ea29d"
  rating: LOW
  value_usd: 316
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1175
  last_active: 2026-11-15
fix:
  layer: contract-upgrade
  who_acts: "proposer EOA 0x35da9c03… through timelock 0xbd3ed9f4…"
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
  note: "Live proposer EOA behind a working timelock: LOW."
---

## Summary

IMDFrensStrategy (Solady permit variant): the recovered address must equal the named owner / the immutable COSIGNER; the implementation can be upgraded through a timelock.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named / IMDReleaseStrategy _cosigned: COSIGNER, an immutable. Read (function text).
- Update path, read at block 26,438,999: proxy to 0xc1fb22eae876ab8df30208caeeffd76f014424e8 with upgradeToAndCall(address,bytes), owner 0xbd3ed9f4abd9946ca6f59c8f13a3ebebde1ea29d.
- owner() at 26438999 = 0xbd3ed9f4abd9946ca6f59c8f13a3ebebde1ea29d, a working timelock (getMinDelay=172800, code 5450 bytes, nonce 1)
- that timelock's PROPOSER_ROLE RoleGranted log (found at its deploy block 26049886) grants the role to 0x35da9c03…, which hasRole=true; that address is an EOA (no code) with nonce 191 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $316 (ETH and 49 priced tokens).
- Activity: 1,175 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

The proposer schedules an upgradeToAndCall through the timelock.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
