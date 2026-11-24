---
id: atoken-67fadbd9-signed-shortcut-lost
format: 2
title: UwU's uWETH permit stops working for holders whose accounts take real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a holder moves its account to real code, and that holder can still approve directly.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x67fadbd9bf8899d7c578db22d7af5e2e500e13e5'
  name: AToken
  code: verified
  code_url: https://etherscan.io/address/0x550649c2a66ca0ad5fc54e74d5603c7be3b0e4aa#code
  proxy_of: '0x550649c2a66ca0ad5fc54e74d5603c7be3b0e4aa'
  copies: 41
  family: a3df5c92afe9e1c286ec7b2937371567
  admin: '0x408c9764993209dc772eb12ff641f4b55f5b005c'
value:
  usd: 14263
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code, and that approve still works.
evidence_level: source
checks:
- id: name
  call: '0x67fadbd9bf8899d7c578db22d7af5e2e500e13e5'
  fn: name()(string)
  is: UwU interest bearing WETH
  says: the token's name on chain is UwU interest bearing WETH
  for:
  - what
- id: permit-ecdsa
  source: '0x550649c2a66ca0ad5fc54e74d5603c7be3b0e4aa'
  file: contracts/aave-protocol-v2/protocol/tokenization/AToken.sol
  lines:
  - 326
  - 349
  has: require(owner == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
  says: permit sets an allowance only when ecrecover returns the owner, with no other way to verify
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve
  source: '0x550649c2a66ca0ad5fc54e74d5603c7be3b0e4aa'
  file: contracts/aave-protocol-v2/protocol/tokenization/IncentivizedERC20.sol
  lines:
  - 109
  - 112
  has: _approve(_msgSender(), spender, amount);
  says: approve sets the caller's own allowance without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: mint
  source: '0x550649c2a66ca0ad5fc54e74d5603c7be3b0e4aa'
  file: contracts/aave-protocol-v2/protocol/tokenization/AToken.sol
  lines:
  - 142
  - 157
  has: _mint(user, amountScaled);
  says: deposits are credited as aTokens to the depositing user
  for:
  - evidence-3
  - whose
- id: underlying
  call: '0x67fadbd9bf8899d7c578db22d7af5e2e500e13e5'
  fn: UNDERLYING_ASSET_ADDRESS()(address)
  is: '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
  says: the underlying asset is WETH
  for:
  - evidence-3
- id: weth-held
  call: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  fn: balanceOf(address)(uint256)
  args:
  - '0x67fadbd9bf8899d7c578db22d7af5e2e500e13e5'
  is: '7904076482742416977'
  says: the token holds 7.904 WETH of its depositors
  for:
  - evidence-3
  - whose
- id: admin
  call: '0x67fadbd9bf8899d7c578db22d7af5e2e500e13e5'
  fn: admin()(address)
  from: '0x408c9764993209DC772eB12FF641F4b55F5b005C'
  is: '0x408c9764993209DC772eB12FF641F4b55F5b005C'
  says: the proxy's immutable admin is 0x408c…005c, UwU's lending pool configurator
  for:
  - admin
- id: eip
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: EIP-8151 returns the recovered address when its code is empty or an EIP-7702 delegation indicator
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-67fadbd9, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL candidate (PQ-19): UwU''s uWETH aToken (implementation 0x550649c2…) accepts permit
    only through ECDSA (no ERC-1271), so a holder whose account takes real code loses gasless approval but keeps
    approve; 8.14 uWETH outstanding, 7.904 WETH held; WETH reserve frozen. Refuter agrees; Claude read the sheet.'
related: []
---

## What happens

UwU's uWETH token lets a holder approve a spender by a signed permit or by calling approve. Permit checks the signature with ECDSA alone, so a holder whose account takes real code loses it. Approve keeps working, and so does permit for an EIP-7702 delegation.

## Evidence

- [permit](https://etherscan.io/address/0x550649c2a66ca0ad5fc54e74d5603c7be3b0e4aa#code) accepts a signature only if ecrecover returns the owner; it has no ERC-1271 path.
- [approve](https://etherscan.io/address/0x550649c2a66ca0ad5fc54e74d5603c7be3b0e4aa#code) sets the caller's own allowance with no signature.
- The [token](https://etherscan.io/address/0x67fadbd9bf8899d7c578db22d7af5e2e500e13e5) holds 7.9 WETH supplied by its depositors.

## Reviewer notes

### Mechanism

The address is an InitializableImmutableAdminUpgradeabilityProxy whose EIP-1967 slot points to AToken 0x5506…e4aa (revision 7). permit (AToken.sol 326-349) builds the EIP-712 digest with the owner's nonce and requires owner == ecrecover(digest, v, r, s), then calls _approve. Under EIP-8151 ecrecover returns nothing for an owner whose account has real code, so the require fails with INVALID_SIGNATURE; an EIP-7702 delegation still recovers. approve, increaseAllowance and decreaseAllowance (IncentivizedERC20.sol 109-112, 142-165) set the caller's own allowance with no signature, so the act stays open by a direct call. Nothing is locked: withdrawals go through the lending pool, which burns aTokens of msg.sender. The proxy admin is an immutable (6 PUSH32 of 0x408c…005c in the runtime code); admin() called from that address returns it, and it equals the addresses provider's getLendingPoolConfigurator(). Name on chain: UwU interest bearing WETH (uWETH); total supply 8.14e18, WETH held 7.904e18, pool 0x2409…c668 not paused.

### Checks

- Header facts: this address alone, at block 26,438,999; 41 addresses run this code.
- Ruled out: unused implementation: this address is an initialized proxy with total supply 8.14 uWETH and 7.9 WETH held at the block.
- Ruled out: ERC-1271 or code-size branch for signers with code: permit (lines 326-349) has none.
- Ruled out: wrong code: the old note named implementation 0xb5bb4f1a; the EIP-1967 slot at the block holds 0x550649c2…e4aa, and the card cites that code.
- Ruled out: signature rechecked later: the permit signature is consumed once (nonce incremented) and never re-verified.
- Ruled out: breaks by itself: permit uses Solidity's ecrecover, which forwards all remaining gas; no fixed gas amount.
- Ruled out: path closed: the lending pool is not paused (paused() false) and permit has no pause check.

### Questions

- contract.project left empty: the on-chain name says UwU; the reviewer may set the registry's slug for UwU Lend.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
