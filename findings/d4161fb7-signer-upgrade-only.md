---
id: d4161fb7-signer-upgrade-only
title: "0xd4161fb7: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd4161fb7aa24b2485c8328116db3165d63a5a3d3"
  family: "9a0a1455a427817128a1088895a35ae5"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "Uninitialized implementation that nothing runs, holding nothing: refuted."
---

## Summary

UFarmPool UUPS implementation, uninitialized, and no proxy runs it. The signer roles are also taken from an external PoolAdmin contract, not from a fixed key.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: an upgradeable fund pool whose ERC-1271 accepts signatures of its admins (6 recoveries). Bytecode and names. Executed: a real transaction is unaffected by code at the signer.
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- Dossier state at 26438999: owner() = 0, name() empty, totalSupply() = 0, decimals() = 0, slots 0-2 zero, balance 0; proxiableUUID() answers, so this is the implementation itself
- Family 9a0a1455 facts: addresses_that_run_it = 1 (this address, direct); no proxy or beacon found
- Decompile: role checks call poolAdmin (slot 0x1f8) isAbleToManageFunds/0x94bd4a67; isValidSignature first accepts hashes stored by signMessage

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
