---
id: 04acaf8d-signed-shortcut-lost
title: "0x04acaf8d (tagged Frax Finance: WFRAX Token): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x04acaf8d2865c0714f79da09645c13fd2888977f"
  family: "14ef3b9209141f306b99f0a0045521ed"
  copies: 2
  label: "Frax Finance: WFRAX Token"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 16550
  last_active: 2026-11-18
  recoveries_14d: 4
fix:
  layer: none
  who_acts: "the affected holder, by calling transfer/approve itself"
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
  note: "LOW: same act open by transfer/approve to the same party; only a signing convenience is lost."
---

## Summary

Frax Finance: WFRAX Token: ERC-3009 transfer/receive/cancelWithAuthorization (and permit where present) need the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use cancelAuthorization, permit, permit(bytes), receiveWithAuthorization, transferWithAuthorization; it can still call approve, transfer itself: a way of…. Rule: permit-like. Executed: a real transaction loses its effect with code at the signer.
- transfer(address,uint256) by the holder is the direct path (selector 0xa9059cbb present)
- approve for the permit act (0x095ea7b3 present)
- row note: a holder whose address has code can no longer use cancelAuthorization, permit, permit(bytes), receiveWithAuthorization, transferWithAuthorization; it can still call approve, transfer itself: a way of…. Rule: permit-like.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 16,550 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

holder calls transfer/approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
