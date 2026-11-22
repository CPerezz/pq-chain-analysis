---
id: levxstreaming-1d38c14b-fixed-signer
format: 2
title: 'LevxStreaming: its signer cannot be replaced and must not take real code'
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
  address: '0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01'
  name: LevxStreaming
  code: verified
  code_url: https://etherscan.io/address/0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01#code
  copies: 1
  upgradeable: 'no'
  admin: '0x612ef87bfcd858687160294b0effaca0cba342e2'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01'
  file: contracts/LevxStreaming.sol
  line: 59
  has: 'require(ECDSA.recover(ECDSA.toEthSignedMessageHash(message), v, r, s) == signer, "LEVX: UNAUTHORIZED");'
  says: start recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01'
  file: contracts/LevxStreaming.sol
  line: 40
  has: signer = _signer;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01'
  fn: signer()(address)
  is: '0xe9d4afb6f8c9196972c6d9a74d5e54bbb7721f5b'
  says: A signer fixed at deployment is 0xe9d4afb6f8c9196972c6d9a74d5e54bbb7721f5b at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xe9d4afb6f8c9196972c6d9a74d5e54bbb7721f5b'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

LevxStreaming accepts a call to start only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [start](https://etherscan.io/address/0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0x1d38c14b78db0f5cb0ec01f2a138af30f0ec0d01#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xe9d4…1f5b](https://etherscan.io/address/0xe9d4afb6f8c9196972c6d9a74d5e54bbb7721f5b), an account without code.

## Reviewer notes

### Mechanism

start (contracts/LevxStreaming.sol, line 45) recovers a signer on line 59 and tests it on line 59 against a signer fixed at deployment (signer() returns 0xe9d4afb6f8c9196972c6d9a74d5e54bbb7721f5b). Neither isValidSignature selector is in the code, so that account is never asked. signer is written on line 40 of contracts/LevxStreaming.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-05-22, recovering 0xe9d4…1f5b; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
