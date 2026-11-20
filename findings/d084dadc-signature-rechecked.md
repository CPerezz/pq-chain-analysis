---
id: d084dadc-signature-rechecked
title: "0xd084dadc: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xd084dadc426c12ca937bc1a6ce6b7e27b3c832a4"
  family: "7762de4624329680b3bc0ce1f09aa060"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (redeploy); stakers must not migrate with open channels"
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
  note: "CRITICAL, as for 0xd60eea94: there is no update path, and the operator and claimers, who relied on the staker's signed commitments, lose unsettled amounts without doing anything."
---

## Summary

SMG PaymentChannels variant (source as template f37d66cc / 0xd60eea94), with WETH (0xc02aaa39) as the staked token. settleStakeCommitments, startTimelockedUnstake and unstake all require ECDSA.recover(stakerSignature) == stakerAddress as well as the notary signature. A staker whose account gets non-7702 code can no longer have its signed commitments settled, so the operator and claimers lose the unsettled spending. It can also never start an unstake. The contract has no upgrade path.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template f37d66cc: PaymentChannels: a staker can start or finish an unstake only with its own ECDSA signature on a commitment, next to the notary's; there is no path without it, so a staker…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- eth_call @26438999 with valid nonces and a random-key signature: settleStakeCommitments, startTimelockedUnstake (from=staker) and unstake (data 0x494e5354414e54) each revert "Invalid StakeCommitment: stakerAddress does not match the signer of stakerSignature."
- selectors resolve to settleStakeCommitments/startTimelockedUnstake/unstake((address,uint256,uint256,uint256,bytes,bytes,bytes)), the same as PaymentChannels.sol lines 602-830 in the template source
- WETH.balanceOf(contract) = 0.5 WETH @26438999; totalClaimableAmount = 0; 0 txs in 90 days

## Impact and exposure

- Value held at block 26,438,999: $902 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a contract-signature (ERC-1271) path for stakers; until then stakers must settle and unstake before migrating their accounts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
