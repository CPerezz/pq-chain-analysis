---
id: swaphtlc-67f5d96f-rotate-signer-before-migrating
format: 2
title: 'SwapHTLC: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x67f5d96f7bc92d391d34a5e9d77283994826949d'
  name: SwapHTLC
  code: verified
  code_url: https://etherscan.io/address/0x67f5d96f7bc92d391d34a5e9d77283994826949d#code
  copies: 2
  family: 43b9a2384f01f69bf573fe83e54d0544
  upgradeable: 'no'
  admin: '0xb9d9bda2a8604ee6b9331f3195977f7f26355298'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 17
impact: liveness
action: Replace the signer with setCommissionSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x67f5d96f7bc92d391d34a5e9d77283994826949d'
  file: project/contracts/SwapHTLC.sol
  line: 243
  has: address signer = ECDSA.recover(digest, signature);
  says: _requireSignedPlan recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x67f5d96f7bc92d391d34a5e9d77283994826949d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x67f5d96f7bc92d391d34a5e9d77283994826949d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x67f5d96f7bc92d391d34a5e9d77283994826949d'
  file: project/contracts/SwapHTLC.sol
  line: 244
  has: if (signer != commissionSigner) revert BadCommissionSignature(signer);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x67f5d96f7bc92d391d34a5e9d77283994826949d'
  file: project/contracts/SwapHTLC.sol
  line: 248
  has: function setCommissionSigner
  says: setCommissionSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x67f5d96f7bc92d391d34a5e9d77283994826949d'
  fn: commissionSigner()(address)
  is: '0xb9d9bda2a8604ee6b9331f3195977f7f26355298'
  says: The signer it keeps in storage is 0xb9d9bda2a8604ee6b9331f3195977f7f26355298 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xb9d9bda2a8604ee6b9331f3195977f7f26355298'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x9a13bf7c0154cf8e60783d6d006fdb8c51ff6521cfaec2cbb9947b010a68ca5c'
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

SwapHTLC checks an ECDSA signature in _requireSignedPlan and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setCommissionSigner changes the signer.

## Evidence

- [_requireSignedPlan](https://etherscan.io/address/0x67f5d96f7bc92d391d34a5e9d77283994826949d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setCommissionSigner](https://etherscan.io/address/0x67f5d96f7bc92d391d34a5e9d77283994826949d#code) changes the signer; only the owner can call it.
- The signer at the block is [0xb9d9…5298](https://etherscan.io/address/0xb9d9bda2a8604ee6b9331f3195977f7f26355298), an account without code.

## Reviewer notes

### Mechanism

_requireSignedPlan (project/contracts/SwapHTLC.sol, line 220) recovers a signer on line 243 and tests it on line 244 against the signer it keeps in storage (commissionSigner() returns 0xb9d9bda2a8604ee6b9331f3195977f7f26355298). Neither isValidSignature selector is in the code, so that account is never asked. setCommissionSigner (project/contracts/SwapHTLC.sol, line 248) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-29, recovering 0xb9d9…5298; 17 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
