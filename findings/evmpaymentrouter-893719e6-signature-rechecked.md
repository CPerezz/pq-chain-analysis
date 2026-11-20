---
id: evmpaymentrouter-893719e6-signature-rechecked
title: "EvmPaymentRouter: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0x893719e64178e2b8e3a05f8b4a2c358428436364"
  family: "3ba1dcb8da703cb5dbcfb98909f01cd4"
  name: "EvmPaymentRouter"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Uninitialized implementation, and no reliance: a revocable pull authorization guarantees nothing to the recipient."
---

## Summary

This is an uninitialized UUPS implementation of EvmPaymentRouter (its constructor calls _disableInitializers; recipient()=0 and the implementation slot is empty). Besides, the recurring authorization can be revoked at will by the payer via revokeRecurring, and pulls only future funds from the payer's wallet, so the recipient was never owed anything a payer key change could take away.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: EvmPaymentRouter _executeRecurring: recurring terms the payer signed earlier are executed later. Read (function text).
- Update path, read at block 26,438,999: UPGRADER_ROLE(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- Sourcify verified source (scratch review_agents/036/src) EvmPaymentRouter.sol:90 _disableInitializers(); :255 _authorizeUpgrade onlyRole(UPGRADER_ROLE)
- at 26438999: recipient()=0x0; EIP-1967 slot empty; Etherscan lists it as 'Implementation For' a proxy
- _executeRecurring requires recovered == terms.payer, and revokeRecurring lets the payer cancel at any time; funds stay in the payer's wallet until pulled

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None (proxies running it are UUPS-upgradeable by UPGRADER_ROLE).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
