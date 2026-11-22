---
id: sweepmultiround-seaportstrategy-3096b32a-rotate-signer-before-migrating
format: 2
title: 'This contract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3096b32a381a6239bfe9325f7c76c5944402e45a'
  name: SweepMultiRound_SeaportStrategy
  code: verified
  code_url: https://etherscan.io/address/0x547a75aba0fa6cd3852a405e4e5ed64d1a7141dc#code
  proxy_of: '0x547a75aba0fa6cd3852a405e4e5ed64d1a7141dc'
  copies: 6
  family: 1e1e352d08565c525baca928c0b353f8
  upgradeable: 'yes'
  admin: '0xfe93d561a66c7f71862219bbd640bddb9f7eb1be'
value:
  usd: 23
  basis: held
activity:
  txs_90d: 156
impact: liveness
action: Replace the signer with setKeeper before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x547a75aba0fa6cd3852a405e4e5ed64d1a7141dc'
  file: src/base/RoundStorage.sol
  line: 304
  has: return ECDSA.recover(hashFundingBatch(batch), signature) == keeper;
  says: _isKeeperSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x547a75aba0fa6cd3852a405e4e5ed64d1a7141dc'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x547a75aba0fa6cd3852a405e4e5ed64d1a7141dc'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x547a75aba0fa6cd3852a405e4e5ed64d1a7141dc'
  file: src/core/AdminControls.sol
  line: 132
  has: function setKeeper
  says: setKeeper changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x3096b32a381a6239bfe9325f7c76c5944402e45a'
  fn: keeper()(address)
  is: '0x94d84a02448856005124c678dd435fe3b87f54c7'
  says: The signer it keeps in storage is 0x94d84a02448856005124c678dd435fe3b87f54c7 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x94d84a02448856005124c678dd435fe3b87f54c7'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
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

This contract checks an ECDSA signature in _isKeeperSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setKeeper changes the signer.

## Evidence

- [_isKeeperSignature](https://etherscan.io/address/0x547a75aba0fa6cd3852a405e4e5ed64d1a7141dc#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setKeeper](https://etherscan.io/address/0x547a75aba0fa6cd3852a405e4e5ed64d1a7141dc#code) changes the signer; only the owner can call it.
- The signer at the block is [0x94d8…54c7](https://etherscan.io/address/0x94d84a02448856005124c678dd435fe3b87f54c7), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_isKeeperSignature (src/base/RoundStorage.sol, line 303) recovers a signer on line 304 and tests it on line 304 against the signer it keeps in storage (keeper() returns 0x94d84a02448856005124c678dd435fe3b87f54c7). Neither isValidSignature selector is in the code, so that account is never asked. setKeeper (src/core/AdminControls.sol, line 132) writes it. The signer's account holds an EIP-7702 delegation to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 6 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 156 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
