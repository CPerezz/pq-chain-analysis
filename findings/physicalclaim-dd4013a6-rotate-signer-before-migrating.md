---
id: physicalclaim-dd4013a6-rotate-signer-before-migrating
format: 2
title: 'PhysicalClaim: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdd4013a64ca6b99cf4c976f76d85c1946134496e'
  name: PhysicalClaim
  code: verified
  code_url: https://etherscan.io/address/0xdd4013a64ca6b99cf4c976f76d85c1946134496e#code
  copies: 1
  upgradeable: 'no'
  admin: '0x7ef0d682280193fb1fb8dc6174f8a0c5bc4f02b0'
value:
  usd: 120
  basis: held
activity:
  txs_90d: 34
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xdd4013a64ca6b99cf4c976f76d85c1946134496e'
  file: contracts/physicalclaim/PhysicalClaim.sol
  line: 107
  has: address signer = submission.message.recover(submission.signature);
  says: _validateSubmission recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdd4013a64ca6b99cf4c976f76d85c1946134496e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdd4013a64ca6b99cf4c976f76d85c1946134496e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xdd4013a64ca6b99cf4c976f76d85c1946134496e'
  file: contracts/physicalclaim/PhysicalClaim.sol
  line: 108
  has: if (submission.message != expectedMessage || signer != _signingAddress) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xdd4013a64ca6b99cf4c976f76d85c1946134496e'
  file: contracts/physicalclaim/PhysicalClaim.sol
  line: 61
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x572ef7f0425002a458ccc10c402cd51456e072e3'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x536a1e767efb601dfda7cbed67cd64c61b61eb1564dc05613306bd7054f8dd1d'
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

PhysicalClaim checks an ECDSA signature in _validateSubmission and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [_validateSubmission](https://etherscan.io/address/0xdd4013a64ca6b99cf4c976f76d85c1946134496e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0xdd4013a64ca6b99cf4c976f76d85c1946134496e#code) changes the signer.
- Its latest signed [transaction](https://etherscan.io/tx/0x536a1e767efb601dfda7cbed67cd64c61b61eb1564dc05613306bd7054f8dd1d) on record recovered [0x572e…72e3](https://etherscan.io/address/0x572ef7f0425002a458ccc10c402cd51456e072e3), an account without code.

## Reviewer notes

### Mechanism

_validateSubmission (contracts/physicalclaim/PhysicalClaim.sol, line 103) recovers a signer on line 107 and tests it on line 108 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (contracts/physicalclaim/PhysicalClaim.sol, line 61) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-12, recovering 0x572e…72e3; 34 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
