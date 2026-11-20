---
id: 7244dbf4-signer-upgrade-only
title: "0x7244dbf4: signer replaceable only by an upgrade"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x7244dbf4461daa2a51d1c2424bc296e0e60d8f5f"
  family: "001223f7dc4e14cb79a27516ba117da9"
  copies: 19
  upgradeable: "no"
  rating: HIGH
  value_usd: 2300
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owners, before migrating (move funds out)"
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
  rating: HIGH
  note: "A multisig whose fixed signer set can never be replaced, so HIGH"
---

## Summary

A 2-owner multisig behind a minimal proxy. setup(address[]) can run only once, no function replaces the owners, and the implementation has no upgrade function. Executions need the owners' ecrecover signatures. Owners: 0x9a5a06ac…, 0x685be413….

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x53d3676ce54e00f3760fef931afb1ad8ef61781a: no admin, no upgrade function in the implementation.
- The decompiled implementation has only setup (reverts 'Contract has been set up before'), execute 0x58cb5e5a, getOwners and getTransactionHash; there is no owner setter or upgrade
- getOwners() lists the 2 owners (dossier state.json at block 26438999); both are EOAs (latest block ~26452920)
- Proxy slot 0 points at a fixed implementation; balance > 0.5 ETH (node survey, block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $2,300 (ETH and 49 priced tokens, over 19 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owners move the funds to a new wallet before migrating

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
