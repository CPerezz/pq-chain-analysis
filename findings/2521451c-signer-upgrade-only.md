---
id: 2521451c-signer-upgrade-only
title: "0x2521451c (tagged deployed by Pimlico: ERC-4337 Bundler 5): signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x2521451c902a3ccfa577b693194f4a81c7091c05"
  family: "fb32c3b54373b65b20fdfeb35a03a3ea"
  copies: 2
  label: "deployed by Pimlico: ERC-4337 Bundler 5"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "Refuted as an uninitialized implementation: no signer is stored at this address and nothing reaches the check with real state. The upgradeTo* functions are UUPS onlyProxy, so the real update path sits at the proxy level."
---

## Summary

The address is a UUPS implementation contract, not a live signer holder: proxiableUUID() answers the EIP-1967 slot (it reverts when delegated), and its own storage was never initialized. The stored key lives in each proxy, and each proxy's own upgrade authority can replace the code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Placed by a rule; copy of template 4a2c7a03, not read on its own.
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 2 with an upgrade function whose caller was not read.
- proxiableUUID() at block 26438999 = 0x360894a1…bbc, so this is a direct (non-delegated) UUPS implementation
- Initializer state: slots 0-5 and the Solady/OZ initializable slots are empty, owner()/signer getters return zero or revert
- EIP-1967 implementation slot empty, balance 0 ETH, nonce 1
- Not a byte copy of template 4a2c7a03 ('differs, placed by a rule'); upgrades: upgradeTo(address), upgradeToAndCall(address,bytes); label deployed by Pimlico: ERC-4337 Bundler 5

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None at this address. Proxies that delegate here are separate rows, and their upgrade authority can replace the code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
