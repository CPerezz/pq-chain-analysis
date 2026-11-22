---
id: upgradeablebatchwithdrawalvault-385c0547-rotate-signer-before-migrating
format: 2
title: 'This contract: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x385c0547d1975157fe93f6cf1eebed37bdecf0d2'
  name: UpgradeableBatchWithdrawalVault
  code: verified
  code_url: https://etherscan.io/address/0x582315ce947421bc65c2cd7d51584dc4214e6f57#code
  proxy_of: '0x582315ce947421bc65c2cd7d51584dc4214e6f57'
  copies: 3
  family: c06772a4e28f18f77aa8f770ec63e6fb
  upgradeable: 'yes'
  admin: '0x28c0cedfbebffd2fcc96b13e929fc81abf290560'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Before a signer's account moves to real code, use setWithdrawSigner so that another key can sign in its
  place.
evidence_level: source
checks:
- id: recover
  source: '0x582315ce947421bc65c2cd7d51584dc4214e6f57'
  file: contracts/UpgradeableBatchWithdrawalVault.sol
  line: 285
  has: address signer = ECDSA.recover(digest, signatures[i]);
  says: _verifySignatures recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x582315ce947421bc65c2cd7d51584dc4214e6f57'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x582315ce947421bc65c2cd7d51584dc4214e6f57'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x582315ce947421bc65c2cd7d51584dc4214e6f57'
  file: contracts/UpgradeableBatchWithdrawalVault.sol
  line: 197
  has: function setWithdrawSigner
  says: setWithdrawSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

This contract checks an ECDSA signature in _verifySignatures and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setWithdrawSigner changes who may sign.

## Evidence

- [_verifySignatures](https://etherscan.io/address/0x582315ce947421bc65c2cd7d51584dc4214e6f57#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setWithdrawSigner](https://etherscan.io/address/0x582315ce947421bc65c2cd7d51584dc4214e6f57#code) changes who may sign (through _setWithdrawSigner); only the owner can call it.

## Reviewer notes

### Mechanism

_verifySignatures (contracts/UpgradeableBatchWithdrawalVault.sol, line 280) recovers a signer on line 285 and tests it on line 285 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. _setWithdrawSigner (contracts/UpgradeableBatchWithdrawalVault.sol, line 296) writes it, called by setWithdrawSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
