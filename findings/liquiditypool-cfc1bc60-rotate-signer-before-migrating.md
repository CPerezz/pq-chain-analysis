---
id: liquiditypool-cfc1bc60-rotate-signer-before-migrating
format: 2
title: 'LiquidityPool: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcfc1bc6013ed89d484c626dd9ee5eb7bc1a1d9da'
  name: LiquidityPool
  code: verified
  code_url: https://etherscan.io/address/0x9b7d662271af6ad17109cd40f9aec9bbdc211685#code
  proxy_of: '0x9b7d662271af6ad17109cd40f9aec9bbdc211685'
  copies: 2
  family: adb08b465cdeff594e3ffd81de34c9f2
  upgradeable: 'yes'
value:
  usd: 318207
  basis: held
activity:
  txs_90d: 849
impact: liveness
action: Replace the signer with setMaintainer before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x9b7d662271af6ad17109cd40f9aec9bbdc211685'
  file: contracts/LiquidityPool.sol
  line: 655
  has: address signer = ECDSA.recover(_hashTypedDataV4(structHash), maintainerSig);
  says: _validateSwapLocal recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9b7d662271af6ad17109cd40f9aec9bbdc211685'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9b7d662271af6ad17109cd40f9aec9bbdc211685'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x9b7d662271af6ad17109cd40f9aec9bbdc211685'
  file: contracts/LiquidityPool.sol
  line: 656
  has: if (signer != maintainer) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x9b7d662271af6ad17109cd40f9aec9bbdc211685'
  file: contracts/LiquidityPool.sol
  line: 175
  has: function setMaintainer
  says: setMaintainer changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xcfc1bc6013ed89d484c626dd9ee5eb7bc1a1d9da'
  fn: maintainer()(address)
  is: '0x6228ab40e809d3077667630b622a4a44a2dd8919'
  says: The signer it keeps in storage is 0x6228ab40e809d3077667630b622a4a44a2dd8919 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x6228ab40e809d3077667630b622a4a44a2dd8919'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x98dfd0def3cc25c0e790a5f8572d2d1cc0a0e6420a32aed5d97cf1d319e7b3e7'
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

LiquidityPool checks an ECDSA signature in _validateSwapLocal and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMaintainer changes the signer.

## Evidence

- [_validateSwapLocal](https://etherscan.io/address/0x9b7d662271af6ad17109cd40f9aec9bbdc211685#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMaintainer](https://etherscan.io/address/0x9b7d662271af6ad17109cd40f9aec9bbdc211685#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x6228…8919](https://etherscan.io/address/0x6228ab40e809d3077667630b622a4a44a2dd8919), an account without code.

## Reviewer notes

### Mechanism

_validateSwapLocal (contracts/LiquidityPool.sol, line 635) recovers a signer on line 655 and tests it on line 656 against the signer it keeps in storage (maintainer() returns 0x6228ab40e809d3077667630b622a4a44a2dd8919). Neither isValidSignature selector is in the code, so that account is never asked. setMaintainer (contracts/LiquidityPool.sol, line 175) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0x6228…8919; 849 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
