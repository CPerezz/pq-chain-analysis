---
id: vesting-93e3d3a7-rotate-signer-before-migrating
format: 2
title: 'Vesting: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x93e3d3a752f31cb46813a0265281ad07f2e2e183'
  name: Vesting
  code: verified
  code_url: https://etherscan.io/address/0x93e3d3a752f31cb46813a0265281ad07f2e2e183#code
  copies: 2
  family: 0fb2c5e33c43b96d6c7c6dbb4276318f
  upgradeable: 'no'
  admin: '0x55d1f38c4d2810affbf23ae62473138ea1a5aa8f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 39
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x93e3d3a752f31cb46813a0265281ad07f2e2e183'
  file: contracts/modules/Vesting.sol
  line: 410
  has: if (signer != hash.recover(signature)) {
  says: _validateSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x93e3d3a752f31cb46813a0265281ad07f2e2e183'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x93e3d3a752f31cb46813a0265281ad07f2e2e183'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x93e3d3a752f31cb46813a0265281ad07f2e2e183'
  file: contracts/modules/Vesting.sol
  line: 358
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x93e3d3a752f31cb46813a0265281ad07f2e2e183'
  fn: signer()(address)
  is: '0x0b42d09a411efe43f3b1960278e86f39c2c51936'
  says: The signer it keeps in storage is 0x0b42d09a411efe43f3b1960278e86f39c2c51936 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x0b42d09a411efe43f3b1960278e86f39c2c51936'
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

Vesting checks an ECDSA signature in _validateSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [_validateSignature](https://etherscan.io/address/0x93e3d3a752f31cb46813a0265281ad07f2e2e183#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x93e3d3a752f31cb46813a0265281ad07f2e2e183#code) changes the signer (through _updateSigner); only the owner can call it.
- The signer at the block is [0x0b42…1936](https://etherscan.io/address/0x0b42d09a411efe43f3b1960278e86f39c2c51936), an account without code.

## Reviewer notes

### Mechanism

_validateSignature (contracts/modules/Vesting.sol, line 396) recovers a signer on line 410 and tests it on line 410 against the signer it keeps in storage (signer() returns 0x0b42d09a411efe43f3b1960278e86f39c2c51936). Neither isValidSignature selector is in the code, so that account is never asked. _updateSigner (contracts/modules/Vesting.sol, line 455) writes it, called by updateSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-18, recovering 0x0b42…1936; 39 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
