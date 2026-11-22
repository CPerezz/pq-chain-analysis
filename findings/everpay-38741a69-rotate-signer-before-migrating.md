---
id: everpay-38741a69-rotate-signer-before-migrating
format: 2
title: 'EverPay: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x38741a69785e84399fcf7c5ad61d572f7ecb1dab'
  name: EverPay
  code: verified
  code_url: https://etherscan.io/address/0x38741a69785e84399fcf7c5ad61d572f7ecb1dab#code
  copies: 3
  family: 244e6e23dc9f13c0229c85dd2b913416
  upgradeable: 'no'
value:
  usd: 181244
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Before a signer's account moves to real code, use addOwner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x38741a69785e84399fcf7c5ad61d572f7ecb1dab'
  file: EverPay.sol
  line: 209
  has: address owner = ecAddress(id, sigs[i]);
  says: submit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x38741a69785e84399fcf7c5ad61d572f7ecb1dab'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x38741a69785e84399fcf7c5ad61d572f7ecb1dab'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x38741a69785e84399fcf7c5ad61d572f7ecb1dab'
  file: EverPay.sol
  line: 120
  has: function addOwner
  says: addOwner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x5c3066ffc4de627a6b9ea5c3e61e1bf2c369a196'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x7323b04a7d96575f59892c67630105cc56c551c942164c73520eec2ad5dab2cc'
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

EverPay accepts a call to submit only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addOwner changes who may sign.

## Evidence

- [submit](https://etherscan.io/address/0x38741a69785e84399fcf7c5ad61d572f7ecb1dab#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addOwner](https://etherscan.io/address/0x38741a69785e84399fcf7c5ad61d572f7ecb1dab#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x7323b04a7d96575f59892c67630105cc56c551c942164c73520eec2ad5dab2cc) on record recovered [0x5c30…a196](https://etherscan.io/address/0x5c3066ffc4de627a6b9ea5c3e61e1bf2c369a196), an account without code.

## Reviewer notes

### Mechanism

submit (EverPay.sol, line 197) recovers a signer on line 209 and tests it on line 209 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addOwner (EverPay.sol, line 120) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-09, recovering 0x5c30…a196; 4 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
