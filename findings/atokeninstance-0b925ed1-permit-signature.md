---
id: atokeninstance-0b925ed1-permit-signature
format: 2
title: Aave aEthwstETH accepts ECDSA permits that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A forged key can take a holder's aTokens; Aave governance can fix it by upgrading the token.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0b925ed163218f6662a35e0f0371ac234f9e9371'
  name: ATokenInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 1862699425
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the aToken through governance to a permit that checks accounts with code through ERC-1271 instead
  of ECDSA.
evidence_level: source
checks:
- id: permit-recover
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts the signature only if ECDSA recovers the owner
  for:
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 183
  - 184
  has: '_approve({owner: owner, spender: spender, amount: value, emitEvent: true});'
  says: after the check permit sets the spender's allowance over the owner's aTokens
  for:
  - evidence-1
  - what
- id: transfer-from
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 188
  - 237
  has: _transfer(sender, recipient, amount.toUint120());
  says: transferFrom spends the allowance and moves the owner's aTokens to the recipient
  for:
  - justification
  - what
- id: underlying-pool-only
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 157
  has: function transferUnderlyingTo(address target, uint256 amount) external virtual override onlyPool {
  says: the underlying the token holds leaves only on the Pool's call, for depositors' withdrawals and borrows
  for:
  - whose
- id: upgrade-fn
  source: '0x0b925ed163218f6662a35e0f0371ac234f9e9371'
  file: '@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol'
  line: 56
  has: function upgradeTo(address newImplementation) external ifAdmin {
  says: the proxy's admin can replace the implementation
  for:
  - evidence-2
  - justification
  - upgradeable
- id: admin-bytecode
  bytecode: '0x0b925ed163218f6662a35e0f0371ac234f9e9371'
  has: 64b761d848206f447fe2dd461b0c635ec39ebb27
  says: the proxy's immutable admin is the PoolConfigurator 0x64b761d8
  for:
  - admin
  - evidence-2
  - justification
  - upgradeable
- id: configurator
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getPoolConfigurator()(address)
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: Aave's addresses provider names 0x64b761d8 as the pool configurator
  for:
  - admin
  - evidence-2
- id: update-atoken
  selector: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  fn: updateAToken((address,string,string,address,bytes))
  says: the pool configurator's implementation has updateAToken, which installs a new aToken implementation
  for:
  - action
  - evidence-2
  - justification
- id: executor-pool-admin
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: isPoolAdmin(address)(bool)
  args:
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: true
  says: Aave's Governance V3 Executor is pool admin in the ACL manager
  for:
  - action
  - evidence-2
  - justification
- id: supply
  call: '0x0b925ed163218f6662a35e0f0371ac234f9e9371'
  fn: totalSupply()(uint256)
  is: '830126668846005514732418'
  says: the token is live, with holders
  for:
  - notes
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

Aave's aEthwstETH token lets a holder approve a spender with a permit signed in ECDSA, and accepts no other signature. A quantum attacker who recovers a holder's key can sign a permit and move that holder's aTokens, also after the holder moves to a smart account at the same address.

## Evidence

- [permit](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code) requires the ECDSA signer to equal the owner and then sets the allowance; it has no ERC-1271 path.
- The [token proxy](https://etherscan.io/address/0x0b925ed163218f6662a35e0f0371ac234f9e9371#code) is upgraded by Aave's pool configurator, which the governance executor controls as pool admin.

## Reviewer notes

### Mechanism

The address is an InitializableImmutableAdminUpgradeabilityProxy whose EIP-1967 slot points to ATokenInstance 0xadc45df3. AToken.permit (lines 162-185) builds the EIP-712 digest with the owner's nonce, requires owner == ECDSA.recover(digest, v, r, s) (line 182), bumps the nonce and calls _approve. No code check, no ERC-1271. transferFrom (lines 188-237) then spends that allowance and moves the owner's aTokens, which redeem for wstETH through the Pool. Under the quantum-exposure rubric EIP-8151 is not assumed: a holder that moves to a post-quantum smart account at the same address (an EIP-7702 delegation still recovers) stays forgeable through its old key. Holders can still use approve (IncentivizedERC20 line 152), which does not stop the forgery. Fix: the proxy's upgradeTo is ifAdmin (BaseImmutableAdminUpgradeabilityProxy line 56); the immutable admin is the PoolConfigurator 0x64b761d8 (in the proxy bytecode, and returned by the provider's getPoolConfigurator); the configurator's implementation has updateAToken, and the Governance V3 Executor 0x5300a1a1 is pool admin in the ACL manager. Rated MEDIUM by step 3: the fix is one governance contract upgrade. The token is live: totalSupply is about 830,127 aEthwstETH, and the wstETH reserve is active, not frozen, not paused (Pool.getConfiguration bits 56/57/60 at the block).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path in permit: none (AToken.sol lines 162-185).
- Ruled out: an unused implementation: this address is the live proxy; totalSupply is non-zero at the block.
- Ruled out: a closed path: the wstETH reserve is active, not paused (Pool.getConfiguration at the block); permit has no pause check.
- Ruled out: the family replay 0xde8136cd: not cited, because I could not read that transaction's other calls to rule out other signed steps; evidence is the source.
- Ruled out: other aToken proxies on the same implementation (aEthWETH, aEthUSDC and others of the old grouped finding) are separate rows, not described here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
