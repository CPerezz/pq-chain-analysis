---
id: boringvault-cba69e0d-signed-shortcut-lost
title: "BoringVault: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xcba69e0d7499acfb6e5c4c9cdaa175334725b206"
  family: "f9a8003e45dd3a95242006e5b02551d2"
  copies: 41
  name: "BoringVault"
  label: "Paxos: PAXGy Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 1410625
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6711
  last_active: 2026-11-18
  recoveries_14d: 8
fix:
  layer: account-migration
  who_acts: "the token holder"
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
  note: "Standard signed shortcut; same act open by direct call → LOW."
---

## Summary

BoringVault (Paxos: PAXGy Token): a signed shortcut (permit/authorization) requires the recovered address to equal the named owner; EIP-8151 makes it fail for an owner whose address holds non-delegation code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read from source. Executed: a real transaction reverts with code at the signer.
- the dossier source has the standard approve (and transfer) the holder calls directly
- code at block has approve selector 0x095ea7b3 or source defines approve; no signature needed
- study note: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read from source. Executed: a real transaction reverts with

## Impact and exposure

- Value held at block 26,438,999: $1.4M (ETH and 49 priced tokens, over 41 addresses).
- Activity: 6,711 transactions called it in the 90 days before that block; last on 2026-11-18.
- 8 signature recoveries in the study's two-week trace window.

## Remediation

Holder calls approve (or the direct function) itself instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
