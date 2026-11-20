---
id: 2eff34eb-signer-upgrade-only
title: "0x2eff34eb (tagged deployed by Pimlico: ERC-4337 Bundler 214): signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x2eff34eb555d45e7a855513ee6047151be4db150"
  family: "5cae3d8d1e82086e21bb91e177da7cf4"
  label: "deployed by Pimlico: ERC-4337 Bundler 214"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: executed
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
  note: "Refuted: the address is an implementation whose initializers are disabled and whose signer is unset."
---

## Summary

Uninitialized implementation contract (UUPS, stored key set): its own storage has no signer, owner or funds; proxies that run it keep their own state and upgrade path and are rated as their own rows.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- OZ5 Initializable slot 0xf0c57e16…6a00 = 0xff..ff (initializers disabled) at 26438999 (chain1)
- owner() returns zero or reverts at 26438999; EIP-1967 implementation and admin slots are empty (chain1)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
