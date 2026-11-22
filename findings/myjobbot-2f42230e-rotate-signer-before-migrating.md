---
id: myjobbot-2f42230e-rotate-signer-before-migrating
format: 2
title: 'MyJobBot: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2f42230ecf2c5c8205ed9558e2051b6eb3a5b362'
  name: MyJobBot
  code: verified
  code_url: https://etherscan.io/address/0x2f42230ecf2c5c8205ed9558e2051b6eb3a5b362#code
  copies: 1
  upgradeable: 'no'
  admin: '0x95b719df33a6b4c2a897caa156bfcff4d8564161'
value:
  usd: 11
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setOracul before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x2f42230ecf2c5c8205ed9558e2051b6eb3a5b362'
  file: MyJobBot.sol
  line: 101
  has: return oracul == ecrecover(hashCheck(check), sigV, sigR, sigS);
  says: verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2f42230ecf2c5c8205ed9558e2051b6eb3a5b362'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2f42230ecf2c5c8205ed9558e2051b6eb3a5b362'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x2f42230ecf2c5c8205ed9558e2051b6eb3a5b362'
  file: MyJobBot.sol
  line: 47
  has: function setOracul
  says: setOracul changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2f42230ecf2c5c8205ed9558e2051b6eb3a5b362'
  fn: oracul()(address)
  is: '0xb46b3e31e0a5c076f1a5b0be2e226768b10e6cf4'
  says: The signer it keeps in storage is 0xb46b3e31e0a5c076f1a5b0be2e226768b10e6cf4 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xb46b3e31e0a5c076f1a5b0be2e226768b10e6cf4'
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

MyJobBot checks an ECDSA signature in verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOracul changes the signer.

## Evidence

- [verify](https://etherscan.io/address/0x2f42230ecf2c5c8205ed9558e2051b6eb3a5b362#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOracul](https://etherscan.io/address/0x2f42230ecf2c5c8205ed9558e2051b6eb3a5b362#code) changes the signer; only the owner can call it.
- The signer at the block is [0xb46b…6cf4](https://etherscan.io/address/0xb46b3e31e0a5c076f1a5b0be2e226768b10e6cf4), an account without code.

## Reviewer notes

### Mechanism

verify (MyJobBot.sol, line 100) recovers a signer on line 101 and tests it on line 101 against the signer it keeps in storage (oracul() returns 0xb46b3e31e0a5c076f1a5b0be2e226768b10e6cf4). Neither isValidSignature selector is in the code, so that account is never asked. setOracul (MyJobBot.sol, line 47) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2020-03-29, recovering 0xb46b…6cf4; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
