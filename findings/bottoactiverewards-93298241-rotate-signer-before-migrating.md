---
id: bottoactiverewards-93298241-rotate-signer-before-migrating
format: 2
title: 'BottoActiveRewards: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x93298241417a63469b6f8f080b4878749acb4c47'
  name: BottoActiveRewards
  code: verified
  code_url: https://etherscan.io/address/0x93298241417a63469b6f8f080b4878749acb4c47#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 8
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x93298241417a63469b6f8f080b4878749acb4c47'
  file: contracts/BottoActiveRewards.sol
  line: 46
  has: address signer = _verify(_hash(permit_), signature_);
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x93298241417a63469b6f8f080b4878749acb4c47'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x93298241417a63469b6f8f080b4878749acb4c47'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x93298241417a63469b6f8f080b4878749acb4c47'
  file: contracts/BottoActiveRewards.sol
  line: 50
  has: hasRole(REWARD_ROLE, signer),
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x93298241417a63469b6f8f080b4878749acb4c47'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x9b627af2a48f2e07beeeb82141e3ac6e231326bf'
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

BottoActiveRewards accepts a call to claim only with an ECDSA signature of a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [claim](https://etherscan.io/address/0x93298241417a63469b6f8f080b4878749acb4c47#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x93298241417a63469b6f8f080b4878749acb4c47#code) changes who may sign.
- The address recovered in its latest signature check on record is [0x9b62…26bf](https://etherscan.io/address/0x9b627af2a48f2e07beeeb82141e3ac6e231326bf), an account without code.

## Reviewer notes

### Mechanism

claim (contracts/BottoActiveRewards.sol, line 41) recovers a signer on line 46 and tests it on line 50 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-04-06, recovering 0x9b62…26bf; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
