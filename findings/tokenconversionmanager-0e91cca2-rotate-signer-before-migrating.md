---
id: tokenconversionmanager-0e91cca2-rotate-signer-before-migrating
format: 2
title: 'TokenConversionManager: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637'
  name: TokenConversionManager
  code: verified
  code_url: https://etherscan.io/address/0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637#code
  copies: 3
  family: e08317e18fdf01277091d2f23266b8f4
  upgradeable: 'no'
  admin: '0x3a02430d1740fff57c7cd10a51e97acc0c77b34c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with updateAuthorizer before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637'
  file: contracts/TokenConversionManager.sol
  line: 95
  has: address signAddress = ecrecover(message, v, r, s);
  says: conversionOut recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637'
  file: contracts/TokenConversionManager.sol
  line: 96
  has: require(signAddress == conversionAuthorizer, "Invalid request or signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637'
  file: contracts/TokenConversionManager.sol
  line: 53
  has: function updateAuthorizer
  says: updateAuthorizer changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637'
  fn: conversionAuthorizer()(address)
  is: '0xe3d21a2bd6890aaafc0ce34cbc52f9e1e7e724af'
  says: The signer it keeps in storage is 0xe3d21a2bd6890aaafc0ce34cbc52f9e1e7e724af at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe3d21a2bd6890aaafc0ce34cbc52f9e1e7e724af'
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

TokenConversionManager accepts a call to conversionOut only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateAuthorizer changes the signer.

## Evidence

- [conversionOut](https://etherscan.io/address/0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateAuthorizer](https://etherscan.io/address/0x0e91cca219fcf72100f8c59c5bcbe7f0dc9f7637#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe3d2…24af](https://etherscan.io/address/0xe3d21a2bd6890aaafc0ce34cbc52f9e1e7e724af), an account without code.

## Reviewer notes

### Mechanism

conversionOut (contracts/TokenConversionManager.sol, line 84) recovers a signer on line 95 and tests it on line 96 against the signer it keeps in storage (conversionAuthorizer() returns 0xe3d21a2bd6890aaafc0ce34cbc52f9e1e7e724af). Neither isValidSignature selector is in the code, so that account is never asked. updateAuthorizer (contracts/TokenConversionManager.sol, line 53) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
