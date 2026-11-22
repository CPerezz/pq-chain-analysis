---
id: screenshots-45e71e4c-rotate-signer-before-migrating
format: 2
title: 'screenshots: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x45e71e4c25ac65c0a553e08c78d1e821103e3efa'
  name: screenshots
  code: verified
  code_url: https://etherscan.io/address/0x45e71e4c25ac65c0a553e08c78d1e821103e3efa#code
  copies: 1
  upgradeable: 'no'
  admin: '0xfb843f8c4992efdb6b42349c35f025ca55742d33'
value:
  usd: 36
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x45e71e4c25ac65c0a553e08c78d1e821103e3efa'
  file: src/screenshots.sol
  line: 52
  has: (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x45e71e4c25ac65c0a553e08c78d1e821103e3efa'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x45e71e4c25ac65c0a553e08c78d1e821103e3efa'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x45e71e4c25ac65c0a553e08c78d1e821103e3efa'
  file: src/screenshots.sol
  line: 57
  has: error == ECDSA.RecoverError.NoError && recovered == signer,
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x45e71e4c25ac65c0a553e08c78d1e821103e3efa'
  file: src/screenshots.sol
  line: 69
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x45e71e4c25ac65c0a553e08c78d1e821103e3efa'
  fn: signer()(address)
  is: '0xc93d835e0bfebcf8b14359786cb255aa65528c81'
  says: The signer it keeps in storage is 0xc93d835e0bfebcf8b14359786cb255aa65528c81 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc93d835e0bfebcf8b14359786cb255aa65528c81'
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

screenshots accepts a call to mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0x45e71e4c25ac65c0a553e08c78d1e821103e3efa#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x45e71e4c25ac65c0a553e08c78d1e821103e3efa#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc93d…8c81](https://etherscan.io/address/0xc93d835e0bfebcf8b14359786cb255aa65528c81), an account without code.

## Reviewer notes

### Mechanism

mint (src/screenshots.sol, line 38) recovers a signer on line 52 and tests it on line 57 against the signer it keeps in storage (signer() returns 0xc93d835e0bfebcf8b14359786cb255aa65528c81). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (src/screenshots.sol, line 69) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-10-14, recovering 0xc93d…8c81; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
