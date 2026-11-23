---
id: burrows-e51aac67-signer-moves-to-code
format: 2
title: 'Burrows: its signer stops counting once that account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe51aac67b09eaed6d3d43e794d6bae679cbe09d8'
  name: Burrows
  code: verified
  code_url: https://etherscan.io/address/0xe51aac67b09eaed6d3d43e794d6bae679cbe09d8#code
  copies: 1
  upgradeable: 'no'
  admin: '0xf6cd7a935e3c339a68b7ccec1897284830af8ac7'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 240
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe51aac67b09eaed6d3d43e794d6bae679cbe09d8'
  file: contracts/Burrows.sol
  line: 110
  has: return (_recover(hash, token) == _signer);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe51aac67b09eaed6d3d43e794d6bae679cbe09d8'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe51aac67b09eaed6d3d43e794d6bae679cbe09d8'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xe51aac67b09eaed6d3d43e794d6bae679cbe09d8'
  file: contracts/Burrows.sol
  line: 93
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
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
related: [burrows-e51aac67-rotate-signer-before-migrating]
---

## What happens

Burrows takes a signature only from the one signer it stores, recovered with ECDSA in _verify. Once that signer's account holds real code, its signatures no longer recover; a delegated account still does. The owner can name a new signer with updateSigner.

## Evidence

- [_verify](https://etherscan.io/address/0xe51aac67b09eaed6d3d43e794d6bae679cbe09d8#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0xe51aac67b09eaed6d3d43e794d6bae679cbe09d8#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

_verify (contracts/Burrows.sol, line 105) recovers a signer on line 110 and compares it with the stored signer. Neither isValidSignature selector is in the code. updateSigner (contracts/Burrows.sol, line 93) writes the signer. Under EIP-8151 the recovery returns no address for an account with real code.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code.

### History

- 2026-11-23: filed to test the verifier.
