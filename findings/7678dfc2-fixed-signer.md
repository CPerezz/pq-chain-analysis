---
id: 7678dfc2-fixed-signer
title: "0x7678dfc2: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x7678dfc2406ac2d60f174813e8a79f2b69861455"
  family: "242a7b0b19f76460a98094e5139f60c4"
  upgradeable: "yes"
  admin: "0x2ce80c468927a3274db3c31025ec1ac14be013b8 (ProxyAdmin (Ownable)), owned by 0xfb8f058ba0b707f20134863dc0c7fa0c2c821129 (EOA, nonce 80)"
  rating: LOW
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 65
  last_active: 2026-10-29
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0xfb8f058ba0b707f20134863dc0c7fa0c2c821129"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: a live party controls the proxy admin."
---

## Summary

Presale: deposit and claim need a signature of SIGNER, fixed in the code; EIP-8151 makes the fixed signer's signature fail once that signer has code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: proxy to 0xb4fd48038f0ad22155497f182052c94ab851c596, admin 0x2ce80c468927a3274db3c31025ec1ac14be013b8.
- EIP-1967 admin slot = 0x2ce80c468927a3274db3c31025ec1ac14be013b8, implementation = 0xb4fd48038f0ad22155497f182052c94ab851c596 at block 26438999
- 0x2ce80c468927a3274db3c31025ec1ac14be013b8: ProxyAdmin (Ownable); owner() = 0xfb8f058ba0b707f20134863dc0c7fa0c2c821129
- 0xfb8f058ba0b707f20134863dc0c7fa0c2c821129: EOA, nonce 80 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens).
- Activity: 65 transactions called it in the 90 days before that block; last on 2026-10-29.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
