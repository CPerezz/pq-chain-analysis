---
id: stake-afb34970-signature-rechecked
title: "Stake: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xafb3497035be453b26c7ef548093c87d99e64324"
  family: "02357b41e9cfbf0ee4c3d2f9a6b334d6"
  copies: 3
  name: "Stake"
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
  note: "Same mechanism and outcome as 0x46168a99: claimers who relied on the staker's signed spend lose, with no upgrade or rescue path, so CRITICAL. A loose match to template f37d66cc, but it runs an equivalent check."
---

## Summary

Rook 'Stake' (CoordinationPaymentChannels design, ROOK token): settleSpentStake rechecks the staker's signature on coordinator-co-signed StakeCommitments. If the staker's address takes real code, spent ROOK cannot reach the claimable pool and claimers lose. The staker's own withdrawal also needs its signature.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template f37d66cc: PaymentChannels: a staker can start or finish an unstake only with its own ECDSA signature on a commitment, next to the notary's; there is no path without it, so a staker…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- cast call --from 0x..dEaD @26438999: settleSpentStake([(dEaD,0,1,0,0x,sig,sig)]) and initiateTimelockedWithdrawal(...) revert 'recovered address is not the stake address'
- recoverTokens(16114acd) blocked for ROOK: blacklist[0xfa5047...] (slot keccak(ROOK,1)) = 1 @26438999; coordinator/claimGenerator (slots 2,3 = EOA 0x3a8f4dff..., nonce 312) can be changed by the operator via updateCoordinatorAddress/updateClaimGeneratorAddress, but the staker key cannot
- EIP-1967 slots 0, no upgrade function; holds 2.0459 ROOK @26438999; txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Stakers must settle and withdraw before giving their address code; long term, redeploy with ERC-1271 or a code check for the staker.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
