---
id: electroneumwrappedetn-74efd06e-signed-shortcut-lost
format: 2
title: eETN holders whose accounts take real code lose permit approvals
status: confirmed
severity: INFORMATIONAL
justification: A holder that moves its account to real code loses permit; approve from the account still works.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x74efd06e318012cb89266f1af03a0520f694a674'
  name: ElectroneumWrappedETN
  code: verified
  code_url: https://etherscan.io/address/0x9db8c107a4c2689ca2a63c88a7a4ebdf86398f59#code
  proxy_of: '0x9db8c107a4c2689ca2a63c88a7a4ebdf86398f59'
  copies: 3
  family: c02e28222ff6286891d363dbd346fcef
  upgradeable: 'yes'
  admin: '0x502dcfaf8d33a7fe3bca9d660299ec7778b97c2b'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell eETN holders that permit stops once their account takes real code, and to call approve from the account
  instead.
evidence_level: source
checks:
- id: permit-recover
  source: '0x9db8c107a4c2689ca2a63c88a7a4ebdf86398f59'
  file: '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol'
  lines:
  - 66
  - 71
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit recovers the signer with ECDSA, reverts unless it equals the holder, then sets the holder's allowance
  for:
  - action
  - evidence-1
  - justification
  - what
  - whose
- id: ecrecover
  source: '0x9db8c107a4c2689ca2a63c88a7a4ebdf86398f59'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover calls the ecrecover precompile
  for:
  - evidence-1
  - what
- id: approve
  source: '0x9db8c107a4c2689ca2a63c88a7a4ebdf86398f59'
  file: '@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol'
  lines:
  - 155
  - 158
  has: address owner = _msgSender();
  says: approve sets the caller's own allowance without a signature
  for:
  - action
  - evidence-2
  - justification
  - what
  - whose
- id: supply
  call: '0x74efd06e318012cb89266f1af03a0520f694a674'
  fn: totalSupply()(uint256)
  is: '19354025000000010000000000'
  says: 19.35 million eETN are in supply at this address
  for:
  - what
- id: not-paused
  call: '0x74efd06e318012cb89266f1af03a0520f694a674'
  fn: paused()(bool)
  is: 'false'
  says: the token is not paused
  for:
  - what
- id: copy-supply
  call: '0x98e6a2b9cec2ff0a1d7833d003c1b4426dc6a47c'
  fn: totalSupply()(uint256)
  is: '0'
  says: the other proxy running this code has no supply
  for:
  - notes
- id: impl-uninit
  call: '0x9db8c107a4c2689ca2a63c88a7a4ebdf86398f59'
  fn: name()(string)
  is: ''
  says: the implementation itself was never initialized
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
- who: r-74efd06e, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. ElectroneumWrappedETN: permit ECDSA-only, approve
    direct; live (about 19.35M eETN, not paused). INFORMATIONAL.'
related: []
---

## What happens

Electroneum Wrapped ETN is a live token: 19.35 million eETN in supply, not paused. Its permit sets a holder's allowance from the holder's ECDSA signature. A holder whose account takes real code loses permit and keeps approve; an EIP-7702 delegation keeps permit working.

## Evidence

- [permit](https://etherscan.io/address/0x9db8c107a4c2689ca2a63c88a7a4ebdf86398f59#code) recovers the signer with ECDSA and requires it to equal the holder; it has no ERC-1271 check.
- [approve](https://etherscan.io/address/0x9db8c107a4c2689ca2a63c88a7a4ebdf86398f59#code) sets the caller's own allowance with no signature.

## Reviewer notes

### Mechanism

The proxy runs ElectroneumWrappedETN (OpenZeppelin ERC20Upgradeable + ERC20PermitUpgradeable + Ownable + Pausable). permit (ERC20PermitUpgradeable lines 49-72) hashes the EIP-712 struct with the owner's nonce, calls ECDSA.recover (ecrecover precompile, ECDSA.sol line 142, all gas forwarded, no fixed gas), reverts unless signer == owner, then _approve(owner, spender, value). No ERC-1271 or code-size branch. approve (ERC20Upgradeable lines 155-158) sets the allowance of _msgSender() with no signature, so the same act stays open to a holder whose account has real code (it can call through its own code). Pause only gates mint (BaseERC20Upgradeable line 28); transfers, approve and permit are not paused, and paused() is false. Copies: proxy 0x98e6a2b9cec2ff0a1d7833d003c1b4426dc6a47c runs the same code with totalSupply 0; the implementation 0x9db8c107a4c2689ca2a63c88a7a4ebdf86398f59 has empty name and totalSupply 0 (uninitialized). This address is the copy in use.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 path for holders with code: permit has none (ERC20PermitUpgradeable lines 66-69).
- Ruled out: a rated issue: the allowance is set at once and transferFrom does not check the signature again; the recovery forwards all gas, so nothing fails under the change without a holder migrating. No replays in the dossier.
- Ruled out: the state: the token is not paused and has 19.35 million eETN in supply at the block; the other proxy copy has zero supply and the implementation is uninitialized.
- Ruled out: a missing direct path: approve sets the caller's own allowance without a signature (ERC20Upgradeable lines 155-158).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
