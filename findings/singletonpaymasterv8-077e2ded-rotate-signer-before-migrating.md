---
id: singletonpaymasterv8-077e2ded-rotate-signer-before-migrating
format: 2
title: 'SingletonPaymasterV8: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86'
  name: SingletonPaymasterV8
  code: verified
  code_url: https://etherscan.io/address/0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86#code
  copies: 3
  family: 4872c60c09963b7cc9f09a847d4d1d0e
  upgradeable: 'no'
value:
  usd: 14
  basis: held
activity:
  txs_90d: 65
impact: liveness
action: Before a signer's account moves to real code, use removeSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86'
  file: contracts/singleton/SingletonPaymasterV7.sol
  line: 150
  has: address recoveredSigner = ECDSA.recover(hash, signature);
  says: _validateVerifyingMode recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86'
  file: contracts/singleton/SingletonPaymasterV7.sol
  line: 152
  has: bool isSignatureValid = signers[recoveredSigner];
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86'
  file: contracts/singleton/base/MultiSigner.sol
  line: 43
  has: function removeSigner
  says: removeSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x983f19e72507cf0bac8f4c9f164ec27a7fc70ab8'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x60cd1ef8b18231ef7eca81d8cf4398d5e2c80fd89b472443d2cd4bf8330762a9'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

SingletonPaymasterV8 checks an ECDSA signature in _validateVerifyingMode and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. removeSigner changes who may sign.

## Evidence

- [_validateVerifyingMode](https://etherscan.io/address/0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [removeSigner](https://etherscan.io/address/0x077e2dedb33a40acbffd5a6d29bc88dbe8ca7a86#code) changes who may sign; only a role holder can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x60cd1ef8b18231ef7eca81d8cf4398d5e2c80fd89b472443d2cd4bf8330762a9) on record recovered [0x983f…0ab8](https://etherscan.io/address/0x983f19e72507cf0bac8f4c9f164ec27a7fc70ab8), an account without code.

## Reviewer notes

### Mechanism

_validateVerifyingMode (contracts/singleton/SingletonPaymasterV7.sol, line 142) recovers a signer on line 150 and tests it on line 152 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. removeSigner (contracts/singleton/base/MultiSigner.sol, line 43) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-16, recovering 0x983f…0ab8; 65 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
