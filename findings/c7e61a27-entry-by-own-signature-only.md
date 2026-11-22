---
id: c7e61a27-entry-by-own-signature-only
title: "0xc7e61a27: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0xc7e61a273517271b52ffb93321a4d2a46c217532"
  family: "dd37bc8e0d6e45f74b57cb42f63f1a96"
  copies: 4
  upgradeable: "no"
  rating: LOW
  value_usd: 4150
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the maker (sign orders from an EOA)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Entry only: locked order funds have cancel and withdraw paths with no signature."
---

## Summary

Unverified LayerZero cross-chain intent escrow (4 copies): a solver deposits a maker-signed order (deposit(order,bytes)) that locks the maker's tokens. A maker with code cannot sign new orders.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: orders signed by the maker named. Bytecode and names.
- heimdall (from the dossier code.hex): cancel(bytes32) needs no signature; it lets the solver, or the offerer after expiry, cancel an active order and move the locked amount to the unlocked balance
- withdraw(address) pays msg.sender its unlocked balance with no signature; owner-only emergencyCancel(bytes32) and emergencyWithdraw also exist
- row value_usd 4150 (held); owner slot_0 = 0xb4afac168ca0cce40c5b4d4e8e49a1e18a630b40

## Impact and exposure

- Value held at block 26,438,999: $4,150 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed; makers sign with EOAs.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
