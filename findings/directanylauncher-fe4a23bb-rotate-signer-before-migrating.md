---
id: directanylauncher-fe4a23bb-rotate-signer-before-migrating
format: 2
title: 'DirectAnyLauncher: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfe4a23bbe27be16955f4d8599c73bac88ef647d1'
  name: DirectAnyLauncher
  code: verified
  code_url: https://etherscan.io/address/0xfe4a23bbe27be16955f4d8599c73bac88ef647d1#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 323
  basis: held
activity:
  txs_90d: 34450
impact: liveness
action: Replace the signer with setPriceSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xfe4a23bbe27be16955f4d8599c73bac88ef647d1'
  file: src/direct/DirectAnyLauncher.sol
  line: 452
  has: ECDSA.tryRecover(quoteDigest(pair, q.priceUsdE8, q.deadline), q.signature);
  says: _verifyQuote recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfe4a23bbe27be16955f4d8599c73bac88ef647d1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfe4a23bbe27be16955f4d8599c73bac88ef647d1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xfe4a23bbe27be16955f4d8599c73bac88ef647d1'
  file: src/direct/DirectAnyLauncher.sol
  line: 453
  has: if (!(err == ECDSA.RecoverError.NoError && signer == priceSigner)) revert CheckBadPriceSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xfe4a23bbe27be16955f4d8599c73bac88ef647d1'
  file: src/direct/DirectAnyLauncher.sol
  line: 357
  has: function setPriceSigner
  says: setPriceSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xfe4a23bbe27be16955f4d8599c73bac88ef647d1'
  fn: priceSigner()(address)
  is: '0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf'
  says: The signer it keeps in storage is 0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x810a8eded87f9c3fe16edfbbeb9bed8e93fe016a2b7f3a92954223b48fadf282'
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

DirectAnyLauncher checks an ECDSA signature in _verifyQuote and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPriceSigner changes the signer.

## Evidence

- [_verifyQuote](https://etherscan.io/address/0xfe4a23bbe27be16955f4d8599c73bac88ef647d1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPriceSigner](https://etherscan.io/address/0xfe4a23bbe27be16955f4d8599c73bac88ef647d1#code) changes the signer.
- The signer at the block is [0xfcd9…2eaf](https://etherscan.io/address/0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf), an account without code.

## Reviewer notes

### Mechanism

_verifyQuote (src/direct/DirectAnyLauncher.sol, line 447) recovers a signer on line 452 and tests it on line 453 against the signer it keeps in storage (priceSigner() returns 0xfcd96cda50585dbc5f1753c1a4a1dc59a6d52eaf). Neither isValidSignature selector is in the code, so that account is never asked. setPriceSigner (src/direct/DirectAnyLauncher.sol, line 357) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-16, recovering 0xfcd9…2eaf; 34,450 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
