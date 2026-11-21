---
id: contract-8d6695f3-entry-by-own-signature-only
format: 2
title: Token subscriptions stop for subscribers whose accounts take real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a subscriber moves to real code, which ends only its own payments, as revoking its
  allowance already can.
category: migration-notice
pattern: PQ-21
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  code: decompiled
  code_url: code/0xd0e52fa458159e74b8a9bb39314b112ccae2c4bd72b58b25bb4269621e2bb2f6.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Warn subscribers that payments stop and they cannot subscribe once their account takes real code; an EIP-7702
  delegation keeps working.
evidence_level: bytecode
checks:
- id: sig-eq
  bytecode: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  has: 496e76616c6964205369676e6174757265
  says: the code holds the revert reason 'Invalid Signature' raised when the recovered address differs from the
    subscriber
  for:
  - action
  - evidence-1
  - justification
  - what
  - whose
- id: exec
  selector: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: executeSubscription(address,address,address,uint256,uint256,uint256,bytes)
  says: the code has executeSubscription, the function that recovers the signature and makes each payment
  for:
  - evidence-1
  - what
- id: no1271
  selector: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code never asks a signer with code through ERC-1271
  for:
  - action
  - evidence-1
  - what
- id: ec-gas
  bytecode: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  has: 206040516020810390808403906000865af115
  says: the call to the recovery precompile forwards all remaining gas, not a constant
  for:
  - justification
- id: pull
  bytecode: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  has: 23b872dd
  says: the code calls the token's transferFrom to take each payment from the subscriber's allowance
  for:
  - justification
  - what
- id: tok-cond
  bytecode: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  has: 73ffffffffffffffffffffffffffffffffffffffff16600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff161480610d525750600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168973ffffffffffffffffffffffffffffffffffffffff16145b1515610d5d57600080fd
  says: the token argument is checked against the stored token only when the stored token is not zero
  for:
  - evidence-2
  - what
- id: cfg-token
  call: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: requiredTokenAddress()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: no token is set, so any token is accepted
  for:
  - evidence-2
  - what
- id: cfg-to
  call: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: requiredToAddress()(address)
  is: '0xe87529A6123a74320e13A6Dabf3606630683C029'
  says: the payee is fixed to 0xe875…c029
  for:
  - evidence-2
  - what
- id: cfg-amt
  call: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: requiredTokenAmount()(uint256)
  is: '1'
  says: each payment is 1 unit of the token
  for:
  - evidence-2
  - what
- id: cfg-period
  call: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: requiredPeriodSeconds()(uint256)
  is: '30'
  says: a payment can be taken every 30 seconds
  for:
  - evidence-2
  - what
- id: recover-now
  call: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: getSubscriptionSigner(bytes32,bytes)(address)
  args:
  - '0x97f4247d3cfd5a5725263e9a3e2723cf1431b269cc2a60c91634dc524c1e09fb'
  - '0xb45e2f95b1bc2afbeee1bbf42654236c60552d40a1dce7f4622a9548f5eb14c32e20c83757e75ba583c989b93059787e9f1965d2c016d100371c72caba9a26001c'
  is: '0xEE4811b9462956C9C3535E79c08776D769CA9F3a'
  says: a fresh subscriber's signature over a subscription hash recovers to its own address today
  for:
  - what
- id: fee-pull
  bytecode: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  has: a360008611156113f1578873ffffffffffffffffffffffffffffffffffffffff166323b872dd8c3389
  says: after the payment, if the signed fee is above zero, the code calls the token's transferFrom with the caller
    as recipient
  for:
  - what
- id: gas-cond
  bytecode: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  has: 60006005541480610da9575060055486145b1515610db457600080fd
  says: the signed fee is checked against the stored fee only when the stored fee is not zero
  for:
  - what
- id: gas-unset
  call: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: requiredGasPrice()(uint256)
  is: '0'
  says: no fee is set, so any signed fee is accepted
  for:
  - what
- id: ready-str
  bytecode: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  has: 537562736372697074696f6e206973206e6f74207265616479
  says: a payment reverts 'Subscription is not ready' until the subscription's own next-valid time has passed
  for:
  - what
- id: hash-token
  call: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: getSubscriptionHash(address,address,address,uint256,uint256,uint256)(bytes32)
  args:
  - '0xEE4811b9462956C9C3535E79c08776D769CA9F3a'
  - '0xe87529A6123a74320e13A6Dabf3606630683C029'
  - '0xdAC17F958D2ee523a2206206994597C13D831ec7'
  - '1'
  - '30'
  - '0'
  is: '0x7946541f00fe8df876fd7d1526f3a169a4f43f588afc8408e8d50aaadce6d6c0'
  says: one subscriber's subscription hash for USDT
  for:
  - what
- id: hash-token-2
  call: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: getSubscriptionHash(address,address,address,uint256,uint256,uint256)(bytes32)
  args:
  - '0xEE4811b9462956C9C3535E79c08776D769CA9F3a'
  - '0xe87529A6123a74320e13A6Dabf3606630683C029'
  - '0x6B175474E89094C44Da98b954EedeAC495271d0F'
  - '1'
  - '30'
  - '0'
  is: '0xfed3d00c214be4ebceae0f42b3071d3f545b7df029ccbafa15265da8963657e6'
  says: the same subscriber for DAI gets a different hash, so a separate timer
  for:
  - what
- id: hash-fee
  call: '0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c'
  fn: getSubscriptionHash(address,address,address,uint256,uint256,uint256)(bytes32)
  args:
  - '0xEE4811b9462956C9C3535E79c08776D769CA9F3a'
  - '0xe87529A6123a74320e13A6Dabf3606630683C029'
  - '0x6B175474E89094C44Da98b954EedeAC495271d0F'
  - '1'
  - '30'
  - '1000000'
  is: '0x791445082d6988c0a3f9fc1c4bb874faf6a39b517f21a905ef88a9f2dcee1e44'
  says: the signed fee is part of the hash too, so another fee is another subscription
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews: []
related: []
---

## What happens

Anyone can collect, on a subscriber's signature, 1 unit of a token it picks for one payee, plus a fee it signed for the caller, once per 30 seconds per signed subscription. Each payment checks that signature again, so a subscriber whose account takes real code can no longer subscribe or be charged.

## Evidence

- The [deployed code](https://etherscan.io/address/0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c#code) requires the recovered address to equal the subscriber before each payment and has no ERC-1271 path.
- [Its settings](https://etherscan.io/address/0x8d6695f3eaec9c935ff8cb7c23e3bd7206bd1b7c#readContract): payee 0xe875…c029, amount 1, period 30 seconds, token unset, which the code reads as any token.

## Reviewer notes

### Mechanism

Unverified code; the decompiler's output was used as a lead and corrected from the bytecode (it dropped the 'required == 0 ||' branches). executeSubscription (0x691d9352) hashes (from, to, token, amount, period, gasPrice), recovers the signature with the ecrecover precompile given all remaining gas, after zeroing the output word, and reverts 'Invalid Signature' unless the result equals from. It then requires the next valid time to have passed, checks each argument against the stored setting unless that setting is zero (token is zero, so any token), sets the next time to now + period, and calls token.transferFrom(from, to, amount) and, if gasPrice > 0, transferFrom(from, msg.sender, gasPrice). cancelSubscription (0xb57b0c7f) also needs the subscriber's own signature. No setter writes slots 0-5; no owner, pause or upgrade path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: signature-rechecked (the row's issue): the payee is paid at the start of each period and the relayer is repaid in the same transaction, so nobody acts on a signature before it is checked again; a migrated subscriber only stops future payments, which revoking its allowance already does.
- Ruled out: fixed gas: the only call to the precompile passes GAS (6000865af1 at 0x1a2f), not a constant.
- Ruled out: ERC-1271 or code-size branch for the signer: no 0x1626ba7e or 0x20c13b0b in the code; every EXTCODESIZE precedes a token call.
- Ruled out: path closed: no pause or setter exists, and the unset token setting accepts any token, so subscriptions can still be executed at the block.
- Ruled out: direct path: no function makes a payment or a subscription without the subscriber's signature.

### Questions

- Whether anyone has ever subscribed through this address is not shown by a read at the block: the subscriptions are a mapping keyed by hash, and the payee 0xe875…c029 has no code and nonce 0.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
