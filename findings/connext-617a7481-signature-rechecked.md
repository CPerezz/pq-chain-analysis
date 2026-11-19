---
id: connext-617a7481-signature-rechecked
title: "ChannelMastercopy: a signature checked again after others relied on it"
project: connext
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x617a74814d2c73b4a1655633c97654274cdb8775"
  family: "58b8e695129ef8eab1cfe41710150735"
  copies: 1647
  name: "ChannelMastercopy"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 272963
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
  note: "counterparty loses the dispute path"
---

## Summary

`ChannelMastercopy` at `0x617a74814d2c73b4a1655633c97654274cdb8775`, with 1,646 more addresses running its code. It checks a signature again after others relied on it; once the signer's account has code, that check fails and the party that relied on it loses.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Connext Vector channel: a channel state, a withdrawal or a transfer resolution counts only with the signatures of the channel's two participants, fixed when the channel is made / Connext Vector…. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read (Connext Vector): a channel state, a withdrawal or a transfer resolution counts only with both participants' signatures, fixed when the channel is made. A participant who takes code after signing makes the counterparty's latest state unprovable on chain.
- The 1,647 channels are fixed delegates to ChannelMastercopy; no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $272,963 (ETH and 49 priced tokens, over 1,647 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
