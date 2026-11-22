---
id: tcgdragons-77654e7e-rotate-signer-before-migrating
format: 2
title: 'TCGDragons: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x77654e7e579b3c817a3672c1c66c050058b92b85'
  name: TCGDragons
  code: verified
  code_url: https://etherscan.io/address/0x77654e7e579b3c817a3672c1c66c050058b92b85#code
  copies: 1
  upgradeable: 'no'
  admin: '0x7ca91734605b3060edcc9ab8492cb192598961d9'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 441
impact: liveness
action: Replace the signer with setOriginalSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x77654e7e579b3c817a3672c1c66c050058b92b85'
  file: TCGDragons.sol
  line: 1654
  has: address signer = ecrecover(prefixedHashMessage, _v, _r, _s);
  says: claimDragon recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x77654e7e579b3c817a3672c1c66c050058b92b85'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x77654e7e579b3c817a3672c1c66c050058b92b85'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x77654e7e579b3c817a3672c1c66c050058b92b85'
  file: TCGDragons.sol
  line: 1656
  has: if(mintKeys[_mintKey] != true){
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x77654e7e579b3c817a3672c1c66c050058b92b85'
  file: TCGDragons.sol
  line: 1636
  has: function setOriginalSigner
  says: setOriginalSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x77654e7e579b3c817a3672c1c66c050058b92b85'
  fn: original_signer()(address)
  is: '0xca21c5e2a367c89e9ccd2ee7941141e930d7dc0d'
  says: The signer it keeps in storage is 0xca21c5e2a367c89e9ccd2ee7941141e930d7dc0d at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xca21c5e2a367c89e9ccd2ee7941141e930d7dc0d'
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

TCGDragons accepts a call to claimDragon only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOriginalSigner changes the signer.

## Evidence

- [claimDragon](https://etherscan.io/address/0x77654e7e579b3c817a3672c1c66c050058b92b85#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOriginalSigner](https://etherscan.io/address/0x77654e7e579b3c817a3672c1c66c050058b92b85#code) changes the signer; only the owner can call it.
- The signer at the block is [0xca21…dc0d](https://etherscan.io/address/0xca21c5e2a367c89e9ccd2ee7941141e930d7dc0d), an account without code.

## Reviewer notes

### Mechanism

claimDragon (TCGDragons.sol, line 1641) recovers a signer on line 1654 and tests it on line 1656 against the signer it keeps in storage (original_signer() returns 0xca21c5e2a367c89e9ccd2ee7941141e930d7dc0d). Neither isValidSignature selector is in the code, so that account is never asked. setOriginalSigner (TCGDragons.sol, line 1636) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-09-15, recovering 0x839c…213e; 441 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
