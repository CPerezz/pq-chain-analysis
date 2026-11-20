---
id: logofclaimedmevblocks-00000000-signature-rechecked
title: "LogOfClaimedMEVBlocks: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x0000000020e0a4bc775eb0cbefc7cfbeafc88444"
  family: "878d3f36abf7b5a1533c14239c032338"
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
  note: "The pool did the work relying on the signed order and loses payment, while the signer exits after the lock = CRITICAL by mechanism. Reviewer: its use case (PoW work orders) ended at the Merge, but the path is still open on chain and activity does not lower the rating."
---

## Summary

submitClaim pays a mining pool from the MEV producer's locked deposit against a work order the producer signed before the pool mined. If the producer's address takes real code, ecrecover no longer matches and the claim silently does nothing. The producer then withdraws via withdrawUpTo once the lock expires.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: LogOfClaimedMEVBlocks submitClaim: the MEV producer's signed block commitment, redeemed later / LogOfClaimedMEVBlocks remainingDurationForWorkClaim: the MEV producer's signed commitment, checked when…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/LogOfClaimedMEVBlocks.sol submitClaim: if (ecrecover(...) == mevProducerAddress) { pay pool from depositedEther }; there is no code check, and on mismatch it is a no-op
- withdrawUpTo lets the producer exit after timestampOfPossibleExit with no signature; the pool has no other path to payment
- No proxy slot, no owner, no upgrade function; ETH balance 0 at block 26438999
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

New deployment accepting ERC-1271 or checking code; pools claim before producers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
