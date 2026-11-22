---
id: greymarket-b8b1bc88-rotate-signer-before-migrating
format: 2
title: 'GreyMarket: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea'
  name: GreyMarket
  code: verified
  code_url: https://etherscan.io/address/0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea#code
  copies: 2
  family: c1e47e40ddca96aa21dc1aab883b5785
  upgradeable: 'no'
  admin: '0x19b824a0eccad83baf1e576e5b2b548d1d420eee'
value:
  usd: 2363
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with _setProofSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea'
  file: src/GreyMarket.sol
  line: 422
  has: return ecrecover(digest, sig.v, sig.r, sig.s) == proofSigner;
  says: validateCreateOrder recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea'
  file: src/GreyMarket.sol
  line: 257
  has: function _setProofSigner
  says: _setProofSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea'
  fn: proofSigner()(address)
  is: '0xcbf10877f9d7cab750a5bd5c72ed9906d10a47e5'
  says: The signer it keeps in storage is 0xcbf10877f9d7cab750a5bd5c72ed9906d10a47e5 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xcbf10877f9d7cab750a5bd5c72ed9906d10a47e5'
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

GreyMarket checks an ECDSA signature in validateCreateOrder and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. _setProofSigner changes the signer.

## Evidence

- [validateCreateOrder](https://etherscan.io/address/0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [_setProofSigner](https://etherscan.io/address/0xb8b1bc880cb6b2ab75418225f4fa4edc749f49ea#code) changes the signer; only the owner can call it.
- The signer at the block is [0xcbf1…47e5](https://etherscan.io/address/0xcbf10877f9d7cab750a5bd5c72ed9906d10a47e5), an account without code.

## Reviewer notes

### Mechanism

validateCreateOrder (src/GreyMarket.sol, line 395) recovers a signer on line 422 and tests it on line 422 against the signer it keeps in storage (proofSigner() returns 0xcbf10877f9d7cab750a5bd5c72ed9906d10a47e5). Neither isValidSignature selector is in the code, so that account is never asked. _setProofSigner (src/GreyMarket.sol, line 257) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-01-14, recovering 0xcbf1…47e5; 0 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
