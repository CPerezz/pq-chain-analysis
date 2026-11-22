---
id: atoken-b95bd079-signed-shortcut-lost
format: 2
title: UwU uDAI holders whose accounts take real code lose permit approvals
status: confirmed
severity: INFORMATIONAL
justification: Breaks only for a holder that moves its account to real code; a direct approve still works and nothing
  is locked.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb95bd0793bcc5524af358ffaae3e38c3903c7626'
  name: AToken
  code: verified
  code_url: https://etherscan.io/address/0x3435ccfa639b756aa7c5097008ab70984524eaf5#code
  proxy_of: '0x3435ccfa639b756aa7c5097008ab70984524eaf5'
  copies: 41
  family: a3df5c92afe9e1c286ec7b2937371567
value:
  usd: 31479
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell uDAI holders whose accounts take real code to approve spenders with a direct call, since their permit
  signatures stop counting.
evidence_level: source
checks:
- id: ecdsa
  source: '0x3435ccfa639b756aa7c5097008ab70984524eaf5'
  file: contracts/aave-protocol-v2/protocol/tokenization/AToken.sol
  line: 346
  has: require(owner == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
  says: permit accepts the signature only if ecrecover returns the owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0x3435ccfa639b756aa7c5097008ab70984524eaf5'
  file: contracts/aave-protocol-v2/protocol/tokenization/AToken.sol
  lines:
  - 347
  - 348
  has: _approve(owner, spender, value);
  says: a valid permit bumps the owner's nonce and sets the allowance
  for:
  - evidence-1
  - what
- id: approve
  source: '0x3435ccfa639b756aa7c5097008ab70984524eaf5'
  file: contracts/aave-protocol-v2/protocol/tokenization/IncentivizedERC20.sol
  lines:
  - 109
  - 112
  has: _approve(_msgSender(), spender, amount);
  says: approve sets the caller's own allowance with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: balance
  source: '0x3435ccfa639b756aa7c5097008ab70984524eaf5'
  file: contracts/aave-protocol-v2/protocol/tokenization/AToken.sol
  lines:
  - 206
  - 209
  has: return super.balanceOf(user).rayMul(_pool.getReserveNormalizedIncome(_underlyingAsset));
  says: each holder's balance is its own scaled balance grown by the pool's income index
  for:
  - whose
- id: name
  call: '0xb95bd0793bcc5524af358ffaae3e38c3903c7626'
  fn: name()(string)
  is: UwU interest bearing DAI
  says: the token's name at the block
  for:
  - what
- id: impl
  storage: '0xb95bd0793bcc5524af358ffaae3e38c3903c7626'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x3435ccfa639b756aa7c5097008ab70984524eaf5'
  says: the proxy runs implementation 0x3435ccfa
  for:
  - evidence-1
- id: supply
  call: '0xb95bd0793bcc5524af358ffaae3e38c3903c7626'
  fn: totalSupply()(uint256)
  is: '31883172487398665656291'
  says: about 31,883 uDAI are outstanding, so the token is in use
  for:
  - evidence-3
- id: dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0xb95bd0793bcc5524af358ffaae3e38c3903c7626'
  is: '31493966801163556626924'
  says: the token holds about 31,494 DAI that backs holders' balances
  for:
  - evidence-3
  - whose
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

UwU's interest-bearing DAI token lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. If a holder's account takes real code, its permit signatures stop counting; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x3435ccfa639b756aa7c5097008ab70984524eaf5#code) sets an allowance only when ecrecover returns the owner.
- [approve](https://etherscan.io/address/0x3435ccfa639b756aa7c5097008ab70984524eaf5#code) sets the caller's own allowance with no signature.
- The [token](https://etherscan.io/address/0xb95bd0793bcc5524af358ffaae3e38c3903c7626) has about 31,883 uDAI outstanding and holds about 31,494 DAI.

## Reviewer notes

### Mechanism

The address is an Aave-style InitializableImmutableAdminUpgradeabilityProxy whose EIP-1967 slot points at AToken 0x3435ccfa (revision 7). permit (AToken.sol lines 326-349) builds the EIP-712 digest with the owner's nonce and requires owner == ecrecover(digest, v, r, s), then calls _approve(owner, spender, value). Under EIP-8151 ecrecover returns nothing for an owner whose account has real code, so the require fails; a 7702 delegation still recovers. approve and increaseAllowance (IncentivizedERC20.sol lines 109-112, 142-145) set the caller's allowance directly, so a smart-account holder keeps the same act. Balances are holders' scaled balances times the pool's normalized income (AToken.sol 206-209); the DAI it holds backs those balances.

### Checks

- Header facts: this address alone, at block 26,438,999; 41 addresses run this code.
- Ruled out: an ERC-1271 or code-size path in permit: none in the verified implementation (no isValidSignature anywhere in its source; lines 326-349).
- Ruled out: an unused implementation: this proxy is initialized (name 'UwU interest bearing DAI', totalSupply about 31,883 uDAI at the block).
- Ruled out: a signature checked again after someone relied on it: permit only sets an allowance once and bumps the nonce; nothing re-verifies it later.
- Ruled out: a break with nobody migrating: ecrecover is called through Solidity's built-in, which forwards all remaining gas; no fixed gas amount.
- Ruled out: wrong code: the row's old note named implementation 0xb5bb4f1a; the EIP-1967 slot at the block holds 0x3435ccfa, whose verified source is the one read here.
- Ruled out: other copies: 40 other addresses run the same proxy code (other UwU aTokens and implementation copies); each is its own row, this card covers uDAI only.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
