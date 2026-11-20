---
id: coordinationpaymentchannels-46168a99-signature-rechecked
title: "CoordinationPaymentChannels: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x46168a99d15e6c620577d75ed7c453a6f53bafd5"
  family: "882bea20d51ed97ed02f3bd59d91ec84"
  name: "CoordinationPaymentChannels"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (redeploy); stakers settle before migrating"
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
  rating: CRITICAL
  note: "A relying party (claimers paid against the staker's signed spend) loses with no update path and no rescue path (ROOK blacklisted from recovery), so CRITICAL by the payment-channel rule. Different code from template f37d66cc but the same design, checked on its own."
---

## Summary

CoordinationPaymentChannels (Rook/KeeperDAO, the ROOK-staking predecessor of template f37d66cc): settleSpentStake rechecks the staker's ECDSA signature on each StakeCommitment that the coordinator and claimers relied on. If the staker's address takes real code, its spent ROOK can never be moved into the claimable pool, so claimers paid under that commitment lose. The staker's own withdrawal (initiateTimelockedWithdrawal, executeInstantWithdrawal) also needs its signature, so its stake is locked too.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template f37d66cc: PaymentChannels: a staker can start or finish an unstake only with its own ECDSA signature on a commitment, next to the notary's; there is no path without it, so a staker…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- cast call --from 0x..dEaD @26438999: settleSpentStake([(dEaD,0,1,0,0x,sig,sig)]) and initiateTimelockedWithdrawal(...) both revert 'recovered address is not the stake address', so the staker's signature is rechecked at settlement and at exit
- recoverTokens(16114acd) is onlyOperator and requires !blacklist[token]; blacklist[ROOK 0xfa5047...] (slot keccak(ROOK,1)) = 1 @26438999, so no operator rescue of ROOK; coordinator/claimGenerator (slots 2,3 = EOA 0x02f82fb8..., nonce 902) can be changed by the operator but the staker key cannot
- EIP-1967 impl/admin slots 0, no upgrade function; holds 2,269.78 ROOK @26438999; txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Stakers must settle all spent commitments and withdraw before giving their address code; long term, redeploy with ERC-1271 or a code check for the staker.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
