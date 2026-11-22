---
id: ethburgertransit-c8c1b417-rotate-signer-before-migrating
format: 2
title: 'ETHBurgerTransit: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc8c1b41713761281a520b7ad81544197bc85a4ce'
  name: ETHBurgerTransit
  code: verified
  code_url: https://etherscan.io/address/0xc8c1b41713761281a520b7ad81544197bc85a4ce#code
  copies: 1
  upgradeable: 'no'
  admin: '0xbc554d0fa1745aeb52acba8343106cf8aca038ca'
value:
  usd: 5
  basis: held
activity:
  txs_90d: 10
impact: liveness
action: Replace the signer with changeSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc8c1b41713761281a520b7ad81544197bc85a4ce'
  file: ETHBurgerTransit.sol
  line: 305
  has: address[] memory signList = _recoverAddresses(hash, _signature);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc8c1b41713761281a520b7ad81544197bc85a4ce'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc8c1b41713761281a520b7ad81544197bc85a4ce'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc8c1b41713761281a520b7ad81544197bc85a4ce'
  file: ETHBurgerTransit.sol
  line: 247
  has: function changeSigner
  says: changeSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc8c1b41713761281a520b7ad81544197bc85a4ce'
  fn: signWallet()(address)
  is: '0x0876ae7e3c833f41d264d7a1d4348e45756ebd54'
  says: The signer it keeps in storage is 0x0876ae7e3c833f41d264d7a1d4348e45756ebd54 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x0876ae7e3c833f41d264d7a1d4348e45756ebd54'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xd3f3f007c13beecba8069dd8905ac93867af03b59a00123a802d239911344520'
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

ETHBurgerTransit checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeSigner changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0xc8c1b41713761281a520b7ad81544197bc85a4ce#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeSigner](https://etherscan.io/address/0xc8c1b41713761281a520b7ad81544197bc85a4ce#code) changes the signer.
- The signer at the block is [0x0876…bd54](https://etherscan.io/address/0x0876ae7e3c833f41d264d7a1d4348e45756ebd54), an account without code.

## Reviewer notes

### Mechanism

_verify (ETHBurgerTransit.sol, line 303) recovers a signer on line 305 and tests it on line 305 against the signer it keeps in storage (signWallet() returns 0x0876ae7e3c833f41d264d7a1d4348e45756ebd54). Neither isValidSignature selector is in the code, so that account is never asked. changeSigner (ETHBurgerTransit.sol, line 247) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-26, recovering 0x0876…bd54; 10 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
