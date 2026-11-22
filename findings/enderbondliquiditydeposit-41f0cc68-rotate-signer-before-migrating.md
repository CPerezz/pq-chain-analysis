---
id: enderbondliquiditydeposit-41f0cc68-rotate-signer-before-migrating
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
  address: '0x41f0cc6865ae1ca32d096b3be317ae84c48a99e8'
  name: EnderBondLiquidityDeposit
  code: verified
  code_url: https://etherscan.io/address/0xccb2374039fb1937a65a2233a130391a1643ebe5#code
  proxy_of: '0xccb2374039fb1937a65a2233a130391a1643ebe5'
  copies: 2
  family: d4cda7b40048b7400f4024b59811f0bf
  upgradeable: 'yes'
  admin: '0xd2a0f4c12164a376b180c29b62247b0212b71405'
value:
  usd: 2
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setsigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xccb2374039fb1937a65a2233a130391a1643ebe5'
  file: contracts/EnderBondLiquidityDeposit.sol
  line: 164
  has: address signAddress = _verify(userSign);
  says: deposit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xccb2374039fb1937a65a2233a130391a1643ebe5'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xccb2374039fb1937a65a2233a130391a1643ebe5'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xccb2374039fb1937a65a2233a130391a1643ebe5'
  file: contracts/EnderBondLiquidityDeposit.sol
  line: 165
  has: require(signAddress == signer && userSign.user == msg.sender, "user is not whitelisted");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xccb2374039fb1937a65a2233a130391a1643ebe5'
  file: contracts/EnderBondLiquidityDeposit.sol
  line: 91
  has: function setsigner
  says: setsigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x41f0cc6865ae1ca32d096b3be317ae84c48a99e8'
  fn: signer()(address)
  is: '0xee7ca89760a3425bc06d8afa201e80c22e5b94e9'
  says: The signer it keeps in storage is 0xee7ca89760a3425bc06d8afa201e80c22e5b94e9 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xee7ca89760a3425bc06d8afa201e80c22e5b94e9'
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

This contract accepts a call to deposit only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setsigner changes the signer.

## Evidence

- [deposit](https://etherscan.io/address/0xccb2374039fb1937a65a2233a130391a1643ebe5#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setsigner](https://etherscan.io/address/0xccb2374039fb1937a65a2233a130391a1643ebe5#code) changes the signer; only the owner can call it.
- The signer at the block is [0xee7c…94e9](https://etherscan.io/address/0xee7ca89760a3425bc06d8afa201e80c22e5b94e9), an account without code.

## Reviewer notes

### Mechanism

deposit (contracts/EnderBondLiquidityDeposit.sol, line 153) recovers a signer on line 164 and tests it on line 165 against the signer it keeps in storage (signer() returns 0xee7ca89760a3425bc06d8afa201e80c22e5b94e9). Neither isValidSignature selector is in the code, so that account is never asked. setsigner (contracts/EnderBondLiquidityDeposit.sol, line 91) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-01-09, recovering 0xee7c…94e9; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
