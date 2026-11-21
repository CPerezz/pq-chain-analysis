---
id: ssin-64a9f1ac-signed-shortcut-lost
format: 2
title: sSIN holders whose accounts take real code lose permit, keep approve
status: confirmed
severity: INFORMATIONAL
justification: A holder whose account takes real code loses permit but can still call approve directly; nothing
  is locked.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042'
  name: sSIN
  code: verified
  code_url: https://etherscan.io/address/0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042#code
  copies: 1
  admin: '0x7ef1615fc734e4df0553d8e5636db6e8538ab29f'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Tell sSIN holders that permit rejects accounts with real code and that a direct approve call still works.
evidence_level: source
checks:
- id: recover
  source: '0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042'
  file: sSIN.sol
  line: 769
  has: address signer = ecrecover(_hash, v, r, s);
  says: permit recovers the signer of the EIP-712 hash with ecrecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: match
  source: '0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042'
  file: sSIN.sol
  line: 770
  has: 'require(signer != address(0) && signer == owner, "ERC20Permit: Invalid signature");'
  says: the recovered address must equal the holder, with no other way to check a signer
  for:
  - action
  - evidence-1
  - justification
  - what
- id: approve
  source: '0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042'
  file: sSIN.sol
  lines:
  - 1015
  - 1016
  has: _allowedValue[ msg.sender ][ spender ] = value;
  says: approve sets the caller's own allowance with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: transfer
  source: '0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042'
  file: sSIN.sol
  line: 993
  has: _gonBalances[ msg.sender ] = _gonBalances[ msg.sender ].sub( gonValue );
  says: 'balances belong to holders: transfer moves the caller''s own balance'
  for:
  - whose
- id: staking
  call: '0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042'
  fn: stakingContract()(address)
  is: '0x8b907190fb9f1816be58eeea6c4e81da122664f8'
  says: the staking contract is set
  for:
  - evidence-3
- id: initialized
  call: '0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042'
  fn: initializer()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: initialize ran and cleared the initializer
  for:
  - evidence-3
- id: supply
  call: '0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042'
  fn: circulatingSupply()(uint256)
  is: 13393980098345
  says: 13,393.98 sSIN (9 decimals) are held outside the staking contract
  for:
  - evidence-3
  - whose
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

Staked Sin (sSIN) lets a holder approve a spender by calling approve, or by signing a permit anyone can submit. Permit accepts the signature if the recovered address is the holder. A holder whose account takes real code loses permit and keeps approve; an EIP-7702 delegation keeps permit working.

## Evidence

- [permit](https://etherscan.io/address/0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042#code) recovers the signer with ecrecover and requires it to equal the holder; it has no other check for a signer with real code.
- [approve](https://etherscan.io/address/0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042#code) sets the caller's own allowance and takes no signature.
- The [token](https://etherscan.io/address/0x64a9f1ac6ae2d424ed0dcc6ce32ae3fe53159042#code) is set up: its staking contract is set and over 13,000 sSIN are held outside it.

## Reviewer notes

### Mechanism

permit (lines 753-774) checks the deadline, builds the EIP-712 hash with the holder's nonce, recovers the signer with ecrecover and requires it to be non-zero and equal to owner; it then increments the nonce and calls _approve, which sets _allowedValue[owner][spender] (lines 1022-1025). approve (lines 1015-1019) and increaseAllowance/decreaseAllowance set the same mapping for msg.sender with no signature. Under EIP-8151 ecrecover returns nothing for a holder whose account has real code, so the equality fails and permit reverts; approve from the holder's own account is unaffected. An EIP-7702 delegation still recovers. Nothing else in the contract checks a signature. State at block 26,438,999: initializer is zero and stakingContract is 0x8b90...64f8, so initialize ran; circulatingSupply is 13,393.98 sSIN (9 decimals); the address itself holds no priced value.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size branch for holders with code: permit has none (lines 769-770).
- Ruled out: unused implementation code: not a proxy, and initialize ran (initializer is zero, stakingContract set).
- Ruled out: a closed path: the contract has no pause; permit checks only the deadline, the nonce and the signature.
- Ruled out: a signature rechecked after others relied on it: permit sets an allowance once and increments the nonce; nothing re-verifies it later.
- Ruled out: a break with nobody migrating: ecrecover is called by solc 0.7.5 without a fixed gas amount (scanner found no gas constant); no window calls or replays exist, so a sender-gas-limit failure on a permit transaction is not shown.
- Ruled out: an owner override: owner 0x7ef1...b29f can only call setIndex (once, while INDEX is 0) and transfer ownership; it cannot change permit.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
