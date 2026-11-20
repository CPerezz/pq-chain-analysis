---
id: c31d50ab-wallets-fixed-signers
title: "0xc31d50ab: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc31d50abc481491a0b78ffb594a25322d2747792"
  family: "a22738e82acee733123c4d51debea1bc"
  upgradeable: "no"
  rating: NONE
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "the contract's admins (3 of 6) by signed admin update"
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
  note: "The signer set is settable by quorum → refuted (rotate-signer-before-migrating). The 6 admin addresses were not enumerated: logs could not be fetched (RPC range limit of 10000 blocks, then timeouts). This does not change the verdict, unless 4 or more admins already have code."
---

## Summary

Not a SimpleMultiSig. It is a 14.9 KB role/admin contract with Chainlink price reads (getCurrentPrice, latestRoundData), a role-gated payable function, and a signed ETH withdrawal 0x05ebeeb0. Every signed action needs adminThreshold OZ-ECDSA admin signatures, and 0xf3bbde75 adds or removes admins and resets the threshold under those same signatures, so the signer set is replaceable.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- sels.txt: adminCount, adminThreshold, configNonce, ADMIN_ROLE, MANAGER_ROLE, hasRole, getCurrentPrice + ~40 unknown selectors; heimdall: 0xf3bbde75 writes the admin map, adminCount and adminThreshold and emits AdminUpdated after a signature check (OZ ECDSA errors fce698f7/f645eedf/d78bce0c); 0x05ebeeb0 signed ETH withdrawal 'ETH transfer failed'; 0x15730cad signed feed config
- at block 26438999: adminCount=6, adminThreshold=3, configNonce=3; ETH balance 0.001; 1967 slots 0
- Etherscan cache: Unverified, creator 0xaeb4a97b068304ab9de6adff13f391970c7e2356, created ~107 days before the cache date
- batch row: value_usd 2, txs_90d 0, last_active null, copies null

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admins rotate any admin key that will take code out of the admin set via a signed admin update, keeping at least 3 recoverable admins.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
