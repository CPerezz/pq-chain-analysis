---
id: oneton-6a3b8b75-signature-rechecked
title: "OneToN: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x6a3b8b754ade680068669815dd2542592cf14f04"
  family: "b8638cf116d63544ce2208b15f3e5174"
  name: "OneToN"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Raiden/Brainbot (new OneToN+UDC); PFS receivers claim before signer migrates"
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
  note: "Relying party (PFS receiver holding an IOU) loses earned payment; signer's timeout withdraw is the signer's exit, not the receiver's; no update path"
---

## Summary

OneToN.claim recovers the IOU signer (Raiden client node key paying a PFS) and requires it equal sender before moving the sender's UserDeposit balance to the receiver. If the sender's address takes real code after issuing IOUs, claims fail while the sender can still planWithdraw/withdraw after withdraw_delay=100 blocks.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Raiden OneToN claim: an IOU the sender signed earlier is claimed later by the receiver from the sender's deposit. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- claim(): require(recoverAddressFromSignature(...)==sender) then deposit_contract.transfer(sender,receiver,...) (source/OneToN.sol ~L739-778)
- UserDeposit.planWithdraw/withdraw by msg.sender alone after withdraw_delay=100 blocks: the depositor (signer) keeps its exit, the receiver has no other claim path
- deposit_contract()=0x53Cc1decDD7d452c8844a5f383e23AD479A1f614 at 26438999, 24.8 RDN-units e18 (whole_balance 2.48e19); EIP-1967 impl/admin slots zero; no owner/upgrade function in source
- txs_90d 0, last_active null (measured)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy OneToN/UDC with ERC-1271 or code-aware verification; receivers claim outstanding IOUs before EIP-8151

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
