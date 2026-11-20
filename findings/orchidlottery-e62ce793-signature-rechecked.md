---
id: orchidlottery-e62ce793-signature-rechecked
title: "OrchidLottery: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xe62ce793c8e52b4135a109dc87f83305192c7d8b"
  family: "615a71dcc79b785c2f46904fa6d56df5"
  copies: 2
  name: "OrchidLottery"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 1
  last_active: 2026-10-23
fix:
  layer: new-deployment
  who_acts: "Orchid (new lottery) and funders"
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
  note: "The relying recipient loses, with no unilateral path = CRITICAL."
---

## Summary

This is the same OrchidLottery as 0xe0dc...; it differs only in the ticket-winning hash (no `issued`). grab() recovers the pot signer from a ticket the recipient already relied on. If the signer gets real code, the recipient cannot redeem, while the funder can still pull/yank after unlock.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Orchid lottery grab: a ticket the funder signed earlier is redeemed later by the recipient. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/lottery.sol: identical grab/take/give/pull/yank; the diff against 0xe0dc is only L230 (keccak of reveal,nonce)
- No ERC-1271 or code check; give() needs msg.sender == signer
- No proxy slot or upgrade function; holds 9.999 OTT at block 26438999
- txs_90d 1, last_active 2026-10-23

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-23.

## Remediation

As 0xe0dc: settle tickets before the signer migrates; new lottery with ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
