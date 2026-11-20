---
id: d48e5655-signed-shortcut-lost
title: "0xd48e5655: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xd48e565561416de59da1050ed70b8d75e8ef28f9"
  family: "f0476b6c95bdbbbd54c61e020df78e25"
  copies: 4
  upgradeable: "yes"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1547
  last_active: 2026-11-17
  recoveries_14d: 3
fix:
  layer: offchain
  who_acts: "token holder (calls approve itself)"
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
  note: "signed shortcut lost, approve stays open to the same holder → LOW."
---

## Summary

unnamed token: permit needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use cancelAuthorization, permit, permit(bytes), receiveWithAuthorization, transferWithAuthorization; it can still call approve, transfer itself: a way of…. Rule: permit-like.
- permit(v,r,s) called at block 26438999 with an owner whose code answers ERC-1271 (state override) reverts: recovery-only, no ERC-1271 fallback
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb
- permit(address,address,uint256,uint256,bytes) with an ERC-1271 owner succeeds: the bytes variant handles a signer with code; transferWithAuthorization(v,r,s) reverts

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,547 transactions called it in the 90 days before that block; last on 2026-11-17.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
