---
id: roboheronft-dbd0c453-rotate-signer-before-migrating
format: 2
title: 'RoboheroNFT: its signer is a contract, so no signature is accepted now'
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
  address: '0xdbd0c4537156cd3921282a4a6446d8ac363b9f80'
  name: RoboheroNFT
  code: verified
  code_url: https://etherscan.io/address/0xebb2903c9068db4ea3eb703649901333d924134c#code
  proxy_of: '0xebb2903c9068db4ea3eb703649901333d924134c'
  copies: 2
  family: 51feda25dd5a26e28ece06da8572428c
  upgradeable: 'yes'
  admin: '0xd4282499e20af2e709c182a56d9e105de3c1b2a8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: If a key is set as signer again, replace it with transferOwnership before its account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0xebb2903c9068db4ea3eb703649901333d924134c'
  file: contracts/RoboheroNFT.sol
  line: 43
  has: address signer = ECDSAUpgradeable.recover(digest, v, r, s);
  says: claimToken recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xebb2903c9068db4ea3eb703649901333d924134c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
- id: no-1271-legacy
  bytecode: '0xebb2903c9068db4ea3eb703649901333d924134c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
- id: match
  source: '0xebb2903c9068db4ea3eb703649901333d924134c'
  file: contracts/RoboheroNFT.sol
  line: 44
  has: require(signer == owner(), "Invalid signature");
  says: the recovered address must be its owner
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xebb2903c9068db4ea3eb703649901333d924134c'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xdbd0c4537156cd3921282a4a6446d8ac363b9f80'
  fn: owner()(address)
  is: '0x645d18c6fca6389a45799a4a09bb7bf4be535393'
  says: Its owner is 0x645d18c6fca6389a45799a4a09bb7bf4be535393 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x645d18c6fca6389a45799a4a09bb7bf4be535393'
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

RoboheroNFT accepts a call to claimToken only with an ECDSA signature of its owner. That signer is a contract at the block, which no ECDSA signature can match, so none is accepted now. transferOwnership can set a key again; replace that key before its account takes real code.

## Evidence

- [claimToken](https://etherscan.io/address/0xebb2903c9068db4ea3eb703649901333d924134c#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0xebb2903c9068db4ea3eb703649901333d924134c#code) changes the signer; only the owner can call it.
- The signer at the block is [0x645d…5393](https://etherscan.io/address/0x645d18c6fca6389a45799a4a09bb7bf4be535393), a contract.

## Reviewer notes

### Mechanism

claimToken (contracts/RoboheroNFT.sol, line 33) recovers a signer on line 43 and tests it on line 44 against its owner (owner() returns 0x645d18c6fca6389a45799a4a09bb7bf4be535393). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. The signer is a contract at the block, and a recovery cannot return a contract's address. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-01-04, recovering 0x3573…400e; 3 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
