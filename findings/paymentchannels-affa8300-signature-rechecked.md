---
id: paymentchannels-affa8300-signature-rechecked
title: "PaymentChannels: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1"
  family: "f37d66ccf0e1a2b64767777737114dec"
  copies: 2
  name: "PaymentChannels"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 101366
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-17
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
  note: "notary and payees lose signed commitments"
---

## Summary

`PaymentChannels` at `0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1`, with 1 more addresses running its code. It checks a signature again after others relied on it; once the signer's account has code, that check fails and the party that relied on it loses.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: PaymentChannels: a staker can start or finish an unstake only with its own ECDSA signature on a commitment, next to the notary's; there is no path without it, so a staker whose account takes code…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand: stake commitments are signed promises that the notary settles later; a staker who takes code after signing makes its commitments unsettleable, so the notary and payees lose what was promised.
- No proxy, no upgrade.

## Impact and exposure

- Value held at block 26,438,999: $101,366 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-17.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
