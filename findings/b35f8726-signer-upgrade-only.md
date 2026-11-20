---
id: b35f8726-signer-upgrade-only
title: "0xb35f8726: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb35f87268ae12f97dfc508aef2045d102c6475ff"
  family: "b24b1fb1cb893bdb1e2484ac76eaf15a"
  upgradeable: "yes"
  admin: "0x409062a018e3355f158f0d13df222e161df92d79 (EOA with 7702 delegation, n=244)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "proxy admin 0x409062a0"
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
  rating: LOW
  note: "A live admin can upgrade, so this is LOW. The 'set of keys in storage' reading looks off: the recovered address is compared to a calldata address with per-signer nonces."
---

## Summary

Live implementation of transparent proxy 0x67cfa128, whose admin is a live 7702-delegated EOA. An upgrade fixes it.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- proxy 0x67cfa12859f18df8e7b2d3b2209e629cc5623b4a: impl slot = 0xb35f8726, admin slot = 0x409062a018e3355f158f0d13df222e161df92d79, balance 0.00036 ETH (state.json @26438999)
- admin 0x409062a0: 7702 delegation, nonce 244 (proxyprobe @26438999)
- heimdall: setGovernance/setEmergencyAdmin; signer flows eq_calldata + map_key (getSigNonce(address)) - the signer is named in the call, not a fixed stored set

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The proxy admin upgrades the implementation if needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
