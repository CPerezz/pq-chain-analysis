---
id: lasercat-08ba8cbb-rotate-signer-before-migrating
format: 2
title: 'LaserCat: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x08ba8cbbefa64aaf9df25e57fe3f15ecc277af74'
  name: LaserCat
  code: verified
  code_url: https://etherscan.io/address/0x08ba8cbbefa64aaf9df25e57fe3f15ecc277af74#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe5f61908c90530f596a56b501df6c42c33436c3f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 68
impact: liveness
action: Replace the signer with setSinger before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x08ba8cbbefa64aaf9df25e57fe3f15ecc277af74'
  file: contracts/LaserCat.sol
  line: 180
  has: .recover(signature) == singer;
  says: _auctionVerify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x08ba8cbbefa64aaf9df25e57fe3f15ecc277af74'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x08ba8cbbefa64aaf9df25e57fe3f15ecc277af74'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x08ba8cbbefa64aaf9df25e57fe3f15ecc277af74'
  file: contracts/LaserCat.sol
  line: 229
  has: function setSinger
  says: setSinger changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xdb4d0270d108eea8fd55b2ab800f71ca4fb896b3'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

LaserCat checks an ECDSA signature in _auctionVerify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSinger changes the signer.

## Evidence

- [_auctionVerify](https://etherscan.io/address/0x08ba8cbbefa64aaf9df25e57fe3f15ecc277af74#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSinger](https://etherscan.io/address/0x08ba8cbbefa64aaf9df25e57fe3f15ecc277af74#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xdb4d…96b3](https://etherscan.io/address/0xdb4d0270d108eea8fd55b2ab800f71ca4fb896b3), an account without code.

## Reviewer notes

### Mechanism

_auctionVerify (contracts/LaserCat.sol, line 172) recovers a signer on line 180 and tests it on line 180 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSinger (contracts/LaserCat.sol, line 229) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-03-10, recovering 0xdb4d…96b3; 68 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
