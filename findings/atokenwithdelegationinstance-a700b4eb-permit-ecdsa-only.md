---
id: atokenwithdelegationinstance-a700b4eb-permit-ecdsa-only
format: 2
title: aEthAAVE permit lets an old ECDSA key spend a migrated holder's tokens
status: confirmed
severity: MEDIUM
justification: Holders' tokens stay forgeable after they migrate; the fix is an upgrade through Aave's PoolConfigurator.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  name: ATokenWithDelegationInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0x38769a7da85429ac9d61167fdfeccaae8aa11766#code
  proxy_of: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 89023768
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the token so permit and metaDelegate refuse ECDSA for owners whose accounts have code and ask them
  through ERC-1271 only.
evidence_level: source
checks:
- id: permit-recover
  source: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts the signature only if the ECDSA-recovered address equals the owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 183
  - 184
  has: '_approve({owner: owner, spender: spender, amount: value, emitEvent: true});'
  says: after the recovery matches, permit sets the owner's allowance for the spender
  for:
  - evidence-1
  - justification
  - what
- id: spend
  source: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 188
  - 235
  has: _transfer(sender, recipient, amount.toUint120());
  says: transferFrom spends the allowance and moves the owner's tokens to the recipient
  for:
  - what
- id: no-1271
  selector: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the implementation's code does not contain the ERC-1271 selector, so it never asks an account
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-sel
  selector: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  fn: permit(address,address,uint256,uint256,uint8,bytes32,bytes32)
  says: permit is in the code that runs behind the proxy
  for:
  - what
- id: delegate-recover
  source: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/delegation/BaseDelegation.sol
  line: 195
  has: require(delegator == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: metaDelegate moves a holder's voting and proposition power on an ECDSA signature alone
  for:
  - action
  - evidence-3
- id: delegate-type-recover
  source: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/delegation/BaseDelegation.sol
  line: 170
  has: require(delegator == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: metaDelegateByType does the same for one power type
  for:
  - action
  - evidence-3
- id: approve-direct
  source: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/base/IncentivizedERC20.sol
  lines:
  - 152
  - 155
  has: '_approve({owner: _msgSender(), spender: spender, amount: amount, emitEvent: true});'
  says: a holder can also approve by a direct call, with no signature
  for:
  - notes
- id: impl-slot
  storage: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  says: the proxy runs the ATokenWithDelegationInstance implementation
  for:
  - what
- id: name
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  fn: name()(string)
  args: []
  is: Aave Ethereum AAVE
  says: the proxy is initialized as the token Aave Ethereum AAVE
  for:
  - what
- id: underlying
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  fn: UNDERLYING_ASSET_ADDRESS()(address)
  args: []
  is: '0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9'
  says: its underlying asset is the AAVE token
  for:
  - what
- id: pool
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  fn: POOL()(address)
  args: []
  is: '0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2'
  says: it belongs to the Aave v3 Ethereum Pool
  for:
  - what
- id: supply
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  fn: totalSupply()(uint256)
  args: []
  is: '801259689170377536095961'
  says: about 801,260 tokens are in holders' hands, so the address is in use
  for:
  - whose
- id: mint
  source: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 64
  - 78
  has: 'onBehalfOf: onBehalfOf,'
  says: tokens are minted by the Pool to the account a deposit is made for, so the supply belongs to depositors
  for:
  - whose
- id: upgrade-fn
  source: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  file: '@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol'
  lines:
  - 56
  - 58
  has: function upgradeTo(address newImplementation) external ifAdmin {
  says: the proxy's admin can replace the implementation
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: admin-immutable
  source: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  file: '@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol'
  line: 17
  has: address internal immutable _admin;
  says: the admin is an immutable in the proxy's code, not in the EIP-1967 admin slot
  for:
  - admin
- id: admin
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  fn: admin()(address)
  args: []
  from: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: asked by 0x64b7…bb27, the proxy answers that 0x64b7…bb27 is its admin
  for:
  - action
  - admin
  - evidence-2
  - justification
  - upgradeable
- id: admin-bytes
  bytecode: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  has: 64b761d848206f447fe2dd461b0c635ec39ebb27
  says: the admin address is embedded in the proxy's runtime code
  for:
  - admin
  - evidence-2
- id: provider
  call: '0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2'
  fn: ADDRESSES_PROVIDER()(address)
  args: []
  is: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  says: the Pool's addresses provider
  for:
  - notes
- id: configurator
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getPoolConfigurator()(address)
  args: []
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: the provider names the proxy's admin as Aave's PoolConfigurator
  for:
  - evidence-2
  - justification
- id: configurator-impl
  storage: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  says: the PoolConfigurator is a proxy of 0xff42…ce99
  for:
  - notes
- id: update-atoken
  selector: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  fn: updateAToken((address,string,string,address,bytes))
  says: the PoolConfigurator's code has updateAToken, its function to change an aToken's implementation
  for:
  - action
  - justification
- id: acl-admin
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getACLAdmin()(address)
  args: []
  is: '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  says: the provider's ACL admin is 0x5300…192a
  for:
  - notes
- id: acl
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getACLManager()(address)
  args: []
  is: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  says: the provider's ACL manager
  for:
  - action
- id: pool-admin
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: isPoolAdmin(address)(bool)
  args:
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: true
  says: 0x5300…192a holds the pool-admin role at the block
  for:
  - action
  - justification
- id: reserve-config
  call: '0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2'
  fn: getConfiguration(address)(uint256)
  args:
  - '0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9'
  is: '7237005577332262213973186568751985094729963302392921186752097983862108330740'
  says: 'the AAVE reserve''s configuration word: bit 56 (active) set, bits 57 (frozen) and 60 (paused) clear'
  for:
  - notes
- id: role-gate
  call: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  data: '0x14ef0ac500000000000000000000000000000000000000000000000000000000000000200000000000000000000000007fc66500c84a76ad7e9c93437bfc5ac33e2ddae900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000038769a7da85429ac9d61167fdfeccaae8aa11766000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000124161766520457468657265756d20414156450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000861457468414156450000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: '0xcdd36a97'
  says: updateAToken called by an address without the pool-admin role reverts with CallerNotPoolAdmin()
  for:
  - action
  - justification
- id: delegate-move
  source: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/delegation/BaseDelegation.sol
  lines:
  - 197
  - 198
  has: _delegateByType(delegator, delegatee, GovernancePowerType.VOTING);
  says: after the recovery matches, metaDelegate hands the delegator's voting and proposition power to the delegatee
  for:
  - action
  - evidence-3
- id: no-legacy-1271
  selector: '0x38769a7da85429ac9d61167fdfeccaae8aa11766'
  fn: isValidSignature(bytes,bytes)
  absent: true
  says: the legacy contract-signature selector 0x20c13b0b is absent from the implementation too
  for:
  - evidence-1
  - justification
  - what
- id: treasury
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  fn: TREASURY()(address)
  args: []
  is: '0x464c71f6c2f760dda6093dcb91c24c39e5d6e18c'
  says: the token's treasury address, where accrued interest is minted
  for:
  - whose
- id: treasury-balance
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  fn: balanceOf(address)(uint256)
  args:
  - '0x464c71f6c2f760dda6093dcb91c24c39e5d6e18c'
  is: '6659615006381457049475'
  says: the treasury holds about 6,659.6 of the 801,259.7 tokens (0.83%); the rest is other holders'
  for:
  - whose
- id: upgrade-admin-ok
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  data: '0x3659cfe600000000000000000000000038769a7da85429ac9d61167fdfeccaae8aa11766'
  from: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  is: 0x
  says: upgradeTo called on the proxy by 0x64b7…bb27 succeeds (simulated, with the current implementation as the
    argument)
  for:
  - evidence-2
  - justification
  - upgradeable
- id: upgrade-other-reverts
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  data: '0x3659cfe600000000000000000000000038769a7da85429ac9d61167fdfeccaae8aa11766'
  from: '0x000000000000000000000000000000000000dead'
  reverts: true
  says: the same upgradeTo call from another address reverts
  for:
  - evidence-2
  - justification
  - upgradeable
- id: transfer-live
  call: '0xa700b4eb416be35b2911fd5dee80678ff64ff6c9'
  fn: transfer(address,uint256)(bool)
  args:
  - '0x000000000000000000000000000000000000dead'
  - '1000000000000000000'
  from: '0x464c71f6c2f760dda6093dcb91c24c39e5d6e18c'
  is: true
  says: a simulated transfer of 1 token by a holder (the treasury) succeeds, so the Pool lets the token move at
    the block
  for:
  - what
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
reviews:
- who: r-a700b4eb, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding (old bundled HIGH), MEDIUM (PQ-1): aEthAAVE''s permit and metaDelegate
    accept only an ECDSA-recovered owner and never ask the account, so a holder that migrates stays forgeable; the
    immutable-admin proxy upgrades only through Aave''s PoolConfigurator (pool-admin role). $89M of holders'' AAVE.
    Two refuters agree; Claude read the sheet.'
related: []
---

## What happens

aEthAAVE, Aave's deposit token for AAVE, lets a holder approve a spender by ECDSA signature. It never asks the holder's account. A quantum attacker who recovers a holder's key can take the tokens, even after the holder moves the same address to post-quantum authorisation.

## Evidence

- [permit](https://etherscan.io/address/0x38769a7da85429ac9d61167fdfeccaae8aa11766#code) requires the owner to equal the ECDSA-recovered address, then sets the allowance; the code has no ERC-1271 call.
- The [proxy](https://etherscan.io/address/0xa700b4eb416be35b2911fd5dee80678ff64ff6c9#code) is upgradeable by its admin, Aave's PoolConfigurator.
- [metaDelegate](https://etherscan.io/address/0x38769a7da85429ac9d61167fdfeccaae8aa11766#code) moves a holder's voting power on the same kind of ECDSA signature.

## Reviewer notes

### Mechanism

The proxy (InitializableImmutableAdminUpgradeabilityProxy) delegates to ATokenWithDelegationInstance 0x3876…1766. AToken.permit (AToken.sol 162-185) builds the EIP-712 digest from the owner's nonce and requires owner == ECDSA.recover (line 182), then _approve (184). transferFrom (188-235) spends that allowance and moves the tokens. BaseDelegation.metaDelegateByType and metaDelegate (lines 170, 195) accept the delegator's ECDSA signature the same way and move governance power. No code-size branch and no ERC-1271 call: selector 0x1626ba7e is absent from the implementation. approve (IncentivizedERC20.sol 152-155) is open to any account by direct call, so post-quantum accounts are not locked out; it does not stop a forged permit. State at the block: supply 801,259.69 aEthAAVE; reserve active, not frozen, not paused. Upgrade path: the proxy's admin is an immutable (the EIP-1967 admin slot is empty, which is why the tool read none); admin() asked from 0x64b7…bb27 returns itself, and the addresses provider names it the PoolConfigurator, whose implementation has updateAToken. 0x5300…192a is the provider's ACL admin and holds the pool-admin role. updateAToken called by an address without the role reverts with CallerNotPoolAdmin() (0xcdd36a97); the same call from 0x5300…192a passes that gate (it reverts later with empty data). Rated MEDIUM: funds can be taken, fix is a contract upgrade by a live admin.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for owners with code: none in permit (AToken.sol 162-185) or metaDelegate (BaseDelegation.sol 143-199); selectors 0x1626ba7e and 0x20c13b0b are absent from the implementation's code.
- Ruled out: an unused implementation: this row is the proxy, initialized as Aave Ethereum AAVE with 801,259.69 tokens of supply; the dossier lists no copies.
- Ruled out: a closed path: permit checks only the deadline, the nonce and the signature; the AAVE reserve is active, not frozen and not paused at the block.
- Ruled out: a direct path as a defence: approve by direct call exists, but it does not switch permit off for the same owner.
- Ruled out: citing the window's recoveries or a replay: the dossier lists no replay for this family, and the sampled recoveries come through bundled calls (selectors 0x13d79a0b, 0x4a7cf362) where other steps may check the same signer; evidence level kept at source. The three recovered signers have no code at the block.
- Ruled out: a no-fix (HIGH) rating: the proxy has upgradeTo for its admin, the admin is the live PoolConfigurator, and its code has updateAToken.
- Ruled out: funds that are the operator's: the treasury holds 6,659.6 of 801,259.7 tokens (0.83%) at the block; the rest is other holders', so whose stays users.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
