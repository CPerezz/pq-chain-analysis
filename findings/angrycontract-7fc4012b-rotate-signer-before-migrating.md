---
id: angrycontract-7fc4012b-rotate-signer-before-migrating
format: 2
title: 'AngryContract: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7fc4012bf86d8aaef4951bb7b486ea02c08c419f'
  name: AngryContract
  code: verified
  code_url: https://etherscan.io/address/0x7fc4012bf86d8aaef4951bb7b486ea02c08c419f#code
  copies: 1
  upgradeable: 'no'
  admin: '0xa0fa7077f620ed5a1c04d6ab60ddd5cc67af6c53'
value:
  usd: 7043
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use addExecutor so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x7fc4012bf86d8aaef4951bb7b486ea02c08c419f'
  file: AngryContract_flat (1).sol
  line: 1106
  has: require( executorList[hash.recover(_sig)], "US" );
  says: prePurchase recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7fc4012bf86d8aaef4951bb7b486ea02c08c419f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7fc4012bf86d8aaef4951bb7b486ea02c08c419f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x7fc4012bf86d8aaef4951bb7b486ea02c08c419f'
  file: AngryContract_flat (1).sol
  line: 937
  has: function addExecutor
  says: addExecutor changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xe3b1e75cb4cb2cba1d13a9826aaee3d4755e90b4'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

AngryContract accepts a call to prePurchase only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addExecutor changes who may sign.

## Evidence

- [prePurchase](https://etherscan.io/address/0x7fc4012bf86d8aaef4951bb7b486ea02c08c419f#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addExecutor](https://etherscan.io/address/0x7fc4012bf86d8aaef4951bb7b486ea02c08c419f#code) changes who may sign; only the owner can call it.
- The address recovered in its latest signature check on record is [0xe3b1…90b4](https://etherscan.io/address/0xe3b1e75cb4cb2cba1d13a9826aaee3d4755e90b4), an account without code.

## Reviewer notes

### Mechanism

prePurchase (AngryContract_flat (1).sol, line 1102) recovers a signer on line 1106 and tests it on line 1106 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addExecutor (AngryContract_flat (1).sol, line 937) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-10-15, recovering 0xe3b1…90b4; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
