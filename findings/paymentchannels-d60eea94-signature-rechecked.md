---
id: paymentchannels-d60eea94-signature-rechecked
format: 2
title: PaymentChannels voids staker spend once the account takes real code
status: confirmed
severity: CRITICAL
justification: Stake notary relies on the staker's signature; code there later voids it, with no upgrade path.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd60eea947aae39e507430b30ce11f142304d9cb1'
  name: PaymentChannels
  code: verified
  code_url: https://etherscan.io/address/0xd60eea947aae39e507430b30ce11f142304d9cb1#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 6594
  whose: mixed
  basis: held
activity:
  txs_90d: 5589
impact: funds-loss
action: Settle stake commitments soon after they are signed, and deploy a version that asks stakers whose accounts
  have real code through ERC-1271.
evidence_level: source
checks:
- id: settle-staker
  source: '0xd60eea947aae39e507430b30ce11f142304d9cb1'
  file: src/PaymentChannels.sol
  line: 782
  has: require(recoveredStakerAddress == commitment.stakerAddress
  says: settlement requires the recovered staker to match the commitment's staker
  for:
  - action
  - evidence-1
  - justification
  - what
  - whose
- id: settle-notary
  source: '0xd60eea947aae39e507430b30ce11f142304d9cb1'
  file: src/PaymentChannels.sol
  line: 788
  has: require(recoveredStakeNotaryAddress == stakeNotaryAddress
  says: settlement also requires the stake notary's signature
  for:
  - justification
  - what
- id: pool
  source: '0xd60eea947aae39e507430b30ce11f142304d9cb1'
  file: src/PaymentChannels.sol
  line: 804
  has: adjustTotalClaimableAmount(totalNewStakeRefundedAmount, totalNewStakeSpentAmount);
  says: settled spend is added to the claimable pool
  for:
  - justification
  - what
- id: claim-cap
  source: '0xd60eea947aae39e507430b30ce11f142304d9cb1'
  file: src/PaymentChannels.sol
  line: 1037
  has: require(claimAmount <= totalClaimableAmount
  says: claims are paid only up to the claimable pool
  for:
  - evidence-2
  - whose
- id: claimable
  call: '0xd60eea947aae39e507430b30ce11f142304d9cb1'
  fn: totalClaimableAmount()(uint256)
  is: '3392185098471323937'
  says: the claimable pool is 3.39 ETH at the block
  for:
  - evidence-2
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xd60eea947aae39e507430b30ce11f142304d9cb1'
  is: '3654015715019611819'
  says: the contract holds 3.65 ETH
  for:
  - evidence-2
- id: notary
  call: '0xd60eea947aae39e507430b30ce11f142304d9cb1'
  fn: stakeNotaryAddress()(address)
  is: '0x7b4c1a2ec1ba718c2696923305e21e2b6a299d84'
  says: the stake notary key
  for:
  - notes
- id: notary-code
  code: '0x7b4c1a2ec1ba718c2696923305e21e2b6a299d84'
  is: empty
  says: the stake notary has no code
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews:
- who: r-d60eea94, the row's refuter
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: reader-1, the reader who settled the row (also its author)
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 'kept: SMG PaymentChannels (ETH): stakers pay with commitments that they and the stake notary co-sign; anyone
    settles them later by recovering the staker''s ECDSA signature (settleStakeCommitments, line 782) into the pool
    that pays claims. A staker whose account takes real code voids its unsettled spend; it cannot take it back without
    migrating, because the stake notary can challenge a timelocked unstake with a newer commitment. PQ-15, CRITICAL:
    no proxy, no upgrade, recoverToken moves only ERC-20 tokens, and others lose. Fix: settle commitments soon and
    deploy a version with ERC-1271. Refuter agreed. Reader dropped the author''s open question (which stakers hold
    open channels): the card does not depend on it; noted under ruled_out. The staker''s own locked stake is the
    address''s separate own-signature-only-exit row.'
related: []
---

## What happens

Stakers pay with commitments they and the stake notary sign; anyone settles them later into the pool that pays claims. Settlement recovers the staker's signature again; once its account has real code, unsettled spend can no longer settle.

## Evidence

- [settleStakeCommitments](https://etherscan.io/address/0xd60eea947aae39e507430b30ce11f142304d9cb1#code) requires the recovered staker to equal stakerAddress, with no ERC-1271 path.
- [claim](https://etherscan.io/address/0xd60eea947aae39e507430b30ce11f142304d9cb1#code) pays at most totalClaimableAmount, 3.39 ETH of the 3.65 ETH held at the block.

## Reviewer notes

### Mechanism

settleStakeCommitments (lines 750-808) recovers each commitment's stakerSignature with ECDSA and requires it to equal commitment.stakerAddress (782), then the stake notary's signature (788), and adds the newly spent amount to totalClaimableAmount (804). claim (1017-1049) pays claimers only up to totalClaimableAmount (1037). Under EIP-8151 the recovery returns no address once the staker's account has real code, so the notary's held commitments revert and the spend never reaches the claim pool. The staker cannot undo the spend without migrating: startTimelockedUnstake (837-886) can be challenged by the stake notary with a newer commitment (850), which is settled. The staker's own exits (unstake 967, startTimelockedUnstake 857) also need its ECDSA signature, so its remaining stake stays in the contract. All three notary keys are one account without code at the block; the contract has no proxy and no upgrade function.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: the signer taking it back without migrating: a timelocked unstake with an older commitment can be challenged by the stake notary with a newer one (line 850).
- Ruled out: an ERC-1271 path for stakers with real code: none in settleStakeCommitments, unstake or startTimelockedUnstake (lines 778-788, 857, 967).
- Ruled out: a key with code: the stake notary is an account without code at the block, so settlement works today.
- Ruled out: Which stakers hold open stake channels at the block: not read (it needs the Staked and Unstaked logs); the card states the mechanism and the amounts held, not any one staker's position.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-27: reviewed again and rewritten from checks that were re-run.
