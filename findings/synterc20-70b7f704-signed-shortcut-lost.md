---
id: synterc20-70b7f704-signed-shortcut-lost
format: 2
title: 'Symbiosis synthetic token: permit stops for holders with real code'
status: confirmed
severity: INFORMATIONAL
justification: A holder loses the signed approval only by moving its account to real code; a direct approve still
  works.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  name: SyntERC20
  project: symbiosis
  code: verified
  code_url: https://etherscan.io/address/0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1#code
  copies: 5
  family: 04dee77323cdd15914ff0f44cca3324b
  upgradeable: 'no'
  admin: '0xbbfb7cb70f84fb6fe1cb13e42a0b71efde769428'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell holders that permit stops once their account takes real code, and that a direct approve call keeps
  working.
evidence_level: source
checks:
- id: recover
  source: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  file: '@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol'
  line: 56
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer of the EIP-712 permit with ECDSA
  for:
  - evidence-1
  - what
- id: match
  source: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  file: '@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol'
  line: 57
  has: 'require(signer == owner, "ERC20Permit: invalid signature");'
  says: the recovered address must equal the token holder named in the permit
  for:
  - action
  - evidence-1
  - justification
  - what
- id: permit-approve
  source: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  file: '@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol'
  line: 59
  has: _approve(owner, spender, value);
  says: a valid permit sets the holder's allowance for the spender
  for:
  - what
  - whose
- id: permit-body
  source: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  file: '@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol'
  lines:
  - 41
  - 60
  has: function permit(
  says: 'the whole permit function: ECDSA only, no ERC-1271 branch'
  for:
  - evidence-1
- id: ecrecover
  source: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 173
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover calls the ecrecover precompile
  for:
  - what
- id: approve
  source: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  file: '@openzeppelin/contracts/token/ERC20/ERC20.sol'
  lines:
  - 132
  - 135
  has: _approve(_msgSender(), spender, amount);
  says: approve sets the caller's own allowance without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: project
  source: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  file: contracts/synth-core/SyntERC20.sol
  line: 25
  has: ERC20Permit("Symbiosis")
  says: the verified source names Symbiosis as the permit domain
  for:
  - what
- id: token-name
  call: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  fn: symbol()(string)
  is: QUAI
  says: the token's symbol is QUAI
  for:
  - what
- id: supply
  call: '0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1'
  fn: totalSupply()(uint256)
  is: '1196000000000000000000'
  says: 1,196 tokens are held by holders at the block
  for:
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

This Symbiosis synthetic token (Quai Network, QUAI) lets a holder approve a spender with an ECDSA-signed permit or with a direct approve call. A holder whose account takes real code can no longer use permit; an EIP-7702 delegation keeps working.

## Evidence

- [permit](https://etherscan.io/address/0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1#code) recovers the signer with ECDSA and requires it to equal the holder; it has no ERC-1271 path.
- [approve](https://etherscan.io/address/0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1#code) sets the caller's own allowance without a signature.

## Reviewer notes

### Mechanism

permit (OpenZeppelin draft-ERC20Permit, lines 41-60) checks the deadline, builds the EIP-712 hash with the holder's nonce, recovers the signer with ECDSA.recover (line 56; ECDSA.tryRecover calls the ecrecover builtin at line 173, which forwards all remaining gas) and requires signer == owner (line 57), then sets the allowance (line 59). No ERC-1271 or code-size branch. approve (ERC20, lines 132-135) sets the allowance of msg.sender with no signature, so the same act stays open by a direct call. SyntERC20 adds only owner-gated mint and burn (lines 12-18) and sets the EIP-712 name to Symbiosis (line 25). At block 26,438,999 the token is live: name Quai Network, symbol QUAI, totalSupply 1,196e18; owner() is a contract (the Synthesis proxy per the source comment on line 8); the address holds no ETH or priced tokens.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: fixed gas: the recovery uses Solidity's ecrecover builtin, which forwards all gas (ECDSA.sol line 173); the scanner found no gas constant.
- Ruled out: breaks by itself: the dossier lists no replays and no traced recoveries for the family; nothing fails under the change unless a holder moves to real code.
- Ruled out: ERC-1271 for holders with code: permit has none (lines 41-60).
- Ruled out: direct path: approve exists and needs no signature (ERC20.sol lines 132-135).
- Ruled out: proxy or unused implementation: not a proxy, no delegatecall; the token has supply 1,196 QUAI at the block, so it is in use.
- Ruled out: signature rechecked later: a permit is consumed once (nonce incremented, line 52); nobody relies on it afterwards inside this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
