---
id: c465b061-signer-upgrade-only
title: "0xc465b061: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc465b061c4814d01da3e80dbea82f7ea3990d9f0"
  family: "86044ce8870cfa9666787494039e5e2c"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xb89c582b590d5364eaa3365b1170a98dbc415ec1, owner EOA 0xc3fC7702905038826EbCFc66D142686948f3DBAA"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "ProxyAdmin 0xb89c582b owner 0xc3fC7702"
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
  note: "A live admin can upgrade, so this is LOW."
---

## Summary

Live implementation of transparent proxy 0x9a00dabc. Its ProxyAdmin is owned by a live EOA, so an upgrade fixes it.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- proxy 0x9a00dabcb2cc9086fc5a663ce15bed080b43df22: impl slot = 0xc465b061, admin slot = 0xb89c582b590d5364eaa3365b1170a98dbc415ec1, balance 0.0113 ETH (state.json @26438999)
- ProxyAdmin owner 0xc3fC7702905038826EbCFc66D142686948f3DBAA (EOA n=48); proxy owner() 0xD27eCD30 (EOA n=44) (proxyprobe @26438999)
- heimdall: validators(address), admins(address), transferOwnership; ecrecover flows eq_caller/eq_recovered/map_key

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The ProxyAdmin owner upgrades the implementation (the validators mapping may also be settable).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
