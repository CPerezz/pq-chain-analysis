---
id: evmpaymentrouter-c8818262-signature-rechecked
title: "EvmPaymentRouter: a signature checked again after others relied on it"
status: confirmed
severity: LOW
patterns: [PQ-15]
impact: liveness
contracts:
- address: "0xc8818262f0ef68f49ff4335d43cb057e5af7f348"
  family: "3ba1dcb8da703cb5dbcfb98909f01cd4"
  name: "EvmPaymentRouter"
  upgradeable: "yes"
  admin: "0xe0a4325455efae0d55b991959dd11c69cd33cda8 (UPGRADER_ROLE, EOA)"
  rating: LOW
  txs_90d: 3
  last_active: 2026-10-28
fix:
  layer: contract-upgrade
  who_acts: "UPGRADER_ROLE holder 0xe0a4325455efae0d55b991959dd11c69cd33cda8"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: the UUPS upgrade is open to a live EOA holding UPGRADER_ROLE."
---

## Summary

EvmPaymentRouter (UUPS): recurring payments execute terms the payer signed earlier; EIP-8151 makes those signatures fail once the payer has code.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: EvmPaymentRouter _executeRecurring: recurring terms the payer signed earlier are executed later. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x893719e64178e2b8e3a05f8b4a2c358428436364 with UPGRADER_ROLE(), called through its own checks.
- source EvmPaymentRouter.sol:255 _authorizeUpgrade is onlyRole(UPGRADER_ROLE)
- hasRole(UPGRADER_ROLE, 0xe0a4…cda8) = true at block 26438999; also holds the default admin role
- 0xe0a4…cda8: no code, nonce 6 at block 26438999
- EIP-1967 implementation 0x893719e64178e2b8e3a05f8b4a2c358428436364 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-28.

## Remediation

Upgrader ships an implementation that accepts ERC-1271 for payers with code; payers can also re-sign.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
