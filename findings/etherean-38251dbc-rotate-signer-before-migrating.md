---
id: etherean-38251dbc-rotate-signer-before-migrating
format: 2
title: 'Etherean: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x38251dbc366d8069d9310dc79917fee6a5403002'
  name: Etherean
  code: verified
  code_url: https://etherscan.io/address/0x38251dbc366d8069d9310dc79917fee6a5403002#code
  copies: 1
  upgradeable: 'no'
  admin: '0x387a161c6b25aa854100abaed39274e51aaffffd'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 21
impact: liveness
action: Replace the signer with acceptVerifier before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x38251dbc366d8069d9310dc79917fee6a5403002'
  file: src/Etherean.sol
  line: 250
  has: address recovered = ECDSA.recover(digest, signature);
  says: _verifyMintSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x38251dbc366d8069d9310dc79917fee6a5403002'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x38251dbc366d8069d9310dc79917fee6a5403002'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x38251dbc366d8069d9310dc79917fee6a5403002'
  file: src/Etherean.sol
  line: 251
  has: if (recovered != verifier) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x38251dbc366d8069d9310dc79917fee6a5403002'
  file: src/Etherean.sol
  line: 220
  has: function acceptVerifier
  says: acceptVerifier changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x38251dbc366d8069d9310dc79917fee6a5403002'
  fn: verifier()(address)
  is: '0x99bd6d19019b1d1df04d2c53cf5ba107c99ccd0a'
  says: The signer it keeps in storage is 0x99bd6d19019b1d1df04d2c53cf5ba107c99ccd0a at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x99bd6d19019b1d1df04d2c53cf5ba107c99ccd0a'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

Etherean checks an ECDSA signature in _verifyMintSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. acceptVerifier changes the signer.

## Evidence

- [_verifyMintSignature](https://etherscan.io/address/0x38251dbc366d8069d9310dc79917fee6a5403002#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [acceptVerifier](https://etherscan.io/address/0x38251dbc366d8069d9310dc79917fee6a5403002#code) changes the signer.
- The signer at the block is [0x99bd…cd0a](https://etherscan.io/address/0x99bd6d19019b1d1df04d2c53cf5ba107c99ccd0a), an account without code.

## Reviewer notes

### Mechanism

_verifyMintSignature (src/Etherean.sol, line 228) recovers a signer on line 250 and tests it on line 251 against the signer it keeps in storage (verifier() returns 0x99bd6d19019b1d1df04d2c53cf5ba107c99ccd0a). Neither isValidSignature selector is in the code, so that account is never asked. acceptVerifier (src/Etherean.sol, line 220) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-19, recovering 0x99bd…cd0a; 21 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
