---
id: tokennetwork-21787564-signature-rechecked
title: "TokenNetwork: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x2178756434b4c8cd3c277d9cfe3808c6959797d1"
  family: "12ad60608df0431a79985cd9f62a72e8"
  copies: 4
  name: "TokenNetwork"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 90
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Raiden participants"
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
  note: "The relying participant loses the transfers it received; no update path."
---

## Summary

Raiden TokenNetwork (counter-signature version, same code as 0xea92bd48): the partner's balance proof and the closer's counter-signature are checked again at close and update. If a partner's address takes code, the received transfers it signed for cannot be proven.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Raiden setTotalWithdraw: a withdraw needs the participant's and the partner's signatures / Raiden closeChannel: the closing party presents the partner's signed balance proof / Raiden…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- TokenNetwork.sol:692 recoverAddressFromBalanceProofCounterSignature == closing_participant; 708 recoverAddressFromBalanceProof == non_closing_participant for nonce > 0
- updateNonClosingBalanceProof 797/808 recover both
- no proxy, no upgrade; only the deprecation switch; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $90 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Settle channels before an address takes code; no on-chain fix.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
