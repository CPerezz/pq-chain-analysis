---
id: tanknft-64665143-rotate-signer-before-migrating
format: 2
title: 'TankNFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6466514368a0c2e1396bc3164495c6f90cba92f6'
  name: TankNFT
  code: verified
  code_url: https://etherscan.io/address/0x6466514368a0c2e1396bc3164495c6f90cba92f6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x575a18ff843609330d7b6fea53a9e0512b602df7'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6466514368a0c2e1396bc3164495c6f90cba92f6'
  file: contracts/Tank.sol
  line: 226
  has: return ecrecover(hash, v, r, s) == _signer;
  says: verifySig recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6466514368a0c2e1396bc3164495c6f90cba92f6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6466514368a0c2e1396bc3164495c6f90cba92f6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x6466514368a0c2e1396bc3164495c6f90cba92f6'
  file: contracts/Tank.sol
  line: 138
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x6466514368a0c2e1396bc3164495c6f90cba92f6'
  fn: getSigner()(address)
  is: '0x9db5171227c41198384442da05b3938d1603c981'
  says: The signer it keeps in storage is 0x9db5171227c41198384442da05b3938d1603c981 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x9db5171227c41198384442da05b3938d1603c981'
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

TankNFT checks an ECDSA signature in verifySig and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [verifySig](https://etherscan.io/address/0x6466514368a0c2e1396bc3164495c6f90cba92f6#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x6466514368a0c2e1396bc3164495c6f90cba92f6#code) changes the signer; only the owner can call it.
- The signer at the block is [0x9db5…c981](https://etherscan.io/address/0x9db5171227c41198384442da05b3938d1603c981), an account without code.

## Reviewer notes

### Mechanism

verifySig (contracts/Tank.sol, line 223) recovers a signer on line 226 and tests it on line 226 against the signer it keeps in storage (getSigner() returns 0x9db5171227c41198384442da05b3938d1603c981). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (contracts/Tank.sol, line 138) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-02-17, recovering 0x9db5…c981; 3 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
