---
id: coordinationpaymentchannels-2f06f0df-signature-rechecked
title: "CoordinationPaymentChannels: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6"
  family: "0d0deff0f3a759cfc98bad3d4001f3df"
  copies: 2
  name: "CoordinationPaymentChannels"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 15778
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "parties settle before a signing address takes code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "coordinator loses signed commitments"
---

## Summary

`CoordinationPaymentChannels` at `0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6`, with 1 more addresses running its code. It checks a signature again after others relied on it; once the signer's account has code, that check fails and the party that relied on it loses.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: CoordinationPaymentChannels: a staker withdraws only with its own ECDSA signature on a commitment next to the coordinator's; a staker whose account takes code cannot withdraw. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: settleSpentStake needs the staker's and the coordinator's signatures over a commitment; a staker who takes code after signing makes spent stake unsettleable, so the coordinator loses what it paid out on that promise.
- No proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $15,778 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
