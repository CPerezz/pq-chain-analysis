---
id: opengsn-d216153c-signature-rechecked
title: "RelayHub: a signature checked again after others relied on it"
project: opengsn
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xd216153c06e857cd7f72665e0af1d7d82172f494"
  family: "b356a0502cd82b95df81dd3568b41aa1"
  copies: 3
  name: "RelayHub"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 18361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 14
  last_active: 2026-10-07
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
  note: "fraud proofs against relays fail"
---

## Summary

`RelayHub` at `0xd216153c06e857cd7f72665e0af1d7d82172f494`, with 2 more addresses running its code. It checks a signature again after others relied on it; once the signer's account has code, that check fails and the party that relied on it loses.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: GSN v1 checkSig: true when the signer its caller names signed / GSN v1 canRelay: the `from` of the relayed call must have signed; a user can always call the recipient itself / GSN v1…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read (GSN v1 RelayHub): penalizeRepeatedNonce and penalizeIllegalTransaction prove a relay's misbehaviour from transactions it signed; a relay whose address took code can no longer be penalised, so recipients it cheated lose the relay's stake as compensation.
- removeRelayByOwner is the relay owner's own action. No proxy, no upgrade. 14 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $18,361 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 14 transactions called it in the 90 days before that block; last on 2026-10-07.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
