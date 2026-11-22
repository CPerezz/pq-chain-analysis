---
id: viarouter-77777777-rotate-signer-before-migrating
format: 2
title: 'ViaRouter: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x777777773fdd8b28bb03377d10fcea75ad9768da'
  name: ViaRouter
  code: verified
  code_url: https://etherscan.io/address/0xb07fd6608fd3ecc40213225585d62496de3f8dcf#code
  proxy_of: '0xb07fd6608fd3ecc40213225585d62496de3f8dcf'
  copies: 2
  family: b1cfb0230faa598f2a6edf710ec33b33
  upgradeable: 'yes'
  admin: '0xbce880cd2edfa04481b5e9ef4969edc64234b222'
value:
  usd: 103
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setValidator before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb07fd6608fd3ecc40213225585d62496de3f8dcf'
  file: contracts/components/ViaRouterBase.sol
  line: 305
  has: address signer = ECDSAUpgradeable.recover(digest, validatorSig);
  says: _checkValidatorSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb07fd6608fd3ecc40213225585d62496de3f8dcf'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb07fd6608fd3ecc40213225585d62496de3f8dcf'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xb07fd6608fd3ecc40213225585d62496de3f8dcf'
  file: contracts/components/ViaRouterBase.sol
  line: 308
  has: require(signer == validator, Errors.NOT_SIGNED_BY_VALIDATOR);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xb07fd6608fd3ecc40213225585d62496de3f8dcf'
  file: contracts/components/ViaRouterControls.sol
  line: 18
  has: function setValidator
  says: setValidator changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x777777773fdd8b28bb03377d10fcea75ad9768da'
  fn: validator()(address)
  is: '0x30cbecbb3786a179483fd2d55a80e7855e53c9b1'
  says: The signer it keeps in storage is 0x30cbecbb3786a179483fd2d55a80e7855e53c9b1 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x30cbecbb3786a179483fd2d55a80e7855e53c9b1'
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

ViaRouter checks an ECDSA signature in _checkValidatorSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setValidator changes the signer.

## Evidence

- [_checkValidatorSignature](https://etherscan.io/address/0xb07fd6608fd3ecc40213225585d62496de3f8dcf#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setValidator](https://etherscan.io/address/0xb07fd6608fd3ecc40213225585d62496de3f8dcf#code) changes the signer; only the owner can call it.
- The signer at the block is [0x30cb…c9b1](https://etherscan.io/address/0x30cbecbb3786a179483fd2d55a80e7855e53c9b1), an account without code.

## Reviewer notes

### Mechanism

_checkValidatorSignature (contracts/components/ViaRouterBase.sol, line 300) recovers a signer on line 305 and tests it on line 308 against the signer it keeps in storage (validator() returns 0x30cbecbb3786a179483fd2d55a80e7855e53c9b1). Neither isValidSignature selector is in the code, so that account is never asked. setValidator (contracts/components/ViaRouterControls.sol, line 18) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-04-16, recovering 0x30cb…c9b1; 0 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
