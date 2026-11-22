---
id: verifyingpaymaster-2bd45d29-rotate-signer-before-migrating
format: 2
title: 'VerifyingPaymaster: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2bd45d293f1e3b790f2923fb36782170b559d84c'
  name: VerifyingPaymaster
  code: verified
  code_url: https://etherscan.io/address/0xa91dc6684e12cea529a7dadc002c153abd064714#code
  proxy_of: '0xa91dc6684e12cea529a7dadc002c153abd064714'
  copies: 3
  family: 694a18490b049ed7f926b640ab13364a
  upgradeable: 'yes'
  admin: '0x4f0cf2a1d11de183e989ff6287cc0973670f0583'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with updateVerifyingSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa91dc6684e12cea529a7dadc002c153abd064714'
  file: src/VerifyingPaymaster.sol
  line: 205
  has: if (verifyingSigner != hash.toEthSignedMessageHash().recover(paymasterAndData[52:])) {
  says: _validatePaymasterUserOp recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa91dc6684e12cea529a7dadc002c153abd064714'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa91dc6684e12cea529a7dadc002c153abd064714'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xa91dc6684e12cea529a7dadc002c153abd064714'
  file: src/VerifyingPaymaster.sol
  line: 121
  has: function updateVerifyingSigner
  says: updateVerifyingSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2bd45d293f1e3b790f2923fb36782170b559d84c'
  fn: verifyingSigner()(address)
  is: '0x39672a635902b0bcef20a20a986064f2fcb1c3ee'
  says: The signer it keeps in storage is 0x39672a635902b0bcef20a20a986064f2fcb1c3ee at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x39672a635902b0bcef20a20a986064f2fcb1c3ee'
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

VerifyingPaymaster checks an ECDSA signature in _validatePaymasterUserOp and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateVerifyingSigner changes the signer.

## Evidence

- [_validatePaymasterUserOp](https://etherscan.io/address/0xa91dc6684e12cea529a7dadc002c153abd064714#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateVerifyingSigner](https://etherscan.io/address/0xa91dc6684e12cea529a7dadc002c153abd064714#code) changes the signer (through _updateVerifyingSigner); only the owner can call it.
- The signer at the block is [0x3967…c3ee](https://etherscan.io/address/0x39672a635902b0bcef20a20a986064f2fcb1c3ee), an account without code.

## Reviewer notes

### Mechanism

_validatePaymasterUserOp (src/VerifyingPaymaster.sol, line 181) recovers a signer on line 205 and tests it on line 205 against the signer it keeps in storage (verifyingSigner() returns 0x39672a635902b0bcef20a20a986064f2fcb1c3ee). Neither isValidSignature selector is in the code, so that account is never asked. _updateVerifyingSigner (src/VerifyingPaymaster.sol, line 158) writes it, called by updateVerifyingSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-19, recovering 0x3967…c3ee; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
