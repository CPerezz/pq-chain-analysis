---
id: moolah-d7c98309-signed-shortcut-lost
title: "Moolah: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xd7c983093065e0169e955c44ab8370110231d3cf"
  family: "8d46c757914fa1b46fb89ecbd432cb61"
  copies: 2
  name: "Moolah"
  label: "deployed by Lista DAO: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 9619207
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 11210
  last_active: 2026-11-18
fix:
  layer: account-migration
  who_acts: "the authorizer"
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
  note: "Same act open by direct call → LOW."
---

## Summary

Morpho-style lending market: setAuthorizationWithSig recovers the authorizer; an authorizer with code fails.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Moolah (Morpho fork) setAuthorizationWithSig: the authorizer named must have signed. Read from source.
- src/moolah/Moolah.sol:632 setAuthorization(authorized,bool) is a direct call by msg.sender
- positions are managed directly by their owner

## Impact and exposure

- Value held at block 26,438,999: $9.6M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 11,210 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Authorizer calls setAuthorization directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
