---
id: atokeninstance-4579a27a-permit-ecdsa-only
format: 2
title: Aave sUSDe aToken permit trusts ECDSA after holders move to post-quantum
status: confirmed
severity: MEDIUM
justification: Holders' aTokens can be taken by a forged permit; only an upgrade by Aave's configurator fixes it.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4579a27af00a62c0eb156349f31b345c08386419'
  name: ATokenInstance
  code: verified
  code_url: https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code
  proxy_of: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  copies: 1
  upgradeable: 'yes'
  admin: '0x64b761d848206f447fe2dd461b0c635ec39ebb27'
value:
  usd: 263070990
  whose: users
  basis: market-cap
activity: {}
impact: funds-loss
action: Upgrade the aToken so permit refuses ECDSA for owners whose accounts have real code and asks them through
  ERC-1271 only.
evidence_level: source
checks:
- id: permit-ecdsa
  source: '0xadc45df3cf1584624c97338bef33363bf5b97ada'
  file: lib/aave-v3-origin/src/contracts/protocol/tokenization/AToken.sol
  line: 182
  has: require(owner == ECDSA.recover(digest, v, r, s), Errors.InvalidSignature());
  says: permit accepts the owner's ECDSA signature and has no other way to check it
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
  says: a valid permit approves a spender over the owner's own aTokens
  for:
  - evidence-1
  - what
  - whose
- id: upgrade
  source: '0x4579a27af00a62c0eb156349f31b345c08386419'
  file: '@aave/core-v3/contracts/protocol/libraries/aave-upgradeability/BaseImmutableAdminUpgradeabilityProxy.sol'
  line: 56
  has: function upgradeTo(address newImplementation) external ifAdmin {
  says: the proxy's admin can replace the implementation
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: admin-imm
  bytecode: '0x4579a27af00a62c0eb156349f31b345c08386419'
  has: 64b761d848206f447fe2dd461b0c635ec39ebb27
  says: the proxy's runtime code holds the pool configurator's address as its immutable admin
  for:
  - action
  - admin
  - evidence-2
  - justification
  - upgradeable
- id: configurator
  call: '0x2f39d218133afab8f2b819b1066c7e434ad94e9e'
  fn: getPoolConfigurator()(address)
  is: '0x64b761D848206f447Fe2dd461b0c635Ec39EbB27'
  says: that address is Aave's pool configurator in the pool's addresses provider
  for:
  - admin
  - evidence-2
  - justification
  - upgradeable
- id: pool
  call: '0x4579a27af00a62c0eb156349f31b345c08386419'
  fn: POOL()(address)
  is: '0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2'
  says: the aToken belongs to the Aave v3 Ethereum Pool
  for:
  - evidence-2
  - justification
- id: provider
  call: '0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2'
  fn: ADDRESSES_PROVIDER()(address)
  is: '0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e'
  says: the Pool's addresses provider is the one that names the configurator
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
  pattern: PQ-1
reviews:
- who: r-4579a27a, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-1): aEthsUSDe''s permit accepts only ECDSA.recover (no ERC-1271),
    so a forged permit moves a holder''s aTokens after the holder migrates; Aave''s PoolConfigurator (the proxy''s
    immutable admin, upgradeable stated with checks by Claude after the second refuter) installs the fix through
    updateAToken. About $263M for this address alone (supply equals the sUSDe held). Two refuters agreed on the
    card, a fresh one on the facts fix; Claude read the sheet.'
related: []
---

## What happens

Aave's aEthsUSDe token lets anyone set an allowance for a holder with the holder's ECDSA signature (permit). It never asks the holder's account, so a holder who moves to post-quantum authorisation at the same address can still be drained by whoever forges the old key.

## Evidence

- [permit](https://etherscan.io/address/0xadc45df3cf1584624c97338bef33363bf5b97ada#code) requires owner == ECDSA.recover(digest, v, r, s), then approves the spender.
- The [proxy](https://etherscan.io/address/0x4579a27af00a62c0eb156349f31b345c08386419#code) can be upgraded only by its fixed admin, the pool configurator 0x64b7…bB27.

## Reviewer notes

### Mechanism

AToken.permit (AToken.sol lines 162-185) builds the EIP-712 digest with the owner's nonce and requires owner == ECDSA.recover(digest, v, r, s); it then bumps the nonce and calls _approve(owner, spender, value). transferFrom then moves the owner's aTokens, which redeem for sUSDe in the Pool. No isValidSignature call exists in the source, and nothing checks whether the owner has code. Without EIP-8151, an owner who later puts post-quantum code on the same address keeps an ECDSA key that still works here. The address is an InitializableImmutableAdminUpgradeabilityProxy whose immutable _admin can call upgradeTo; the admin bytes in the runtime code equal Pool.ADDRESSES_PROVIDER().getPoolConfigurator() = 0x64b761D848206f447Fe2dd461b0c635Ec39EbB27 at the block.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: unused address: name() is 'Aave Ethereum sUSDe' and totalSupply() is 2.09e26 at the block, so this proxy is in use.
- Ruled out: an ERC-1271 or code-size branch: none in the source (no isValidSignature).
- Ruled out: a direct path: approve() sets the allowance by a direct call from the holder, so post-quantum holders keep a way to approve; it does not close the forged-permit path.
- Ruled out: replay 0xde8136cd… is not cited: its root call bundles other steps, and the card rests on the source.
- Ruled out: the other 34 addresses of this code family are separate rows.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
