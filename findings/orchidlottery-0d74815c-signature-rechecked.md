---
id: orchidlottery-0d74815c-signature-rechecked
title: "OrchidLottery: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x0d74815c436524b0aad7b348ebb0f772d6a27135"
  family: "378d15075c09c18280ab5ffca89dd932"
  copies: 2
  name: "OrchidLottery"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
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
  note: "Rated on the mechanism: the relying recipient loses = CRITICAL. It holds 0 OXT and is dormant."
---

## Summary

This is the OXT OrchidLottery variant; its verifier book() takes more arguments, but grab() is the same. The recipient redeems a ticket the pot signer signed earlier, and if the signer address takes real code the redemption fails while the funder can still pull/yank after unlock.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Orchid lottery grab: a ticket the funder signed earlier is redeemed later by the recipient from the funder's balance; the recipient relies on the signature. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/lottery.sol: grab ecrecover -> take(funder, signer, ...); the diff against 0xe62c is only in the OrchidVerifier.book signature and take's ratio argument
- No ERC-1271 or code check; give() needs msg.sender == signer
- No proxy slot or upgrade function; token OXT 0x4575f413..., balance 0 at block 26438999 (value does not lower the rating)
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

As 0xe0dc.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
