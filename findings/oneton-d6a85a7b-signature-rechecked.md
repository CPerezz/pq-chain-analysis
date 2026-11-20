---
id: oneton-d6a85a7b-signature-rechecked
title: "OneToN: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xd6a85a7b1673b18b56aa689b856a9826d90cc567"
  family: "15022c8a046d7daaf57c054de5c486ce"
  name: "OneToN"
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
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted only because the receiver-registration gate is permanently closed. If the registry were live, this would be CRITICAL (the receiver relied on the IOU, and the sender can withdraw after 100 blocks)."
---

## Summary

Raiden OneToN: claim() recovers the sender's IOU signature and pays the receiver from the sender's UDC deposit, which is the CRITICAL mechanism. But claim() first requires service_registry.hasValidRegistration(receiver), and no receiver can be registered any more, so every path is closed for good.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Raiden OneToN claim: an IOU the sender signed earlier is claimed later from the sender's deposit. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify verified source (scratch review_agents/036/src) OneToN.sol claim(): require(hasValidRegistration(receiver)); require(block.number <= expiration_block); recovered == sender
- the only registered service ever, 0xDCd32F44…, has service_valid_till 1634114147 (2021); ServiceRegistry 0xbDFDCE3B… deprecated()=true, so deposit() reverts and no one can register again
- UDC 0x5c0f3d9D… names this contract as one_to_n_address; its whole_balance is 1.15e21 token units (now withdrawable by depositors via planWithdraw/withdraw, 100-block delay)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
