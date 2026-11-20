---
id: c49e8f73-fixed-signer
title: "0xc49e8f73 (tagged deployed by CIAN: Deployer): signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc49e8f73689225a644c8744e7be0f1ec4e82d0ba"
  family: "ad73b2e2048d26bf965d35abfa0fb4dc"
  label: "deployed by CIAN: Deployer"
  upgradeable: "yes"
  admin: "0xbc8adfac2bd3ea38c0742bf893c59248d5e2ac51 (ProxyAdmin (Ownable)), owned by 0x8fa9aa69a6e94c1cd49fbf214c833b2911d02553 (EOA, nonce 1815)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0x8fa9aa69a6e94c1cd49fbf214c833b2911d02553"
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
- Update path, read at block 26,438,999: proxy to 0xde7480c5fee782411d6cb4119a7b2dbd9af84352, admin 0xbc8adfac2bd3ea38c0742bf893c59248d5e2ac51.
- EIP-1967 admin slot = 0xbc8adfac2bd3ea38c0742bf893c59248d5e2ac51, implementation = 0xde7480c5fee782411d6cb4119a7b2dbd9af84352 at block 26438999
- 0xbc8adfac2bd3ea38c0742bf893c59248d5e2ac51: ProxyAdmin (Ownable); owner() = 0x8fa9aa69a6e94c1cd49fbf214c833b2911d02553
- 0x8fa9aa69a6e94c1cd49fbf214c833b2911d02553: EOA, nonce 1815 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
