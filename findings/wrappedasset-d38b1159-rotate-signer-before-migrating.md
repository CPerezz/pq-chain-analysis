---
id: wrappedasset-d38b1159-rotate-signer-before-migrating
format: 2
title: 'WrappedAsset: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd38b1159c8aee064af2d869afa1c2c1632da8b97'
  name: WrappedAsset
  code: verified
  code_url: https://etherscan.io/address/0xd38b1159c8aee064af2d869afa1c2c1632da8b97#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Before a signer's account moves to real code, use setManager so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xd38b1159c8aee064af2d869afa1c2c1632da8b97'
  file: vendorregistry.sol
  line: 89
  has: 'require(addressIsAManager(recoverSigner(message, signature)), "VendorRegistry: Registration failed, invalid
    si'
  says: registerAsVendor recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd38b1159c8aee064af2d869afa1c2c1632da8b97'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd38b1159c8aee064af2d869afa1c2c1632da8b97'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd38b1159c8aee064af2d869afa1c2c1632da8b97'
  file: managable.sol
  line: 35
  has: function setManager
  says: setManager changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xf14662361eea4ce03caf5517d1d4eb613cf349de'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

WrappedAsset accepts a call to registerAsVendor only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setManager changes who may sign.

## Evidence

- [registerAsVendor](https://etherscan.io/address/0xd38b1159c8aee064af2d869afa1c2c1632da8b97#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setManager](https://etherscan.io/address/0xd38b1159c8aee064af2d869afa1c2c1632da8b97#code) changes who may sign.
- The address recovered in its latest signature check on record is [0xf146…49de](https://etherscan.io/address/0xf14662361eea4ce03caf5517d1d4eb613cf349de), an account without code.

## Reviewer notes

### Mechanism

registerAsVendor (vendorregistry.sol, line 84) recovers a signer on line 89 and tests it on line 89 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setManager (managable.sol, line 35) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-01-20, recovering 0xf146…49de; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
