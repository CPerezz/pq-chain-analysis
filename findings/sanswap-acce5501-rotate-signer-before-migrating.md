---
id: sanswap-acce5501-rotate-signer-before-migrating
format: 2
title: 'SANSWAP: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xacce550121e59d04bf3a616c4155f89d2cf7d4c4'
  name: SANSWAP
  code: verified
  code_url: https://etherscan.io/address/0xacce550121e59d04bf3a616c4155f89d2cf7d4c4#code
  copies: 1
  upgradeable: 'no'
  admin: '0x658faf561fc9eb2588b969e91467e2a7d178d6e0'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 436
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xacce550121e59d04bf3a616c4155f89d2cf7d4c4'
  file: src/SANSWAP.sol
  line: 239
  has: if (SIGNER != ECDSA.recover(hash, _signature)) {
  says: _validateSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xacce550121e59d04bf3a616c4155f89d2cf7d4c4'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xacce550121e59d04bf3a616c4155f89d2cf7d4c4'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xacce550121e59d04bf3a616c4155f89d2cf7d4c4'
  file: src/SANSWAP.sol
  line: 145
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xacce550121e59d04bf3a616c4155f89d2cf7d4c4'
  fn: SIGNER()(address)
  is: '0xfa4c6947adfef7614f48e99141fa3fec38692ee5'
  says: The signer it keeps in storage is 0xfa4c6947adfef7614f48e99141fa3fec38692ee5 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfa4c6947adfef7614f48e99141fa3fec38692ee5'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xb4006c6ded803f76c695bb18cce154b47539fbdae164f57bb7a64be88e4e16b7'
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

SANSWAP checks an ECDSA signature in _validateSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [_validateSignature](https://etherscan.io/address/0xacce550121e59d04bf3a616c4155f89d2cf7d4c4#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xacce550121e59d04bf3a616c4155f89d2cf7d4c4#code) changes the signer; only a role holder can call it.
- The signer at the block is [0xfa4c…2ee5](https://etherscan.io/address/0xfa4c6947adfef7614f48e99141fa3fec38692ee5), an account without code.

## Reviewer notes

### Mechanism

_validateSignature (src/SANSWAP.sol, line 221) recovers a signer on line 239 and tests it on line 239 against the signer it keeps in storage (SIGNER() returns 0xfa4c6947adfef7614f48e99141fa3fec38692ee5). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/SANSWAP.sol, line 145) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-06, recovering 0xfa4c…2ee5; 436 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
