---
id: kubztreasure-e1b81cd6-rotate-signer-before-migrating
format: 2
title: 'KubzTreasure: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe1b81cd6a494cbca06a8e2055a62c2cf0fa5a8ac'
  name: KubzTreasure
  code: verified
  code_url: https://etherscan.io/address/0x48bfc104dbd7e24555b0cfe7b46948b0e2001ec1#code
  proxy_of: '0x48bfc104dbd7e24555b0cfe7b46948b0e2001ec1'
  copies: 1
  upgradeable: 'yes'
  admin: '0xf025a72ed25c5d24a0179c93a75ca74a9fa5744c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 430
impact: liveness
action: Replace the signer with setAddresses before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x48bfc104dbd7e24555b0cfe7b46948b0e2001ec1'
  file: contracts/KubzTreasure.sol
  line: 404
  has: ECDSA.recover(
  says: checkValidityAlt recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x48bfc104dbd7e24555b0cfe7b46948b0e2001ec1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x48bfc104dbd7e24555b0cfe7b46948b0e2001ec1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x48bfc104dbd7e24555b0cfe7b46948b0e2001ec1'
  file: contracts/KubzTreasure.sol
  line: 409
  has: ) == signerAlt,
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x48bfc104dbd7e24555b0cfe7b46948b0e2001ec1'
  file: contracts/KubzTreasure.sol
  line: 110
  has: function setAddresses
  says: setAddresses changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xe1b81cd6a494cbca06a8e2055a62c2cf0fa5a8ac'
  fn: signerAlt()(address)
  is: '0xdcba0b3b511b3388c0389c978e859dfe26587bc7'
  says: The signer it keeps in storage is 0xdcba0b3b511b3388c0389c978e859dfe26587bc7 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xdcba0b3b511b3388c0389c978e859dfe26587bc7'
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

KubzTreasure checks an ECDSA signature in checkValidityAlt and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAddresses changes the signer.

## Evidence

- [checkValidityAlt](https://etherscan.io/address/0x48bfc104dbd7e24555b0cfe7b46948b0e2001ec1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAddresses](https://etherscan.io/address/0x48bfc104dbd7e24555b0cfe7b46948b0e2001ec1#code) changes the signer; only the owner can call it.
- The signer at the block is [0xdcba…7bc7](https://etherscan.io/address/0xdcba0b3b511b3388c0389c978e859dfe26587bc7), an account without code.

## Reviewer notes

### Mechanism

checkValidityAlt (contracts/KubzTreasure.sol, line 398) recovers a signer on line 404 and tests it on line 409 against the signer it keeps in storage (signerAlt() returns 0xdcba0b3b511b3388c0389c978e859dfe26587bc7). Neither isValidSignature selector is in the code, so that account is never asked. setAddresses (contracts/KubzTreasure.sol, line 110) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-06-09; 430 transactions called the address in the 90 days before the block. 6 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
