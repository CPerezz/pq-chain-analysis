---
id: a10f9315-signature-rechecked
title: "0xa10f9315: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xa10f931578b4e1107958c85619de683153741ed2"
  family: "37db250e6486e8f352ad07a3d5c9111a"
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
  note: "Same rechecked staker signature as template f37d66cc; the relying claimers lose with no upgrade path and no ETH rescue, so CRITICAL. The staker's own lock (own-signature-only-exit) is also present but the relying-party loss decides."
---

## Summary

A native-ETH variant of the PaymentChannels template, with an added reserve channel: settleStakeCommitments rechecks the staker's signature on StakeCommitments that the stake notary and claimers relied on. If the staker's address takes real code, its spent ETH can never be settled into totalClaimableAmount, so claimers lose. startTimelockedUnstake and unstake also need the staker's signature, so its stake is locked.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template f37d66cc: PaymentChannels: a staker can start or finish an unstake only with its own ECDSA signature on a commitment, next to the notary's; there is no path without it, so a staker…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- cast call @26438999: settleStakeCommitments([(dEaD,0,1,0,0x,sig,sig)]) and startTimelockedUnstake(...) from dEaD revert 'Invalid StakeCommitment: stakerAddress does not match the signer of stakerSignature.', which is the template's check
- Decompile: ETH leaves only via executeTimelockedUnstake (766309f9, after a signed startTimelockedUnstake), unstake (signed) and claim (8f0bc152, claimNotary signature); recoverToken (9be65a60) is ERC20-only (balanceOf/transfer) with no ETH path, so there is no operator rescue of staked ETH
- Notaries (slots 3,4,5 = EOA 0x694d3f75..., nonce 0) can be replaced via set*NotaryAddress by the operator (sole OPERATOR_ROLE member EOA 0x70b45bef..., nonce 1894), but the staker key cannot; EIP-1967 slots 0, no upgrade function; balance 99,999,999,999,990 wei @26438999; txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Stakers must settle and unstake before giving their address code; long term, redeploy with ERC-1271 or a code check for the staker.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
