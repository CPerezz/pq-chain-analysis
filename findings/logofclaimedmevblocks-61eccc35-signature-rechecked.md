---
id: logofclaimedmevblocks-61eccc35-signature-rechecked
title: "LogOfClaimedMEVBlocks: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x61eccc35812487311a3102a8c2d88138171050f2"
  family: "4c2567b1baf98c39d6cf14a5f55b89c2"
  name: "LogOfClaimedMEVBlocks"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "pool operators (stop relying on producers whose addresses may take code)"
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
  note: "The relying pool operator loses the payment while the producer's timeout exit lets it walk away; no update path."
---

## Summary

LogOfClaimedMEVBlocks: a pool operator mines an MEV producer's block relying on the producer's signed payment commitment and later redeems it against the producer's locked deposit. If the producer's address takes code, submitClaim silently skips the claim, and the producer withdraws after the lock.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: LogOfClaimedMEVBlocks submitClaim: the MEV producer's signed block commitment is redeemed later against its deposit / LogOfClaimedMEVBlocks remainingDurationForWorkClaim: a view. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- submitClaim: `if (ecrecover(...) == mevProducer)` gates the transfer of blockPayment from the producer's deposit to poolOperator; otherwise it is a no-op
- withdrawUpTo: the depositor withdraws by msg.sender after timestampOfPossibleExit, with no signature
- no owner, proxy or upgrade; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on chain; pool operators must claim before a producer's address takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
