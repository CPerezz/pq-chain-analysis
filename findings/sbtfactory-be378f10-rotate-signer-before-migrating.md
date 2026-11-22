---
id: sbtfactory-be378f10-rotate-signer-before-migrating
format: 2
title: 'SBTFactory: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbe378f10275345d4a4aaf7919dbc7e110bd107f6'
  name: SBTFactory
  code: verified
  code_url: https://etherscan.io/address/0xbe378f10275345d4a4aaf7919dbc7e110bd107f6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x9d103e79b330f06f2c522f7a8ae47dc2cd39133c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Before a signer's account moves to real code, use addGlobalSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xbe378f10275345d4a4aaf7919dbc7e110bd107f6'
  file: src/SBTFactory.sol
  line: 398
  has: address recoveredSigner = ECDSA.recover(ethSignedMessageHash, signature);
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbe378f10275345d4a4aaf7919dbc7e110bd107f6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbe378f10275345d4a4aaf7919dbc7e110bd107f6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xbe378f10275345d4a4aaf7919dbc7e110bd107f6'
  file: src/SBTFactory.sol
  line: 401
  has: if (globalAuthorizedSigners[recoveredSigner]) {
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xbe378f10275345d4a4aaf7919dbc7e110bd107f6'
  file: src/SBTFactory.sol
  line: 284
  has: function addGlobalSigner
  says: addGlobalSigner changes who may sign
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
related: []
---

## What happens

SBTFactory checks an ECDSA signature in _verifySignature and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addGlobalSigner changes who may sign.

## Evidence

- [_verifySignature](https://etherscan.io/address/0xbe378f10275345d4a4aaf7919dbc7e110bd107f6#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addGlobalSigner](https://etherscan.io/address/0xbe378f10275345d4a4aaf7919dbc7e110bd107f6#code) changes who may sign; only the owner can call it.

## Reviewer notes

### Mechanism

_verifySignature (src/SBTFactory.sol, line 390) recovers a signer on line 398 and tests it on line 401 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addGlobalSigner (src/SBTFactory.sol, line 284) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
