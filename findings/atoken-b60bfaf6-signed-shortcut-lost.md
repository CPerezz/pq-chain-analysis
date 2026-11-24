---
id: atoken-b60bfaf6-signed-shortcut-lost
format: 2
title: Edel wCOINx holders whose accounts take real code lose permit
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a holder moves its account to real code; that holder can still approve by direct call.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb60bfaf6c91ca6315381b5e01e9743c3ae445602'
  name: AToken
  code: verified
  code_url: https://etherscan.io/address/0xb0c626f9c25418ba16132e5ae33cf54e61f8242f#code
  proxy_of: '0xb0c626f9c25418ba16132e5ae33cf54e61f8242f'
  copies: 207
  family: 7e66219b795aa32d7e5dea5b960c8791
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell holders to approve spenders by direct call, not permit, once their accounts take real code.
evidence_level: source
checks:
- id: ecdsa
  source: '0xb0c626f9c25418ba16132e5ae33cf54e61f8242f'
  file: '@aave/core-v3/contracts/protocol/tokenization/AToken.sol'
  line: 190
  has: require(owner == ecrecover(digest, v, r, s), Errors.INVALID_SIGNATURE);
  says: permit accepts a signature only when ecrecover returns the owner named in the call
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-owner
  source: '0xb0c626f9c25418ba16132e5ae33cf54e61f8242f'
  file: '@aave/core-v3/contracts/protocol/tokenization/AToken.sol'
  lines:
  - 191
  - 192
  has: _approve(owner, spender, value);
  says: after the signature check permit sets the owner's own allowance
  for:
  - evidence-1
  - whose
- id: approve
  source: '0xb0c626f9c25418ba16132e5ae33cf54e61f8242f'
  file: '@aave/core-v3/contracts/protocol/tokenization/base/IncentivizedERC20.sol'
  lines:
  - 137
  - 140
  has: _approve(_msgSender(), spender, amount);
  says: approve sets the caller's allowance without any signature
  for:
  - action
  - evidence-2
  - justification
  - what
  - whose
- id: supply
  call: '0xb60bfaf6c91ca6315381b5e01e9743c3ae445602'
  fn: totalSupply()(uint256)
  is: '32747134151952609508'
  says: the token has 32.75 units outstanding at the block
  for:
  - what
- id: name
  call: '0xb60bfaf6c91ca6315381b5e01e9743c3ae445602'
  fn: name()(string)
  is: Edel wCOINx
  says: the token's on-chain name
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-b60bfaf6, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: 'agree: header Upgradeable (not established, not wrong): the proxy has upgradeTo and its immutable admin
    is the Edel PoolConfigurator 0xceae10fc... (getPoolConfigurator of the Edel Market provider); the card could
    show Upgradeable: yes, and the action could add that the pool admin can upgrade permit to accept ERC-1271; header
    Activity (not established, not wrong): the wCOINx reserve was last updated 2026-07-01 (~140 days before the
    block), so no supply, withdraw, borrow or repay since; transfers/permits'
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. Edel wCOINx aToken: permit ECDSA-only (AToken.sol
    190), approve direct. INFORMATIONAL. For a later pass: the proxy is upgradeable by the Edel PoolConfigurator
    (an option for the action); the reserve was last updated 2026-07-01.'
related: []
---

## What happens

Edel wCOINx, a lending deposit token with 32.7 units held, lets a holder approve a spender by signed permit, counted only if the recovered address is the holder. A holder whose account takes real code loses permit; approve by direct call still works, and an EIP-7702 delegation keeps permit working.

## Evidence

- [permit](https://etherscan.io/address/0xb0c626f9c25418ba16132e5ae33cf54e61f8242f#code) requires the recovered address to equal the owner named in the call, then sets that owner's allowance.
- [approve](https://etherscan.io/address/0xb0c626f9c25418ba16132e5ae33cf54e61f8242f#code) sets the caller's own allowance with no signature.

## Reviewer notes

### Mechanism

The proxy's EIP-1967 slot points to the AToken implementation 0xb0c6…242f (Aave v3 code). AToken.permit (lines 170-193) builds an EIP-712 digest over owner, spender, value, the owner's nonce and deadline, requires owner == ecrecover(digest, v, r, s) at line 190, bumps the nonce and calls _approve(owner, spender, value). There is no ERC-1271 or code-size branch, so under EIP-8151 a holder whose account holds real code can never satisfy line 190; a 7702 delegation still recovers. IncentivizedERC20.approve (lines 137-140) calls _approve(_msgSender(), …) without a signature, so the same allowance stays reachable by a direct call from the holder's account. Solidity's ecrecover forwards all gas, so nothing breaks with nobody migrating. State at the block: name() is 'Edel wCOINx', totalSupply() 32.75e18, underlying wCOINx (0x3a98…11dA), pool 0x3EEe…Faa6; the reserve configuration has active=1, frozen=1, paused=0, so new deposits are closed but holders keep their tokens and permit/approve are not gated by the pool.

### Checks

- Header facts: this address alone, at block 26,438,999; 207 addresses run this code.
- Ruled out: ERC-1271 or a second signature path in permit: none, the only check is line 190 of AToken.sol.
- Ruled out: unused implementation: this address is the proxy itself, initialized (name() answers, totalSupply() is 32.75e18).
- Ruled out: breaks by itself: the recovery uses Solidity's ecrecover with all remaining gas, no fixed gas; no replays or traced recoveries in the dossier.
- Ruled out: the explorer label 'Spark: wstETH Token' in the old row does not match the chain: name() is 'Edel wCOINx' and the underlying is wCOINx, so no label is stated.
- Ruled out: the row's 207 copies and their $3.9B value belong to the code family; this address holds 0 ETH and 0 of its underlying (balanceOf on wCOINx is 0). Each copy in use is its own row.
- Ruled out: a paused market closing the path: the reserve is frozen but not paused, and neither permit nor approve calls the pool.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
