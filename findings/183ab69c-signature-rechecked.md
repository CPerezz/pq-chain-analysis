---
id: 183ab69c-signature-rechecked
title: "0x183ab69c: a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x183ab69cee81bf518d5c56d114a7749db412be3f"
  family: "c37661add9d3167a34822ea13d8884aa"
  copies: 93
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner/publisher and subscribers: redeploy and re-sign"
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
  note: "MEDIUM: the subscription function dies for good for a subscriber whose address takes code, but no money is locked (pull from wallet, prepaid periods) and there is no update path. The owner's powers (changeOwnership, endContract) do not fix it. The template attribution is wrong."
---

## Summary

Not a Connext LedgerChannel: a Groundhog-style Subscription variant (owner, changeOwnership, endContract). executeSubscription re-runs ecrecover on the subscriber's signature each period and pulls tokens from the subscriber's wallet. Code at the subscriber's address only stops future pulls, and nothing is locked.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: d3c576cd executeSubscription calls ecrecover and compares with from, then transferFrom(from,to,amount) and a gas refund via transferFrom(from,msg.sender,gasPrice); 71d22d4d cancelSubscription needs the signature and msg.sender == subscriber
- Owner-only 2af4c31e changeOwnership and endContract (selfdestruct to owner) cannot replace or repair the subscriber's key; owner() = 0x587FB98E…B407 at 26438999
- No proxy (EIP-1967 slots 0); balance 0; the contract holds no tokens by design
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 93 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Re-subscribe from an EOA key on a new deployment; revoke the allowance to stop payments.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
