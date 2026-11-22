---
id: block-807a0774-rotate-signer-before-migrating
format: 2
title: 'Block: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x807a0774236a0fbe9e7f8e7df49edfed0e6777ea'
  name: Block
  code: verified
  code_url: https://etherscan.io/address/0xe0dfb064f5a5018001f2d8ee337e4f37b110a922#code
  proxy_of: '0xe0dfb064f5a5018001f2d8ee337e4f37b110a922'
  copies: 2
  family: 7b7b9587aac597428217db2909f99ce0
  upgradeable: 'yes'
  admin: '0x8f37d36f7c98e294dbb675d0a7a35c640e4e17c8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 27
impact: liveness
action: Replace the signer with setOracleAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe0dfb064f5a5018001f2d8ee337e4f37b110a922'
  file: contracts/Block.sol
  line: 119
  has: messageHash.toEthSignedMessageHash().recover(signature) ==
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe0dfb064f5a5018001f2d8ee337e4f37b110a922'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe0dfb064f5a5018001f2d8ee337e4f37b110a922'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xe0dfb064f5a5018001f2d8ee337e4f37b110a922'
  file: contracts/Block.sol
  line: 146
  has: function setOracleAddress
  says: setOracleAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x807a0774236a0fbe9e7f8e7df49edfed0e6777ea'
  fn: oracleAddress()(address)
  is: '0xfc95d6f09139e8b587a4de9bbb066dc3e3ae29fc'
  says: The signer it keeps in storage is 0xfc95d6f09139e8b587a4de9bbb066dc3e3ae29fc at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xfc95d6f09139e8b587a4de9bbb066dc3e3ae29fc'
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

Block checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOracleAddress changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0xe0dfb064f5a5018001f2d8ee337e4f37b110a922#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOracleAddress](https://etherscan.io/address/0xe0dfb064f5a5018001f2d8ee337e4f37b110a922#code) changes the signer; only the owner can call it.
- The signer at the block is [0xfc95…29fc](https://etherscan.io/address/0xfc95d6f09139e8b587a4de9bbb066dc3e3ae29fc), an account without code.

## Reviewer notes

### Mechanism

_verify (contracts/Block.sol, line 113) recovers a signer on line 119 and tests it on line 119 against the signer it keeps in storage (oracleAddress() returns 0xfc95d6f09139e8b587a4de9bbb066dc3e3ae29fc). Neither isValidSignature selector is in the code, so that account is never asked. setOracleAddress (contracts/Block.sol, line 146) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-07-11, recovering 0xfc95…29fc; 27 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
