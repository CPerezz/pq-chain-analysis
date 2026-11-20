---
id: a5fef013-wallets-fixed-signers
title: "0xa5fef013 (tagged deployed by Staker: Deployer): wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa5fef01330c965f6c7cf1e624ab8a7f3310235e8"
  family: "d233af790d818cb4afc55cb73bd6576a"
  copies: 19
  label: "deployed by Staker: Deployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "the owners (2-of-3)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Signer set replaceable by signed call → refuted."
---

## Summary

SimpleMultiSig-like (owners/isOwner/threshold/nonce), but selector 0x1113c9a0 is a threshold-signed owner reset: it verifies signatures over 0x19‖this‖args‖nonce, bumps nonce, rewrites owners and threshold.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly: 0x1113c9a0 → sig check (0x28a), nonce++, owner-rewrite routine 0x366 (clears isOwner flags, writes owners array), SSTORE slot 3 (threshold)
- At 26438999 (reth): owners 0x1d6a…22d3, 0xe7bb…0d74, 0x1966…b755 (all EOAs today), threshold 2, nonce 0; ETH 0; signer code-today checks (latest, block ~26452900, publicnode)
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 19 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign an owner reset to new keys before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
