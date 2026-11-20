---
id: 93a4e1af-wallets-fixed-signers
title: "0x93a4e1af (tagged deployed by Valinity: Deployer): wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x93a4e1af91c97561df697c2092c371141b6828c8"
  family: "ea45a93a0670a109f45ac3bab12c192d"
  copies: 2
  label: "deployed by Valinity: Deployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "the owner (1-of-1)"
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
  note: "Signer settable → refuted."
---

## Summary

Verified MultiSig (SimpleMultiSig-like execute) but with setOwners(threshold, owners[]) callable by the multisig itself through execute, so owners are replaceable.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- setOwners: require(address(this)==msg.sender, 'Can only be called by multisig'), rewrites owners and threshold (heimdall)
- At 26438999 (reth): threshold 1, ownersArr = [0xa75c…9c90] (EOA today, nonce 8), nonce 6; ETH 0; signer code-today checks (latest, block ~26452900, publicnode)
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner executes setOwners to new keys before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
