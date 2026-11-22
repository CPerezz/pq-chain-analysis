---
id: michelin3xplorerclub-87ec0441-rotate-signer-before-migrating
format: 2
title: 'Michelin3xplorerClub: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x87ec044115cd9e0e09221031441640ee48b3a8f2'
  name: Michelin3xplorerClub
  code: verified
  code_url: https://etherscan.io/address/0x93cbee8a37b40a06b41caf7bddb11de184c0120d#code
  proxy_of: '0x93cbee8a37b40a06b41caf7bddb11de184c0120d'
  copies: 2
  family: f284ff47141604a62b3717b456ebf9f4
  upgradeable: 'yes'
  admin: '0x04ac4b2f088ffb718feba136522c1b4f69cf2639'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 169
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x93cbee8a37b40a06b41caf7bddb11de184c0120d'
  file: contracts/extensions/CouponExtension.sol
  line: 45
  has: address signer = message.recover(signature);
  says: _checkCoupon recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x93cbee8a37b40a06b41caf7bddb11de184c0120d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x93cbee8a37b40a06b41caf7bddb11de184c0120d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x93cbee8a37b40a06b41caf7bddb11de184c0120d'
  file: contracts/extensions/CouponExtension.sol
  line: 47
  has: if (!hasRole(SIGNER_ROLE, signer)) {
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x93cbee8a37b40a06b41caf7bddb11de184c0120d'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
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

Michelin3xplorerClub checks an ECDSA signature in _checkCoupon and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_checkCoupon](https://etherscan.io/address/0x93cbee8a37b40a06b41caf7bddb11de184c0120d#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x93cbee8a37b40a06b41caf7bddb11de184c0120d#code) changes who may sign.

## Reviewer notes

### Mechanism

_checkCoupon (contracts/extensions/CouponExtension.sol, line 43) recovers a signer on line 45 and tests it on line 47 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-10-27; 169 transactions called the address in the 90 days before the block. 39 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
