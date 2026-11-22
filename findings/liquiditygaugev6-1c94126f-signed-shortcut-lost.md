---
id: liquiditygaugev6-1c94126f-signed-shortcut-lost
format: 2
title: 'Curve crvUSDe gauge: permit stops for holders whose accounts take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only when a holder moves to real code; that holder still approves by a direct call; nothing
  locked.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  name: LiquidityGaugeV6
  project: curve
  code: verified
  code_url: https://etherscan.io/address/0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 479
  last: 2026-11-17
impact: liveness
action: Tell gauge holders to use approve instead of permit once their account takes real code; 7702 delegation
  keeps permit working.
evidence_level: source
checks:
- id: permit-ecrecover
  source: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  file: LiquidityGaugeV6.vy
  line: 573
  has: assert ecrecover(digest, _v, _r, _s) == _owner
  says: permit accepts only an ECDSA signature that recovers to the token holder
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-sets
  source: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  file: LiquidityGaugeV6.vy
  line: 575
  has: self.allowance[_owner][_spender] = _value
  says: a valid permit sets the holder's allowance for the spender
  for:
  - what
  - whose
- id: approve
  source: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  file: LiquidityGaugeV6.vy
  line: 527
  has: self.allowance[msg.sender][_spender] = _value
  says: approve sets the same allowance for the caller without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: author
  source: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  file: LiquidityGaugeV6.vy
  line: 6
  has: '@author Curve.Fi'
  says: the verified source is Curve's gauge
  for:
  - what
- id: gauge-name
  call: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  fn: name()(string)
  is: Curve.fi crvUSDe Gauge Deposit
  says: the gauge is the crvUSDe pool's gauge
  for:
  - what
- id: not-killed
  call: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  fn: is_killed()(bool)
  is: false
  says: the gauge is not killed at the block
  for:
  - evidence-3
- id: supply
  call: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  fn: totalSupply()(uint256)
  is: '941126374049857754769467'
  says: holders have about 941,126 gauge tokens deposited
  for:
  - notes
- id: full-gas
  bytecode: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  has: 60015afa
  says: the call to the recovery precompile forwards all remaining gas (PUSH1 0x01, GAS, STATICCALL)
  for:
  - evidence-1
- id: no-1271
  bytecode: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  has: 1626ba7e
  absent: true
  says: the code never calls isValidSignature
  for:
  - evidence-1
- id: deposit-pull
  source: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  file: LiquidityGaugeV6.vy
  line: 430
  has: ERC20(self.lp_token).transferFrom(msg.sender, self, _value)
  says: deposit pulls the depositor's LP tokens into the gauge
  for:
  - what
  - whose
- id: lp-token
  call: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  fn: lp_token()(address)
  is: '0x5B03CcCAb7BA3010fA5CAd23746cbf0794938e96'
  says: the gauge's LP token is the crvUSDe pool
  for:
  - evidence-3
  - what
- id: lp-held
  call: '0x5b03cccab7ba3010fa5cad23746cbf0794938e96'
  fn: balanceOf(address)(uint256)
  args:
  - '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  is: '941126374049857754769467'
  says: the gauge holds 941,126 crvUSDe LP tokens
  for:
  - evidence-3
  - what
  - whose
- id: lp-supply
  call: '0x5b03cccab7ba3010fa5cad23746cbf0794938e96'
  fn: totalSupply()(uint256)
  is: '946628630376191154990744'
  says: the pool's LP supply; the gauge holds 99.4% of it
  for:
  - evidence-3
- id: usdt-coin
  call: '0x5b03cccab7ba3010fa5cad23746cbf0794938e96'
  fn: coins(uint256)(address)
  args:
  - '0'
  is: '0xdAC17F958D2ee523a2206206994597C13D831ec7'
  says: coin 0 of the pool is USDT (6 decimals)
  for:
  - what
- id: usde-coin
  call: '0x5b03cccab7ba3010fa5cad23746cbf0794938e96'
  fn: coins(uint256)(address)
  args:
  - '1'
  is: '0x4c9EDD5852cd905f086C759E8383e09bff1E68B3'
  says: coin 1 of the pool is USDe (18 decimals)
  for:
  - what
- id: lp-withdraw
  call: '0x5b03cccab7ba3010fa5cad23746cbf0794938e96'
  fn: remove_liquidity(uint256,uint256[])(uint256[])
  args:
  - '941126374049857754769467'
  - - '0'
    - '0'
  from: '0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85'
  is:
  - '838263426313'
  - '145205068939764147652961'
  says: withdrawn in the pool's proportions, the gauge's LP returns 838,263.43 USDT and 145,205.07 USDe
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This Curve gauge holds users' 941,126 crvUSDe LP tokens, which withdraw for about 838,263 USDT and 145,205 USDe. A holder can approve a spender of its gauge tokens by signed permit; the signature must recover to the holder. A holder whose account takes real code loses permit and keeps approve.

## Evidence

- [permit](https://etherscan.io/address/0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85#code) requires that the ECDSA signature recovers to the token holder; it never asks the holder's code.
- [approve](https://etherscan.io/address/0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85#code) sets the same allowance for the caller with no signature.
- The [gauge](https://etherscan.io/address/0x1c94126f29a9d6f9ef3ccb1d5d58ebcacc519f85#code) is not killed and holds 941,126 crvUSDe LP tokens, 99.4% of the pool's supply.

## Reviewer notes

### Mechanism

permit (lines 533-579) builds the EIP-2612 digest with the holder's nonce, asserts ecrecover(digest, v, r, s) == _owner (line 573), then sets allowance[_owner][_spender] (line 575) and bumps the nonce. Under EIP-8151 ecrecover returns nothing for an owner with real code, so the assert fails and that holder cannot use permit; an EIP-7702 delegation still recovers. approve (line 527), increaseAllowance and decreaseAllowance set the same allowance for msg.sender with no signature, so a holder whose account has real code calls them from that code. The precompile call in the bytecode forwards all remaining gas (PUSH1 0x01, GAS, STATICCALL), so the higher recovery price does not break permit for anyone else. State at block 26,438,999: is_killed false, totalSupply 941,126.37 tokens, lp_token crvUSDe (0x5B03…8e96) with the same balance held by the gauge; version v6.1.0.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 for holders with code: the source declares an ERC1271 interface (lines 27-28) and the permit docstring claims support (line 547), but permit never calls isValidSignature; the only signature check is line 573.
- Ruled out: A fixed gas budget for the precompile: the call at bytecode offset 4449 passes GAS, so nothing breaks with nobody migrating.
- Ruled out: A signature relied on by others and checked again later: permit is checked once and consumed by the nonce; nothing re-verifies it.
- Ruled out: Proxy or unused implementation: no proxy slots or DELEGATECALL, and this address has its own deposits (totalSupply 941,126 tokens, not killed).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
