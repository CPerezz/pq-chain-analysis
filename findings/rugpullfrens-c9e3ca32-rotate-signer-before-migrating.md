---
id: rugpullfrens-c9e3ca32-rotate-signer-before-migrating
format: 2
title: 'RugPullFrens: its signer is a contract, so no signature is accepted now'
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
  address: '0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad'
  name: RugPullFrens
  code: verified
  code_url: https://etherscan.io/address/0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad#code
  copies: 1
  upgradeable: 'no'
  admin: '0xe7604c000011444793e7021b41448f0753972719'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 26
impact: liveness
action: If a key is set as signer again, replace it with transferOwnership before its account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad'
  file: contracts/RugPullFrens.sol
  line: 159
  has: address recoveredAddr = ECDSA.recover(_hashTypedDataV4(keccak256(abi.encode(
  says: isPresaleEligible recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
- id: no-1271-legacy
  bytecode: '0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
- id: match
  source: '0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad'
  file: contracts/RugPullFrens.sol
  line: 166
  has: return owner() == recoveredAddr;
  says: the recovered address must be its owner
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad'
  fn: owner()(address)
  is: '0xe7604c000011444793e7021b41448f0753972719'
  says: Its owner is 0xe7604c000011444793e7021b41448f0753972719 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xe7604c000011444793e7021b41448f0753972719'
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

RugPullFrens checks an ECDSA signature in isPresaleEligible and accepts only its owner. That signer is a contract at the block, which no ECDSA signature can match, so none is accepted now. transferOwnership can set a key again; replace that key before its account takes real code.

## Evidence

- [isPresaleEligible](https://etherscan.io/address/0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0xc9e3ca32caaa6ee67476c5d35d4b8ec64f58d4ad#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe760…2719](https://etherscan.io/address/0xe7604c000011444793e7021b41448f0753972719), a contract.

## Reviewer notes

### Mechanism

isPresaleEligible (contracts/RugPullFrens.sol, line 158) recovers a signer on line 159 and tests it on line 166 against its owner (owner() returns 0xe7604c000011444793e7021b41448f0753972719). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. The signer is a contract at the block, and a recovery cannot return a contract's address. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-02-11, recovering 0x5bba…7dbc; 26 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
