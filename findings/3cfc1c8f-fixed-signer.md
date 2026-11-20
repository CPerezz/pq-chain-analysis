---
id: 3cfc1c8f-fixed-signer
title: "0x3cfc1c8f: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3cfc1c8f3ab1ebd58a5174d8020c6a015363f057"
  family: "62948dcbc6a0a85f58a6530a8a865d58"
  upgradeable: "yes"
  admin: "0xfc883afdca9f704522a6e28647605d719ccc8721 (custom 879-byte admin contract embedded as an immutable in the 793-byte proxy), owned by 0x651ed4cc2557d2956f1e98e2dbe57c755403ce26 (EOA, nonce 902)"
  rating: LOW
  value_usd: 6
  value_basis: held
  value_as_of: 2026-11-18
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
- Update path, read at block 26,438,999: proxy to 0xcc497df9aed4fa35d1f98c47d754e7294f3a42c7, admin 0xfc883afdca9f704522a6e28647605d719ccc8721.
- EIP-1967 admin slot = 0xfc883afdca9f704522a6e28647605d719ccc8721, implementation = 0xcc497df9aed4fa35d1f98c47d754e7294f3a42c7 at block 26438999
- 0xfc883afdca9f704522a6e28647605d719ccc8721: custom 879-byte admin contract embedded as an immutable in the 793-byte proxy; owner() = 0x651ed4cc2557d2956f1e98e2dbe57c755403ce26
- 0x651ed4cc2557d2956f1e98e2dbe57c755403ce26: EOA, nonce 902 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $6 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
