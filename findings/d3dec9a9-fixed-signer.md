---
id: d3dec9a9-fixed-signer
title: "0xd3dec9a9: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd3dec9a9a1fd04402b20333434ee1b46e8c54c2f"
  family: "c9e7c2e0e02b2f17edeace3a730624e5"
  upgradeable: "yes"
  admin: "0x160d6aa85fe0a371f9d0804d6653201557f535be (ProxyAdmin (Ownable)), owned by 0xcdae2f6680fea894bd088377c9a97db79f762bb0 (EOA, nonce 133)"
  rating: LOW
  txs_90d: 1
  last_active: 2026-09-25
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0xcdae2f6680fea894bd088377c9a97db79f762bb0"
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

DogZone721 free mint: signed by `signer`, set at construction, no setter in the source; EIP-8151 makes the fixed signer's signature fail once that signer has code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DogZone721 free mint: signed by `signer`, set at construction, no setter in the source. Same code idiom as template d4de1d4c, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x3c1c6eb9176ed338ae8e767305830b7da3fd7ee7, admin 0x160d6aa85fe0a371f9d0804d6653201557f535be.
- EIP-1967 admin slot = 0x160d6aa85fe0a371f9d0804d6653201557f535be, implementation = 0x3c1c6eb9176ed338ae8e767305830b7da3fd7ee7 at block 26438999
- 0x160d6aa85fe0a371f9d0804d6653201557f535be: ProxyAdmin (Ownable); owner() = 0xcdae2f6680fea894bd088377c9a97db79f762bb0
- 0xcdae2f6680fea894bd088377c9a97db79f762bb0: EOA, nonce 133 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
