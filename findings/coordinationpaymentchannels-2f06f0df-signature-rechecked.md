---
id: coordinationpaymentchannels-2f06f0df-signature-rechecked
format: 2
title: Keeper channel states stop counting once the keeper's account takes real code
status: confirmed
severity: CRITICAL
justification: A keeper that moves to real code voids its signed channel states; the contract cannot be changed.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  name: CoordinationPaymentChannels
  code: verified
  code_url: https://etherscan.io/address/0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6#code
  copies: 2
  family: 0d0deff0f3a759cfc98bad3d4001f3df
  upgradeable: 'no'
value:
  usd: 15511
  whose: mixed
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Settle each keeper's latest signed commitment with settleSpentStake before any keeper's account can take
  real code.
evidence_level: source
checks:
- id: stake
  source: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  file: contracts/protocol/CoordinationPaymentChannels.sol
  lines:
  - 204
  - 211
  has: stakedAmount[msg.sender] += _amount;
  says: stake credits WETH to the caller's channel
  for:
  - what
- id: start
  source: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  file: contracts/protocol/CoordinationPaymentChannels.sol
  lines:
  - 309
  - 311
  has: only stakeAddress can start the withdrawal process
  says: only the keeper starts a withdrawal; afterwards the call is open
  for:
  - justification
  - what
- id: challenge
  source: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  file: contracts/protocol/CoordinationPaymentChannels.sol
  lines:
  - 316
  - 319
  has: msg.sender == _commitment.stakeAddress || msg.sender == coordinator
  says: the coordinator may resubmit a newer commitment during the timelock
  for:
  - evidence-1
  - justification
  - what
- id: keeper-sig
  source: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  file: contracts/protocol/CoordinationPaymentChannels.sol
  lines:
  - 321
  - 324
  has: require(recoveredStakeAddress == _commitment.stakeAddress, "recovered address is not the stake address");
  says: the keeper's signature is recovered with ECDSA on every submission, including the coordinator's
  for:
  - evidence-1
  - justification
  - what
- id: coord-sig
  source: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  file: contracts/protocol/CoordinationPaymentChannels.sol
  lines:
  - 325
  - 328
  has: require(recoveredCoordinatorAddress == coordinator, "recovered address is not the coordinator");
  says: the coordinator's signature on the same commitment is also required
  for:
  - what
- id: execute
  source: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  file: contracts/protocol/CoordinationPaymentChannels.sol
  lines:
  - 356
  - 369
  has: WETH.safeTransfer(_stakeAddress, withdrawalAmount);
  says: after the timelock, stake minus recorded spend is paid with no signature
  for:
  - evidence-2
  - what
- id: settle
  source: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  file: contracts/protocol/CoordinationPaymentChannels.sol
  lines:
  - 257
  - 279
  has: function settleSpentStake(
  says: settleSpentStake records a commitment's spend when the keeper's and coordinator's signatures recover
  for:
  - action
- id: staked
  call: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  fn: stakedAmount(address)(uint256)
  args:
  - '0x766648e039e663eea55463782a5f0543dce7fe17'
  is: '10700000000000000000'
  says: this keeper has 10.7 WETH staked
  for:
  - evidence-3
  - whose
- id: spent
  call: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  fn: stakeSpent(address)(uint256)
  args:
  - '0x766648e039e663eea55463782a5f0543dce7fe17'
  is: '5545387280275626479'
  says: 5.545 WETH of it is settled as spent
  for:
  - evidence-3
  - whose
- id: claimable
  call: '0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6'
  fn: totalClaimableAmount()(uint256)
  is: '3437741750667927269'
  says: 3.44 WETH is claimable earnings
  for:
  - whose
- id: keeper-eoa
  code: '0x766648e039e663eea55463782a5f0543dce7fe17'
  is: empty
  says: the keeper's account has no code today
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews:
- who: r-2f06f0df, the row's refuter
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: reader-1, the reader who settled the row (also its author)
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 'kept: CoordinationPaymentChannels: keepers stake WETH and pay the coordinator off chain with channel states
    both sign. When a keeper starts a timelocked withdrawal with an old state, the coordinator answers with a newer
    one, and the contract recovers the keeper''s ECDSA signature on it again (lines 316-324); once the keeper''s
    account has real code the answer fails and the keeper leaves with WETH already spent. PQ-15, CRITICAL: no update
    path and the coordinator loses. Fix: settle states promptly and deploy a version with ERC-1271. Refuter agreed
    with no objection. Reader corrections: What happens reworded (the old second sentence said the newer state is
    ''checked again by the keeper''; it is the keeper''s signature that the contract checks), and the author''s
    question about pending off-chain states dropped as unreadable on chain (noted under ruled_out).'
related: []
---

## What happens

Keepers stake WETH and pay the coordinator off chain with channel states both sign. If a keeper withdraws with an old state, the coordinator answers with a newer one the keeper signed. Once the keeper's account has real code, that signature stops counting and the keeper leaves with WETH it spent.

## Evidence

- [initiateTimelockedWithdrawal](https://etherscan.io/address/0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6#code) requires the keeper's ECDSA signature, also on the coordinator's challenge.
- [executeTimelockedWithdrawal](https://etherscan.io/address/0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6#code) pays out after seven days with no signature.
- A [keeper](https://etherscan.io/address/0x766648e039e663eea55463782a5f0543dce7fe17) still has 10.7 WETH staked here, of which 5.55 WETH is settled as spent.

## Reviewer notes

### Mechanism

stake (lines 204-211) credits a keeper's WETH. Keeper and coordinator sign commitments off chain (stakeSpent, stakeNonce). initiateTimelockedWithdrawal (305-349): only the keeper may start it (310); the coordinator may resubmit a newer commitment while the timelock runs (318), which resets it. Every submission recovers both the keeper's signature (321-324) and the coordinator's (325-328) with ECDSA. executeTimelockedWithdrawal (356-372) pays stakedAmount - stakeSpent after seven days with no signature. A keeper that starts with an old commitment and then moves its account to real code makes the coordinator's newer commitment fail at line 324, so it withdraws WETH it already spent; settleSpentStake (257-295) fails the same way, so the coordinator's unsettled earnings, from which claims are paid, are lost. The contract has no proxy and no setter for the keeper check; updateCoordinatorAddress only changes the coordinator key. At the block the coordinator and claim generator are 0x3a8f4dff... (an account without code, an operator); keeper 0x766648e0... (no code) has 10.7 WETH staked and 5.545 spent; totalClaimableAmount is 3.44 WETH; the contract holds 8.60 WETH.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or second path for a keeper with code: every commitment check uses ECDSA.recover and compares with stakeAddress (lines 272-275, 321-324, 395-398).
- Ruled out: taken back without migrating: the keeper cannot withdraw alone; every exit needs the coordinator's signature on the commitment (325-328, 399-402), and the coordinator can answer an old one while the keeper has no code.
- Ruled out: a fix by setting: updateCoordinatorAddress (183-188) replaces only the coordinator key; recoverTokens cannot move WETH, which the constructor blacklists (line 170).
- Ruled out: Whether the coordinator holds signed keeper commitments newer than those settled on chain: off-chain state that no read shows; the card states the mechanism and what the keeper has staked and spent on chain, not a pending commitment.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-27: reviewed again and rewritten from checks that were re-run.
