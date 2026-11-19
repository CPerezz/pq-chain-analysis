---
id: virtualpaymentmanager-07bfa78d-signature-rechecked
title: "VirtualPaymentManager: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x07bfa78d66d104fe9936201427400b0d78a2284c"
  family: "95f1dddb95873d0cbc38dca1ac4aba49"
  name: "VirtualPaymentManager"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 13956
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "parties settle before a signing address takes code"
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
  note: "recipient loses a signed payment"
---

## Summary

`VirtualPaymentManager` at `0x07bfa78d66d104fe9936201427400b0d78a2284c`. It checks a signature again after others relied on it; once the signer's account has code, that check fails and the party that relied on it loses.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Archanova verifyOwnerSignature: the signer must be an owner device of the account / Archanova virtual payment: the payment must be signed by a device of the paying account; the recipient withdraws…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read (Archanova): a virtual payment is signed by a device of the paying account and withdrawn later by the recipient from the payer's deposit. A device with code is asked through its own verifySignature (Archanova's interface, not ERC-1271); a device migrated to generic code fails it, so the recipient loses the payment it relied on.
- Guardian 0x99819fedbcf9986824bbe094df928887d1a443a6; no proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $13,956 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
