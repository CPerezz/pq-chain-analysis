---
id: 31a1540e-fixed-signer
title: "0x31a1540e: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x31a1540ee18f186eafe032e6cf8ebd2132764087"
  family: "f6f2a771d5de892508adae0673978f56"
  upgradeable: "yes"
  admin: "0x99c7bfdfaab25514e491fb962e1c3c9b1be2ed1e (custom 879-byte admin contract embedded as an immutable in the 793-byte proxy), owned by 0x651ed4cc2557d2956f1e98e2dbe57c755403ce26 (EOA, nonce 902)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0x651ed4cc2557d2956f1e98e2dbe57c755403ce26"
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
  note: "LOW: a live party controls the proxy admin. The admin's upgrade function was not decoded; owner() is the only check made."
---

## Summary

launchpad mint: the signer must be SIGNER, fixed in the code; EIP-8151 makes the fixed signer's signature fail once that signer has code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x3b1246dce88a07ea58f95701f9fa89be040c0fd0, admin 0x99c7bfdfaab25514e491fb962e1c3c9b1be2ed1e.
- EIP-1967 admin slot = 0x99c7bfdfaab25514e491fb962e1c3c9b1be2ed1e, implementation = 0x3b1246dce88a07ea58f95701f9fa89be040c0fd0 at block 26438999
- 0x99c7bfdfaab25514e491fb962e1c3c9b1be2ed1e: custom 879-byte admin contract embedded as an immutable in the 793-byte proxy; owner() = 0x651ed4cc2557d2956f1e98e2dbe57c755403ce26
- 0x651ed4cc2557d2956f1e98e2dbe57c755403ce26: EOA, nonce 902 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
