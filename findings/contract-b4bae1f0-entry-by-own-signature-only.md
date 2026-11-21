---
id: contract-b4bae1f0-entry-by-own-signature-only
format: 2
title: Token subscriptions stop once a subscriber's account takes real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a subscriber moves its account to real code, which ends its subscriptions here as
  cancelling would.
category: migration-notice
pattern: PQ-21
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  code: decompiled
  code_url: code/0x2514a6a7b67e99ecab2119be44011729b5ebc972986c970191dd789dc9ec8b31.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before converting an account to real code, re-subscribe from one without it; an EIP-7702 delegation keeps
  working.
evidence_level: bytecode
checks:
- id: sig-recovers
  call: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  fn: getSubscriptionSigner(bytes32,bytes)(address)
  args:
  - '0x2d63081a72a9557db5def8e36c59590794c1accf5f6c5d1a2683e500e6138b60'
  - '0x9cf7a925a1a2b672482a26f94c96f2b9067d710529cd0808971a77048db7ce5b6fd8e9f488b9a74dd34ae1bf35712a592436c36d9031d5e35a7cc4435de794221c'
  is: '0x77AA39e55cf6d0F188E6E10441602953a3600650'
  says: a subscription signature from a fresh test key recovers to that key's address
  for:
  - what
- id: exec-ok
  call: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  fn: executeSubscription(address,address,address,uint256,uint256,uint256,bytes)(bool)
  args:
  - '0x77AA39e55cf6d0F188E6E10441602953a3600650'
  - '0x000000000000000000000000000000000000dEaD'
  - '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
  - 0
  - 0
  - 0
  - '0x9cf7a925a1a2b672482a26f94c96f2b9067d710529cd0808971a77048db7ce5b6fd8e9f488b9a74dd34ae1bf35712a592436c36d9031d5e35a7cc4435de794221c'
  from: '0x000000000000000000000000000000000000bEEF'
  is: true
  says: any caller can execute a pull signed by the subscriber named in the call
  for:
  - evidence-1
  - what
- id: exec-wrong
  call: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  fn: executeSubscription(address,address,address,uint256,uint256,uint256,bytes)(bool)
  args:
  - '0x000000000000000000000000000000000000dEaD'
  - '0x000000000000000000000000000000000000dEaD'
  - '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
  - 0
  - 0
  - 0
  - '0x9cf7a925a1a2b672482a26f94c96f2b9067d710529cd0808971a77048db7ce5b6fd8e9f488b9a74dd34ae1bf35712a592436c36d9031d5e35a7cc4435de794221c'
  reverts_with: Invalid Signature
  says: a pull for a subscriber the signature does not recover to is rejected
  for:
  - action
  - evidence-1
  - justification
  - what
- id: exec-terms
  call: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  fn: executeSubscription(address,address,address,uint256,uint256,uint256,bytes)(bool)
  args:
  - '0x77AA39e55cf6d0F188E6E10441602953a3600650'
  - '0x000000000000000000000000000000000000dEaD'
  - '0xE41d2489571d322189246DaFA5ebDe1F4699F498'
  - 1000
  - 86400
  - 0
  - '0xd9b010fe9a6bf7274aea55ab1915b6c50ca781256713969e44ae7af0f02879105d914e79a26d0ca4e1dce8107bef1bfd29281ea9e796731747de22a6b25830291b'
  reverts_with: Transfer Failed
  says: a pull with another token, amount and a one-day period passes the signature and terms and reaches the token
    transfer
  for:
  - evidence-2
  - what
- id: cancel-ok
  call: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  fn: cancelSubscription(address,address,address,uint256,uint256,uint256,bytes)(bool)
  args:
  - '0x77AA39e55cf6d0F188E6E10441602953a3600650'
  - '0x000000000000000000000000000000000000dEaD'
  - '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
  - 0
  - 0
  - 0
  - '0x9cf7a925a1a2b672482a26f94c96f2b9067d710529cd0808971a77048db7ce5b6fd8e9f488b9a74dd34ae1bf35712a592436c36d9031d5e35a7cc4435de794221c'
  is: true
  says: the subscriber's signature cancels the subscription
  for:
  - evidence-3
  - justification
- id: cancel-wrong
  call: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  fn: cancelSubscription(address,address,address,uint256,uint256,uint256,bytes)(bool)
  args:
  - '0x000000000000000000000000000000000000dEaD'
  - '0x000000000000000000000000000000000000dEaD'
  - '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
  - 0
  - 0
  - 0
  - '0x9cf7a925a1a2b672482a26f94c96f2b9067d710529cd0808971a77048db7ce5b6fd8e9f488b9a74dd34ae1bf35712a592436c36d9031d5e35a7cc4435de794221c'
  reverts_with: Invalid Signature for subscription cancellation
  says: cancelling needs a signature that recovers to the subscriber
  for:
  - evidence-3
  - what
- id: req-recipient
  storage: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  slot: 1
  is: 0
  says: the stored required recipient is unset
  for:
  - evidence-2
- id: req-token
  storage: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  slot: 2
  is: 0
  says: the stored required token is unset
  for:
  - evidence-2
- id: req-amount
  storage: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  slot: 3
  is: 0
  says: the stored required amount is unset
  for:
  - evidence-2
- id: req-period
  storage: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  slot: 4
  is: 0
  says: the stored required period is unset
  for:
  - evidence-2
- id: req-fee
  storage: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  slot: 5
  is: 0
  says: the stored required fee is unset
  for:
  - evidence-2
- id: no-1271
  selector: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code has no ERC-1271 entry point
  for:
  - notes
- id: gas-all
  bytecode: '0xb4bae1f0edeea19772d37912888f90a8e7425885'
  has: 865af115
  says: the signature recovery call forwards all remaining gas (DUP7 GAS CALL ISZERO), not a fixed amount
  for:
  - notes
- id: spec
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: 'EIP-8151: recovery returns nothing for an account with real code; an EIP-7702 delegation still recovers'
  for:
  - action
  - justification
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

Subscribers sign payment terms once; anyone can then pull each period's tokens from their wallet. Every pull and cancel checks that signature again. Once a subscriber's account takes real code, its subscriptions here stop; an EIP-7702 delegation keeps working.

## Evidence

- [Simulated at the pinned block](https://etherscan.io/address/0xb4bae1f0edeea19772d37912888f90a8e7425885#code), a pull signed by a fresh key succeeds for any caller and fails for another subscriber.
- [No recipient, token or terms are fixed](https://etherscan.io/address/0xb4bae1f0edeea19772d37912888f90a8e7425885#code): the stored requirements are empty, and other terms reach the token transfer.
- [Cancelling](https://etherscan.io/address/0xb4bae1f0edeea19772d37912888f90a8e7425885#code) also needs a signature that recovers to the subscriber.

## Reviewer notes

### Mechanism

Unverified EIP-1337 token-subscription code (selectors resolve to executeSubscription, cancelSubscription, getSubscriptionHash, getSubscriptionSigner, isSubscriptionReady). executeSubscription(from,to,token,amount,period,gasPrice,sig) hashes the terms, recovers the signer from the Ethereum-signed-message hash with all remaining gas, and requires it to equal from ('Invalid Signature'); it then checks the period has elapsed, stores the next valid time, calls token.transferFrom(from,to,amount), checks the recipient balance rose, and pays gasPrice from `from` to the caller. cancelSubscription recovers the same signature and sets the next valid time to the maximum. The required* slots (1-5) are zero, so any recipient, token and terms are accepted (shown by eth_call at block 26,438,999 with a fresh key). No ERC-1271 path, no admin, no proxy. Under EIP-8151 the recovery returns nothing once `from` has real code, so pulls and signed cancels revert for that subscriber.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: signature-rechecked (rated): each pull is paid when it executes, before the next period, and the subscriber can stop any time by cancelSubscription or by revoking the token allowance directly; migrating voids nothing someone already relied on.
- Ruled out: fixed-gas-recovery: the recovery call forwards all remaining gas (GAS CALL), so the price change alone does not break it.
- Ruled out: an ERC-1271 or direct path: no isValidSignature selector; no function executes or cancels for the caller without the signature.
- Ruled out: a closed path: the required terms are unset and a fresh-key pull succeeds at the block.
- Ruled out: Not a Connext ledger channel as first placed by template: the selectors and revert texts are the EIP-1337 subscription contract's.

### Questions

- Whether any subscription was ever executed through this address is not established: the row shows no transactions in 90 days, and no log scan was allowed.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
