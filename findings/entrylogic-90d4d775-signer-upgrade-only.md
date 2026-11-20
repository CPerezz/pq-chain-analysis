---
id: entrylogic-90d4d775-signer-upgrade-only
title: "EntryLogic: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x90d4d7753a5d7d623f25927b4d30ff34b9246551"
  family: "4ccd8b345d2dcbbaea1cfccf0d05342b"
  name: "EntryLogic"
  upgradeable: "yes"
  admin: "3-of-5 Safe 0xd4090073472F02D860e65f71f8B96d3Ac236D3CE"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "3-of-5 Safe 0xd4090073472F02D860e65f71f8B96d3Ac236D3CE via ProxyAdmin 0x9c968a4007979040a2c3dbcdbc8e78bb2d0a4ad2"
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
  note: "Live 3-of-5 Safe admin found on-chain — LOW."
---

## Summary

EntryLogic bridge fee quote (feeSigner check) is behind a live TransparentUpgradeableProxy with a real admin, contradicting the row's 'no proxy slot, no upgrade function'.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: bridge fee quote: the signer must be feeSigner. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- node, block 26438999: proxy 0x2ef5513ed9c44ddff9ff10b5120426cabd27c49d, eip1967 implementation = 0x90d4d7753a5d7d623f25927b4d30ff34b9246551 (matches, live), admin = ProxyAdmin 0x9c968a40... (nonce 1), owner() of that ProxyAdmin = Safe 0xd4090073...
- node: Safe getThreshold()=3, getOwners()=5 addresses, all EOAs with real nonces (111, 3, 4, 9, 5) — live

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Safe upgrades the proxy to an implementation with a replaceable feeSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
