---
id: salesorderupgradeable-b6c220d5-rotate-signer-before-migrating
format: 2
title: 'SalesOrderUpgradeable: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb6c220d5fb70ff88a7490d47bc4c2000f74de78c'
  name: SalesOrderUpgradeable
  code: verified
  code_url: https://etherscan.io/address/0x71c603190130d09d530c6df928fbe08c00e64e19#code
  proxy_of: '0x71c603190130d09d530c6df928fbe08c00e64e19'
  copies: 6
  family: 35a259bf2b12d73a320ce4be1310a322
  upgradeable: 'yes'
  admin: '0x79db3dee7d98bc8261469e145e5bc417ea3f1338'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 15
impact: liveness
action: Replace the signer with executeOrderSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x71c603190130d09d530c6df928fbe08c00e64e19'
  file: project/contracts/SalesOrderUpgradeable.sol
  line: 497
  has: address recovered = ECDSA.recover(digest, signature);
  says: _pay recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x71c603190130d09d530c6df928fbe08c00e64e19'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x71c603190130d09d530c6df928fbe08c00e64e19'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x71c603190130d09d530c6df928fbe08c00e64e19'
  file: project/contracts/SalesOrderUpgradeable.sol
  line: 498
  has: if (recovered != orderSigner) revert InvalidOrderSigner(recovered);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x71c603190130d09d530c6df928fbe08c00e64e19'
  file: project/contracts/SalesOrderUpgradeable.sol
  line: 296
  has: function executeOrderSigner
  says: executeOrderSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xb6c220d5fb70ff88a7490d47bc4c2000f74de78c'
  fn: orderSigner()(address)
  is: '0x43da9425a38ac09c7323f85ef02979f1cd1fe735'
  says: The signer it keeps in storage is 0x43da9425a38ac09c7323f85ef02979f1cd1fe735 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x43da9425a38ac09c7323f85ef02979f1cd1fe735'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xfcc6ea03402c9418419c1a987ab37113d19c6aabc57112de9b5aa5e048df6181'
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

SalesOrderUpgradeable checks an ECDSA signature in _pay and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. executeOrderSigner changes the signer.

## Evidence

- [_pay](https://etherscan.io/address/0x71c603190130d09d530c6df928fbe08c00e64e19#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [executeOrderSigner](https://etherscan.io/address/0x71c603190130d09d530c6df928fbe08c00e64e19#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x43da…e735](https://etherscan.io/address/0x43da9425a38ac09c7323f85ef02979f1cd1fe735), an account without code.

## Reviewer notes

### Mechanism

_pay (project/contracts/SalesOrderUpgradeable.sol, line 476) recovers a signer on line 497 and tests it on line 498 against the signer it keeps in storage (orderSigner() returns 0x43da9425a38ac09c7323f85ef02979f1cd1fe735). Neither isValidSignature selector is in the code, so that account is never asked. executeOrderSigner (project/contracts/SalesOrderUpgradeable.sol, line 296) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 6 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-08, recovering 0x43da…e735; 15 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
