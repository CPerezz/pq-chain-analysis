---
id: priceattestorv2-131e13da-rotate-signer-before-migrating
format: 2
title: 'PriceAttestorV2: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x131e13da34549d30c5bb8f1cf30d097f3c52406b'
  name: PriceAttestorV2
  code: verified
  code_url: https://etherscan.io/address/0x131e13da34549d30c5bb8f1cf30d097f3c52406b#code
  copies: 2
  family: 6e18c8575aa422ff1b8b5ff3b957bd56
  upgradeable: 'no'
  admin: '0x93620a4a7d45a770ff2e801eb84b03a7630ae8b6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 177
impact: liveness
action: Replace the signer with acceptSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x131e13da34549d30c5bb8f1cf30d097f3c52406b'
  file: src/v2/PriceAttestorV2.sol
  line: 358
  has: if (_recover(snap, signature) != signer) revert BadSignature();
  says: _evaluate recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x131e13da34549d30c5bb8f1cf30d097f3c52406b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x131e13da34549d30c5bb8f1cf30d097f3c52406b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x131e13da34549d30c5bb8f1cf30d097f3c52406b'
  file: src/v2/PriceAttestorV2.sol
  line: 693
  has: function acceptSigner
  says: acceptSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x131e13da34549d30c5bb8f1cf30d097f3c52406b'
  fn: signer()(address)
  is: '0x5d0f42b1380a45200105fed1614f6532947cb4e7'
  says: The signer it keeps in storage is 0x5d0f42b1380a45200105fed1614f6532947cb4e7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x5d0f42b1380a45200105fed1614f6532947cb4e7'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xbc9c7ceebdad0f634540081efb481394e3c58e6290bb1f3dc2ac9757464b0701'
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

PriceAttestorV2 checks an ECDSA signature in _evaluate and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. acceptSigner changes the signer.

## Evidence

- [_evaluate](https://etherscan.io/address/0x131e13da34549d30c5bb8f1cf30d097f3c52406b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [acceptSigner](https://etherscan.io/address/0x131e13da34549d30c5bb8f1cf30d097f3c52406b#code) changes the signer.
- The signer at the block is [0x5d0f…b4e7](https://etherscan.io/address/0x5d0f42b1380a45200105fed1614f6532947cb4e7), an account without code.

## Reviewer notes

### Mechanism

_evaluate (src/v2/PriceAttestorV2.sol, line 349) recovers a signer on line 358 and tests it on line 358 against the signer it keeps in storage (signer() returns 0x5d0f42b1380a45200105fed1614f6532947cb4e7). Neither isValidSignature selector is in the code, so that account is never asked. acceptSigner (src/v2/PriceAttestorV2.sol, line 693) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-02, recovering 0x5d0f…b4e7; 177 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
