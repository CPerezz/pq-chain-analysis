---
id: 81e54d11-signer-upgrade-only
title: "0x81e54d11: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x81e54d1198d5ab7df155ae5f0997c3c30f1bfa88"
  family: "f4a8b68cad6658cadfc5cfd77bf5068e"
  copies: 4
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody — no update path exists"
evidence:
  level: bytecode
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
  rating: MEDIUM
  note: "No update path (upgrades=[] contradicts the row's 'code can be replaced' guess), but transfer() remains a working exit so nothing is locked — MEDIUM, not HIGH."
---

## Summary

The row address is itself a live EIP-1967 (UUPS-style, admin slot zero) proxy to implementation 0xb577741cec5b1dfe85561abc0a4f82d224091db0 (22,745 bytes); the facts pipeline found no setter and no upgrade selector anywhere in that implementation. A signature-gated function (not named in the facts) dies for good, but plain transfer(address,uint256) is listed as a working exit, so held balances are not stuck.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- node, block 26438999: eip1967 implementation slot = 0xb577741cec5b1dfe85561abc0a4f82d224091db0, admin slot = 0 (no separate ProxyAdmin)
- batch facts: implementation_bytes=22745, setters=[], upgrades=[], exits=["transfer(address,uint256)"] — no replace mechanism for the signer or the code was found

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None available on-chain; a fresh deployment would be needed to replace the signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
