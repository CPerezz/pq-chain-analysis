---
id: seelebridge-cad5a42d-rotate-signer-before-migrating
title: "SeeleBridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcad5a42d74f66d96650fdf1a1b1d738dedb7d876"
  family: "374885151ae28d9077a0809096fb2898"
  copies: 2
  name: "SeeleBridge"
  label: "deployed by SeeleN: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 71100
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner EOA 0x8660…5130"
evidence:
  level: source-read
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
  note: "Live upgrade path (ProxyAdmin owned by an active EOA) plus a signature-based valset rotation."
---

## Summary

SeeleBridge (Gravity fork, transparent proxy): validator set signatures checked by ecrecover; updateValset rotates the set only with current validators' signatures.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Seele bridge (Gravity fork): the validator set is replaced by updateValset. Read by hand.
- SeeleBridge.sol:1755 updateValset is signed by the current valset (no owner setter); owner has upgrade (ProxyAdmin) and withdraw(token, amount) onlyOwner (l.2221)
- EIP-1967 admin = ProxyAdmin 0x32462e97…db97, owner() = 0x86601ae7…5130, an EOA with nonce 464; the bridge owner() is the same EOA
- validators below the power threshold can still rotate a migrating member out via updateValset

## Impact and exposure

- Value held at block 26,438,999: $71,100 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Validators rotate the migrating key out with updateValset while the threshold is met; otherwise the owner upgrades the implementation through ProxyAdmin.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
