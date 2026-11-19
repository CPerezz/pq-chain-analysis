---
id: coordinationpaymentchannels-2f06f0df-own-signature-only-exit
title: "CoordinationPaymentChannels: funds released only by the party's own signature"
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6"
  family: "0d0deff0f3a759cfc98bad3d4001f3df"
  copies: 2
  name: "CoordinationPaymentChannels"
  upgradeable: "no"
  rating: HIGH
  value_usd: 15778
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "each party acts before its address takes code"
evidence:
  level: source-read
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
  rating: HIGH
  note: "stakers' own stakes locked"
---

## Summary

`CoordinationPaymentChannels` at `0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6`, with 1 more addresses running its code. It releases a party's funds or rights only on that party's own ECDSA signature; once the party's account has code, they are locked.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: CoordinationPaymentChannels: a staker withdraws only with its own ECDSA signature on a commitment next to the coordinator's; a staker whose account takes code cannot withdraw. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: initiateTimelockedWithdrawal and executeInstantWithdrawal both require ECDSA.recover(...) == commitment.stakeAddress next to the coordinator's signature; executeTimelockedWithdrawal only finishes what was initiated. A staker whose address has code cannot start a withdrawal.
- The coordinator is replaceable (updateCoordinatorAddress); stakers' keys are not. No proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $15,778 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Act before migrating the address; new deployments accept ERC-1271 or a direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
