---
id: m1dollarsystemconverter-868a3c7b-rotate-signer-before-migrating
format: 2
title: 'M1DollarSystemConverter: replace the signer before it takes real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x868a3c7bcca7f93941c1d95e951033afab4b8cc6'
  name: M1DollarSystemConverter
  code: verified
  code_url: https://etherscan.io/address/0x868a3c7bcca7f93941c1d95e951033afab4b8cc6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x3e5e7f4a98b72d41a17767b3de2eede6f8c10ddb'
value:
  usd: 21
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x868a3c7bcca7f93941c1d95e951033afab4b8cc6'
  file: contracts/M1Vault.sol
  line: 118
  has: require(hash.recover(_eipSignature) == owner(), "Unchecked system authorization credentials");
  says: _verifyEIPPermission recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x868a3c7bcca7f93941c1d95e951033afab4b8cc6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x868a3c7bcca7f93941c1d95e951033afab4b8cc6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0x868a3c7bcca7f93941c1d95e951033afab4b8cc6'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x868a3c7bcca7f93941c1d95e951033afab4b8cc6'
  fn: owner()(address)
  is: '0x3e5e7f4a98b72d41a17767b3de2eede6f8c10ddb'
  says: Its owner is 0x3e5e7f4a98b72d41a17767b3de2eede6f8c10ddb at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x3e5e7f4a98b72d41a17767b3de2eede6f8c10ddb'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x6100f36c8ab22088a85de9d995843262466a703bb317abce65cf411b9e0ba71b'
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

M1DollarSystemConverter checks an ECDSA signature in _verifyEIPPermission and accepts only its owner. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [_verifyEIPPermission](https://etherscan.io/address/0x868a3c7bcca7f93941c1d95e951033afab4b8cc6#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x868a3c7bcca7f93941c1d95e951033afab4b8cc6#code) changes the signer; only the owner can call it.
- The signer at the block is [0x3e5e…0ddb](https://etherscan.io/address/0x3e5e7f4a98b72d41a17767b3de2eede6f8c10ddb), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

_verifyEIPPermission (contracts/M1Vault.sol, line 103) recovers a signer on line 118 and tests it on line 118 against its owner (owner() returns 0x3e5e7f4a98b72d41a17767b3de2eede6f8c10ddb). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. The signer's account holds an EIP-7702 delegation to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-08-24, recovering 0x3e5e…0ddb; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
