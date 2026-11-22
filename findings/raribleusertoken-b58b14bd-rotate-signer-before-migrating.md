---
id: raribleusertoken-b58b14bd-rotate-signer-before-migrating
format: 2
title: 'RaribleUserToken: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb'
  name: RaribleUserToken
  code: verified
  code_url: https://etherscan.io/address/0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb#code
  copies: 2803
  family: 793b4fe62f054cc8bb4c3434759b9352
  upgradeable: 'no'
  admin: '0x9da8833763c54f5aaeb5f372c1ce31d8350f8a28'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use addSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb'
  file: RaribleUserToken.sol
  line: 1022
  has: require(isSigner(ecrecover(keccak256(abi.encodePacked(this, id)), v, r, s)), "signer should sign tokenId");
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb'
  file: RaribleUserToken.sol
  line: 977
  has: function addSigner
  says: addSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xf03ba06dd459ae597357b491219fcb573f5fe683'
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

RaribleUserToken accepts a call to mint only with an ECDSA signature of an address in the signer set it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addSigner changes who may sign.

## Evidence

- [mint](https://etherscan.io/address/0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb#code) recovers the signature with ECDSA and accepts only an address in the signer set it keeps; the code never asks that account.
- [addSigner](https://etherscan.io/address/0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb#code) changes who may sign (through _addSigner).
- The address recovered in its latest signature check on record is [0xf03b…e683](https://etherscan.io/address/0xf03ba06dd459ae597357b491219fcb573f5fe683), an account without code.

## Reviewer notes

### Mechanism

mint (RaribleUserToken.sol, line 1021) recovers a signer on line 1022 and tests it on line 1022 against an address in the signer set it keeps. Neither isValidSignature selector is in the code, so that account is never asked. _addSigner (RaribleUserToken.sol, line 985) writes it, called by addSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2,803 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2021-07-11, recovering 0xf03b…e683; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
