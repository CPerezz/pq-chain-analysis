---
id: digitalanimals-25593a50-rotate-signer-before-migrating
format: 2
title: 'DigitalAnimals: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x25593a50255bfb30ea027f6966417b0bf780401d'
  name: DigitalAnimals
  code: verified
  code_url: https://etherscan.io/address/0x25593a50255bfb30ea027f6966417b0bf780401d#code
  copies: 1
  upgradeable: 'no'
  admin: '0xeaa7ae766b0b0689eccfb5d4dfd6f54030027ef9'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 232
impact: liveness
action: Replace the signer with transferSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x25593a50255bfb30ea027f6966417b0bf780401d'
  file: contracts/DigitalAnimals.sol
  line: 228
  has: return signer == ECDSA.recover(hash, signature);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x25593a50255bfb30ea027f6966417b0bf780401d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x25593a50255bfb30ea027f6966417b0bf780401d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x25593a50255bfb30ea027f6966417b0bf780401d'
  file: contracts/Signable.sol
  line: 18
  has: function transferSigner
  says: transferSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x25593a50255bfb30ea027f6966417b0bf780401d'
  fn: signer()(address)
  is: '0x8c585d293bb1bf26ab6fa599eb038d4e873e807b'
  says: The signer it keeps in storage is 0x8c585d293bb1bf26ab6fa599eb038d4e873e807b at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x8c585d293bb1bf26ab6fa599eb038d4e873e807b'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
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

DigitalAnimals checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferSigner changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0x25593a50255bfb30ea027f6966417b0bf780401d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [transferSigner](https://etherscan.io/address/0x25593a50255bfb30ea027f6966417b0bf780401d#code) changes the signer; only the owner can call it.
- The signer at the block is [0x8c58…807b](https://etherscan.io/address/0x8c585d293bb1bf26ab6fa599eb038d4e873e807b), an account without code.

## Reviewer notes

### Mechanism

_verify (contracts/DigitalAnimals.sol, line 227) recovers a signer on line 228 and tests it on line 228 against the signer it keeps in storage (signer() returns 0x8c585d293bb1bf26ab6fa599eb038d4e873e807b). Neither isValidSignature selector is in the code, so that account is never asked. transferSigner (contracts/Signable.sol, line 18) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-02-07, recovering 0x8c58…807b; 232 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
