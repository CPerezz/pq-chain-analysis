---
id: megasale-b9b55c38-rotate-signer-before-migrating
format: 2
title: 'MegaSale: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb9b55c3870c98ed1da1dd598e32a0fa28462e938'
  name: MegaSale
  code: verified
  code_url: https://etherscan.io/address/0xb9b55c3870c98ed1da1dd598e32a0fa28462e938#code
  copies: 3
  family: 24c0b9042f724009221d75c2542559ca
  upgradeable: 'no'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xb9b55c3870c98ed1da1dd598e32a0fa28462e938'
  file: src/MegaSale.sol
  line: 456
  has: address recoveredSigner = PurchasePermitWithAllocationLib.recoverSigner(permit, signature);
  says: _validatePurchasePermit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb9b55c3870c98ed1da1dd598e32a0fa28462e938'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb9b55c3870c98ed1da1dd598e32a0fa28462e938'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xb9b55c3870c98ed1da1dd598e32a0fa28462e938'
  file: src/MegaSale.sol
  line: 457
  has: if (!hasRole(PURCHASE_PERMIT_SIGNER_ROLE, recoveredSigner)) {
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xb9b55c3870c98ed1da1dd598e32a0fa28462e938'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x9a1964e04d10ccfe1a9ce300d943f71c6e3ae24c'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

MegaSale checks an ECDSA signature in _validatePurchasePermit and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_validatePurchasePermit](https://etherscan.io/address/0xb9b55c3870c98ed1da1dd598e32a0fa28462e938#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xb9b55c3870c98ed1da1dd598e32a0fa28462e938#code) changes who may sign.
- The address recovered in its latest signature check on record is [0x9a19…e24c](https://etherscan.io/address/0x9a1964e04d10ccfe1a9ce300d943f71c6e3ae24c), an account without code.

## Reviewer notes

### Mechanism

_validatePurchasePermit (src/MegaSale.sol, line 440) recovers a signer on line 456 and tests it on line 457 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-11-26, recovering 0x9a19…e24c; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
