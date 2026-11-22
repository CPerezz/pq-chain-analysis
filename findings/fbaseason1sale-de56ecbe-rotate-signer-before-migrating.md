---
id: fbaseason1sale-de56ecbe-rotate-signer-before-migrating
format: 2
title: 'FbaSeason1Sale: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xde56ecbe1de76d39ec77bb35882c70978b9e8f66'
  name: FbaSeason1Sale
  code: verified
  code_url: https://etherscan.io/address/0xde56ecbe1de76d39ec77bb35882c70978b9e8f66#code
  copies: 1
  upgradeable: 'no'
  admin: '0xcb7777b136467973c6ec5897e32567ece119a60d'
value:
  usd: 1533
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setTrustedSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xde56ecbe1de76d39ec77bb35882c70978b9e8f66'
  file: contracts/FbaSeason1Sale.sol
  line: 320
  has: address signer = _getOrderSigner(order, signature);
  says: _checkOrderParameters recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xde56ecbe1de76d39ec77bb35882c70978b9e8f66'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xde56ecbe1de76d39ec77bb35882c70978b9e8f66'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xde56ecbe1de76d39ec77bb35882c70978b9e8f66'
  file: contracts/FbaSeason1Sale.sol
  line: 321
  has: if (signer != s_trustedSigner) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xde56ecbe1de76d39ec77bb35882c70978b9e8f66'
  file: contracts/FbaSeason1Sale.sol
  line: 147
  has: function setTrustedSigner
  says: setTrustedSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xde56ecbe1de76d39ec77bb35882c70978b9e8f66'
  fn: getTrustedSigner()(address)
  is: '0xc8da3819b9d8fce35d3c35059f2189de239eff9c'
  says: The signer it keeps in storage is 0xc8da3819b9d8fce35d3c35059f2189de239eff9c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc8da3819b9d8fce35d3c35059f2189de239eff9c'
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

FbaSeason1Sale checks an ECDSA signature in _checkOrderParameters and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setTrustedSigner changes the signer.

## Evidence

- [_checkOrderParameters](https://etherscan.io/address/0xde56ecbe1de76d39ec77bb35882c70978b9e8f66#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setTrustedSigner](https://etherscan.io/address/0xde56ecbe1de76d39ec77bb35882c70978b9e8f66#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc8da…ff9c](https://etherscan.io/address/0xc8da3819b9d8fce35d3c35059f2189de239eff9c), an account without code.

## Reviewer notes

### Mechanism

_checkOrderParameters (contracts/FbaSeason1Sale.sol, line 319) recovers a signer on line 320 and tests it on line 321 against the signer it keeps in storage (getTrustedSigner() returns 0xc8da3819b9d8fce35d3c35059f2189de239eff9c). Neither isValidSignature selector is in the code, so that account is never asked. setTrustedSigner (contracts/FbaSeason1Sale.sol, line 147) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-08-20, recovering 0xc8da…ff9c; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
