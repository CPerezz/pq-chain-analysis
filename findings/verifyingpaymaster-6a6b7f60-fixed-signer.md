---
id: verifyingpaymaster-6a6b7f60-fixed-signer
format: 2
title: 'VerifyingPaymaster: its signer cannot be replaced and must not take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a signer's account takes real code; the signer is fixed, so a new contract is then
  needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739'
  name: VerifyingPaymaster
  code: verified
  code_url: https://etherscan.io/address/0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739#code
  copies: 9
  family: 16c5cbb60cfd99923c2c0d9d94630478
  upgradeable: 'no'
  admin: '0xff29474634b6d37bb1caf9b14f4f06575ce2e570'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 16
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739'
  file: contracts/samples/VerifyingPaymaster.sol
  line: 84
  has: if (verifyingSigner != ECDSA.recover(hash, signature)) {
  says: _validatePaymasterUserOp recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739'
  file: contracts/samples/VerifyingPaymaster.sol
  line: 32
  has: verifyingSigner = _verifyingSigner;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739'
  fn: verifyingSigner()(address)
  is: '0xff29474634b6d37bb1caf9b14f4f06575ce2e570'
  says: A signer fixed at deployment is 0xff29474634b6d37bb1caf9b14f4f06575ce2e570 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xff29474634b6d37bb1caf9b14f4f06575ce2e570'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x9f2a6eabb17a890fe8ea8f7e0145142e7b0afe42622d2f6e39672f416094b7c1'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

VerifyingPaymaster checks an ECDSA signature in _validatePaymasterUserOp and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [_validatePaymasterUserOp](https://etherscan.io/address/0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x6a6b7f6012ee5bef1cdf95df25e5045c7727c739#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xff29…e570](https://etherscan.io/address/0xff29474634b6d37bb1caf9b14f4f06575ce2e570), an account without code.

## Reviewer notes

### Mechanism

_validatePaymasterUserOp (contracts/samples/VerifyingPaymaster.sol, line 73) recovers a signer on line 84 and tests it on line 84 against a signer fixed at deployment (verifyingSigner() returns 0xff29474634b6d37bb1caf9b14f4f06575ce2e570). Neither isValidSignature selector is in the code, so that account is never asked. verifyingSigner is written on line 32 of contracts/samples/VerifyingPaymaster.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 9 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-10, recovering 0xff29…e570; 16 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
