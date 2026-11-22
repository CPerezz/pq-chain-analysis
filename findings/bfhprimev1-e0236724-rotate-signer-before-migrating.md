---
id: bfhprimev1-e0236724-rotate-signer-before-migrating
format: 2
title: 'BFHPrimeV1: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe02367242b348caca4bf39fd1249b212a88adcec'
  name: BFHPrimeV1
  code: verified
  code_url: https://etherscan.io/address/0xe02367242b348caca4bf39fd1249b212a88adcec#code
  copies: 1
  upgradeable: 'no'
  admin: '0x56a5496e1c702c85d3fa599aeee04be96ba7a074'
value:
  usd: 290
  basis: held
activity:
  txs_90d: 10
impact: liveness
action: Replace the signer with setValidater before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe02367242b348caca4bf39fd1249b212a88adcec'
  file: BFHPrimeV1.sol
  line: 286
  has: address signer = recover(ethSignedMessageHash(encodeData(_from, _hash, _blockNum, _priceWei)), _signature);
  says: validateSig recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe02367242b348caca4bf39fd1249b212a88adcec'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe02367242b348caca4bf39fd1249b212a88adcec'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xe02367242b348caca4bf39fd1249b212a88adcec'
  file: BFHPrimeV1.sol
  line: 287
  has: return (signer == validator);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xe02367242b348caca4bf39fd1249b212a88adcec'
  file: BFHPrimeV1.sol
  line: 251
  has: function setValidater
  says: setValidater changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xe02367242b348caca4bf39fd1249b212a88adcec'
  fn: validator()(address)
  is: '0xa3833d8bf7f7b7166c07f3309f70459477a1a746'
  says: The signer it keeps in storage is 0xa3833d8bf7f7b7166c07f3309f70459477a1a746 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xa3833d8bf7f7b7166c07f3309f70459477a1a746'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xf982ca3f6547efd69ff8d0a4e48a7f4e5ab7bcd204c6af57997fc2db4e56d8bf'
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

BFHPrimeV1 checks an ECDSA signature in validateSig and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setValidater changes the signer.

## Evidence

- [validateSig](https://etherscan.io/address/0xe02367242b348caca4bf39fd1249b212a88adcec#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setValidater](https://etherscan.io/address/0xe02367242b348caca4bf39fd1249b212a88adcec#code) changes the signer.
- The signer at the block is [0xa383…a746](https://etherscan.io/address/0xa3833d8bf7f7b7166c07f3309f70459477a1a746), an account without code.

## Reviewer notes

### Mechanism

validateSig (BFHPrimeV1.sol, line 284) recovers a signer on line 286 and tests it on line 287 against the signer it keeps in storage (validator() returns 0xa3833d8bf7f7b7166c07f3309f70459477a1a746). Neither isValidSignature selector is in the code, so that account is never asked. setValidater (BFHPrimeV1.sol, line 251) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-15, recovering 0xa383…a746; 10 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
