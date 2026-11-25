---
id: atokeninstance-5e8c8a72-permit-signature
format: 2
title: Aave's aEthLINK accepts ECDSA-signed permits that can spend holders' tokens
status: confirmed
severity: MEDIUM
justification: A forged permit lets someone spend a holder's aEthLINK; a governance upgrade of the token can fix
  it.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5e8c8a7243651db1384c0ddfdbe39761e8e7e51a'
  name: ATokenInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 69044597
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the aToken so permit asks an owner whose account has real code through ERC-1271 only, never ECDSA.
evidence_level: source
checks:
- id: name
  call: '0x5e8c8a7243651db1384c0ddfdbe39761e8e7e51a'
  fn: name()(string)
  is: Aave Ethereum LINK
  says: the address is the live aEthLINK token
  for:
  - what
- id: impl
  storage: '0x5e8c8a7243651db1384c0ddfdbe39761e8e7e51a'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x000000000000000000000000adc45df3cf1584624c97338bef33363bf5b97ada'
  says: the proxy runs the ATokenInstance implementation 0xadc45df3
  for:
  - evidence-2
- id: ecdsa
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts the signature only if ECDSA recovers the owner
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: approve-permit
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
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
- id: no-1271
  selector: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the implementation code carries no ERC-1271 selector, so it never asks an owner's account
  for:
  - action
  - evidence-1
  - what
- id: upgrade-fn
  source: '0x5e8c8a7243651db1384c0ddfdbe39761e8e7e51a'
  file: '@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol'
  lines:
  - 56
  - 58
  has: function upgradeTo(address newImplementation) external ifAdmin {
  says: the proxy's admin can replace its implementation
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: upgrade-sel
  selector: '0x5e8c8a7243651db1384c0ddfdbe39761e8e7e51a'
  fn: upgradeTo(address)
  says: the deployed proxy carries upgradeTo
  for:
  - upgradeable
- id: admin
  call: '0x5e8c8a7243651db1384c0ddfdbe39761e8e7e51a'
  fn: admin()(address)
  from: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  is: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  says: the proxy's admin is the PoolConfigurator 0x64b761d8
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
  says: Aave's addresses provider names 0x64b761d8 as the PoolConfigurator
  for:
  - admin
- id: configurator-update
  selector: '0xff42ce30054dce7dc7c1282a9a497aa58eabce99'
  fn: updateAToken((address,string,string,address,bytes))
  says: the PoolConfigurator implementation has updateAToken, which upgrades an aToken
  for:
  - action
  - justification
- id: gov-admin
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x12ad05bde78c5ab75238ce885307f96ecd482bb402ef831f99e7018a0f169b7b'
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: true
  says: the Aave Governance V3 Executor holds POOL_ADMIN_ROLE in the ACLManager
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
  pattern: PQ-1
reviews:
- who: r-5e8c8a72, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding (old bundled HIGH), MEDIUM (PQ-1): aEthLINK''s permit accepts only an
    ECDSA-recovered owner and never asks the account, so a holder that migrates stays forgeable; the proxy upgrades
    only through Aave''s PoolConfigurator (pool-admin role held by Governance V3''s Executor). $69.0M supply (upper
    bound). Two refuters agree; Claude read the sheet.'
related: []
---

## What happens

Aave's aEthLINK token gives an allowance to anyone holding a permit that the owner's ECDSA key signed. It never asks the owner's account, so a quantum attacker who recovers a holder's key can spend that holder's tokens, even after the holder moves to post-quantum authorisation at the same address.

## Evidence

- [permit](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code) requires the owner to equal the ECDSA-recovered signer, then sets the allowance; it has no ERC-1271 path.
- The [token proxy](https://etherscan.io/address/0x5e8c8a7243651db1384c0ddfdbe39761e8e7e51a#code) can be switched to new code by its admin, Aave's PoolConfigurator.

## Reviewer notes

### Mechanism

The address is an InitializableImmutableAdminUpgradeabilityProxy whose EIP-1967 slot points at ATokenInstance 0xadc45df3 (aave-v3-origin, revision 5). AToken.permit(owner, spender, value, deadline, v, r, s) builds the EIP-712 digest with the owner's nonce and requires owner == ECDSA.recover(digest, v, r, s) (AToken.sol line 182), then increments the nonce and calls _approve (line 184). OpenZeppelin ECDSA.recover calls the ecrecover precompile (ECDSA.sol line 148). Nothing on the path checks whether the owner has code or calls isValidSignature. With the allowance, the spender calls transferFrom and can withdraw the LINK through the Pool. The proxy's admin is an immutable, the PoolConfigurator 0x64b761d8 (admin() answers it when called from that address; the address is in the proxy bytecode); upgradeTo is admin-only (BaseImmutableAdminUpgradeabilityProxy lines 56-58). The PoolConfigurator implementation carries updateAToken; the Pool's addresses provider names 0x64b761d8 as configurator and its owner and ACL admin is the Governance V3 Executor 0x5300a1a1, which holds POOL_ADMIN_ROLE in the ACLManager. Rated MEDIUM by the quantum-exposure rubric: holders' own funds are forgeable, and the fix is a governance upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or a code-size branch: the implementation source has no isValidSignature, 1271 or code check anywhere (grep over all files).
- Ruled out: unused implementation: this address is the live aEthLINK proxy, name 'Aave Ethereum LINK' and totalSupply 7,528,332.7 aEthLINK at the block; the dossier saw 68 recovering calls from 37 distinct signers in the two-week window.
- Ruled out: direct path: owners can still call approve themselves (IncentivizedERC20 lines 152-153); that keeps post-quantum accounts usable but does not close the forged-permit path, so the finding stands.
- Ruled out: wrong code: the EIP-1967 slot at the block holds 0xadc45df3, the implementation whose source is read here.
- Ruled out: the family replay 0xde8136cd (root selector 0x6d7b7040) was not cited: I could not confirm without traces that it reaches this token or that no other step checks the same signer; evidence stays at source.
- Ruled out: the 7702 case: under EIP-8151 an EIP-7702 delegation still recovers, so delegated holders stay exposed; the card does not rely on EIP-8151.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
