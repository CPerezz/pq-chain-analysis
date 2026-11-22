---
id: flatteningattestation-7915fa1b-rotate-signer-before-migrating
format: 2
title: 'FlatteningAttestation: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f'
  name: FlatteningAttestation
  code: verified
  code_url: https://etherscan.io/address/0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f#code
  copies: 1
  upgradeable: 'no'
  admin: '0xa2e8f8d26a6c1240b328fc6f4f2d9bc3921d1f55'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 111
impact: liveness
action: Replace the signer with setAttestationSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f'
  file: contracts/src/FlatteningAttestation.sol
  line: 107
  has: address signer = ECDSA.recover(hashAttestation(attestation), signature);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f'
  file: contracts/src/FlatteningAttestation.sol
  line: 108
  has: if (signer != attestationSigner) revert InvalidAttestationSigner(signer);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f'
  file: contracts/src/FlatteningAttestation.sol
  line: 59
  has: function setAttestationSigner
  says: setAttestationSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f'
  fn: attestationSigner()(address)
  is: '0x8b5ef9c6334d04590cb6131c46548b34ee26c928'
  says: The signer it keeps in storage is 0x8b5ef9c6334d04590cb6131c46548b34ee26c928 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x8b5ef9c6334d04590cb6131c46548b34ee26c928'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x89b6aa8cda3b05099f8af9f26ad1526d2320f0a410d19f1ef2bad6f7d4cc7c14'
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

FlatteningAttestation checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAttestationSigner changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAttestationSigner](https://etherscan.io/address/0x7915fa1b376de495e0d0b254da11a6cb27cc4b8f#code) changes the signer; only the owner can call it.
- The signer at the block is [0x8b5e…c928](https://etherscan.io/address/0x8b5ef9c6334d04590cb6131c46548b34ee26c928), an account without code.

## Reviewer notes

### Mechanism

_verify (contracts/src/FlatteningAttestation.sol, line 91) recovers a signer on line 107 and tests it on line 108 against the signer it keeps in storage (attestationSigner() returns 0x8b5ef9c6334d04590cb6131c46548b34ee26c928). Neither isValidSignature selector is in the code, so that account is never asked. setAttestationSigner (contracts/src/FlatteningAttestation.sol, line 59) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-16, recovering 0x8b5e…c928; 111 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
