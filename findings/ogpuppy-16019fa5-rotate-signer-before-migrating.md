---
id: ogpuppy-16019fa5-rotate-signer-before-migrating
format: 2
title: 'OGPuppy: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10'
  name: OGPuppy
  code: verified
  code_url: https://etherscan.io/address/0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10#code
  copies: 2
  family: 6885a0f96acf93b75138c44d62ec5a55
  upgradeable: 'no'
  admin: '0x4cbdfcbb6c1fd0dbb3afce8720f8905c0a449242'
value:
  usd: 1299
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10'
  file: contracts/OGPuppy.sol
  line: 257
  has: recoverySigner = ecrecover(hash, v, r, s);
  says: _verifyHashSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10'
  file: contracts/OGPuppy.sol
  line: 259
  has: return signer == recoverySigner;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10'
  file: contracts/OGPuppy.sol
  line: 102
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10'
  fn: signer()(address)
  is: '0x0893383e01685bebcb87af96a3d04f4f602ed662'
  says: The signer it keeps in storage is 0x0893383e01685bebcb87af96a3d04f4f602ed662 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x0893383e01685bebcb87af96a3d04f4f602ed662'
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

OGPuppy checks an ECDSA signature in _verifyHashSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_verifyHashSignature](https://etherscan.io/address/0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x16019fa5d56d5c76b52d443e46ef4faa72cbdb10#code) changes the signer; only the owner can call it.
- The signer at the block is [0x0893…d662](https://etherscan.io/address/0x0893383e01685bebcb87af96a3d04f4f602ed662), an account without code.

## Reviewer notes

### Mechanism

_verifyHashSignature (contracts/OGPuppy.sol, line 230) recovers a signer on line 257 and tests it on line 259 against the signer it keeps in storage (signer() returns 0x0893383e01685bebcb87af96a3d04f4f602ed662). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/OGPuppy.sol, line 102) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-11-26, recovering 0x0893…d662; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
