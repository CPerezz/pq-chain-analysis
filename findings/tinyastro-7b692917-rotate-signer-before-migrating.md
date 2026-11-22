---
id: tinyastro-7b692917-rotate-signer-before-migrating
format: 2
title: 'TinyAstro: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7b692917124f64e1658d67c72ab5df5219078e37'
  name: TinyAstro
  code: verified
  code_url: https://etherscan.io/address/0x7b692917124f64e1658d67c72ab5df5219078e37#code
  copies: 1
  upgradeable: 'no'
  admin: '0x3dbaa3506b9f51535bbcd30a8b9ed4c075c8b6ef'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 157
impact: liveness
action: Replace the signer with setPubSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7b692917124f64e1658d67c72ab5df5219078e37'
  file: contracts/TinyAstro.sol
  line: 250
  has: address signer = ecrecover(digest, _v, _r, _s);
  says: _isCouponValid recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7b692917124f64e1658d67c72ab5df5219078e37'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7b692917124f64e1658d67c72ab5df5219078e37'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x7b692917124f64e1658d67c72ab5df5219078e37'
  file: contracts/TinyAstro.sol
  line: 251
  has: if (signer == address(0)) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x7b692917124f64e1658d67c72ab5df5219078e37'
  file: contracts/TinyAstro.sol
  line: 216
  has: function setPubSigner
  says: setPubSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x7b692917124f64e1658d67c72ab5df5219078e37'
  fn: pubSigner()(address)
  is: '0xe3d258d0c901c9b9ac2dcc4b34bd6c91304078fd'
  says: The signer it keeps in storage is 0xe3d258d0c901c9b9ac2dcc4b34bd6c91304078fd at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe3d258d0c901c9b9ac2dcc4b34bd6c91304078fd'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
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

TinyAstro checks an ECDSA signature in _isCouponValid and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPubSigner changes the signer.

## Evidence

- [_isCouponValid](https://etherscan.io/address/0x7b692917124f64e1658d67c72ab5df5219078e37#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPubSigner](https://etherscan.io/address/0x7b692917124f64e1658d67c72ab5df5219078e37#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe3d2…78fd](https://etherscan.io/address/0xe3d258d0c901c9b9ac2dcc4b34bd6c91304078fd), an account without code.

## Reviewer notes

### Mechanism

_isCouponValid (contracts/TinyAstro.sol, line 244) recovers a signer on line 250 and tests it on line 251 against the signer it keeps in storage (pubSigner() returns 0xe3d258d0c901c9b9ac2dcc4b34bd6c91304078fd). Neither isValidSignature selector is in the code, so that account is never asked. setPubSigner (contracts/TinyAstro.sol, line 216) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-07-30, recovering 0xe3d2…78fd; 157 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
