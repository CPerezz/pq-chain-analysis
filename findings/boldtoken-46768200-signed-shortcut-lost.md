---
id: boldtoken-46768200-signed-shortcut-lost
format: 2
title: BoldToken permit stops working for holders whose accounts take real code
status: confirmed
severity: INFORMATIONAL
justification: A holder that moves to real code loses permit but can still approve directly; nothing is locked.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x46768200f4a78ec38c7ddcb18982ab3f5850cc8a'
  name: BoldToken
  code: verified
  code_url: https://etherscan.io/address/0x46768200f4a78ec38c7ddcb18982ab3f5850cc8a#code
  copies: 12
  family: 5d67d04fb21904181ead64925e69a896
  upgradeable: 'no'
  admin: none
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell holders to use approve, not permit, once they move their accounts to real code.
evidence_level: source
checks:
- id: permit
  source: '0x46768200f4a78ec38c7ddcb18982ab3f5850cc8a'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol
  lines:
  - 64
  - 67
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: permit approves only when the recovered signer equals the holder named in the call, and approves that holder's
    own tokens
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: ecdsa
  source: '0x46768200f4a78ec38c7ddcb18982ab3f5850cc8a'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: the signer is recovered with the ecrecover precompile, no ERC-1271 fallback
  for:
  - evidence-1
  - what
- id: approve
  source: '0x46768200f4a78ec38c7ddcb18982ab3f5850cc8a'
  file: lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
  lines:
  - 136
  - 140
  has: _approve(owner, spender, amount);
  says: approve sets the caller's allowance by a direct call without a signature
  for:
  - action
  - justification
  - what
- id: supply-zero
  call: '0x46768200f4a78ec38c7ddcb18982ab3f5850cc8a'
  fn: totalSupply()(uint256)
  is: '0'
  says: this deployment has no tokens in circulation
  for:
  - evidence-2
  - what
- id: owner-zero
  call: '0x46768200f4a78ec38c7ddcb18982ab3f5850cc8a'
  fn: owner()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: ownership is renounced; nobody can reconfigure the token
  for:
  - admin
  - evidence-2
- id: bold-supply
  call: '0x6440f144b7e50d6a8439336510312d2f54beb01d'
  fn: totalSupply()(uint256)
  is: '32820394161748558700253728'
  says: the BOLD copy has about 32.8 million tokens in supply
  for:
  - evidence-3
  - what
- id: usdaf-supply
  call: '0x9cf12ccd6020b6888e4d4c4e4c7aca33c1eb91f8'
  fn: totalSupply()(uint256)
  is: '185536853941005355099330'
  says: another USDaf copy has about 185.5 thousand tokens in supply
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

BoldToken lets a holder approve a spender by a signed permit or by calling approve. A holder whose account takes real code loses permit and keeps approve; an EIP-7702 delegation keeps permit working. This USDaf deployment has no supply; the BOLD and other USDaf copies are in use.

## Evidence

- [permit](https://etherscan.io/address/0x46768200f4a78ec38c7ddcb18982ab3f5850cc8a#code) approves when the ECDSA signer equals the holder named in the call, with no fallback for a holder with real code.
- [This token](https://etherscan.io/token/0x46768200f4a78ec38c7ddcb18982ab3f5850cc8a) has a total supply of zero and its owner is renounced.
- The [BOLD copy](https://etherscan.io/token/0x6440f144b7e50d6a8439336510312d2f54beb01d) has a supply of about 32.8 million tokens.

## Reviewer notes

### Mechanism

permit (ERC20Permit.sol, lines 49-68) builds the EIP-712 hash with the holder's nonce, calls ECDSA.recover (ECDSA.sol, lines 124-155; ecrecover at line 139 with no gas cap) and requires the result to equal the owner argument, then calls _approve(owner, spender, value). Under EIP-8151 ecrecover returns nothing for a signer with real code, recover reverts with InvalidSignature, and permit fails. approve (ERC20.sol, lines 136-140) sets the same allowance for msg.sender without a signature. BoldToken.sol adds no other signature path. Owner is zero at the block (setCollateralRegistry renounces), so the code cannot be reconfigured; no proxy. This address (USDaf) has totalSupply 0 at block 26,438,999 with collateralRegistryAddress set to 0x5fe5...6979; the copies 0x6440...501d (BOLD, 32.8M) and 0x9cf1...91f8 (USDaf, 185.5k) carry supply and the family's window recoveries.

### Checks

- Header facts: this address alone, at block 26,438,999; 12 addresses run this code.
- Ruled out: an ERC-1271 or code-size path: permit has none (ERC20Permit.sol lines 49-68), BoldToken.sol does not override it.
- Ruled out: a break with nobody migrating: ecrecover is called without a fixed gas amount (ECDSA.sol line 139); the family replay of tx 0xa1972ead... under EIP-8151 alone passes.
- Ruled out: citing the replay: tx 0xa1972ead... is a CoW settlement (root selector 0x13d79a0b) whose order the same signer signs, so its revert with code at the signer does not isolate this contract; evidence_level stays source.
- Ruled out: path closed for good: no pause in the source; this address has zero supply, but whether its branch contracts can still mint was not read, so the card states the supply only.
- Ruled out: wrong code: the address is verified as BoldToken and is not a proxy.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
