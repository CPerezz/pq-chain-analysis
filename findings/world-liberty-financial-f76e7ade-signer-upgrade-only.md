---
id: world-liberty-financial-f76e7ade-signer-upgrade-only
title: "WLFIStakingAccountingLib: signer replaceable only by an upgrade"
project: world-liberty-financial
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf76e7ade36c2e9a43d1192a17478a6900acce8ed"
  family: "e8962d18d779f3396e2624151b5251f0"
  copies: 2
  name: "WLFIStakingAccountingLib"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x638820b90a9352295d75efbf80001bfdd2d6c504 owned by 3-of-5 Safe 0x5be9a4959308A0D0c7bC0870E319314d8D957dBB"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "3-of-5 Safe 0x5be9a495 via ProxyAdmin 0x638820b9"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A live multisig admin upgrades the only known user, so LOW. Consistent with the L048 proposal for proxy 0x196fee96."
---

## Summary

WLFIStakingAccountingLib is a linked Solidity library (code starts with PUSH20 of its own address); the reward signer comes from the caller's storage. Its user, the WLFI staking proxy 0x196fee96, is upgradeable by a live 3-of-5 Safe.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the recovered address must be the reward signer passed in from storage. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- the row's code begins 0x73f76e7a…3014 (library call guard), so it holds no state
- proxy 0x196fee96: implementation slot = 0xf757d680, admin slot = ProxyAdmin 0x638820b9, owner() = Safe 0x5be9a495
- Safe 0x5be9a495 getThreshold=3; 5 owners, all EOAs (nonces 42, 67, 3, 416, 525)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Upgrade the staking implementation (and relink) to read a new reward signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
