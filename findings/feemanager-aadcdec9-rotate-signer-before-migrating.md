---
id: feemanager-aadcdec9-rotate-signer-before-migrating
format: 2
title: 'FeeManager: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xaadcdec98ce6c560c6e4b1c2b1b31258d5c1af9a'
  name: FeeManager
  code: verified
  code_url: https://etherscan.io/address/0xaadcdec98ce6c560c6e4b1c2b1b31258d5c1af9a#code
  copies: 1
  upgradeable: 'no'
  admin: '0x0b132f11bd70a07ea1579b595a1ae0ad975284c6'
value:
  usd: 687
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xaadcdec98ce6c560c6e4b1c2b1b31258d5c1af9a'
  file: FeeManager.sol
  line: 498
  has: return signer == ECDSA.recover(hash, signature);
  says: matchSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xaadcdec98ce6c560c6e4b1c2b1b31258d5c1af9a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xaadcdec98ce6c560c6e4b1c2b1b31258d5c1af9a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xaadcdec98ce6c560c6e4b1c2b1b31258d5c1af9a'
  file: FeeManager.sol
  line: 418
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xaadcdec98ce6c560c6e4b1c2b1b31258d5c1af9a'
  fn: signer()(address)
  is: '0xa6293ffb651e23543cbdfbf65bc14595db7a29c1'
  says: The signer it keeps in storage is 0xa6293ffb651e23543cbdfbf65bc14595db7a29c1 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xa6293ffb651e23543cbdfbf65bc14595db7a29c1'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

FeeManager checks an ECDSA signature in matchSigner and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [matchSigner](https://etherscan.io/address/0xaadcdec98ce6c560c6e4b1c2b1b31258d5c1af9a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xaadcdec98ce6c560c6e4b1c2b1b31258d5c1af9a#code) changes the signer; only the owner can call it.
- The signer at the block is [0xa629…29c1](https://etherscan.io/address/0xa6293ffb651e23543cbdfbf65bc14595db7a29c1), an account without code.

## Reviewer notes

### Mechanism

matchSigner (FeeManager.sol, line 493) recovers a signer on line 498 and tests it on line 498 against the signer it keeps in storage (signer() returns 0xa6293ffb651e23543cbdfbf65bc14595db7a29c1). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (FeeManager.sol, line 418) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-06-06, recovering 0xa629…29c1; 0 transactions called the address in the 90 days before the block. 5 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
