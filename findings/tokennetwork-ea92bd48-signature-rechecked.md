---
id: tokennetwork-ea92bd48-signature-rechecked
title: "TokenNetwork: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4"
  family: "4c461c57446e3e0f9cec219f328fab55"
  copies: 5
  name: "TokenNetwork"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 1107
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
  note: "The relying participant loses the partner-signed transfers it received; no update path."
---

## Summary

Raiden TokenNetwork (newer, with counter-signatures): closeChannel requires the closer's own counter-signature and, for nonce > 0, the partner's balance-proof signature. If the partner's address takes code, received transfers cannot be proven; if the closer's address takes code, it cannot close at all and must wait for the partner.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Raiden setTotalWithdraw: a withdraw needs the participant's and the partner's signatures / Raiden closeChannel: the closing party presents the partner's signed balance proof / Raiden…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- TokenNetwork.sol:692-701: recoverAddressFromBalanceProofCounterSignature(...) == closing_participant
- TokenNetwork.sol:706-716: for nonce > 0, the partner's balance proof must recover to non_closing_participant; nonce 0 forfeits received transfers
- setTotalWithdraw needs both participants' signatures; no proxy, no upgrade; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $1,107 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Participants should settle before an address takes code; no on-chain fix.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
