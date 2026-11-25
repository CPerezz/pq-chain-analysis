---
id: atokeninstance-5ee5bf7a-permit-signature
format: 2
title: aEthWBTC lets a forged ECDSA permit spend a holder's tokens
status: confirmed
severity: MEDIUM
justification: A forged key can take a holder's deposit; Aave's pool admin can fix it by upgrading the token.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5ee5bf7ae06d1be5997a1a72006fe6c607ec6de8'
  name: ATokenInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 2245527364
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the token through the PoolConfigurator to a permit that checks accounts with code through ERC-1271
  or a post-quantum scheme.
evidence_level: source
checks:
- id: permit-recover
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: AToken.sol
  line: 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts the signature only if ECDSA recovers the owner
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
  says: a valid permit sets the spender's allowance over the owner's balance
  for:
  - evidence-1
  - justification
  - what
- id: spend
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: AToken.sol
  lines:
  - 188
  - 196
  has: _spendAllowance(
  says: transferFrom moves a holder's tokens against that allowance
  for:
  - justification
  - what
- id: mint
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: AToken.sol
  lines:
  - 64
  - 69
  has: ) external virtual override onlyPool returns (bool) {
  says: tokens are minted only by the Pool, to depositors
  for:
  - whose
- id: underlying
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: AToken.sol
  line: 157
  has: function transferUnderlyingTo(address target, uint256 amount) external virtual override onlyPool {
  says: the WBTC the token holds leaves only on the Pool's order, for depositors and borrowers
  for:
  - whose
- id: symbol
  call: '0x5ee5bf7ae06d1be5997a1a72006fe6c607ec6de8'
  fn: symbol()(string)
  is: aEthWBTC
  says: the token is aEthWBTC
  for:
  - what
- id: underlying-asset
  call: '0x5ee5bf7ae06d1be5997a1a72006fe6c607ec6de8'
  fn: UNDERLYING_ASSET_ADDRESS()(address)
  is: '0x2260fac5e5542a773aa44fbcfedf7c193bc2c599'
  says: its underlying is WBTC
  for:
  - what
- id: upgrade-src
  source: '0x5ee5bf7ae06d1be5997a1a72006fe6c607ec6de8'
  file: BaseImmutableAdminUpgradeabilityProxy.sol
  line: 56
  has: function upgradeTo(address newImplementation) external ifAdmin {
  says: the proxy's admin can replace its implementation
  for:
  - upgradeable
- id: upgrade-sel
  selector: '0x5ee5bf7ae06d1be5997a1a72006fe6c607ec6de8'
  fn: upgradeTo(address)
  says: the deployed proxy has upgradeTo
  for:
  - evidence-2
  - upgradeable
- id: admin
  call: '0x5ee5bf7ae06d1be5997a1a72006fe6c607ec6de8'
  fn: admin()(address)
  from: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: the proxy's admin is 0x64b761d8
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
  says: 0x64b761d8 is Aave's PoolConfigurator for this pool
  for:
  - admin
- id: updateatoken
  selector: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  fn: updateAToken((address,string,string,address,bytes))
  says: the PoolConfigurator's implementation has updateAToken
  for:
  - action
  - evidence-2
  - justification
- id: gate
  call: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  data: '0x14ef0ac500000000000000000000000000000000000000000000000000000000000000200000000000000000000000002260fac5e5542a773aa44fbcfedf7c193bc2c59900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000adc45df3cf1584624c97338bef33363bf5b97ada000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000124161766520457468657265756d20574254430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000861457468574254430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: '0xcdd36a97'
  says: updateAToken refuses a caller that is not pool admin (CallerNotPoolAdmin)
  for:
  - action
  - evidence-2
  - justification
- id: pooladmin
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: isPoolAdmin(address)(bool)
  args:
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: true
  says: 0x5300a1a1 holds Aave's pool admin role
  for:
  - action
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
  pattern: PQ-1
reviews:
- who: r-5ee5bf7a, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-1): aEthWBTC''s permit accepts only ECDSA.recover (no ERC-1271),
    so a forged permit moves a holder''s aTokens even after the holder migrates; Aave governance can replace the
    implementation through the PoolConfigurator (updateAToken, pool-admin gated). Token supply affected (upper bound)
    at the underlying''s price. Two refuters agree; Claude read the sheet. Soft spot recorded: a holder with debt
    loses only what the health check allows.'
related: []
---

## What happens

Aave's aEthWBTC, the receipt for WBTC deposited in Aave, lets anyone set an allowance for a holder with a permit the holder signed with ECDSA. A quantum attacker who recovers a holder's key can sign one and take the holder's balance, also after the holder moves to post-quantum keys.

## Evidence

- [permit](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code) sets the allowance when ECDSA recovers the owner from the signature, with no other way to sign.
- The [token](https://etherscan.io/address/0x5ee5bf7ae06d1be5997a1a72006fe6c607ec6de8#code) is a proxy whose admin, Aave's PoolConfigurator, replaces its code when Aave's pool admin calls it.

## Reviewer notes

### Mechanism

permit (AToken.sol 162-185) builds the EIP-712 digest with the owner's nonce, requires owner == ECDSA.recover(digest, v, r, s) (OpenZeppelin ECDSA, no ERC-1271, no code check), bumps the nonce and calls _approve. transferFrom (188 on) spends that allowance and moves the holder's scaled balance; the spender can then withdraw WBTC from the Pool. The address is an InitializableImmutableAdminUpgradeabilityProxy (EIP-1967 slot -> ATokenInstance 0xadc45df3) whose immutable admin is the PoolConfigurator 0x64b761d8 (admin() answers it only when called from it). PoolConfigurator (proxy, implementation 0xff42ce30) has updateAToken((address,string,string,address,bytes)); called from 0x...dEaD it reverts CallerNotPoolAdmin (0xcdd36a97); ACLManager 0xc2aacf65 reports 0x5300a1a1 (owner and ACL admin of the addresses provider 0x2f39d218) as pool admin. So the permit can be replaced by an upgrade, which makes the exposure rubric MEDIUM. Rubric does not assume EIP-8151; under EIP-8151 an account that takes real code would no longer be forgeable here, while an EIP-7702 delegation still would.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for owners with code: permit has none (lines 162-185) and OpenZeppelin ECDSA.recover has none.
- Ruled out: unused implementation: this address is the live proxy, initialized as aEthWBTC with WBTC as underlying and a total supply of 3,492,699,184,111 (8 decimals) at the block.
- Ruled out: direct path: approve (IncentivizedERC20 line 152) lets a post-quantum holder grant allowances without a signature, but it does not stop a forged permit, so it does not lower the rating.
- Ruled out: rescueTokens (line 335) is pool-admin only and refuses the underlying, so it is no second drain path.
- Ruled out: replay of 0xde8136cd… in the dossier runs on the same implementation but another aToken address and its other calls were not read; not cited.
- Ruled out: the other aTokens on implementation 0xadc45df3 are separate rows.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
