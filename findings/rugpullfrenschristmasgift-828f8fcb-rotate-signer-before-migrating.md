---
id: rugpullfrenschristmasgift-828f8fcb-rotate-signer-before-migrating
format: 2
title: 'This contract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0'
  name: RugPullFrensChristmasGift
  code: verified
  code_url: https://etherscan.io/address/0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0#code
  copies: 1
  upgradeable: 'no'
  admin: '0x3d34f69aed7e3bb13754a05ed1d95a25968c0c73'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0'
  file: contracts/RugPullFrensChristmasGift.sol
  line: 108
  has: address recoveredAddr = ECDSA.recover(_hashTypedDataV4(keccak256(abi.encode(
  says: isFreeMintEligible recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0'
  file: contracts/RugPullFrensChristmasGift.sol
  line: 114
  has: return owner() == recoveredAddr;
  says: the recovered address must be its owner
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0'
  fn: owner()(address)
  is: '0x3d34f69aed7e3bb13754a05ed1d95a25968c0c73'
  says: Its owner is 0x3d34f69aed7e3bb13754a05ed1d95a25968c0c73 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x3d34f69aed7e3bb13754a05ed1d95a25968c0c73'
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

This contract checks an ECDSA signature in isFreeMintEligible and accepts only its owner. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [isFreeMintEligible](https://etherscan.io/address/0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x828f8fcb9b044aa8c7cc97ecabf2f016f2ec6cc0#code) changes the signer.
- The signer at the block is [0x3d34…0c73](https://etherscan.io/address/0x3d34f69aed7e3bb13754a05ed1d95a25968c0c73), an account without code.

## Reviewer notes

### Mechanism

isFreeMintEligible (contracts/RugPullFrensChristmasGift.sol, line 107) recovers a signer on line 108 and tests it on line 114 against its owner (owner() returns 0x3d34f69aed7e3bb13754a05ed1d95a25968c0c73). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-06-24, recovering 0x3d34…0c73; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
