---
id: duckwarrantredeemer-4c0b10d3-rotate-signer-before-migrating
format: 2
title: 'DuckWarrantRedeemer: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4c0b10d3bf4282609f36ae5620491f240d1af898'
  name: DuckWarrantRedeemer
  code: verified
  code_url: https://etherscan.io/address/0x4c0b10d3bf4282609f36ae5620491f240d1af898#code
  copies: 1
  upgradeable: 'no'
  admin: '0x1fa0e5aa2ff1904176dbac116d3d882c8dbf1b25'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 233
impact: liveness
action: Replace the signer with setRandomnessSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x4c0b10d3bf4282609f36ae5620491f240d1af898'
  file: project/contracts/DuckWarrantRedeemer.sol
  line: 328
  has: address recoveredSigner = ECDSA.recover(
  says: _verifyClaimSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4c0b10d3bf4282609f36ae5620491f240d1af898'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4c0b10d3bf4282609f36ae5620491f240d1af898'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x4c0b10d3bf4282609f36ae5620491f240d1af898'
  file: project/contracts/DuckWarrantRedeemer.sol
  line: 332
  has: if (recoveredSigner != randomnessSigner) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x4c0b10d3bf4282609f36ae5620491f240d1af898'
  file: project/contracts/DuckWarrantRedeemer.sol
  line: 174
  has: function setRandomnessSigner
  says: setRandomnessSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x4c0b10d3bf4282609f36ae5620491f240d1af898'
  fn: randomnessSigner()(address)
  is: '0x3851f33ba66b77790f53e8c9c724f662ac04187b'
  says: The signer it keeps in storage is 0x3851f33ba66b77790f53e8c9c724f662ac04187b at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x3851f33ba66b77790f53e8c9c724f662ac04187b'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x591892390c96df4fc15198e6600bacc135e5c3c0b5078271e4d6aee62549cc92'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

DuckWarrantRedeemer checks an ECDSA signature in _verifyClaimSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setRandomnessSigner changes the signer.

## Evidence

- [_verifyClaimSignature](https://etherscan.io/address/0x4c0b10d3bf4282609f36ae5620491f240d1af898#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setRandomnessSigner](https://etherscan.io/address/0x4c0b10d3bf4282609f36ae5620491f240d1af898#code) changes the signer (through _setRandomnessSigner); only the owner can call it.
- The signer at the block is [0x3851…187b](https://etherscan.io/address/0x3851f33ba66b77790f53e8c9c724f662ac04187b), an account without code.

## Reviewer notes

### Mechanism

_verifyClaimSignature (project/contracts/DuckWarrantRedeemer.sol, line 309) recovers a signer on line 328 and tests it on line 332 against the signer it keeps in storage (randomnessSigner() returns 0x3851f33ba66b77790f53e8c9c724f662ac04187b). Neither isValidSignature selector is in the code, so that account is never asked. _setRandomnessSigner (project/contracts/DuckWarrantRedeemer.sol, line 337) writes it, called by setRandomnessSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x3851…187b; 233 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
