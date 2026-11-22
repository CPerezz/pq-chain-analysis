---
id: nft-3502e53d-rotate-signer-before-migrating
format: 2
title: 'NFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3502e53d598c0749c934029c883ad2f60eace664'
  name: NFT
  code: verified
  code_url: https://etherscan.io/address/0x3502e53d598c0749c934029c883ad2f60eace664#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4107c4f705383c179b75cfae35913bc5835414e9'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Replace the signer with setServer before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x3502e53d598c0749c934029c883ad2f60eace664'
  file: contracts/NFT.sol
  line: 115
  has: return ecrecover(messageHash, 27, r, s) == _server || ecrecover(messageHash, 28, r, s) == _server;
  says: verify_code recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x3502e53d598c0749c934029c883ad2f60eace664'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x3502e53d598c0749c934029c883ad2f60eace664'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x3502e53d598c0749c934029c883ad2f60eace664'
  file: contracts/NFT.sol
  line: 71
  has: function setServer
  says: setServer changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x3502e53d598c0749c934029c883ad2f60eace664'
  fn: _server()(address)
  is: '0x7efb785389b55699378d6a531e5ecf0b3bf30625'
  says: The signer it keeps in storage is 0x7efb785389b55699378d6a531e5ecf0b3bf30625 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x7efb785389b55699378d6a531e5ecf0b3bf30625'
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

NFT checks an ECDSA signature in verify_code and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setServer changes the signer.

## Evidence

- [verify_code](https://etherscan.io/address/0x3502e53d598c0749c934029c883ad2f60eace664#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setServer](https://etherscan.io/address/0x3502e53d598c0749c934029c883ad2f60eace664#code) changes the signer; only the owner can call it.
- The signer at the block is [0x7efb…0625](https://etherscan.io/address/0x7efb785389b55699378d6a531e5ecf0b3bf30625), an account without code.

## Reviewer notes

### Mechanism

verify_code (contracts/NFT.sol, line 101) recovers a signer on line 115 and tests it on line 115 against the signer it keeps in storage (_server() returns 0x7efb785389b55699378d6a531e5ecf0b3bf30625). Neither isValidSignature selector is in the code, so that account is never asked. setServer (contracts/NFT.sol, line 71) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-05-24; 6 transactions called the address in the 90 days before the block. 32 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
