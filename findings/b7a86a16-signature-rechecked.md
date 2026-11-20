---
id: b7a86a16-signature-rechecked
title: "0xb7a86a16 (tagged deployed by Gitcoin: Maintainer): a signature checked again after others relied on it"
status: confirmed
severity: MEDIUM
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0xb7a86a1683a67caacbfb1435f7e4f97d9b95c137"
  family: "f1c112dfb84fe94e3d24ddf7bee93698"
  copies: 649
  label: "deployed by Gitcoin: Maintainer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "subscriber (re-subscribe on a new contract) / Gitcoin"
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
  note: "The relying grantee loses only future, unpaid instalments that the subscriber could stop anyway by revoking the allowance. Nobody loses held funds, so it is not CRITICAL. No funds are locked (non-custodial). The signed function dies for good and there is no update path → MEDIUM. Applies to the 649 copies if they share the bytecode."
---

## Summary

Gitcoin Grants subscription (EIP-1337 style): executeSubscription (0xd3c576cd, relayer-only) recovers the subscriber's signature each period and pulls tokens via transferFrom. If the subscriber's address takes real code, the subscription stops paying. The contract holds no funds, and the subscriber keeps their tokens and can revoke the allowance.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: 649 subscription contracts: a payment authorisation signed once by the subscriber is executed again at each period. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled 0xd3c576cd: msg.sender == relayer (slot 1), recovered signer == from, then token.transferFrom(from,to,amount) and gas fee; non-custodial, ETH balance 0
- cancelSubscription 0x71d22d4d also needs the subscriber's signature and msg.sender==subscriber, but token.approve(this,0) by the subscriber stops payments directly
- EIP-1967 slots 0 at 26438999; owner 0xe3d9bbe491f5dcaae347642004db1dea9c458d1b is an EOA, nonce 3, but it has only changeOwnership/endContract (selfdestruct): no upgrade or key path

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 649 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Subscribers whose address will take code re-subscribe on a code-aware contract; grantees re-collect pledges off-chain.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
