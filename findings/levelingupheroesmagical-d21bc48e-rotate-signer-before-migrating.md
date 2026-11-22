---
id: levelingupheroesmagical-d21bc48e-rotate-signer-before-migrating
format: 2
title: 'LevelingUpHeroesMagical: its signer is a contract; no signature is accepted'
status: confirmed
severity: INFORMATIONAL
justification: Nothing can break while the signer is a contract; a key set later can be replaced before it moves
  to real code.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428'
  name: LevelingUpHeroesMagical
  code: verified
  code_url: https://etherscan.io/address/0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428#code
  copies: 1
  upgradeable: 'no'
  admin: '0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 19
impact: liveness
action: If a key is set as signer again, replace it with transferOwnership before its account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428'
  file: contracts/BaseFixedPriceAuctionERC721A.sol
  line: 72
  has: return (_recover(hash, signature) == owner());
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
- id: no-1271-legacy
  bytecode: '0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
- id: setter
  selector: '0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428'
  fn: owner()(address)
  is: '0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428'
  says: Its owner is 0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428'
  is: contract
  says: the signer's account is a contract
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

LevelingUpHeroesMagical checks an ECDSA signature in _verify and accepts only its owner. That signer is a contract at the block, which no ECDSA signature can match, so none is accepted now. transferOwnership can set a key again; replace that key before its account takes real code.

## Evidence

- [_verify](https://etherscan.io/address/0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428#code) changes the signer; only the owner can call it.
- The signer at the block is [0xd21b…6428](https://etherscan.io/address/0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428), a contract.

## Reviewer notes

### Mechanism

_verify (contracts/BaseFixedPriceAuctionERC721A.sol, line 71) recovers a signer on line 72 and tests it on line 72 against its owner (owner() returns 0xd21bc48e08b8bca95939a6f7babdca9dd1ac6428). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. The signer is a contract at the block, and a recovery cannot return a contract's address. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-04-07, recovering 0x1e8b…921b; 19 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
