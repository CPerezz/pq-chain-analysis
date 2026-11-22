---
id: ordinallands-5b9e0c26-rotate-signer-before-migrating
format: 2
title: 'OrdinalLands: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970'
  name: OrdinalLands
  code: verified
  code_url: https://etherscan.io/address/0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4f7993fdfbef06b594926da672df795eed5ecd26'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setLandLord before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970'
  file: contracts/OrdinalLands.sol
  line: 52
  has: address signer = ecrecover(digest, sig.v, sig.r, sig.s);
  says: verifyTitleDeed recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970'
  file: contracts/OrdinalLands.sol
  line: 53
  has: require(signer != address(0), "zero address");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970'
  file: contracts/OrdinalLands.sol
  line: 46
  has: function setLandLord
  says: setLandLord changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970'
  fn: landlord()(address)
  is: '0x045ab4c1652e97deaf8fc8236c3cbfd7b66449f3'
  says: The signer it keeps in storage is 0x045ab4c1652e97deaf8fc8236c3cbfd7b66449f3 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x045ab4c1652e97deaf8fc8236c3cbfd7b66449f3'
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

OrdinalLands checks an ECDSA signature in verifyTitleDeed and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setLandLord changes the signer.

## Evidence

- [verifyTitleDeed](https://etherscan.io/address/0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setLandLord](https://etherscan.io/address/0x5b9e0c264cf40ea550fc2da4ea5fa6db59bcc970#code) changes the signer; only the owner can call it.
- The signer at the block is [0x045a…49f3](https://etherscan.io/address/0x045ab4c1652e97deaf8fc8236c3cbfd7b66449f3), an account without code.

## Reviewer notes

### Mechanism

verifyTitleDeed (contracts/OrdinalLands.sol, line 50) recovers a signer on line 52 and tests it on line 53 against the signer it keeps in storage (landlord() returns 0x045ab4c1652e97deaf8fc8236c3cbfd7b66449f3). Neither isValidSignature selector is in the code, so that account is never asked. setLandLord (contracts/OrdinalLands.sol, line 46) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-02-27, recovering 0x045a…49f3; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
