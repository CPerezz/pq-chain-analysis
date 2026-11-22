---
id: defunctcollective-c7dd0693-rotate-signer-before-migrating
format: 2
title: 'DefunctCollective: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc7dd0693f49f612c74ee7756f5c98c5efac1122d'
  name: DefunctCollective
  code: verified
  code_url: https://etherscan.io/address/0xc7dd0693f49f612c74ee7756f5c98c5efac1122d#code
  copies: 1
  upgradeable: 'no'
  admin: '0x72e9708ed7f689d428763d2c1eb6336402dd9cd6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setOrderSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc7dd0693f49f612c74ee7756f5c98c5efac1122d'
  file: contracts/DefunctCollective.sol
  line: 115
  has: if (ECDSA.recover(_hashTypedDataV4(_hashOrder(o)), signature) != orderSigner) revert BadSignature();
  says: fuse recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc7dd0693f49f612c74ee7756f5c98c5efac1122d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc7dd0693f49f612c74ee7756f5c98c5efac1122d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc7dd0693f49f612c74ee7756f5c98c5efac1122d'
  file: contracts/DefunctCollective.sol
  line: 191
  has: function setOrderSigner
  says: setOrderSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc7dd0693f49f612c74ee7756f5c98c5efac1122d'
  fn: orderSigner()(address)
  is: '0xf01745b5d3a6bc63df50901a4cdb2f6591b54e48'
  says: The signer it keeps in storage is 0xf01745b5d3a6bc63df50901a4cdb2f6591b54e48 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xf01745b5d3a6bc63df50901a4cdb2f6591b54e48'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xb73b1a9018260fd79cb658d707aa82e4f83e211be234766a8305b42c4fc5f803'
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

DefunctCollective accepts a call to fuse only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOrderSigner changes the signer.

## Evidence

- [fuse](https://etherscan.io/address/0xc7dd0693f49f612c74ee7756f5c98c5efac1122d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOrderSigner](https://etherscan.io/address/0xc7dd0693f49f612c74ee7756f5c98c5efac1122d#code) changes the signer; only a role holder can call it.
- The signer at the block is [0xf017…4e48](https://etherscan.io/address/0xf01745b5d3a6bc63df50901a4cdb2f6591b54e48), an account without code.

## Reviewer notes

### Mechanism

fuse (contracts/DefunctCollective.sol, line 111) recovers a signer on line 115 and tests it on line 115 against the signer it keeps in storage (orderSigner() returns 0xf01745b5d3a6bc63df50901a4cdb2f6591b54e48). Neither isValidSignature selector is in the code, so that account is never asked. setOrderSigner (contracts/DefunctCollective.sol, line 191) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-02, recovering 0xf017…4e48; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
