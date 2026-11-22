---
id: tokenfy-a6dd9803-fixed-signer
format: 2
title: 'Tokenfy: its signer cannot be replaced and must not take real code'
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
  address: '0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7'
  name: Tokenfy
  code: verified
  code_url: https://etherscan.io/address/0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7#code
  copies: 1
  upgradeable: 'no'
  admin: '0x269fb5d729ba03710c522b0b4644ca2414f72f79'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 188
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7'
  file: Tokenfy.sol
  line: 113
  has: return ecrecover(digest, v, r, s) == signerAddress;
  says: signerValid recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7'
  file: Tokenfy.sol
  line: 73
  has: signerAddress = _signerAddress;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7'
  fn: signerAddress()(address)
  is: '0xb6614ef9e2797043273d22c898b63bc524e68389'
  says: A signer fixed at deployment is 0xb6614ef9e2797043273d22c898b63bc524e68389 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xb6614ef9e2797043273d22c898b63bc524e68389'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

Tokenfy checks an ECDSA signature in signerValid and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [signerValid](https://etherscan.io/address/0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0xa6dd98031551c23bb4a2fbe2c4d524e8f737c6f7#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xb661…8389](https://etherscan.io/address/0xb6614ef9e2797043273d22c898b63bc524e68389), an account without code.

## Reviewer notes

### Mechanism

signerValid (Tokenfy.sol, line 104) recovers a signer on line 113 and tests it on line 113 against a signer fixed at deployment (signerAddress() returns 0xb6614ef9e2797043273d22c898b63bc524e68389). Neither isValidSignature selector is in the code, so that account is never asked. signerAddress is written on line 73 of Tokenfy.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-03-16, recovering 0xb661…8389; 188 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
