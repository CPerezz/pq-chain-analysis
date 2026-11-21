---
id: atokeninstance-5c647ce0-permit-signature
format: 2
title: Aave's cbBTC aToken lets an ECDSA-signed permit move holders' aTokens
status: confirmed
severity: MEDIUM
justification: A forged permit can take a holder's aTokens; the fix is an upgrade that Aave governance must pass.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5c647ce0ae10658ec44fa4e11a51c96e94efd1dd'
  name: ATokenInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 1398697496
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the aToken through governance to a permit that asks ERC-1271 when the holder's account has code.
evidence_level: source
checks:
- id: name
  call: '0x5c647ce0ae10658ec44fa4e11a51c96e94efd1dd'
  fn: name()(string)
  is: Aave Ethereum cbBTC
  says: the proxy is Aave's cbBTC aToken
  for:
  - what
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
  line: 184
  has: '_approve({owner: owner, spender: spender, amount: value, emitEvent: true});'
  says: a valid permit sets the spender's allowance over the owner's aTokens
  for:
  - what
- id: ecrecover
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-helpers/lib/aave-address-book/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover is the ecrecover precompile
  for:
  - evidence-1
  - what
- id: spend-allowance
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 188
  - 235
  has: _transfer(sender, recipient, amount.toUint120());
  says: transferFrom spends the allowance and moves the owner's aTokens to the recipient
  for:
  - justification
  - what
- id: upgrade-fn
  source: '0x5c647ce0ae10658ec44fa4e11a51c96e94efd1dd'
  file: src/core/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol
  lines:
  - 69
  - 76
  has: _upgradeTo(newImplementation);
  says: the proxy admin can replace the implementation with upgradeToAndCall
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: proxy-admin
  call: '0x5c647ce0ae10658ec44fa4e11a51c96e94efd1dd'
  fn: admin()(address)
  from: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  is: '0x64b761D848206f447Fe2dd461b0c635Ec39EbB27'
  says: the proxy admin is the PoolConfigurator 0x64b761d8
  for:
  - action
  - admin
  - evidence-2
  - justification
  - upgradeable
- id: admin-in-code
  bytecode: '0x5c647ce0ae10658ec44fa4e11a51c96e94efd1dd'
  has: 64b761d848206f447fe2dd461b0c635ec39ebb27
  says: the admin address is an immutable in the proxy's runtime code
  for:
  - admin
- id: exec-pool-admin
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: isPoolAdmin(address)(bool)
  args:
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: true
  says: the Aave Governance V3 Executor is a pool admin in the ACLManager
  for:
  - action
  - evidence-2
  - justification
- id: update-atoken
  selector: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  fn: updateAToken((address,string,string,address,bytes))
  says: the PoolConfigurator implementation has updateAToken, its aToken upgrade function
  for:
  - action
  - evidence-2
  - justification
- id: held-cbbtc
  call: '0xcbb7c0000ab88b473b1f5afd9ef808440eed33bf'
  fn: balanceOf(address)(uint256)
  args:
  - '0x5c647ce0ae10658ec44fa4e11a51c96e94efd1dd'
  is: '2143253469293'
  says: the aToken holds 21,432.5 cbBTC of suppliers' deposits
  for:
  - whose
- id: supply
  call: '0x5c647ce0ae10658ec44fa4e11a51c96e94efd1dd'
  fn: totalSupply()(uint256)
  is: '2152802618084'
  says: holders' aTokens are claims on 21,528 cbBTC, more than the contract holds
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

Aave's cbBTC aToken sets an allowance for anyone who shows a holder's ECDSA-signed permit. A quantum attacker who recovers a holder's key can sign a permit and move that holder's aTokens, even after the holder switches to post-quantum authorisation at the same address.

## Evidence

- `permit`, line 182 of the [verified source](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code), requires `owner == ECDSA.recover(digest, v, r, s)` and has no other check.
- The [proxy](https://etherscan.io/address/0x5c647ce0ae10658ec44fa4e11a51c96e94efd1dd#code) can be upgraded by its admin, Aave's PoolConfigurator, which takes orders from the governance Executor.

## Reviewer notes

### Mechanism

The address is an InitializableImmutableAdminUpgradeabilityProxy whose EIP-1967 slot points at ATokenInstance 0xadc45df3. AToken.permit (lines 162-185) builds the EIP-712 digest over owner, spender, value, nonce and deadline, requires owner == ECDSA.recover(digest, v, r, s) (line 182), which calls ecrecover (ECDSA.sol line 148), bumps the nonce and calls _approve (line 184). transferFrom (line 188 on) then spends that allowance (_spendAllowance, line 195) and moves the holder's aTokens, which redeem for cbBTC through the Pool. No code-size branch and no ERC-1271 call on this path. Today a holder who moves to post-quantum authorisation at the same address (an EIP-7702 delegation, or a frame account) keeps an ECDSA key that still signs here. EIP-8151 would close it only for holders whose accounts take real code. The proxy admin is an immutable (BaseImmutableAdminUpgradeabilityProxy lines 17, 56-76): admin() called from the PoolConfigurator 0x64b761d8 returns it, and its address is in the proxy bytecode. The PoolConfigurator's implementation 0xff42ce30 has updateAToken((address,string,string,address,bytes)); the Pool's addresses provider owner and ACL admin is the Governance V3 Executor 0x5300a1a1, which ACLManager reports as a pool admin.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for holders with code: permit (lines 162-185) has none.
- Ruled out: unused implementation: the address is the live aEthcbBTC proxy, totalSupply 21,528 cbBTC at the block, and 37 distinct signers were recovered here in the two-week trace window, all three sampled signers EOAs.
- Ruled out: direct path: approve (IncentivizedERC20 lines 152-155) lets a holder grant an allowance by a direct call, so post-quantum holders are not locked out; it does not stop a forged permit.
- Ruled out: rechecked-later / gas: the recovery is a plain ECDSA.recover with all gas forwarded; no signature is rechecked after others relied on it.
- Ruled out: copies: the dossier lists none for this proxy; the old finding grouped 10 other aToken proxies on the same implementation, each its own row.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
