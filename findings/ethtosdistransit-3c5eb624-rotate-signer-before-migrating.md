---
id: ethtosdistransit-3c5eb624-rotate-signer-before-migrating
format: 2
title: 'ETHTosDisTransit: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3c5eb624e578d368190642adfb2c06e829584c9f'
  name: ETHTosDisTransit
  code: verified
  code_url: https://etherscan.io/address/0x3c5eb624e578d368190642adfb2c06e829584c9f#code
  copies: 1
  upgradeable: 'no'
  admin: '0x0000ed5383a59a5e4813fdb384d87a1d50e7b9f7'
value:
  usd: 480
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with changeSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x3c5eb624e578d368190642adfb2c06e829584c9f'
  file: ETHTosDisTransit.sol
  line: 396
  has: address[] memory signList = _recoverAddresses(hash, _signature);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x3c5eb624e578d368190642adfb2c06e829584c9f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x3c5eb624e578d368190642adfb2c06e829584c9f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x3c5eb624e578d368190642adfb2c06e829584c9f'
  file: ETHTosDisTransit.sol
  line: 328
  has: function changeSigner
  says: changeSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x3c5eb624e578d368190642adfb2c06e829584c9f'
  fn: signWallet()(address)
  is: '0xd971d0fbcee32310c9b115fcd35699d621f27fa7'
  says: The signer it keeps in storage is 0xd971d0fbcee32310c9b115fcd35699d621f27fa7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xd971d0fbcee32310c9b115fcd35699d621f27fa7'
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

ETHTosDisTransit checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeSigner changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0x3c5eb624e578d368190642adfb2c06e829584c9f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeSigner](https://etherscan.io/address/0x3c5eb624e578d368190642adfb2c06e829584c9f#code) changes the signer.
- The signer at the block is [0xd971…7fa7](https://etherscan.io/address/0xd971d0fbcee32310c9b115fcd35699d621f27fa7), an account without code.

## Reviewer notes

### Mechanism

_verify (ETHTosDisTransit.sol, line 394) recovers a signer on line 396 and tests it on line 396 against the signer it keeps in storage (signWallet() returns 0xd971d0fbcee32310c9b115fcd35699d621f27fa7). Neither isValidSignature selector is in the code, so that account is never asked. changeSigner (ETHTosDisTransit.sol, line 328) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-12-09, recovering 0xd971…7fa7; 0 transactions called the address in the 90 days before the block. 4 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
