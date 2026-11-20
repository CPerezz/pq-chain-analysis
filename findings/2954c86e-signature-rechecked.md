---
id: 2954c86e-signature-rechecked
title: "0x2954c86e: a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x2954c86ee2ea63817bb88bd1330c3d93ac960179"
  family: "922da416f10c1f6da15d74a393c159bd"
  copies: 40
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
  note: "MEDIUM: the subscription dies for good for that subscriber, but nothing is locked (pull from wallet, prepaid period) and there is no update path. The template attribution is wrong."
---

## Summary

Not a Connext LedgerChannel: an earlier Groundhog Subscription variant (author, tokenAddress, tokenAmount, periodSeconds, gasPrice, endContract; no signed cancel). executeSubscription calls isSubscriptionReady (signer == from) each period and pulls tokens from the subscriber's wallet. Code at the subscriber's address stops future pulls only.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: d3c576cd reverts 'Subscription is not ready or conditions of transction are not met' unless the recovered signer == from, then transferFrom(from,to,amount) and the gas refund transferFrom(from,msg.sender,gasPrice)
- Storage at 26438999: author/to slots 0x2fDB988f…be9B, token 0xe41d2489…f498 (ZRX), amount 0x163f71b19b8c50000; endContract is author-only selfdestruct; no key setter
- No proxy (EIP-1967 slots 0); balance 0; tokens never held by the contract
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 40 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Re-subscribe from an EOA key on a new deployment; revoke the allowance to stop payments.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
