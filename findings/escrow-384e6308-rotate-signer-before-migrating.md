---
id: escrow-384e6308-rotate-signer-before-migrating
format: 2
title: 'Escrow: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x384e6308d797c02db0db1fb85789e26dc94719cb'
  name: Escrow
  code: verified
  code_url: https://etherscan.io/address/0x384e6308d797c02db0db1fb85789e26dc94719cb#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4218d5fea05020213f1a1284f3625f6d7ac5c092'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 346
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x384e6308d797c02db0db1fb85789e26dc94719cb'
  file: contracts/Escrow.sol
  line: 640
  has: address recovered712 = digest.recover(signature);
  says: _verifyOfferSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x384e6308d797c02db0db1fb85789e26dc94719cb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x384e6308d797c02db0db1fb85789e26dc94719cb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x384e6308d797c02db0db1fb85789e26dc94719cb'
  file: contracts/Escrow.sol
  line: 641
  has: bool ok = recovered712 == user;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x384e6308d797c02db0db1fb85789e26dc94719cb'
  file: contracts/Escrow.sol
  line: 260
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x384e6308d797c02db0db1fb85789e26dc94719cb'
  fn: signer()(address)
  is: '0x46f300cc7b52d10f70fce088b70d9d437a0941ae'
  says: The signer it keeps in storage is 0x46f300cc7b52d10f70fce088b70d9d437a0941ae at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x46f300cc7b52d10f70fce088b70d9d437a0941ae'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x81470fc63f25c06c1d42daa90d0a7e58f71a0b5030dbf0c31cf5c62e893a077c'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

Escrow checks an ECDSA signature in _verifyOfferSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_verifyOfferSignature](https://etherscan.io/address/0x384e6308d797c02db0db1fb85789e26dc94719cb#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x384e6308d797c02db0db1fb85789e26dc94719cb#code) changes the signer; only the owner can call it.
- The signer at the block is [0x46f3…41ae](https://etherscan.io/address/0x46f300cc7b52d10f70fce088b70d9d437a0941ae), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_verifyOfferSignature (contracts/Escrow.sol, line 639) recovers a signer on line 640 and tests it on line 641 against the signer it keeps in storage (signer() returns 0x46f300cc7b52d10f70fce088b70d9d437a0941ae). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/Escrow.sol, line 260) writes it. The signer's account holds an EIP-7702 delegation to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-13, recovering 0xbb7e…a485; 346 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
