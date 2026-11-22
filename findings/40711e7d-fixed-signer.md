---
id: 40711e7d-fixed-signer
title: "0x40711e7d: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x40711e7d328b5b97737c869a23e43b3c147ce638"
  family: "2cb44e6f2b16ce8ef5def29c32cd89ec"
  upgradeable: "yes"
  admin: "0x9e3ff47de7877689e73e286d6d3856e08714c212 (ProxyAdmin (Ownable)), owned by 0xf7dbe6729e9eeec33b16472c70d79e3e9c98c3f6 (Safe 1.3.0, 2-of-5 owners)"
  rating: LOW
  txs_90d: 3
  last_active: 2026-11-05
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0xf7dbe6729e9eeec33b16472c70d79e3e9c98c3f6"
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
- Update path, read at block 26,438,999: proxy to 0xc4ea4b0fd176743635091ba63b3c46f9db49cabc, admin 0x9e3ff47de7877689e73e286d6d3856e08714c212.
- EIP-1967 admin slot = 0x9e3ff47de7877689e73e286d6d3856e08714c212, implementation = 0xc4ea4b0fd176743635091ba63b3c46f9db49cabc at block 26438999
- 0x9e3ff47de7877689e73e286d6d3856e08714c212: ProxyAdmin (Ownable); owner() = 0xf7dbe6729e9eeec33b16472c70d79e3e9c98c3f6
- 0xf7dbe6729e9eeec33b16472c70d79e3e9c98c3f6: Safe 1.3.0, 2-of-5 owners at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-11-05.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
