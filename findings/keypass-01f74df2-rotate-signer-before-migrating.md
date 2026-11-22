---
id: keypass-01f74df2-rotate-signer-before-migrating
format: 2
title: 'KeyPass: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x01f74df24e81c8ae5eb1ff6642283c10e022fb56'
  name: KeyPass
  code: verified
  code_url: https://etherscan.io/address/0xe3f0939374e642c05b021378f4eca0b946cfb58f#code
  proxy_of: '0xe3f0939374e642c05b021378f4eca0b946cfb58f'
  copies: 2
  family: 8af23851c1ebd63a24bed1f8bb2812fe
  upgradeable: 'yes'
  admin: '0x9213ccca8cba95d90134f28391caf1453e12c5d2'
value:
  usd: 262
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe3f0939374e642c05b021378f4eca0b946cfb58f'
  file: contracts/KeyPass.sol
  line: 90
  has: require(signer == _verify(_ticket), "Invalid ticket");
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe3f0939374e642c05b021378f4eca0b946cfb58f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe3f0939374e642c05b021378f4eca0b946cfb58f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xe3f0939374e642c05b021378f4eca0b946cfb58f'
  file: contracts/KeyPass.sol
  line: 117
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x01f74df24e81c8ae5eb1ff6642283c10e022fb56'
  fn: signer()(address)
  is: '0xdb07c408c47da4cc73a105f87b4d665931a3ebfb'
  says: The signer it keeps in storage is 0xdb07c408c47da4cc73a105f87b4d665931a3ebfb at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xdb07c408c47da4cc73a105f87b4d665931a3ebfb'
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

KeyPass accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0xe3f0939374e642c05b021378f4eca0b946cfb58f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xe3f0939374e642c05b021378f4eca0b946cfb58f#code) changes the signer; only the owner can call it.
- The signer at the block is [0xdb07…ebfb](https://etherscan.io/address/0xdb07c408c47da4cc73a105f87b4d665931a3ebfb), an account without code.

## Reviewer notes

### Mechanism

claim (contracts/KeyPass.sol, line 85) recovers a signer on line 90 and tests it on line 90 against the signer it keeps in storage (signer() returns 0xdb07c408c47da4cc73a105f87b4d665931a3ebfb). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/KeyPass.sol, line 117) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-02-16, recovering 0xdb07…ebfb; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
