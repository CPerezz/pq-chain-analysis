---
id: swapdistributegateway-33ca5366-rotate-signer-before-migrating
format: 2
title: 'SwapDistributeGateway: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x33ca5366bbb08f4602861d84eb65376b41da134f'
  name: SwapDistributeGateway
  code: verified
  code_url: https://etherscan.io/address/0x33ca5366bbb08f4602861d84eb65376b41da134f#code
  copies: 4
  family: 2e98cf6d8f4f9ee135a11b2177e3fcd5
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Before a signer's account moves to real code, use updateSigners so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x33ca5366bbb08f4602861d84eb65376b41da134f'
  file: src/SwapDistributeGateway.sol
  line: 428
  has: address recovered = ECDSA.recover(digest, signatures_[i].v, signatures_[i].r, signatures_[i].s);
  says: _validateSignatures recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x33ca5366bbb08f4602861d84eb65376b41da134f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x33ca5366bbb08f4602861d84eb65376b41da134f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x33ca5366bbb08f4602861d84eb65376b41da134f'
  file: src/SwapDistributeGateway.sol
  line: 228
  has: function updateSigners
  says: updateSigners changes who may sign
  for:
  - action
  - evidence-2
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

SwapDistributeGateway checks an ECDSA signature in _validateSignatures and accepts only an address in the signer set it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigners changes who may sign.

## Evidence

- [_validateSignatures](https://etherscan.io/address/0x33ca5366bbb08f4602861d84eb65376b41da134f#code) recovers the signature with ECDSA and accepts only an address in the signer set it keeps; the code never asks that account.
- [updateSigners](https://etherscan.io/address/0x33ca5366bbb08f4602861d84eb65376b41da134f#code) changes who may sign; only a role holder can call it.

## Reviewer notes

### Mechanism

_validateSignatures (src/SwapDistributeGateway.sol, line 417) recovers a signer on line 428 and tests it on line 428 against an address in the signer set it keeps. Neither isValidSignature selector is in the code, so that account is never asked. updateSigners (src/SwapDistributeGateway.sol, line 228) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
