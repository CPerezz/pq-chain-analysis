---
id: bonusdistributor-2f925542-rotate-signer-before-migrating
format: 2
title: 'BonusDistributor: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2f925542d1689258be55f87e17fcd8b7480d76f0'
  name: BonusDistributor
  code: verified
  code_url: https://etherscan.io/address/0x2f925542d1689258be55f87e17fcd8b7480d76f0#code
  copies: 4
  family: 8a47d6e22c8028177cf1e92014299f28
  upgradeable: 'no'
  admin: '0x66a2d663f73d151e7ef552196de163d8023bc39e'
value:
  usd: 4588
  basis: held
activity:
  txs_90d: 13
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x2f925542d1689258be55f87e17fcd8b7480d76f0'
  file: contracts/adapters/distributor/bonusDistributor.sol
  line: 80
  has: address signerRecovered = ECDSA.recover(digest, signature);
  says: validateSig recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2f925542d1689258be55f87e17fcd8b7480d76f0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2f925542d1689258be55f87e17fcd8b7480d76f0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x2f925542d1689258be55f87e17fcd8b7480d76f0'
  file: contracts/adapters/distributor/bonusDistributor.sol
  line: 82
  has: return signerRecovered == signer;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x2f925542d1689258be55f87e17fcd8b7480d76f0'
  file: contracts/adapters/distributor/bonusDistributor.sol
  line: 37
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2f925542d1689258be55f87e17fcd8b7480d76f0'
  fn: getSigner()(address)
  is: '0xfd2ac595d84628003abfda3096e9a88c53ccbaa4'
  says: The signer it keeps in storage is 0xfd2ac595d84628003abfda3096e9a88c53ccbaa4 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfd2ac595d84628003abfda3096e9a88c53ccbaa4'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xbe30b8019dba617e7857b6093d3597c5a2c7d49cdbe382962dec48dd4c914ce9'
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

BonusDistributor checks an ECDSA signature in validateSig and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [validateSig](https://etherscan.io/address/0x2f925542d1689258be55f87e17fcd8b7480d76f0#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x2f925542d1689258be55f87e17fcd8b7480d76f0#code) changes the signer; only the owner can call it.
- The signer at the block is [0xfd2a…baa4](https://etherscan.io/address/0xfd2ac595d84628003abfda3096e9a88c53ccbaa4), an account without code.

## Reviewer notes

### Mechanism

validateSig (contracts/adapters/distributor/bonusDistributor.sol, line 77) recovers a signer on line 80 and tests it on line 82 against the signer it keeps in storage (getSigner() returns 0xfd2ac595d84628003abfda3096e9a88c53ccbaa4). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (contracts/adapters/distributor/bonusDistributor.sol, line 37) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-08, recovering 0xfd2a…baa4; 13 transactions called the address in the 90 days before the block. 5 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
