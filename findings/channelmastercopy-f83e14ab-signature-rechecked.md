---
id: channelmastercopy-f83e14ab-signature-rechecked
title: "ChannelMastercopy: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xf83e14ab0ccb59d7715d3101f93c363302820fd8"
  family: "356434880283283fb67b67b84dd58f13"
  copies: 30
  name: "ChannelMastercopy"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 10
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "channel participants"
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
  note: "The counterparty relying on co-signed states loses its balance with no timeout and no update path; rated by mechanism, not by the small value held."
---

## Summary

Connext Vector channel (45-byte proxy to ChannelMastercopy 0x8407ef1b…): channel states (disputeChannel) and withdrawals each need the signatures of both fixed participants, alice and bob. If one participant's address takes code, the other cannot enforce the latest co-signed state or withdrawal it relied on.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Connext Vector channel: a channel state, a withdrawal or a transfer resolution counts only with the signatures of the channel's two participants, fixed when the channel is made / Connext Vector…. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address.
- CMCAdjudicator.sol:386-400 verifySignaturesOnChannelStateHash: checkSignature(aliceSignature, ccs.alice) and (bobSignature, ccs.bob)
- CMCWithdraw.sol:85-97: withdraw requires both alice's and bob's signatures
- alice and bob are fixed at setup; the proxy delegates to a fixed mastercopy (no upgrade); value $10, txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $10 (ETH and 49 priced tokens, over 30 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on chain; close channels while both participants' addresses can still sign.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
