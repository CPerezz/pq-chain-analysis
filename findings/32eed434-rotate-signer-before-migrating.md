---
id: 32eed434-rotate-signer-before-migrating
title: "0x32eed434: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x32eed43402adcd16d628f4f55f6bc8b06c659ce8"
  family: "8e8ed0e3d18d404eae7ecec0d3dbb305"
  copies: 3
  upgradeable: "yes"
  admin: "owner EOA 0x63fD68eC1cfe0F6A05Ef2977222a490EEE354ef2 (UUPS) on proxy 0x42f741dd…"
  rating: LOW
  txs_90d: 1104
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner 0x63fD68eC1cfe0F6A05Ef2977222a490EEE354ef2 of proxy 0x42f741dd356404df0fb5ab6160cec7a10834e55e"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: owner-gated setter, owner is an active EOA. Only one of the three copies' proxies was identified."
---

## Summary

UUPS Ownable implementation (unverified) with an allowedOracles set (signatures/isValidSignature from oracles), used by proxy 0x42f741dd…e55e. Under EIP-8151 an oracle with real code stops verifying.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (addOracle, removeOracle). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- trace_filter at block 26438676: proxy 0x42f741dd… delegatecalls 0x32eed434…; its implementation slot = 0x32eed434… at block 26438999
- Decompiled addOracle (0xdf5dd1a5) and removeOracle (0xfdc85fc4) require msg.sender == owner() (Solady Unauthorized 0x30cd7471)
- owner() of proxy = 0x63fD68eC… at block: EOA, nonce 90

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1,104 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The owner calls addOracle(newKey)/removeOracle(old) before an oracle account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
