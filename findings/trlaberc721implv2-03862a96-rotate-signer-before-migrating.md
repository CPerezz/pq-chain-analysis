---
id: trlaberc721implv2-03862a96-rotate-signer-before-migrating
format: 2
title: 'TRLabERC721ImplV2: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x03862a96d2717a72f29ef6bbe79be66dafd3c638'
  name: TRLabERC721ImplV2
  code: verified
  code_url: https://etherscan.io/address/0x9894d3beb082e2ed97c31495de52b5088255fca9#code
  proxy_of: '0x9894d3beb082e2ed97c31495de52b5088255fca9'
  copies: 5
  family: 9ebba5d5f0e0df14d069ffa2ed532631
  upgradeable: 'yes'
  admin: '0xaffed4f375d686e8d38ffda8009c5d8c126f00a6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x9894d3beb082e2ed97c31495de52b5088255fca9'
  file: src/TRLabERC721ImplV2.sol
  line: 146
  has: address recoveredAddress = digest.recover(sig);
  says: transferByPermit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9894d3beb082e2ed97c31495de52b5088255fca9'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9894d3beb082e2ed97c31495de52b5088255fca9'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x9894d3beb082e2ed97c31495de52b5088255fca9'
  file: src/TRLabERC721ImplV2.sol
  line: 148
  has: if (recoveredAddress == address(0) || recoveredAddress != owner) {
  says: the recovered address must be its owner
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x9894d3beb082e2ed97c31495de52b5088255fca9'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x03862a96d2717a72f29ef6bbe79be66dafd3c638'
  fn: owner()(address)
  is: '0xaffed4f375d686e8d38ffda8009c5d8c126f00a6'
  says: Its owner is 0xaffed4f375d686e8d38ffda8009c5d8c126f00a6 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xaffed4f375d686e8d38ffda8009c5d8c126f00a6'
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

TRLabERC721ImplV2 accepts a call to transferByPermit only with an ECDSA signature of its owner. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [transferByPermit](https://etherscan.io/address/0x9894d3beb082e2ed97c31495de52b5088255fca9#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x9894d3beb082e2ed97c31495de52b5088255fca9#code) changes the signer.
- The signer at the block is [0xaffe…00a6](https://etherscan.io/address/0xaffed4f375d686e8d38ffda8009c5d8c126f00a6), an account without code.

## Reviewer notes

### Mechanism

transferByPermit (src/TRLabERC721ImplV2.sol, line 138) recovers a signer on line 146 and tests it on line 148 against its owner (owner() returns 0xaffed4f375d686e8d38ffda8009c5d8c126f00a6). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
