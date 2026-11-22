---
id: executionoracle-1a865bb2-rotate-signer-before-migrating
format: 2
title: 'ExecutionOracle: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa'
  name: ExecutionOracle
  code: verified
  code_url: https://etherscan.io/address/0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa#code
  copies: 3
  family: 965a6874706d2de0a2af54ca2a248364
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa'
  file: src/ExecutionOracle.sol
  line: 64
  has: (address recovered, ECDSA.RecoverError error,) = ECDSA.tryRecover(digest, v, r, s);
  says: fill recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa'
  file: src/ExecutionOracle.sol
  line: 65
  has: if (error != ECDSA.RecoverError.NoError || recovered != signer) revert BadSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa'
  file: src/SignedOracle.sol
  line: 70
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa'
  fn: signer()(address)
  is: '0x8312c2a4d1184fd9e0e36280d33a2838b0465e76'
  says: The signer it keeps in storage is 0x8312c2a4d1184fd9e0e36280d33a2838b0465e76 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x8312c2a4d1184fd9e0e36280d33a2838b0465e76'
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

ExecutionOracle checks an ECDSA signature in fill and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [fill](https://etherscan.io/address/0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x1a865bb2d87d31c204b4b8a7dddc1c50d55215aa#code) changes the signer.
- The signer at the block is [0x8312…5e76](https://etherscan.io/address/0x8312c2a4d1184fd9e0e36280d33a2838b0465e76), an account without code.

## Reviewer notes

### Mechanism

fill (src/ExecutionOracle.sol, line 39) recovers a signer on line 64 and tests it on line 65 against the signer it keeps in storage (signer() returns 0x8312c2a4d1184fd9e0e36280d33a2838b0465e76). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/SignedOracle.sol, line 70) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
