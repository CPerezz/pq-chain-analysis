---
id: monumentals-4edcd949-fixed-signer
format: 2
title: 'Monumentals: its signer cannot be replaced and must not take real code'
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
  address: '0x4edcd9491799bc9b13e688c7ef11356c34d739a6'
  name: Monumentals
  code: verified
  code_url: https://etherscan.io/address/0x4edcd9491799bc9b13e688c7ef11356c34d739a6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x30fabc9c95fd74bcf92726569096747d189dbcea'
value:
  usd: 3
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x4edcd9491799bc9b13e688c7ef11356c34d739a6'
  file: Monumentals.sol
  line: 1899
  has: address signer = ecrecover(digest, voucher.v, voucher.r, voucher.s);
  says: _isSigned recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4edcd9491799bc9b13e688c7ef11356c34d739a6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4edcd9491799bc9b13e688c7ef11356c34d739a6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x4edcd9491799bc9b13e688c7ef11356c34d739a6'
  file: Monumentals.sol
  line: 1900
  has: 'require(signer != address(0), ''ECDSA: invalid signature'');'
  says: the recovered address must be a signer fixed at deployment
  for:
  - evidence-1
  - justification
  - what
- id: written
  source: '0x4edcd9491799bc9b13e688c7ef11356c34d739a6'
  file: Monumentals.sol
  line: 1759
  has: address private immutable adminSigner = 0x64df27b9156fBe53C6Bb5335Ef3A676c28Aa0b86;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x64df27b9156fbe53c6bb5335ef3a676c28aa0b86'
  is: empty
  says: 'the address recovered in the latest signature check on record has no code: an ECDSA key controls it'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

Monumentals checks an ECDSA signature in _isSigned and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [_isSigned](https://etherscan.io/address/0x4edcd9491799bc9b13e688c7ef11356c34d739a6#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x4edcd9491799bc9b13e688c7ef11356c34d739a6#code); the verified source has no function that writes it afterwards.
- The address recovered in its latest signature check on record is [0x64df…0b86](https://etherscan.io/address/0x64df27b9156fbe53c6bb5335ef3a676c28aa0b86), an account without code.

## Reviewer notes

### Mechanism

_isSigned (Monumentals.sol, line 1894) recovers a signer on line 1899 and tests it on line 1900 against a signer fixed at deployment. Neither isValidSignature selector is in the code, so that account is never asked. adminSigner is written on line 1759 of Monumentals.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-07-28, recovering 0x64df…0b86; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
