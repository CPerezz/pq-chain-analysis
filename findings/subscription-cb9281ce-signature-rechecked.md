---
id: subscription-cb9281ce-signature-rechecked
title: "Subscription: a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0xcb9281ce2a2ce7a979effb8cf45697c78b1f8b39"
  family: "21cad798f9825935629771f7b7540d4b"
  copies: 3
  name: "Subscription"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 2
  last_active: 2026-08-26
fix:
  layer: new-deployment
  who_acts: "publisher (requiredToAddress) and subscribers: redeploy and re-sign, or pay directly"
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
  note: "MEDIUM: payment is taken in advance at the start of each period, so the publisher never relies on an unpaid signature. When it breaks, only future pulls die; no funds are locked and there is no update path. Subscribers cancel by revoking the allowance even though signed cancel dies. The template attribution is wrong."
---

## Summary

Not a Connext LedgerChannel: this is the tokensubscription.com/Groundhog Subscription contract. executeSubscription re-runs ecrecover on the subscriber's one-time signature each period and pulls tokens with transferFrom straight from the subscriber's wallet to the publisher. If the subscriber's address takes code, future pulls revert, but nothing is locked and no payment already made is undone.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile: d3c576cd (executeSubscription) requires recovered signer == from ('Invalid Signature'), then nextValidTimestamp = now + period, then token.transferFrom(from, to, amount) and transferFrom(from, msg.sender, gasPrice); 71d22d4d cancelSubscription is signature-only
- Contract holds no funds by design: balance 0 at 26438999; tokens move from the subscriber's wallet under allowance and never sit in the contract
- No proxy: EIP-1967 impl and admin slots are 0; no owner, no setter (facts: setters []); requiredToAddress 0x34aA3F35…fDF3
- txs_90d 2, last_active 2026-08-26

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-08-26.

## Remediation

Subscribers who give their address code must re-subscribe from an EOA key on a new deployment, or pay directly; they can still stop payments by revoking the ERC-20 allowance.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
