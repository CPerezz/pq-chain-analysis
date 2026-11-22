---
id: portal-ec000064-signed-shortcut-lost
title: "Portal: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xec000064576f9c95a8623bc0eff3db6d296ea6df"
  family: "c5f652cd48cf6b4d21da35f148c31b46"
  copies: 7
  name: "Portal"
  upgradeable: "no"
  rating: LOW
  value_usd: 40
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 64391
  last_active: 2026-10-27
fix:
  layer: offchain
  who_acts: "the user (calls open directly)"
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
  note: "signed shortcut lost, same act open by a direct call to the same party → LOW."
---

## Summary

Eco Portal / OriginSettler: openFor takes the user's gasless order signature (recover == order.user); a user with code cannot open by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Eco OriginSettler _validateOrderSig: the user named signs a gasless order; the user can open it directly / Eco IntentSource recoverToken: no signature in this function. Read (function text).
- OriginSettler._validateOrderSig: hash.recover(signature) == order.user, no ERC-1271 (dossier source)
- OriginSettler.open(OnchainCrossChainOrder) lets the user open the order directly (dossier source line 48)

## Impact and exposure

- Value held at block 26,438,999: $40 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 64,391 transactions called it in the 90 days before that block; last on 2026-10-27.

## Remediation

the affected party uses the direct call instead of the signed path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
