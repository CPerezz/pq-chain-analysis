---
id: atokeninstance-23878914-permit-signature
format: 2
title: A post-quantum aEthUSDT holder can still be drained by a forged ECDSA permit
status: confirmed
severity: MEDIUM
justification: A forged permit can move a holder's aTokens; a pool-admin upgrade through the PoolConfigurator can
  fix it.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x23878914efe38d27c4d67ab83ed1b93a74d4086a'
  name: ATokenInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 2897823632
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the aToken via the PoolConfigurator so permit checks owners with real code by ERC-1271 only, never
  by ecrecover.
evidence_level: source
checks:
- id: permit-ecdsa
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: AToken.sol
  line: 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts the signature only if ECDSA recovery returns the owner
  for:
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: AToken.sol
  lines:
  - 183
  - 184
  has: '_approve({owner: owner, spender: spender, amount: value, emitEvent: true});'
  says: a valid permit sets the owner's allowance for the spender
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: ecrecover
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover calls the ecrecover precompile
  for:
  - evidence-1
  - what
- id: spend
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: AToken.sol
  lines:
  - 186
  - 235
  has: _transfer(sender, recipient, amount.toUint120());
  says: transferFrom spends the allowance and moves the holder's aTokens to the recipient
  for:
  - justification
  - what
  - whose
- id: proxy-admin
  call: '0x23878914efe38d27c4d67ab83ed1b93a74d4086a'
  fn: admin()(address)
  from: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: the proxy's admin is the PoolConfigurator
  for:
  - action
  - admin
  - evidence-2
  - justification
  - upgradeable
- id: upgrade-fn
  source: '0x23878914efe38d27c4d67ab83ed1b93a74d4086a'
  file: BaseImmutableAdminUpgradeabilityProxy.sol
  line: 56
  has: function upgradeTo(address newImplementation) external ifAdmin
  says: the proxy admin can replace the implementation
  for:
  - action
  - evidence-2
  - upgradeable
- id: configurator
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getPoolConfigurator()(address)
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: the Aave addresses provider names 0x64b761d8 as the PoolConfigurator
  for:
  - action
  - admin
  - evidence-2
  - justification
- id: configurator-guard
  call: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  data: '0x14ef0ac50000000000000000000000000000000000000000000000000000000000000020000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000adc45df3cf1584624c97338bef33363bf5b97ada000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000016100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000162000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts_with: '0xcdd36a97'
  says: updateAToken exists on the PoolConfigurator and refuses a caller that is not a pool admin (CallerNotPoolAdmin)
  for:
  - action
  - evidence-2
  - justification
- id: executor-admin
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: isPoolAdmin(address)(bool)
  args:
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: true
  says: 0x5300a1a1 holds the pool admin role, so a live caller can drive updateAToken
  for:
  - evidence-2
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

Aave's aEthUSDT token lets a holder approve a spender with a permit signed in ECDSA, and checks it with ecrecover alone. A holder who moves to post-quantum authorisation at the same address can still be drained: permit never asks the account, so a forged ECDSA permit moves its aTokens.

## Evidence

- [permit](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code) sets the allowance only if ecrecover returns the owner; it never asks the owner by ERC-1271.
- The [proxy](https://etherscan.io/address/0x23878914efe38d27c4d67ab83ed1b93a74d4086a#code) is upgraded by the PoolConfigurator, which refuses callers that are not pool admins.

## Reviewer notes

### Mechanism

AToken.permit (lines 162-185 of the implementation 0xadc45df3) builds the EIP-712 digest from the owner's nonce and requires owner == ECDSA.recover(digest, v, r, s); ECDSA.recover calls ecrecover (ECDSA.sol line 148). On success it bumps the nonce and calls _approve(owner, spender, value). transferFrom (lines 186-237) spends that allowance and moves the owner's aTokens to any recipient, who can redeem them for USDT through the Pool. No isValidSignature call and no code check anywhere on this path. The proxy 0x23878914 is an InitializableImmutableAdminUpgradeabilityProxy whose immutable admin is the PoolConfigurator 0x64b761d8 (admin() answers 0x64b761d8 when called from it); upgradeTo is ifAdmin. The PoolConfigurator (from POOL() -> ADDRESSES_PROVIDER() -> getPoolConfigurator()) exposes updateAToken and reverts with CallerNotPoolAdmin (0xcdd36a97) for other callers. 0x5300a1a1, a contract (1,808 bytes) that owns the addresses provider, is a pool admin in the ACL manager 0xc2aacf65. Holders can still use approve directly, which takes no signature; that does not stop a forged permit, so the rating is MEDIUM (fix is a contract upgrade), not LOW.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: permit has no isValidSignature call or code-length branch (AToken.sol lines 162-185); the only signature path is ECDSA.recover.
- Ruled out: unused-implementation: the row's address is the proxy users call; totalSupply is 2,900,699,096.009980 aEthUSDT and it holds 419,372,542.69 USDT at block 26,438,999.
- Ruled out: path-closed: the USDT reserve is active, not frozen and not paused at block 26,438,999 (Pool.getConfiguration bits 56/57/60 = 1/0/0); permit itself has no pause check.
- Ruled out: setter: the PoolConfigurator is the proxy's immutable admin (call from it to admin() returns it); updateAToken exists in its implementation 0xff42ce30 (selector 0x14ef0ac5) and is pool-admin gated. A simulated updateAToken from the Executor with the same implementation reverted with empty data (likely re-initialization), so the upgrade itself was not executed in simulation.
- Ruled out: breaks-by-itself / EIP-8151: this row is rated under quantum-exposure, where EIP-8151 is not assumed. The family replay 0xde8136cd (another copy of this implementation) succeeds under EIP-8151 and reverts with code at the signer; it is not cited because it is not this address.
- Ruled out: Other aTokens on the same implementation (aEthWETH, aEthUSDC, ...) are separate rows; aEthAAVE additionally has metaDelegate on another implementation.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
