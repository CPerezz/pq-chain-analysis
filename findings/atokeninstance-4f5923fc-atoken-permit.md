---
id: atokeninstance-4f5923fc-atoken-permit
format: 2
title: aEthUSDe permit lets a holder's old ECDSA key move their aTokens
status: confirmed
severity: MEDIUM
justification: A derived key moves a holder's aTokens even after the holder migrates; Aave's pool admin can fix
  it by upgrade.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4f5923fc5fd4a93352581b38b7cd26943012decf'
  name: ATokenInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 627719307
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the aToken so permit refuses ECDSA for owners whose accounts have code and asks them through ERC-1271
  only.
evidence_level: source
checks:
- id: permit
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 162
  - 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts a signature only if its ECDSA recovery equals the owner
  for:
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 182
  - 184
  has: '_approve({owner: owner, spender: spender, amount: value, emitEvent: true});'
  says: after the ECDSA check permit sets the spender's allowance over the owner's aTokens
  for:
  - evidence-1
  - justification
  - what
- id: transferfrom
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 188
  - 198
  has: _spendAllowance(
  says: transferFrom lets a spender move the owner's aTokens against that allowance
  for:
  - justification
  - what
- id: admin
  call: '0x4f5923fc5fd4a93352581b38b7cd26943012decf'
  fn: admin()(address)
  from: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: the proxy's admin is the pool configurator 0x64b7
  for:
  - action
  - admin
  - evidence-2
  - justification
  - upgradeable
- id: configurator
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getPoolConfigurator()(address)
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: Aave's pool addresses provider names 0x64b7 as the pool configurator
  for:
  - admin
- id: proxy-upgrade
  source: '0x4f5923fc5fd4a93352581b38b7cd26943012decf'
  file: '@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol'
  lines:
  - 69
  - 77
  has: function upgradeToAndCall(address newImplementation, bytes calldata data)
  says: the proxy's admin can replace the implementation
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: cfg-impl
  storage: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  says: the pool configurator runs implementation 0xff42
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: cfg-update
  source: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  file: lib/aave-v3-origin-private/src/contracts/protocol/pool/PoolConfigurator.sol
  lines:
  - 96
  - 100
  has: ConfiguratorLogic.executeUpdateAToken(_pool, input);
  says: updateAToken, for the pool admin, replaces an aToken's implementation
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: cfg-logic
  source: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  file: lib/aave-v3-origin-private/src/contracts/protocol/libraries/logic/ConfiguratorLogic.sol
  lines:
  - 180
  - 190
  has: proxy.upgradeToAndCall(implementation, initParams);
  says: the configurator upgrades the aToken proxy with upgradeToAndCall
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: cfg-onlyadmin
  source: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  file: lib/aave-v3-origin-private/src/contracts/protocol/pool/PoolConfigurator.sol
  lines:
  - 584
  - 587
  has: require(aclManager.isPoolAdmin(msg.sender), Errors.CallerNotPoolAdmin());
  says: only an account the ACL manager calls pool admin can call updateAToken
  for:
  - action
  - evidence-2
  - justification
- id: acl
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getACLManager()(address)
  is: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  says: the addresses provider names 0xc2aa as the ACL manager
  for:
  - action
  - evidence-2
  - justification
- id: pooladmin
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: isPoolAdmin(address)(bool)
  args:
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: 'true'
  says: a pool admin is set (0x5300a1a1...), so the upgrade path is reachable
  for:
  - action
  - evidence-2
  - justification
- id: supply
  call: '0x4f5923fc5fd4a93352581b38b7cd26943012decf'
  fn: totalSupply()(uint256)
  is: '627973348108932502258829646'
  says: holders own about 628 million aEthUSDe at the block
  for:
  - whose
- id: underlying-held
  call: '0x4c9edd5852cd905f086c759e8383e09bff1e68b3'
  fn: balanceOf(address)(uint256)
  args:
  - '0x4f5923fc5fd4a93352581b38b7cd26943012decf'
  is: '615930236854211197730416848'
  says: the token holds about 616 million USDe deposited by its holders
  for:
  - whose
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

Aave's aEthUSDe token accepts a permit only when an ECDSA signature recovers to the holder. A quantum attacker who derives a holder's key can sign a permit and pull that holder's aTokens, even after the holder moves the account to post-quantum authorisation.

## Evidence

- [permit](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code) recovers the signer with ECDSA, compares it with the owner and sets the allowance; it never asks the owner's account.
- [updateAToken](https://etherscan.io/address/0xff42ce30054dce7dc7c1282a9a497aa58eabce99#code) lets Aave's pool admin upgrade this token through the pool configurator, which is the proxy's admin.

## Reviewer notes

### Mechanism

aEthUSDe (0x4f59...) is an Aave InitializableImmutableAdminUpgradeabilityProxy whose EIP-1967 slot points at ATokenInstance 0xadc4. AToken.permit (lines 162-185) builds the EIP-712 digest with the owner's nonce, requires owner == ECDSA.recover(digest, v, r, s), bumps the nonce and calls _approve(owner, spender, value). transferFrom (line 188 on) spends that allowance and moves the scaled balance, which the spender can redeem for USDe through the pool. There is no isValidSignature call anywhere in the implementation's source, so an owner whose address now runs post-quantum account code is still bound by its old secp256k1 key: anyone holding that key can sign a permit. The proxy's immutable admin is the PoolConfigurator 0x64b7 (admin() answers it when called from 0x64b7, the address the pool's addresses provider names). Its implementation 0xff42 exposes updateAToken (onlyPoolAdmin: ACLManager.isPoolAdmin) which calls ConfiguratorLogic._upgradeTokenImplementation -> proxy.upgradeToAndCall. The ACL manager named by the addresses provider reports 0x5300a1a1... as a pool admin, so the fix is an Aave upgrade decided by that admin, not a protocol change: MEDIUM.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for owners with code: the implementation's source has no isValidSignature or 1271 reference, and permit (lines 162-185) only compares the ECDSA result with the owner.
- Ruled out: unused implementation: this is the proxy users call; name aEthUSDe, total supply 627,973,348 aEthUSDe and 615,930,236 USDe held at the block, and seven permit recoveries in the two-week trace window, all by accounts with no code.
- Ruled out: direct path: approve (IncentivizedERC20 lines 152-155) lets a holder grant an allowance by a direct call, so post-quantum holders are not locked out; it does not close the signed path.
- Ruled out: the fork replay 0xde8136cd... (EIP-8151 with signer code reverts) was not cited: it is a bundled call and this card is about the quantum-exposure rating, not the EIP-8151 change.
- Ruled out: other aTokens on the same implementation are separate rows; this card speaks only of aEthUSDe.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
