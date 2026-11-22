---
id: orchidlottery-e0dcc708-signature-rechecked
title: "OrchidLottery: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xe0dcc70880bee5579dd93c317d272a4121a80117"
  family: "124895080a6ac6828ffbd18fb4abda8d"
  copies: 2
  name: "OrchidLottery"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 2
  last_active: 2026-10-23
fix:
  layer: new-deployment
  who_acts: "Orchid (new lottery) and funders (redeem or settle outstanding tickets before migrating the signer key)"
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
  note: "The recipient relied on a ticket signed earlier and loses it while the funder keeps an exit, so a party that did nothing loses = CRITICAL. A new pot with a fresh signer protects only future tickets, not ones already issued."
---

## Summary

OrchidLottery grab() redeems a winning ticket that the pot's signer key signed earlier. The recipient (VPN provider) has already served on the strength of that signature. If the signer address takes real code, ecrecover returns 0 or a different address and the recipient cannot redeem. The funder can still pull/yank the pot after warn() plus 1 day.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Orchid lottery grab: a ticket the funder signed earlier is redeemed later by the recipient from the funder's balance. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/lottery.sol grab: signer = ecrecover(...ticket...); take(funder, signer, recipient, amount); no code check or ERC-1271
- The only no-signature payout path is give(), which needs msg.sender == signer, so it is at the signer's discretion and the recipient has no unilateral path; the funder exits via pull/yank after unlock
- No proxy slot or upgrade function; holds 26,659.6 OTT (token 0xff9978b7...) at block 26438999
- txs_90d 2, last_active 2026-10-23

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-10-23.

## Remediation

Funders let tickets expire or settle with providers before giving the signer key real code; Orchid deploys a lottery that verifies the signer via ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
