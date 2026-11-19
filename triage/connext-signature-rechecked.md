---
id: connext-signature-rechecked
title: "2 contract families (1,652 addresses): under EIP-8151 a signature others relied on fails once its signer has code"
project: connext
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xdef55d8b43337f61876cdfd3aa34c19fadd3b9f6"
  name: "ChannelMastercopy (study family 58b8e695), 1 of 1,647 addresses running it"
  upgradeable: "no"
- address: "0xbf2aeab03b82c182599930217272ef0fc5cf662b"
  name: "ECTools (study family 5c6fba46), 1 of 5 addresses running it"
  upgradeable: "no"
families:
- code: "0xdef55d8b43337f61876cdfd3aa34c19fadd3b9f6"
  name: "ChannelMastercopy (study family 58b8e695)"
  instances: 1647
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 273030
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xbf2aeab03b82c182599930217272ef0fc5cf662b"
  name: "ECTools (study family 5c6fba46)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 106289
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 58b8e695, 5c6fba46"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 2 code families, 1,652 addresses, $379k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xdef55d8b43337f61876cdfd3aa34c19fadd3b9f6` (ChannelMastercopy, family `58b8e695`, 1,647 addresses, $273k): Connext Vector channel: a channel state, a withdrawal or a transfer resolution counts only with the signatures of the channel's two participants, fixed when the channel is made / Connext Vector channel (utility… Decided by: read (function text).
- `0xbf2aeab03b82c182599930217272ef0fc5cf662b` (ECTools, family `5c6fba46`, 5 addresses, $106k): Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must have signed the final balances / Connext ledger… Decided by: read (function text).
