---
id: uniswapv2pair-3e8769bb-signed-shortcut-lost
format: 2
title: Liquidity providers whose accounts take real code lose permit on this pair
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a liquidity holder moves its account to real code, and approve stays open to it.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  name: UniswapV2Pair
  code: verified
  code_url: https://etherscan.io/address/0x3e8769bb28fed24c6eef161b48b7689a5fb0e320#code
  copies: 528187
  family: 3b28342b0f070d14c1f9ca4d898de8c2
  upgradeable: 'no'
value:
  usd: 1063
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell liquidity providers whose accounts take real code to call approve directly instead of signing a permit.
evidence_level: source
checks:
- id: permit-recover
  source: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  file: UniswapV2Pair.sol
  line: 192
  has: address recoveredAddress = ecrecover(digest, v, r, s);
  says: permit recovers the signer of the EIP-712 digest with ecrecover
  for:
  - what
- id: permit-require
  source: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  file: UniswapV2Pair.sol
  line: 193
  has: 'require(recoveredAddress != address(0) && recoveredAddress == owner, ''UniswapV2: INVALID_SIGNATURE'');'
  says: permit reverts unless the recovered address is non-zero and equals the owner argument
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  file: UniswapV2Pair.sol
  line: 194
  has: _approve(owner, spender, value);
  says: a valid permit sets the owner's allowance for the spender
  for:
  - what
- id: approve
  source: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  file: UniswapV2Pair.sol
  lines:
  - 165
  - 167
  has: _approve(msg.sender, spender, value);
  says: approve sets the caller's own allowance without a signature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: mint
  source: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  file: UniswapV2Pair.sol
  line: 405
  has: function mint(address to) external lock returns (uint liquidity) {
  says: 'mint has no access check: anyone who adds liquidity receives liquidity tokens'
  for:
  - what
- id: burn-prorata
  source: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  file: UniswapV2Pair.sol
  lines:
  - 438
  - 439
  has: amount0 = liquidity.mul(balance0) / _totalSupply;
  says: the reserves are paid out pro rata to liquidity token holders who burn them
  for:
  - whose
- id: name
  call: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  fn: name()(string)
  is: Uniswap V2
  says: the liquidity token is named Uniswap V2
  for:
  - what
- id: supply
  call: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  fn: totalSupply()(uint256)
  is: '14226892127235659897'
  says: total liquidity token supply at the block
  for:
  - evidence-2
  - what
- id: dead
  call: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  fn: balanceOf(address)(uint256)
  args:
  - '0x000000000000000000000000000000000000dEaD'
  is: '14226892127235658897'
  says: all of the supply but 1,000 base units is at 0x…dEaD
  for:
  - evidence-2
  - what
- id: zero
  call: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  fn: balanceOf(address)(uint256)
  args:
  - '0x0000000000000000000000000000000000000000'
  is: '1000'
  says: the 1,000 minimum liquidity is locked at address zero
  for:
  - evidence-2
  - what
- id: eip
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: ecrecover returns nothing for a recovered account with real code, and still recovers an EIP-7702 delegation
  for:
  - what
- id: no-1271
  selector: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code does not ask signers through ERC-1271
  for:
  - notes
- id: factory
  call: '0x3e8769bb28fed24c6eef161b48b7689a5fb0e320'
  fn: factory()(address)
  is: '0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f'
  says: the pair was initialized by its factory and is in use on its own
  for:
  - notes
- id: replay-8151
  replay: '0x1688b7fe7744a6de9075bb6f032298b549a4cb5531d3ab205eb8f20864e82b86'
  run: eip8151
  ok: true
  says: a router permit removal on a pair of this code succeeds under EIP-8151 with nobody migrating
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-3e8769bb, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL notice (PQ-19): a Uniswap V2 pair whose permit requires ecrecover to return the owner,
    so it stops working for an owner whose account takes real code; approve, transfer and transferFrom need no signature.
    Today only the dead and zero addresses hold its liquidity tokens. Refuter agrees; Claude read the sheet.'
related: []
---

## What happens

This Uniswap V2 pair lets a liquidity token holder approve a spender by a signed permit or by calling approve. Holders whose accounts take real code lose permit; approve and EIP-7702 delegations still work. Today its liquidity tokens sit at 0x…dEaD and address zero, until someone adds liquidity.

## Evidence

- [permit](https://etherscan.io/address/0x3e8769bb28fed24c6eef161b48b7689a5fb0e320#code) requires ecrecover to return the named owner; approve sets the caller's own allowance.
- Of the [pair's](https://etherscan.io/token/0x3e8769bb28fed24c6eef161b48b7689a5fb0e320#balances) 14.23 liquidity tokens, all but 1,000 base units (at address zero) are at 0x…dEaD.

## Reviewer notes

### Mechanism

permit (lines 183-195) builds the EIP-712 digest with the owner's nonce, recovers it with ecrecover (line 192) and requires a non-zero result equal to the owner argument (line 193), then sets allowance[owner][spender] (line 194). Under EIP-8151 ecrecover returns nothing for an owner whose account has real code, so the require fails; an EIP-7702 delegation still recovers. approve (lines 165-168) sets the caller's own allowance with no signature, so a holder with code keeps the direct path; transfer and transferFrom need no signature either. At block 26,438,999 the pair is initialized by factory 0x5C69…aA6f (token0 0x1D21…3ab3 'DON', token1 WETH), reserves 366.07 DON and 0.5879 WETH. totalSupply 14,226,892,127,235,659,897 = 14,226,892,127,235,658,897 at 0x…dEaD + 1,000 at address zero (the minimum liquidity locked by mint, line 416). So no liquidity provider other than these two addresses holds tokens at the block; mint (line 405) has no access check, so anyone who adds liquidity becomes a holder and the notice applies to them. The reserves are paid out pro rata to whoever burns liquidity tokens (lines 438-439).

### Checks

- Header facts: this address alone, at block 26,438,999; 528,187 addresses run this code.
- Ruled out: an ERC-1271 path for owners with code: permit has none (lines 183-195) and the code holds no isValidSignature selector.
- Ruled out: breaking by itself: a family replay of a router permit removal (tx 0x1688b7fe…2b86) succeeds under EIP-8151 alone; ecrecover is called with all remaining gas (scan reports no gas constant).
- Ruled out: unused implementation: this address is a pair initialized by its factory with non-zero reserves (factory, token0, token1, getReserves at the block).
- Ruled out: path closed for good: mint is open to anyone (line 405), so new holders, and permit, can come back.
- Ruled out: the other 528,186 addresses running this code: their state differs and is not described here.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
