---
id: atokeninstance-98c23e9d-permit-signature
format: 2
title: Aave's aEthUSDC lets a forged ECDSA permit spend a holder's deposit
status: confirmed
severity: MEDIUM
justification: A forged key spends a holder's deposit, and the fix is an upgrade by Aave's pool admins.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x98c23e9d8f34fefb1b7bd6a91b7ff122f4e16f5c'
  name: ATokenInstance
  project: aave
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 2736557864
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the aToken so that permit asks owners whose accounts have code through ERC-1271 instead of ECDSA.
evidence_level: source
checks:
- id: symbol
  call: '0x98c23e9d8f34fefb1b7bd6a91b7ff122f4e16f5c'
  fn: symbol()(string)
  is: aEthUSDC
  says: the address is the live aEthUSDC token
  for:
  - what
- id: permit-recover
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts the signature only if ECDSA recovery gives the owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 184
  has: '_approve({owner: owner, spender: spender, amount: value, emitEvent: true});'
  says: a valid permit sets the spender's allowance over the owner's own balance
  for:
  - evidence-1
  - what
  - whose
- id: ecdsa-lib
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-helpers/lib/aave-address-book/lib/aave-v3-origin/lib/solidity-utils/lib/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: the recovery is a plain ecrecover
  for:
  - evidence-1
  - what
- id: spend
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  lines:
  - 188
  - 237
  has: _transfer(sender, recipient, amount.toUint120());
  says: transferFrom spends the allowance and moves the holder's aTokens to the recipient
  for:
  - justification
  - what
- id: usdc-held
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x98c23e9d8f34fefb1b7bd6a91b7ff122f4e16f5c'
  is: '147713774826595'
  says: the token holds 147.7M USDC of its depositors
  for:
  - whose
- id: proxy-upgrade
  source: '0x98c23e9d8f34fefb1b7bd6a91b7ff122f4e16f5c'
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
- id: proxy-admin
  call: '0x98c23e9d8f34fefb1b7bd6a91b7ff122f4e16f5c'
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
- id: proxy-admin-code
  bytecode: '0x98c23e9d8f34fefb1b7bd6a91b7ff122f4e16f5c'
  has: 64b761d848206f447fe2dd461b0c635ec39ebb27
  says: the admin is an immutable in the proxy's code
  for:
  - admin
  - evidence-2
- id: configurator-gate
  call: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
  fn: updateAToken((address,string,string,address,bytes))
  args:
  - - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
    - Aave Ethereum USDC
    - aEthUSDC
    - '0xadc45df3cf1584624c97338bef33363bf5b97ada'
    - 0x
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: '0xcdd36a97'
  says: updateAToken refuses a caller that is not a pool admin (CallerNotPoolAdmin)
  for:
  - action
  - evidence-2
  - justification
- id: executor-admin
  call: '0xc2aacf6553d20d1e9d78e365aaba8032af9c85b0'
  fn: isPoolAdmin(address)(bool)
  args:
  - '0x5300a1a15135ea4dc7ad5a167152c01efc9b192a'
  is: 'true'
  says: 0x5300a1a1 holds the pool admin role, so a live party can upgrade
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

aEthUSDC, Aave's USDC deposit token, gives a spender an allowance when the holder's ECDSA key signs a permit. A quantum attacker who recovers a holder's key can sign one and move the holder's aEthUSDC, even after the holder moves to a post-quantum account.

## Evidence

- [permit](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code) sets the allowance if ECDSA recovery of the signed message gives the owner; it has no other signature check.
- The [token proxy](https://etherscan.io/address/0x98c23e9d8f34fefb1b7bd6a91b7ff122f4e16f5c#code) is upgraded by Aave's PoolConfigurator, whose update function admits pool admins and nobody else.

## Reviewer notes

### Mechanism

The proxy delegates to ATokenInstance 0xadc45df3 (EIP-1967 slot). AToken.permit (lines 162-185) builds the EIP-712 digest with the owner's nonce and requires owner == ECDSA.recover(digest, v, r, s) (line 182); OpenZeppelin ECDSA.recover only calls ecrecover (line 148), with no ERC-1271 and no code check. It then bumps the nonce and calls _approve(owner, spender, value). AToken.transferFrom (lines 188-237) spends that allowance and moves the holder's scaled balance to the recipient, who can withdraw USDC from the Pool. A CRQC that derives a holder's secp256k1 key from any on-chain signature can do this; the holder moving its address to post-quantum authorisation does not stop it (without EIP-8151, which is not assumed). Upgrade path: BaseImmutableAdminUpgradeabilityProxy.upgradeTo/upgradeToAndCall are ifAdmin and the admin is an immutable equal to PoolConfigurator 0x64b761d8 (admin() answers it when called from that address; the address is in the proxy bytecode). The Pool's addresses provider names the same configurator. PoolConfigurator.updateAToken reverts CallerNotPoolAdmin for a random caller; 0x5300a1a1 is a pool admin and DEFAULT_ADMIN in the ACL manager, and the provider's owner and ACL admin.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path in permit: none (AToken.sol lines 162-185; ECDSA.recover lines 148 and 160-164 call only ecrecover).
- Ruled out: unused implementation: this address is the live aEthUSDC proxy, initialized (symbol aEthUSDC, totalSupply 2,737,251,128 USDC units of 6 decimals, underlying USDC) and holding 147.7M USDC at the block.
- Ruled out: direct path: approve (IncentivizedERC20.sol lines 152-153) lets a post-quantum holder grant allowances without a signature; it does not stop a forged permit, so the finding stands, and it is why post-quantum users are not locked out.
- Ruled out: the family replay 0xde8136cd... (root selector 0x6d7b7040) was not cited: it concerns EIP-8151 behaviour, not quantum forgery, and its calls could not be read without traces.
- Ruled out: the reserve is not paused or frozen at the block (Pool.getConfiguration(USDC): active bit 1, frozen 0, paused 0), so permit and transferFrom are live.
- Ruled out: the updateAToken call simulated from 0x5300a1a1 with this aToken's own name and implementation passes the admin check and reverts later with empty data; the card does not claim a particular upgrade payload works.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
