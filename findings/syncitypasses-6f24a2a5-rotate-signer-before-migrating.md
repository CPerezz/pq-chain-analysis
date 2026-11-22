---
id: syncitypasses-6f24a2a5-rotate-signer-before-migrating
format: 2
title: 'SynCityPasses: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6f24a2a5ecfffb0610f69929e9aa7fcef441897a'
  name: SynCityPasses
  code: verified
  code_url: https://etherscan.io/address/0x6f24a2a5ecfffb0610f69929e9aa7fcef441897a#code
  copies: 1
  upgradeable: 'no'
  admin: '0x41bdd852d3618dc5d6338279f373bf7935dc0242'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 10
impact: liveness
action: Replace the signer with setValidator before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6f24a2a5ecfffb0610f69929e9aa7fcef441897a'
  file: contracts/SynCityPasses.sol
  line: 138
  has: return validator != address(0) && validator == _hash.recover(_signature);
  says: _isSignedByValidator recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6f24a2a5ecfffb0610f69929e9aa7fcef441897a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6f24a2a5ecfffb0610f69929e9aa7fcef441897a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x6f24a2a5ecfffb0610f69929e9aa7fcef441897a'
  file: contracts/SynCityPasses.sol
  line: 66
  has: function setValidator
  says: setValidator changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x6f24a2a5ecfffb0610f69929e9aa7fcef441897a'
  fn: validator()(address)
  is: '0xc626be886d4b7d09898152c61959a9a898a78d6f'
  says: The signer it keeps in storage is 0xc626be886d4b7d09898152c61959a9a898a78d6f at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc626be886d4b7d09898152c61959a9a898a78d6f'
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

SynCityPasses checks an ECDSA signature in _isSignedByValidator and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setValidator changes the signer.

## Evidence

- [_isSignedByValidator](https://etherscan.io/address/0x6f24a2a5ecfffb0610f69929e9aa7fcef441897a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setValidator](https://etherscan.io/address/0x6f24a2a5ecfffb0610f69929e9aa7fcef441897a#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc626…8d6f](https://etherscan.io/address/0xc626be886d4b7d09898152c61959a9a898a78d6f), an account without code.

## Reviewer notes

### Mechanism

_isSignedByValidator (contracts/SynCityPasses.sol, line 137) recovers a signer on line 138 and tests it on line 138 against the signer it keeps in storage (validator() returns 0xc626be886d4b7d09898152c61959a9a898a78d6f). Neither isValidSignature selector is in the code, so that account is never asked. setValidator (contracts/SynCityPasses.sol, line 66) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-05-22, recovering 0xc626…8d6f; 10 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
