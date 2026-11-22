---
id: collectible-72a2a3ae-rotate-signer-before-migrating
format: 2
title: 'Collectible: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x72a2a3ae48637512b01346ae9c21c422148e9480'
  name: Collectible
  code: verified
  code_url: https://etherscan.io/address/0x72a2a3ae48637512b01346ae9c21c422148e9480#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 377
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Before a signer's account moves to real code, use toggleAdminAddress so that another key can sign in its
  place.
evidence_level: source
checks:
- id: recover
  source: '0x72a2a3ae48637512b01346ae9c21c422148e9480'
  file: contracts/Collectible.sol
  line: 292
  has: address signer = ECDSA.recover(digest, signature);
  says: redeem recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x72a2a3ae48637512b01346ae9c21c422148e9480'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x72a2a3ae48637512b01346ae9c21c422148e9480'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x72a2a3ae48637512b01346ae9c21c422148e9480'
  file: contracts/Collectible.sol
  line: 293
  has: require(adminAddresses[signer], "Invalid signature");
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x72a2a3ae48637512b01346ae9c21c422148e9480'
  file: contracts/Collectible.sol
  line: 151
  has: function toggleAdminAddress
  says: toggleAdminAddress changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x1487a06fc88eb6c110497e1cca40d2f0fa659379'
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

Collectible accepts a call to redeem only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. toggleAdminAddress changes who may sign.

## Evidence

- [redeem](https://etherscan.io/address/0x72a2a3ae48637512b01346ae9c21c422148e9480#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [toggleAdminAddress](https://etherscan.io/address/0x72a2a3ae48637512b01346ae9c21c422148e9480#code) changes who may sign.
- The address recovered in its latest signature check on record is [0x1487…9379](https://etherscan.io/address/0x1487a06fc88eb6c110497e1cca40d2f0fa659379), an account without code.

## Reviewer notes

### Mechanism

redeem (contracts/Collectible.sol, line 284) recovers a signer on line 292 and tests it on line 293 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. toggleAdminAddress (contracts/Collectible.sol, line 151) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-02-09, recovering 0x1487…9379; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
