---
id: world-liberty-financial-196fee96-signer-upgrade-only
title: "WLFIStakingAccountingLib: signer replaceable only by an upgrade"
project: world-liberty-financial
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x196fee96efeaad585483a6d950e70286b6851923"
  family: "e8962d18d779f3396e2624151b5251f0"
  name: "WLFIStakingAccountingLib"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x638820b90a9352295d75efbf80001bfdd2d6c504 owned by Safe 0x5be9a4959308a0d0c7bc0870e319314d8d957dbb (3/5)"
  rating: LOW
  value_usd: 12214810
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1228
  last_active: 2026-11-17
fix:
  layer: contract-upgrade
  who_acts: "3-of-5 Safe 0x5be9a495… via ProxyAdmin 0x638820b9…"
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
  note: "Live multisig admin: LOW."
---

## Summary

WLFIStakingAccountingLib: the recovered address must equal the reward signer kept in storage, with no setter. Holds $12.2M.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the recovered address must be the reward signer passed in from storage. Read from source.
- Update path, read at block 26,438,999: proxy to 0xf757d680b6b9fa5be2068e7b794754de90b840ec, admin 0x638820b90a9352295d75efbf80001bfdd2d6c504.
- EIP-1967 admin slot at 26438999 = 0x638820b9… (ProxyAdmin); owner() = Safe 0x5be9a495…
- Safe getThreshold=3, 5 owners all EOAs with nonzero nonces (42,67,3,416,525)

## Impact and exposure

- Value held at block 26,438,999: $12.2M (ETH and 49 priced tokens).
- Activity: 1,228 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Upgrade to an implementation that reads a new reward signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
