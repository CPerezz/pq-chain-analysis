---
id: subscription-1e759be8-signature-rechecked
title: "Subscription: a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x1e759be854f7855ac7aba48b2c1c9b73b86ede70"
  family: "7d9cb58111f9c8b8e3a2a06f7c3bc6b5"
  copies: 15
  name: "Subscription"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "author/publisher and subscribers: redeploy and re-sign"
evidence:
  level: bytecode
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
  rating: MEDIUM
  note: "MEDIUM: the function dies for good but nothing is locked, and there is no update path. The publisher is paid in advance per period, so no completed reliance loses funds. The template attribution is wrong."
---

## Summary

Not a Connext LedgerChannel: a Groundhog-style Subscription (author, endContract). Each period, executeSubscription checks the subscriber's signature again and pulls tokens directly from the subscriber's wallet. If that address takes code, future pulls revert, with no loss of funds already paid and nothing locked.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: d3c576cd requires address(arg0) == recovered ('Invalid Signature') before transferFrom(from,to,amount) and transferFrom(from,msg.sender,gasPrice); 71d22d4d cancel needs both the signature and msg.sender == subscriber
- endContract: require(msg.sender == author); selfdestruct(author). author = 0x004bb281…cb7f at 26438999; no setter for any key
- No proxy (EIP-1967 slots 0); balance 0; contract holds no tokens by design
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 15 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Re-subscribe from an EOA key on a new deployment; revoke the allowance to stop payments.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
