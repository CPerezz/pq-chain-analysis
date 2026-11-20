---
id: 8d6695f3-signature-rechecked
title: "0x8d6695f3: a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c"
  family: "d0b28e4657ba50033eaad83f4ed40782"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "subscription publisher (to-address) / author redeploys; subscriber re-subscribes from a fresh EOA"
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
  note: "The signature is rechecked each period after the publisher relied on it, but payments are made in advance per period (nextValidTimestamp is set at execution), and the subscriber could revoke the allowance at any time anyway. So the relying party loses no funds it was owed, and nothing is locked in the contract. With no update path and a function that dies with nothing locked, that is MEDIUM, not CRITICAL. The template match to Connext was wrong."
---

## Summary

Not a Connext ledger channel: an EIP-1337 token-subscription contract (older version, requiredToAddress 0xe87529…C029, period 30s, amount 1). It recovers the subscriber's one-time signature again on every executeSubscription. Once the subscriber's address has real code, the recurring pull dies for good. The contract holds no funds, and the subscriber's tokens stay in their own wallet.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0 selectors in common with LedgerChannel 5c6fba46; has getSubscriptionHash/executeSubscription/isSubscriptionReady/requiredToAddress/author (older 7-arg executeSubscription 0x691d9352, isSubscriptionReady 0x0ad8ad66)
- executeSubscription: ecrecover(subscriptionHash) == from, then token.transferFrom(from,to,amount) and gas fee transferFrom(from,msg.sender,gasPrice); no code check, no ERC-1271
- balance 0 ETH at 26438999; EIP-1967 impl/admin slots 0; no setter or upgrade function (only author-only endContract selfdestruct in the newer version)
- author 0x5649cfcc583e380c55fC045Bb112e90FC0F8dfef (nonce 33) is an EOA (code 0x) at 26438999; txs_90d=0, last_active=null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Publisher and subscriber set up a new subscription on a new deployment, or the subscriber pays directly; nothing to recover

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
