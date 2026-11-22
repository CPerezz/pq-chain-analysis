---
id: pushinventory-18b02c4d-rotate-signer-before-migrating
format: 2
title: 'PushInventory: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x18b02c4d8876bf456fb93553578927dd1c4f2f1e'
  name: PushInventory
  code: verified
  code_url: https://etherscan.io/address/0xa6aae2c154325c7bdf5484510299b983fccc86c3#code
  proxy_of: '0xa6aae2c154325c7bdf5484510299b983fccc86c3'
  copies: 4
  family: ca57ff003a1bbc6c14fa7de54686cfbb
  upgradeable: 'yes'
  admin: '0x8f5b9ffd1e91418391e7d612e0144e023e4f16d8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 305
impact: liveness
action: Replace the signer with setAuthorizer before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa6aae2c154325c7bdf5484510299b983fccc86c3'
  file: src/PushInventory.sol
  line: 895
  has: address signer = ECDSA.recover(messageHash, signature);
  says: _verifyWithdrawalAuthorization recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa6aae2c154325c7bdf5484510299b983fccc86c3'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa6aae2c154325c7bdf5484510299b983fccc86c3'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xa6aae2c154325c7bdf5484510299b983fccc86c3'
  file: src/PushInventory.sol
  line: 896
  has: if (signer != authorizer) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xa6aae2c154325c7bdf5484510299b983fccc86c3'
  file: src/PushInventory.sol
  line: 557
  has: function setAuthorizer
  says: setAuthorizer changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x18b02c4d8876bf456fb93553578927dd1c4f2f1e'
  fn: getAuthorizer()(address)
  is: '0xa6d88f3ca9df2fa374cfa6f3e53ed67a7d98955b'
  says: The signer it keeps in storage is 0xa6d88f3ca9df2fa374cfa6f3e53ed67a7d98955b at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xa6d88f3ca9df2fa374cfa6f3e53ed67a7d98955b'
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

PushInventory checks an ECDSA signature in _verifyWithdrawalAuthorization and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthorizer changes the signer.

## Evidence

- [_verifyWithdrawalAuthorization](https://etherscan.io/address/0xa6aae2c154325c7bdf5484510299b983fccc86c3#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAuthorizer](https://etherscan.io/address/0xa6aae2c154325c7bdf5484510299b983fccc86c3#code) changes the signer; only the owner can call it.
- The signer at the block is [0xa6d8…955b](https://etherscan.io/address/0xa6d88f3ca9df2fa374cfa6f3e53ed67a7d98955b), an account without code.

## Reviewer notes

### Mechanism

_verifyWithdrawalAuthorization (src/PushInventory.sol, line 872) recovers a signer on line 895 and tests it on line 896 against the signer it keeps in storage (getAuthorizer() returns 0xa6d88f3ca9df2fa374cfa6f3e53ed67a7d98955b). Neither isValidSignature selector is in the code, so that account is never asked. setAuthorizer (src/PushInventory.sol, line 557) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 305 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
