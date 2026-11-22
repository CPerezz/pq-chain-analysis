---
id: liquiditybondsevolutionlockerfixed-425e9077-rotate-signer-before-migrating
format: 2
title: 'This contract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x425e9077014295808a2500c6ba25b3a171980956'
  name: LiquidityBondsEvolutionLockerFixed
  code: verified
  code_url: https://etherscan.io/address/0x87e90762806866592c4dff2b416e11a98fa05901#code
  proxy_of: '0x87e90762806866592c4dff2b416e11a98fa05901'
  copies: 3
  family: 5442be39fe0d09ff4666b6c4cbc4fa7b
  upgradeable: 'yes'
  admin: '0xedcb6862781c2338e1133dd3fe65c9e060fc8f13'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x87e90762806866592c4dff2b416e11a98fa05901'
  file: contracts/LiquidityBondsEvolutionLockerFixed.sol
  line: 368
  has: address recoveredSigner = ECDSA.recover(ethSignedMessageHash, _signature);
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x87e90762806866592c4dff2b416e11a98fa05901'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x87e90762806866592c4dff2b416e11a98fa05901'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x87e90762806866592c4dff2b416e11a98fa05901'
  file: contracts/LiquidityBondsEvolutionLockerFixed.sol
  line: 370
  has: 'require(recoveredSigner == signer, "LiquidityBondLocker: Invalid signature");'
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x87e90762806866592c4dff2b416e11a98fa05901'
  file: contracts/LiquidityBondsEvolutionLockerFixed.sol
  line: 522
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x425e9077014295808a2500c6ba25b3a171980956'
  fn: signer()(address)
  is: '0x300b46f9dd871d2aca4f36a833f02274b3989912'
  says: The signer it keeps in storage is 0x300b46f9dd871d2aca4f36a833f02274b3989912 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x300b46f9dd871d2aca4f36a833f02274b3989912'
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

This contract checks an ECDSA signature in _verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_verifySignature](https://etherscan.io/address/0x87e90762806866592c4dff2b416e11a98fa05901#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x87e90762806866592c4dff2b416e11a98fa05901#code) changes the signer; only the owner can call it.
- The signer at the block is [0x300b…9912](https://etherscan.io/address/0x300b46f9dd871d2aca4f36a833f02274b3989912), an account without code.

## Reviewer notes

### Mechanism

_verifySignature (contracts/LiquidityBondsEvolutionLockerFixed.sol, line 358) recovers a signer on line 368 and tests it on line 370 against the signer it keeps in storage (signer() returns 0x300b46f9dd871d2aca4f36a833f02274b3989912). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/LiquidityBondsEvolutionLockerFixed.sol, line 522) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-02-14, recovering 0x300b…9912; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
