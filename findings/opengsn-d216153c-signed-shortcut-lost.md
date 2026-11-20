---
id: opengsn-d216153c-signed-shortcut-lost
title: "RelayHub: signed shortcut lost by users with code"
project: opengsn
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd216153c06e857cd7f72665e0af1d7d82172f494"
  family: "b356a0502cd82b95df81dd3568b41aa1"
  copies: 3
  name: "RelayHub"
  upgradeable: "no"
  rating: LOW
  value_usd: 18407
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 14
  last_active: 2026-10-07
fix:
  layer: offchain
  who_acts: "the user"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $18407, txs_90d 14."
---

## Summary

GSN v1 RelayHub: relayCall needs the `from` user's signature; under EIP-8151 a user with code cannot be relayed.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: GSN v1 checkSig: true when the signer its caller names signed / GSN v1 canRelay: the `from` of the relayed call must have signed; a user can always call the recipient itself / GSN v1…. Read from source.
- canRelay/relayCall check the user's signature over the relayed call (RelayHub.sol:87, 134)
- The user can call the recipient contract itself; the hub is optional
- Relay-signed proofs (penalize*) only punish relays

## Impact and exposure

- Value held at block 26,438,999: $18,407 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 14 transactions called it in the 90 days before that block; last on 2026-10-07.

## Remediation

The user calls the recipient directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
