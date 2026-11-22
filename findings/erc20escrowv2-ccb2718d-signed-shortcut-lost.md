---
id: erc20escrowv2-ccb2718d-signed-shortcut-lost
title: "ERC20EscrowV2: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xccb2718d633ed28bdf0639134380e2f5b05162b5"
  family: "ba1ed685933342c5f46663c2bfeb2adf"
  name: "ERC20EscrowV2"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 151583
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 16254
  last_active: 2026-11-18
  recoveries_14d: 3984
fix:
  layer: none
  who_acts: "buyer/seller; the owner"
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
  rating: MEDIUM
  note: "The dispute act has no direct path, but funds stay movable (release, cancel, owner rescue), so MEDIUM. Reviewer: the study and the reading say LOW."
---

## Summary

ERC20EscrowV2 trade escrow: release and buyerCancel are direct, but opening a dispute is signature-only (the arbitrator submits). A buyer or seller with code cannot open a dispute.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: trade escrow in tokens, the same design as ETHEscrowV2 (its functions and caller checks listed by grep, ETH version read): direct release and buyerCancel, relayed signatures, disputes only with a…. Read by hand. Executed: a real transaction reverts with code at the signer.
- reading.first.json: release (msg.sender == seller, line 227) and buyerCancel (msg.sender == buyer, line 240) are direct
- reading.first.json: the dispute path has no path without ecrecover; resolveDispute always recovers
- Owner claimStuck/withdrawTo moves stuck tokens; relayer signers are replaceable by the owner via setRelayerSigners

## Impact and exposure

- Value held at block 26,438,999: $151,583 (ETH and 49 priced tokens).
- Activity: 16,254 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,984 signature recoveries in the study's two-week trace window.

## Remediation

The parties use direct release or cancel; the owner can rescue funds with claimStuck.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
