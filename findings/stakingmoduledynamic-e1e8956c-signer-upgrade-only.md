---
id: stakingmoduledynamic-e1e8956c-signer-upgrade-only
title: "StakingModuleDynamic: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe1e8956cc44fea05d48cae5c129e1a1aa15560ee"
  family: "a873e2ae8a2090d2f7fd6a9c4fde765d"
  name: "StakingModuleDynamic"
  upgradeable: "yes"
  admin: "privileged address 0x9fda1612… (EOA, nonce 2) via UUPS upgradeTo"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "privileged EOA 0x9fda1612… (from registry 0x84f14de1…)"
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
  note: "Same act open by direct call and a live UUPS owner: LOW."
---

## Summary

StakingModuleDynamic implementation behind UUPS proxy 0xc8d1fc9f…. The signed admin setters accept the registry's privileged address, which can also call them directly with no signature and can upgrade.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: StakingModuleDynamic processSignatureVerification: the verification address calls, or signs. Read (function text).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- Source ERC712CustomUpgradeable.processSignatureVerification: if msg.sender == verificationAddr the signature is skipped
- Source StakingModuleDynamic: _authorizeUpgrade is onlyOwner, i.e. msg.sender == privilegedAddressObj.getPrivilegedAddress()
- Proxy 0xc8d1fc9f… impl slot = 0xe1e8956c; slot 54 = registry 0x84f14de1…; getPrivilegedAddress() = 0x9fda1612E0dd49901f937487E2D351713BD858ED (no code, nonce 2) at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Privileged address calls the setters directly, or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
