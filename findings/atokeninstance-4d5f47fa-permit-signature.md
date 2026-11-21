---
id: atokeninstance-4d5f47fa-permit-signature
format: 2
title: Aave aEthWETH accepts ECDSA permits that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A forged permit lets anyone spend a holder's aWETH; the fix is an Aave governance upgrade of the
  aToken.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4d5f47fa6a74757f35c14fd3a6ef8e3c9bc514e8'
  name: ATokenInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 3836319860
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the aToken implementation so permit asks accounts with real code through ERC-1271 instead of ECDSA.
evidence_level: source
checks:
- id: ecdsa
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts the owner's signature only through ECDSA recovery
  for:
  - evidence-1
  - justification
  - what
- id: approve-permit
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 184
  has: '_approve({owner: owner, spender: spender, amount: value, emitEvent: true});'
  says: a valid permit sets the spender's allowance on the owner's balance
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: transferfrom
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 188
  - 197
  has: _spendAllowance(
  says: transferFrom spends the allowance and moves the holder's own balance
  for:
  - justification
  - what
  - whose
- id: upgrade
  source: '0x4d5f47fa6a74757f35c14fd3a6ef8e3c9bc514e8'
  file: '@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol'
  lines:
  - 56
  - 58
  has: function upgradeTo(address newImplementation) external ifAdmin {
  says: the admin can replace the implementation
  for:
  - action
  - justification
  - upgradeable
- id: admin
  call: '0x4d5f47fa6a74757f35c14fd3a6ef8e3c9bc514e8'
  fn: admin()(address)
  from: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: the proxy admin is 0x64b7…bb27
  for:
  - action
  - admin
  - evidence-2
  - justification
  - upgradeable
- id: admin-bytes
  bytecode: '0x4d5f47fa6a74757f35c14fd3a6ef8e3c9bc514e8'
  has: 64b761d848206f447fe2dd461b0c635ec39ebb27
  says: the admin address is fixed in the proxy's code
  for:
  - admin
  - evidence-2
- id: no-1271
  selector: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the ERC-1271 isValidSignature selector appears nowhere in the aToken code, so permit never asks the account
  for:
  - what
- id: configurator
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getPoolConfigurator()(address)
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: Aave's addresses provider names 0x64b7…bb27 as the PoolConfigurator
  for:
  - action
  - evidence-2
  - justification
- id: update-atoken
  selector: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  fn: updateAToken((address,string,string,address,bytes))
  says: the PoolConfigurator implementation has updateAToken
  for:
  - action
  - evidence-2
  - justification
- id: pool-admin
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: isPoolAdmin(address)(bool)
  args:
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: 'true'
  says: 0x5300…192a is a pool admin in Aave's ACLManager
  for:
  - justification
- id: pool-admin-owner
  call: '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  fn: owner()(address)
  is: '0xdabad81af85554e9ae636395611c58f7ec1aaec5'
  says: the pool admin contract is owned by 0xdaba…aec5
  for:
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

Aave's aEthWETH grants an allowance when a holder signs a permit, checked with ECDSA only. A quantum attacker with a holder's key can sign a permit and take the aWETH, even after the holder moves to post-quantum keys at the same address: permit never asks the account.

## Evidence

- [permit](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code) requires owner == ECDSA.recover(digest, v, r, s), then approves the spender.
- The [proxy](https://etherscan.io/address/0x4d5f47fa6a74757f35c14fd3a6ef8e3c9bc514e8#code) has a fixed admin, Aave's PoolConfigurator 0x64b7…bb27, which upgrades aTokens with updateAToken.

## Reviewer notes

### Mechanism

The address is an InitializableImmutableAdminUpgradeabilityProxy over ATokenInstance 0xadc4…7ada. AToken.permit (lines 162-185) builds the EIP-712 digest with the owner's nonce, requires owner == ECDSA.recover(digest, v, r, s) and calls _approve(owner, spender, value). transferFrom (line 188 on) spends that allowance and moves the owner's scaled balance. No ERC-1271 branch. A holder that moves its own authorisation to post-quantum keys at the same address stays forgeable here (an EIP-7702 delegation does not change this; real code would only under EIP-8151, which this category does not assume). The proxy admin is an immutable set at construction: Aave's PoolConfigurator 0x64b7…bb27 (behind its own proxy, implementation 0xff42…ce99 exposes updateAToken). The ACL admin and a pool admin is 0x5300…192a, owned by 0xdaba…aec5, so an upgrade is an Aave governance action.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 for signers with code: permit has only ECDSA.recover (line 182).
- Ruled out: unused implementation: this is the proxy users call; name() returns Aave Ethereum WETH and the window shows 603 recoveries.
- Ruled out: direct path: holders can still approve() directly (IncentivizedERC20 line 152), so post-quantum accounts are not locked out, but that does not stop a forged permit after the holder migrates.
- Ruled out: a lone admin key: the proxy admin is the PoolConfigurator contract (getPoolConfigurator of provider 0x2f39…4e9e), whose implementation 0xff42…ce99 has updateAToken; ACLManager 0xc2aa…85b0 lists 0x5300…192a (owned by 0xdaba…aec5) as pool admin. That updateAToken is pool-admin-gated is from Aave's public source, not a check here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
