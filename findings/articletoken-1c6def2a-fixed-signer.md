---
id: articletoken-1c6def2a-fixed-signer
format: 2
title: 'ArticleToken: its signer cannot be replaced and must not take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a signer's account takes real code; the signer is fixed, so a new contract is then
  needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1c6def2af6a7982c08808901049d44e89f8be026'
  name: ArticleToken
  code: verified
  code_url: https://etherscan.io/address/0x1c6def2af6a7982c08808901049d44e89f8be026#code
  copies: 1
  upgradeable: 'no'
  admin: '0xbd56dba641a856a0afa8dc05bfe52368965bb04b'
value:
  usd: 56
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x1c6def2af6a7982c08808901049d44e89f8be026'
  file: ArticleToken.sol
  line: 2357
  has: return ECDSA.recover(ethSignedMessageHash, signature) == signingAddress;
  says: verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1c6def2af6a7982c08808901049d44e89f8be026'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1c6def2af6a7982c08808901049d44e89f8be026'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x1c6def2af6a7982c08808901049d44e89f8be026'
  file: ArticleToken.sol
  line: 2291
  has: address public signingAddress = 0x0e2f7b8A6963ad617D53521c1989911CBfe0f9C8;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1c6def2af6a7982c08808901049d44e89f8be026'
  fn: signingAddress()(address)
  is: '0x0e2f7b8a6963ad617d53521c1989911cbfe0f9c8'
  says: A signer fixed at deployment is 0x0e2f7b8a6963ad617d53521c1989911cbfe0f9c8 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x0e2f7b8a6963ad617d53521c1989911cbfe0f9c8'
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

ArticleToken checks an ECDSA signature in verifySignature and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [verifySignature](https://etherscan.io/address/0x1c6def2af6a7982c08808901049d44e89f8be026#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x1c6def2af6a7982c08808901049d44e89f8be026#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x0e2f…f9c8](https://etherscan.io/address/0x0e2f7b8a6963ad617d53521c1989911cbfe0f9c8), an account without code.

## Reviewer notes

### Mechanism

verifySignature (ArticleToken.sol, line 2353) recovers a signer on line 2357 and tests it on line 2357 against a signer fixed at deployment (signingAddress() returns 0x0e2f7b8a6963ad617d53521c1989911cbfe0f9c8). Neither isValidSignature selector is in the code, so that account is never asked. signingAddress is written on line 2291 of ArticleToken.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-12-08, recovering 0x0e2f…f9c8; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
