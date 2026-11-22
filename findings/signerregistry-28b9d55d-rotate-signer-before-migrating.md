---
id: signerregistry-28b9d55d-rotate-signer-before-migrating
format: 2
title: 'SignerRegistry: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x28b9d55dbb17949af60ee8f517c58513df71012d'
  name: SignerRegistry
  code: verified
  code_url: https://etherscan.io/address/0x28b9d55dbb17949af60ee8f517c58513df71012d#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6b1161781b898539f58c1f8900e2fe090c32e2da'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 8
impact: liveness
action: Before a signer's account moves to real code, use setAdmin so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x28b9d55dbb17949af60ee8f517c58513df71012d'
  file: contracts/signerRegistry/SignerRegistry.sol
  line: 289
  has: address recovered = ECDSA.recover(digest, adminSigs[i]);
  says: _checkAdmins recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x28b9d55dbb17949af60ee8f517c58513df71012d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x28b9d55dbb17949af60ee8f517c58513df71012d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x28b9d55dbb17949af60ee8f517c58513df71012d'
  file: contracts/signerRegistry/SignerRegistry.sol
  line: 234
  has: function setAdmin
  says: setAdmin changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x9920c45570dc76acb48b215308b7d3791e3518ce'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x76a9bea4a29b18390b87c8991a005964c5b456f096a9192322b48c8dc411da1f'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

SignerRegistry checks an ECDSA signature in _checkAdmins and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAdmin changes who may sign.

## Evidence

- [_checkAdmins](https://etherscan.io/address/0x28b9d55dbb17949af60ee8f517c58513df71012d#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setAdmin](https://etherscan.io/address/0x28b9d55dbb17949af60ee8f517c58513df71012d#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x76a9bea4a29b18390b87c8991a005964c5b456f096a9192322b48c8dc411da1f) on record recovered [0x9920…18ce](https://etherscan.io/address/0x9920c45570dc76acb48b215308b7d3791e3518ce), an account without code.

## Reviewer notes

### Mechanism

_checkAdmins (contracts/signerRegistry/SignerRegistry.sol, line 283) recovers a signer on line 289 and tests it on line 289 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setAdmin (contracts/signerRegistry/SignerRegistry.sol, line 234) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-20, recovering 0x9920…18ce; 8 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
