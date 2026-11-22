---
id: launchfactory-4c402aa9-rotate-signer-before-migrating
format: 2
title: 'LaunchFactory: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4c402aa92f166be2d3d9ba1b2879bd2b5616a26d'
  name: LaunchFactory
  code: verified
  code_url: https://etherscan.io/address/0x4c402aa92f166be2d3d9ba1b2879bd2b5616a26d#code
  copies: 1
  upgradeable: 'no'
  admin: '0xec4529d816f2a1f4604b241755d01a15c2ce9a17'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 324
impact: liveness
action: Replace the signer with setPriceSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x4c402aa92f166be2d3d9ba1b2879bd2b5616a26d'
  file: src/LaunchFactory.sol
  line: 275
  has: if (ECDSA.recover(digest, p.priceSignature) != priceSigner) revert BadPriceSignature();
  says: _verifyPrice recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4c402aa92f166be2d3d9ba1b2879bd2b5616a26d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4c402aa92f166be2d3d9ba1b2879bd2b5616a26d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x4c402aa92f166be2d3d9ba1b2879bd2b5616a26d'
  file: src/LaunchFactory.sol
  line: 157
  has: function setPriceSigner
  says: setPriceSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x4c402aa92f166be2d3d9ba1b2879bd2b5616a26d'
  fn: priceSigner()(address)
  is: '0x9296698ab7dcde04d0e4b05d0d87cb21b6bc5ca2'
  says: The signer it keeps in storage is 0x9296698ab7dcde04d0e4b05d0d87cb21b6bc5ca2 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x9296698ab7dcde04d0e4b05d0d87cb21b6bc5ca2'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x2426667ab3ee029f759ca3e7cd7cac9a1dc465e067eaa811f990b9d14d351e74'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

LaunchFactory checks an ECDSA signature in _verifyPrice and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPriceSigner changes the signer.

## Evidence

- [_verifyPrice](https://etherscan.io/address/0x4c402aa92f166be2d3d9ba1b2879bd2b5616a26d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPriceSigner](https://etherscan.io/address/0x4c402aa92f166be2d3d9ba1b2879bd2b5616a26d#code) changes the signer; only the owner can call it.
- The signer at the block is [0x9296…5ca2](https://etherscan.io/address/0x9296698ab7dcde04d0e4b05d0d87cb21b6bc5ca2), an account without code.

## Reviewer notes

### Mechanism

_verifyPrice (src/LaunchFactory.sol, line 270) recovers a signer on line 275 and tests it on line 275 against the signer it keeps in storage (priceSigner() returns 0x9296698ab7dcde04d0e4b05d0d87cb21b6bc5ca2). Neither isValidSignature selector is in the code, so that account is never asked. setPriceSigner (src/LaunchFactory.sol, line 157) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-05, recovering 0x9296…5ca2; 324 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
