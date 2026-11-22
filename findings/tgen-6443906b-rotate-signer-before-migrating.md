---
id: tgen-6443906b-rotate-signer-before-migrating
format: 2
title: 'TGen: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6443906bf780753522c4c5c5eafb5f9905cf069d'
  name: TGen
  code: verified
  code_url: https://etherscan.io/address/0x6443906bf780753522c4c5c5eafb5f9905cf069d#code
  copies: 1
  upgradeable: 'no'
  admin: '0x501e859af7f32a94bbef57de3b375a45207a03e0'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 20
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6443906bf780753522c4c5c5eafb5f9905cf069d'
  file: contracts/TGen.sol
  line: 46
  has: address signer = _recoverSigner(msg.sender, _signature);
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6443906bf780753522c4c5c5eafb5f9905cf069d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6443906bf780753522c4c5c5eafb5f9905cf069d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x6443906bf780753522c4c5c5eafb5f9905cf069d'
  file: contracts/TGen.sol
  line: 48
  has: require(signer == owner(), "Not authorized to mint");
  says: the recovered address must be its owner
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x6443906bf780753522c4c5c5eafb5f9905cf069d'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x6443906bf780753522c4c5c5eafb5f9905cf069d'
  fn: owner()(address)
  is: '0x501e859af7f32a94bbef57de3b375a45207a03e0'
  says: Its owner is 0x501e859af7f32a94bbef57de3b375a45207a03e0 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x501e859af7f32a94bbef57de3b375a45207a03e0'
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

TGen accepts a call to mint only with an ECDSA signature of its owner. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0x6443906bf780753522c4c5c5eafb5f9905cf069d#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x6443906bf780753522c4c5c5eafb5f9905cf069d#code) changes the signer.
- The signer at the block is [0x501e…03e0](https://etherscan.io/address/0x501e859af7f32a94bbef57de3b375a45207a03e0), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/TGen.sol, line 45) recovers a signer on line 46 and tests it on line 48 against its owner (owner() returns 0x501e859af7f32a94bbef57de3b375a45207a03e0). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-07-27; 20 transactions called the address in the 90 days before the block. 384 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
