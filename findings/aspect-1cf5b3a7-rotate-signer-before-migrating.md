---
id: aspect-1cf5b3a7-rotate-signer-before-migrating
format: 2
title: 'Aspect: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f'
  name: Aspect
  code: verified
  code_url: https://etherscan.io/address/0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f#code
  copies: 2
  family: e837f4f9356a1d2e99616ae1d53b6954
  upgradeable: 'no'
  admin: '0xad5502bdca0fbd6280b7903a727de9fad78985f7'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 12
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f'
  file: contracts/Aspect.sol
  line: 143
  has: address authority = recoverSigner(message, _signature);
  says: mintWhitelist recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f'
  file: contracts/Aspect.sol
  line: 144
  has: require(authority == owner(), UNAUTHORIZED);
  says: the recovered address must be its owner
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f'
  fn: owner()(address)
  is: '0xad5502bdca0fbd6280b7903a727de9fad78985f7'
  says: Its owner is 0xad5502bdca0fbd6280b7903a727de9fad78985f7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xad5502bdca0fbd6280b7903a727de9fad78985f7'
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

Aspect accepts a call to mintWhitelist only with an ECDSA signature of its owner. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [mintWhitelist](https://etherscan.io/address/0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x1cf5b3a7dfc58cd00beecad18d04b03ad9e13b4f#code) changes the signer.
- The signer at the block is [0xad55…85f7](https://etherscan.io/address/0xad5502bdca0fbd6280b7903a727de9fad78985f7), an account without code.

## Reviewer notes

### Mechanism

mintWhitelist (contracts/Aspect.sol, line 130) recovers a signer on line 143 and tests it on line 144 against its owner (owner() returns 0xad5502bdca0fbd6280b7903a727de9fad78985f7). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-07-11, recovering 0xad55…85f7; 12 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
