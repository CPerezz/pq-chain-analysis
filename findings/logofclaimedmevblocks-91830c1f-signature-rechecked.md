---
id: logofclaimedmevblocks-91830c1f-signature-rechecked
title: "LogOfClaimedMEVBlocks: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x91830c1ff56f82776dd5acc00f8ec803129d5b9d"
  family: "ac91f58e89722133b0a2498b53477ce9"
  name: "LogOfClaimedMEVBlocks"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "contract deployer (new deployment); MEV producers"
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
  note: "The pool relied on the signature and loses payment = CRITICAL. The owner is not an upgrade path. Same Merge caveat as 0x0000000020e0."
---

## Summary

This is the Ownable variant of LogOfClaimedMEVBlocks. It adds whitelistMiningPool and requires msg.sender == blockSubmissionsOperator[pool], but submitClaim keeps the same check: the producer's earlier signed work order is recovered when the pool claims payment from the producer's deposit. If the producer's address takes code, the claim is a no-op and the producer can withdraw after the lock.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: LogOfClaimedMEVBlocks submitClaim: the MEV producer's signed commitment, redeemed later / LogOfClaimedMEVBlocks remainingDurationForWorkClaim: the MEV producer's signed commitment, checked when a…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source diff against 0x0000000020e0: only Ownable, whitelistMiningPool and the operator check were added; the ecrecover == mevProducerAddress payout is unchanged
- owner() = 0xd4a216c4... can only whitelist pools; there is no upgrade and no way to replace the signer
- No proxy slot; ETH balance 0 at block 26438999
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

As 0x0000000020e0.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
