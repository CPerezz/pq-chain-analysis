---
id: paymentchannels-affa8300-signature-rechecked
format: 2
title: Payment channel spends stop settling once a staker's account takes real code
status: confirmed
severity: CRITICAL
justification: A staker who moves to real code voids its signed spends; nothing can change the contract.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  name: PaymentChannels
  code: verified
  code_url: https://etherscan.io/address/0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1#code
  copies: 2
  family: f37d66ccf0e1a2b64767777737114dec
  upgradeable: 'no'
value:
  usd: 100463
  whose: users
  basis: held
activity:
  txs_90d: 1
impact: funds-loss
action: Settle every held staker commitment promptly, and deploy a version that asks stakers with real code through
  ERC-1271.
evidence_level: source
checks:
- id: settle-staker
  source: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  file: contracts/PaymentChannels.sol
  line: 634
  has: require(recoveredStakerAddress == commitment.stakerAddress
  says: settling a commitment requires the recovered staker signature to match the staker
  for:
  - evidence-1
  - justification
  - what
- id: settle-anyone
  source: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  file: contracts/PaymentChannels.sol
  line: 592
  has: Any address may call this function
  says: anyone holding co-signed commitments can settle them
  for:
  - action
- id: unstake-staker
  source: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  file: contracts/PaymentChannels.sol
  lines:
  - 804
  - 815
  has: require(recoveredStakerAddress == _commitment.stakerAddress
  says: instant unstake requires the staker's own signature
  for:
  - evidence-2
  - what
- id: timelock-staker
  source: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  file: contracts/PaymentChannels.sol
  lines:
  - 701
  - 708
  has: require(recoveredStakerAddress == _commitment.stakerAddress
  says: the timelocked unstake and the notary's challenge require the staker's signature
  for:
  - evidence-2
  - what
- id: weth-unrecoverable
  source: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  file: contracts/PaymentChannels.sol
  line: 452
  has: setTokenUnrecoverable(address(WETH));
  says: the operator's token rescue excludes WETH from deployment
  for:
  - evidence-2
  - justification
  - what
- id: staked
  source: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  file: contracts/PaymentChannels.sol
  lines:
  - 540
  - 541
  has: stakedAmount[msg.sender] += _amount;
  says: WETH sent in is credited to the staker
  for:
  - what
  - whose
- id: claim-pay
  source: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  file: contracts/PaymentChannels.sol
  line: 941
  has: WETH.safeTransfer(_claimerAddress, claimAmount);
  says: claimable WETH is paid to claimers
  for:
  - whose
- id: weth-balance
  call: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  fn: balanceOf(address)(uint256)
  args:
  - '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  is: '55671928962132100985'
  says: the contract holds about 55.67 WETH
  for:
  - what
- id: no-1271
  bytecode: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  has: 1626ba7e
  absent: true
  says: the code never asks a signer through ERC-1271
  for:
  - action
  - what
- id: claims
  logs: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  topic: '0xd8138f8a3f377c5259ca548e70e4c2de94f129f5a11036a15b69513cba2b426a'
  from: 18464428
  count: 804
  says: 804 claims were paid from the contract's creation to the block
  for:
  - notes
- id: claimer-1-not-operator
  call: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  fn: isOperator(address)(bool)
  args:
  - '0xf6337b38141c019cf7cd7a5752cbdf041a270bbb'
  is: false
  says: claimer 0xf6337b38… does not hold the operator role
  for:
  - notes
- id: claimer-2-not-operator
  call: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  fn: isOperator(address)(bool)
  args:
  - '0x3391aade96c1b96e23ef7f910b58b5c708b96ce5'
  is: false
  says: claimer 0x3391aade… does not hold the operator role
  for:
  - notes
- id: claimer-3-not-operator
  call: '0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1'
  fn: isOperator(address)(bool)
  args:
  - '0x5da10ca988e6eae47d3748b5fda95e0d85ffa408'
  is: false
  says: claimer 0x5da10ca9… does not hold the operator role
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
- who: r-affa8300, the row's refuter
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: reader-1, the reader who settled the row (also its author)
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 'kept: SMG PaymentChannels (WETH): stakers'' spends, co-signed off chain by the staker and the stake notary,
    are settled later by recovering the staker''s ECDSA signature (settleStakeCommitments) and paid to claimers
    from totalClaimableAmount on the claim notary''s signature. A staker that moves to real code voids spends already
    served, and its own stake stays locked because every exit needs its signature. PQ-15, CRITICAL: not upgradeable,
    WETH excluded from the operator''s rescue, and others lose. Fix: settle held commitments promptly and deploy
    a version with ERC-1271. Refuter agreed. The author''s open question (are the claimers the operator''s own addresses,
    which would make it MEDIUM) answered by the reader from the Claimed logs: 804 claims, the three largest claimers
    are Safes with overlapping owners and none holds the operator role; no check ties them to the operator, so CRITICAL
    stands. Checks claims and claimer-1..3-not-operator added; card text unchanged. The notary keys'' own rotate-before-migrating
    notice is a separate issue not filed here.'
related: []
---

## What happens

It holds stakers' WETH and pays spends the staker and a notary co-sign off chain. Settling rechecks the staker's ECDSA signature, so a staker whose account takes real code voids spends already served; an EIP-7702 delegation keeps working. Its stake then stays locked: every exit needs its signature.

## Evidence

- [settleStakeCommitments](https://etherscan.io/address/0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1#code) recovers the staker's signature and requires it to match the staker.
- [unstake and startTimelockedUnstake](https://etherscan.io/address/0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1#code) also require the staker's ECDSA signature; WETH is excluded from the operator's rescue.

## Reviewer notes

### Mechanism

A staker stakes WETH (stake, line 534). Off chain the staker and the stake notary co-sign StakeCommitments recording the cumulative amount spent; the service is delivered against them. settleStakeCommitments (lines 602-660), callable by anyone, recovers both signatures with OpenZeppelin ECDSA (ecrecover) and requires the first to equal commitment.stakerAddress (line 634) before crediting the spend to totalClaimableAmount, from which claimers are paid on the claim notary's signature (settleClaim, lines 908-946). The notary's challenge in startTimelockedUnstake (lines 689-737) rechecks the same staker signature (line 708). Under EIP-8151 a staker whose account has real code recovers to nothing, so every commitment it signed fails to settle and the notary cannot challenge. The staker cannot exit either: unstake (line 815) and startTimelockedUnstake (line 708) require its signature, and recoverToken refuses WETH, which the constructor marks unrecoverable for good (line 452; OperatorRecoverable lines 48-49, 82-85). The contract has no proxy or upgrade path.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: taken back without migrating: a staker can start a timelocked unstake with an older commitment, but the notary can challenge it with a newer one for 7 days (lines 672-676, 701), so the staker cannot take back spends alone.
- Ruled out: an ERC-1271 path: the runtime code has no isValidSignature selector.
- Ruled out: the notaries: both stake and claim notary keys are EOAs that the operator can replace (setStakeNotaryAddress, setClaimNotaryAddress); that is a separate rotate-before-migrating notice.
- Ruled out: use: one call in the 90 days to the block, a claim that reverted (0xc4af99046619b98a95b05347b0453cc616d4cc3dcb0423ffed35823119db5d8c); 20,247 recoveries to block 24,674,864 are a lead only.
- Ruled out: Claimers are the operator's own: 804 Claimed events since creation; the three largest claimers (0xf6337b38…, 0x3391aade…, 0x5da10ca9…) are Safe proxies with overlapping owners, and none of them holds the operator role (isOperator false). No check shows the claimers belong to the operator, so others' money is at stake and the rating stays CRITICAL.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-27: reviewed again and rewritten from checks that were re-run.
