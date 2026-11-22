---
id: cakeslices-c316e173-rotate-signer-before-migrating
format: 2
title: 'CakeSlices: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc316e173eed7a8b49b0a39904432da6dd022c359'
  name: CakeSlices
  code: verified
  code_url: https://etherscan.io/address/0xc316e173eed7a8b49b0a39904432da6dd022c359#code
  copies: 1
  upgradeable: 'no'
  admin: '0x57e9b574fdaab5352b0c5634fcede53d9b498d77'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc316e173eed7a8b49b0a39904432da6dd022c359'
  file: CakeSlices.sol
  line: 1655
  has: require(recover(hash,signature) == signer, "Invalid Signature");
  says: mintSlice recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc316e173eed7a8b49b0a39904432da6dd022c359'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc316e173eed7a8b49b0a39904432da6dd022c359'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc316e173eed7a8b49b0a39904432da6dd022c359'
  file: CakeSlices.sol
  line: 1555
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc316e173eed7a8b49b0a39904432da6dd022c359'
  fn: signer()(address)
  is: '0x5fb0cb478cda3e95467045f7a256094094fa19e1'
  says: The signer it keeps in storage is 0x5fb0cb478cda3e95467045f7a256094094fa19e1 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x5fb0cb478cda3e95467045f7a256094094fa19e1'
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

CakeSlices accepts a call to mintSlice only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [mintSlice](https://etherscan.io/address/0xc316e173eed7a8b49b0a39904432da6dd022c359#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xc316e173eed7a8b49b0a39904432da6dd022c359#code) changes the signer; only the owner can call it.
- The signer at the block is [0x5fb0…19e1](https://etherscan.io/address/0x5fb0cb478cda3e95467045f7a256094094fa19e1), an account without code.

## Reviewer notes

### Mechanism

mintSlice (CakeSlices.sol, line 1630) recovers a signer on line 1655 and tests it on line 1655 against the signer it keeps in storage (signer() returns 0x5fb0cb478cda3e95467045f7a256094094fa19e1). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (CakeSlices.sol, line 1555) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-09-06, recovering 0x5fb0…19e1; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
