---
id: connext-bf2aeab0-signature-rechecked
title: "ECTools: a signature checked again after others relied on it"
project: connext
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xbf2aeab03b82c182599930217272ef0fc5cf662b"
  family: "5c6fba46e8a71080eacef5aafd837cf4"
  copies: 5
  name: "ECTools"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 106365
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10
  last_active: 2026-10-05
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
  note: "counterparty loses the dispute path"
---

## Summary

`ECTools` at `0xbf2aeab03b82c182599930217272ef0fc5cf662b`, with 4 more addresses running its code. It checks a signature again after others relied on it; once the signer's account has code, that check fails and the party that relied on it loses.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must have signed the final…. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read (Connext ledger channel, ECTools.isSignedBy): consensus close and updateLCstate need both parties' signatures over the state put on chain; a party that takes code after signing leaves the other without a provable state.
- Fixed delegates, no upgrade. 10 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $106,365 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-10-05.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
