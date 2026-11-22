---
id: a3swalletfactoryv3-04c87b76-rotate-signer-before-migrating
format: 2
title: 'A3SWalletFactoryV3: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x04c87b76b73ed706d4aac567e3adccb994591b1b'
  name: A3SWalletFactoryV3
  code: verified
  code_url: https://etherscan.io/address/0xb509dbdd1d89952fc4d7821a09572c8faba1630c#code
  proxy_of: '0xb509dbdd1d89952fc4d7821a09572c8faba1630c'
  copies: 2
  family: af7eec26b76e154dd8a39ada6ef0738e
  upgradeable: 'yes'
  admin: '0xcdb01899e35466b948b3476cbd60acc3ce477e4f'
value:
  usd: 595
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with updateSystemSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb509dbdd1d89952fc4d7821a09572c8faba1630c'
  file: contracts/v3/A3SWalletFactoryV3.sol
  line: 168
  has: ECDSA.recover(signedHash, signature) == systemSigner;
  says: isValidToMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb509dbdd1d89952fc4d7821a09572c8faba1630c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb509dbdd1d89952fc4d7821a09572c8faba1630c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb509dbdd1d89952fc4d7821a09572c8faba1630c'
  file: contracts/v3/A3SWalletFactoryV3.sol
  line: 222
  has: function updateSystemSigner
  says: updateSystemSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x04c87b76b73ed706d4aac567e3adccb994591b1b'
  fn: systemSigner()(address)
  is: '0x4aabcc2adcac52706156ed7bfeb0294a649f5684'
  says: The signer it keeps in storage is 0x4aabcc2adcac52706156ed7bfeb0294a649f5684 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x4aabcc2adcac52706156ed7bfeb0294a649f5684'
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

A3SWalletFactoryV3 checks an ECDSA signature in isValidToMint and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSystemSigner changes the signer.

## Evidence

- [isValidToMint](https://etherscan.io/address/0xb509dbdd1d89952fc4d7821a09572c8faba1630c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSystemSigner](https://etherscan.io/address/0xb509dbdd1d89952fc4d7821a09572c8faba1630c#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4aab…5684](https://etherscan.io/address/0x4aabcc2adcac52706156ed7bfeb0294a649f5684), an account without code.

## Reviewer notes

### Mechanism

isValidToMint (contracts/v3/A3SWalletFactoryV3.sol, line 160) recovers a signer on line 168 and tests it on line 168 against the signer it keeps in storage (systemSigner() returns 0x4aabcc2adcac52706156ed7bfeb0294a649f5684). Neither isValidSignature selector is in the code, so that account is never asked. updateSystemSigner (contracts/v3/A3SWalletFactoryV3.sol, line 222) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-09-11, recovering 0x4aab…5684; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
