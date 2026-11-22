---
id: allowlistv3-1-02f1fa8b-rotate-signer-before-migrating
format: 2
title: 'AllowlistV3_1: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x02f1fa8b196d21c7b733eb2700b825611d8a38e5'
  name: AllowlistV3_1
  code: verified
  code_url: https://etherscan.io/address/0x2f67d98bd20d9580f52efa5ff70edaed9f2f316d#code
  proxy_of: '0x2f67d98bd20d9580f52efa5ff70edaed9f2f316d'
  copies: 2
  family: 1ab8ae0f47a1dc8f7a09cead8d1e746d
  upgradeable: 'yes'
  admin: '0xb819692a58db9dd4d3b403a875439b6ca155c610'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1798
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x2f67d98bd20d9580f52efa5ff70edaed9f2f316d'
  file: protocol/allowlist/src/v3_1/AllowlistV3_1.sol
  line: 513
  has: if (ECDSA.recover(digest, v, r, s) != owner()) revert InvalidSigner();
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2f67d98bd20d9580f52efa5ff70edaed9f2f316d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2f67d98bd20d9580f52efa5ff70edaed9f2f316d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0x2f67d98bd20d9580f52efa5ff70edaed9f2f316d'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x02f1fa8b196d21c7b733eb2700b825611d8a38e5'
  fn: owner()(address)
  is: '0x7747940adbc7191f877a9b90596e0da4f8deb2fe'
  says: Its owner is 0x7747940adbc7191f877a9b90596e0da4f8deb2fe at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x7747940adbc7191f877a9b90596e0da4f8deb2fe'
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

AllowlistV3_1 checks an ECDSA signature in _verifySignature and accepts only its owner. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [_verifySignature](https://etherscan.io/address/0x2f67d98bd20d9580f52efa5ff70edaed9f2f316d#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x2f67d98bd20d9580f52efa5ff70edaed9f2f316d#code) changes the signer.
- The signer at the block is [0x7747…b2fe](https://etherscan.io/address/0x7747940adbc7191f877a9b90596e0da4f8deb2fe), an account without code.

## Reviewer notes

### Mechanism

_verifySignature (protocol/allowlist/src/v3_1/AllowlistV3_1.sol, line 511) recovers a signer on line 513 and tests it on line 513 against its owner (owner() returns 0x7747940adbc7191f877a9b90596e0da4f8deb2fe). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1,798 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
