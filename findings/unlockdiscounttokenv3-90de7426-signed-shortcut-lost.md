---
id: unlockdiscounttokenv3-90de7426-signed-shortcut-lost
format: 2
title: UDT holders whose accounts take real code lose permit and signed delegation
status: confirmed
severity: INFORMATIONAL
justification: A holder who moves to real code loses only the signed shortcuts; approve and delegate by direct call
  still work.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x90de74265a416e1393a450752175aed98fe11517'
  name: UnlockDiscountTokenV3
  code: verified
  code_url: https://etherscan.io/address/0xcb22bd8b943879e83193f479ec4e3c98b610b507#code
  proxy_of: '0xcb22bd8b943879e83193f479ec4e3c98b610b507'
  copies: 2
  family: be3fd52a408a7ac90d12ded4d60cbd81
  upgradeable: 'yes'
  admin: '0x79918a4389a437906538e0bbf39918bfa4f7690e'
value:
  usd: 106
  basis: held
activity: {}
impact: liveness
action: Tell holders to call approve and delegate directly once their accounts take real code; signed permits stop
  counting.
evidence_level: source
checks:
- id: permit
  source: '0xcb22bd8b943879e83193f479ec4e3c98b610b507'
  file: contracts/ERC20Patched.sol
  lines:
  - 1023
  - 1026
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: permit approves only when the recovered signer is the owner
  for:
  - action
  - evidence-1
  - justification
  - what
- id: delbysig
  source: '0xcb22bd8b943879e83193f479ec4e3c98b610b507'
  file: contracts/ERC20Patched.sol
  lines:
  - 1504
  - 1513
  has: return _delegate(signer, delegatee);
  says: delegateBySig delegates the votes of the recovered signer
  for:
  - evidence-1
  - justification
  - what
- id: recover-zero
  source: '0xcb22bd8b943879e83193f479ec4e3c98b610b507'
  file: contracts/ERC20Patched.sol
  lines:
  - 761
  - 762
  has: 'require(signer != address(0), "ECDSA: invalid signature");'
  says: a recovery that returns nothing reverts
  for:
  - what
- id: approve
  source: '0xcb22bd8b943879e83193f479ec4e3c98b610b507'
  file: contracts/ERC20Patched.sol
  lines:
  - 427
  - 429
  has: _approve(_msgSender(), spender, amount);
  says: approve sets the caller's allowance without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: delegate
  source: '0xcb22bd8b943879e83193f479ec4e3c98b610b507'
  file: contracts/ERC20Patched.sol
  lines:
  - 1488
  - 1490
  has: return _delegate(_msgSender(), delegatee);
  says: delegate moves the caller's votes without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: supply
  call: '0x90de74265a416e1393a450752175aed98fe11517'
  fn: totalSupply()(uint256)
  is: '1000874903333859333969688'
  says: the proxy is the token in use, with about 1.0 million UDT
  for:
  - evidence-3
  - what
- id: domain
  call: '0x90de74265a416e1393a450752175aed98fe11517'
  fn: DOMAIN_SEPARATOR()(bytes32)
  is: '0x7cbc02de6ee5b9c8ebba49207299c818ef648edff1a7ee06d5fa7c983a0b5fb3'
  says: the EIP-712 domain for permit and delegateBySig is set
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-90de7426, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. UDT: permit and delegateBySig ECDSA-only; approve
    and delegate direct. For the wording pass: the proxy is admin-upgradeable, so adding ERC-1271 by an upgrade
    is an option for the action; the $106 is stray USDT and UDT at the token itself.'
related: []
---

## What happens

The Unlock Discount Token lets a holder approve a spender or delegate its votes with an ECDSA signature, or by a direct call from its own address. A holder whose account takes real code loses the signed way; an EIP-7702 delegation keeps it working.

## Evidence

- [permit](https://etherscan.io/address/0xcb22bd8b943879e83193f479ec4e3c98b610b507#code) approves only if the recovered signer is the owner; delegateBySig moves the votes of whoever signed.
- [approve and delegate](https://etherscan.io/address/0xcb22bd8b943879e83193f479ec4e3c98b610b507#code) act for the caller and take no signature.
- The [token](https://etherscan.io/token/0x90de74265a416e1393a450752175aed98fe11517) is live behind its proxy, with about 1.0 million UDT in supply and its signing domain set.

## Reviewer notes

### Mechanism

The address is an EIP-1967 proxy for UnlockDiscountTokenV3 (OpenZeppelin ERC20VotesComp v4.2, patched). permit (ERC20Patched.sol 1008-1027) recovers the EIP-712 Permit digest with ECDSAUpgradeable.recover, which calls ecrecover and reverts on address(0) (761-762), then requires signer == owner and approves. delegateBySig (1495-1514) recovers the Delegation digest, consumes that signer's nonce and delegates the signer's votes. Under EIP-8151 a holder with real code recovers to nothing, so both revert for it; a 7702 delegation still recovers. approve (427-430) and delegate (1488-1490) act for msg.sender without a signature, so no right is lost. The implementation copy 0xcb22... holds no supply (totalSupply 0) and is not the token in use.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 path for holders with code: the source has no isValidSignature call.
- Ruled out: a fixed gas budget: recovery is Solidity's ecrecover, which forwards the available gas; the scanner found no gas constant.
- Ruled out: the unused implementation: the proxy is initialized (name, supply about 1.0 million UDT, a non-zero DOMAIN_SEPARATOR); the implementation copy has totalSupply 0.
- Ruled out: a signature rechecked after others relied on it: permit and delegateBySig act once and consume a nonce.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
