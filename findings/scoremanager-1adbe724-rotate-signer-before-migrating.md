---
id: scoremanager-1adbe724-rotate-signer-before-migrating
format: 2
title: 'ScoreManager: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1adbe7243e1f9df97c1248fcf54cc0aa54c727cb'
  name: ScoreManager
  code: verified
  code_url: https://etherscan.io/address/0x1adbe7243e1f9df97c1248fcf54cc0aa54c727cb#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x1adbe7243e1f9df97c1248fcf54cc0aa54c727cb'
  file: contracts/ScoreManager.sol
  line: 190
  has: address signer = _getSigner(data, signature);
  says: _validateSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1adbe7243e1f9df97c1248fcf54cc0aa54c727cb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1adbe7243e1f9df97c1248fcf54cc0aa54c727cb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x1adbe7243e1f9df97c1248fcf54cc0aa54c727cb'
  file: contracts/ScoreManager.sol
  line: 191
  has: if (!hasRole(SIGNER_ROLE, signer)) {
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x1adbe7243e1f9df97c1248fcf54cc0aa54c727cb'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xe1d6f78840f2ad73da3ebc8f76220da1b8830fda'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x9dc1cc0500ca02fa7b764ba0ffb549669017d2a2136c686d279391506f93a393'
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

ScoreManager checks an ECDSA signature in _validateSignature and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_validateSignature](https://etherscan.io/address/0x1adbe7243e1f9df97c1248fcf54cc0aa54c727cb#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x1adbe7243e1f9df97c1248fcf54cc0aa54c727cb#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x9dc1cc0500ca02fa7b764ba0ffb549669017d2a2136c686d279391506f93a393) on record recovered [0xe1d6…0fda](https://etherscan.io/address/0xe1d6f78840f2ad73da3ebc8f76220da1b8830fda), an account without code.

## Reviewer notes

### Mechanism

_validateSignature (contracts/ScoreManager.sol, line 186) recovers a signer on line 190 and tests it on line 191 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-07, recovering 0xe1d6…0fda; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
