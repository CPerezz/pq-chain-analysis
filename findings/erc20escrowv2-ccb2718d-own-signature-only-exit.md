---
id: erc20escrowv2-ccb2718d-own-signature-only-exit
title: "ERC20EscrowV2: funds released only by the party's own signature"
status: confirmed
severity: MEDIUM
patterns: [PQ-16]
impact: liveness
contracts:
- address: "0xccb2718d633ed28bdf0639134380e2f5b05162b5"
  family: "ba1ed685933342c5f46663c2bfeb2adf"
  name: "ERC20EscrowV2"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 151598
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 16254
  last_active: 2026-11-18
  recoveries_14d: 3984
fix:
  layer: offchain
  who_acts: "the owner sweeps stuck trades with claimStuck after the delay and settles them off chain"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "disputes with a party with code end in the operator's sweep"
---

## Summary

`ERC20EscrowV2` at `0xccb2718d633ed28bdf0639134380e2f5b05162b5`. A dispute is resolved only with an ECDSA signature of the buyer or the seller, so a party whose address has code cannot have it resolved; the trade's tokens then leave only through the owner's delayed sweep.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: trade escrow in tokens, the same design as ETHEscrowV2 (its functions and caller checks listed by grep, ETH version read): direct release and buyerCancel, relayed signatures, disputes only with a…. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand (same design as ETHEscrowV2): release and buyerCancel are direct calls; relayed actions and dispute resolution need a party's signature.
- claimStuck (owner, after stuckDelaySeconds, settable with setStuckDelaySeconds) moves a stuck trade's funds without a party's signature: a way out through the operator, not the parties.
- Executed: a real dispute resolution reverts once the signing party has code. 16,254 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $151,598 (ETH and 49 priced tokens).
- Activity: 16,254 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,984 signature recoveries in the study's two-week trace window.

## Remediation

The owner sweeps and settles stuck disputes; a new version accepting ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
