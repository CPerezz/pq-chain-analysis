---
id: atokeninstance-bdfa7b78-permit-signature
format: 2
title: A forged ECDSA permit can let a quantum attacker take aEthweETH holders' tokens
status: confirmed
severity: MEDIUM
justification: Holders' deposits can be taken with a forged permit; fixing the check needs an Aave governance upgrade.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbdfa7b7893081b35fb54027489e2bc7a38275129'
  name: ATokenInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 2694056638
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the aToken through the PoolConfigurator to a permit that checks owners with code through ERC-1271.
evidence_level: source
checks:
- id: ecdsa
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts only an owner equal to the ECDSA-recovered signer
  for:
  - evidence-1
  - justification
  - what
- id: allow
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 184
  has: '_approve({owner: owner, spender: spender, amount: value, emitEvent: true});'
  says: a valid permit sets the owner's allowance for the spender
  for:
  - evidence-1
  - justification
  - what
- id: transferfrom
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 188
  - 236
  has: _spendAllowance(
  says: transferFrom spends the allowance and moves the owner's aTokens
  for:
  - what
- id: mint
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 64
  - 69
  has: onlyPool
  says: aTokens are minted only by the Pool, to depositors
  for:
  - evidence-3
  - whose
- id: upgrade
  source: '0xbdfa7b7893081b35fb54027489e2bc7a38275129'
  file: '@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol'
  lines:
  - 56
  - 58
  has: function upgradeTo(address newImplementation) external ifAdmin
  says: the proxy's admin can replace its implementation
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: admin
  call: '0xbdfa7b7893081b35fb54027489e2bc7a38275129'
  fn: admin()(address)
  from: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: the proxy's admin is the PoolConfigurator
  for:
  - action
  - admin
  - evidence-2
  - upgradeable
- id: configurator
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getPoolConfigurator()(address)
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: Aave's addresses provider names 0x64b761d8 as the PoolConfigurator
  for:
  - admin
  - evidence-2
- id: notadmin
  call: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  data: '0x14ef0ac50000000000000000000000000000000000000000000000000000000000000020000000000000000000000000cd5fe23c85820f7b72d0926fc9b05b43e359b7ee00000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000adc45df3cf1584624c97338bef33363bf5b97ada000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000134161766520457468657265756d20776545544800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000961457468776545544800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts_with: '0xcdd36a97'
  says: updateAToken for aEthweETH reverts with CallerNotPoolAdmin for a caller without the pool-admin role
  for:
  - action
  - evidence-2
  - justification
- id: acl
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: isPoolAdmin(address)(bool)
  args:
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: true
  says: the Aave governance executor holds the pool-admin role
  for:
  - action
  - evidence-2
  - justification
- id: supply
  call: '0xbdfa7b7893081b35fb54027489e2bc7a38275129'
  fn: totalSupply()(uint256)
  is: 1347826430330664593983036
  says: 1,347,826 aEthweETH are held by depositors
  for:
  - evidence-3
  - whose
- id: held
  call: '0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee'
  fn: balanceOf(address)(uint256)
  args:
  - '0xbdfa7b7893081b35fb54027489e2bc7a38275129'
  is: 1347778025124233670836909
  says: the token holds 1,347,778 weETH of depositors' funds
  for:
  - evidence-3
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
reviews:
- who: r-bdfa7b78, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-1): aEthweETH''s permit accepts only ECDSA.recover (no ERC-1271),
    so a forged permit moves a holder''s aTokens even after the holder migrates; Aave governance can replace the
    implementation through the PoolConfigurator (updateAToken, pool-admin gated). Token supply affected (upper bound)
    at the underlying''s price. Two refuters agree; Claude read the sheet. Soft spot recorded: a holder with debt
    loses only what the health check allows.'
related: []
---

## What happens

Aave's aEthweETH token sets a holder's allowance from a permit signed with ECDSA. A quantum attacker who recovers a holder's key can sign a permit and move that holder's tokens, even after the holder moves to a post-quantum account at the same address.

## Evidence

- [permit](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code) sets the allowance when the owner equals the ECDSA-recovered signer; it never asks ERC-1271.
- The [token](https://etherscan.io/address/0xbdfa7b7893081b35fb54027489e2bc7a38275129#code) is a proxy upgraded by Aave's PoolConfigurator, which needs the pool-admin role; Aave's governance executor holds it.
- Depositors hold 1,347,826 [aEthweETH](https://etherscan.io/token/0xbdfa7b7893081b35fb54027489e2bc7a38275129), backed by 1,347,778 weETH held by the token.

## Reviewer notes

### Mechanism

The proxy (InitializableImmutableAdminUpgradeabilityProxy) delegates to ATokenInstance 0xadc45df3 (EIP-1967 slot). AToken.permit (lines 162-185) checks owner != 0 and the deadline, builds the EIP-712 digest with the owner's nonce, requires owner == ECDSA.recover(digest, v, r, s) (line 182), bumps the nonce and calls _approve (line 184). No code check, no ERC-1271. transferFrom (lines 188-237) spends that allowance and moves the owner's aTokens, which the spender can redeem through the Pool. approve (IncentivizedERC20 line 153) is a direct path a post-quantum account can use, but it does not switch permit off. Fix path: the proxy's immutable admin is the PoolConfigurator 0x64b761d8 (admin() answers it when called from it; the provider's getPoolConfigurator returns it). The configurator's updateAToken reverts with CallerNotPoolAdmin (0xcdd36a97) for another caller, and the ACLManager says the governance executor 0x5300a1a1 is pool admin. Severity: quantum-exposure, users' own funds stay forgeable after migration, fixable by a governance upgrade: MEDIUM (step 3).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for owners with code: permit has none (line 182 uses ECDSA.recover only).
- Ruled out: an unused implementation: this address is the initialized proxy, totalSupply 1,347,826 aEthweETH at the block; recoveries by this code appear in the scan window (11 calls).
- Ruled out: a direct path that removes the risk: approve exists (line 153) but permit stays open, so a forged permit still sets an allowance.
- Ruled out: wrong code: the EIP-1967 slot points at 0xadc45df3, the verified ATokenInstance read here.
- Ruled out: the family replay 0xde8136cd is not cited: it is for the code family, not shown to call this address, and EIP-8151 is not assumed under this category.
- Ruled out: other aTokens on the same implementation (aEthWETH, aEthUSDC, ...) are separate rows; this card covers aEthweETH only.
- Ruled out: a setter that cannot be used: updateAToken from 0x…dEaD reverts with CallerNotPoolAdmin, and isPoolAdmin(executor) is true, so the upgrade path is live.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
