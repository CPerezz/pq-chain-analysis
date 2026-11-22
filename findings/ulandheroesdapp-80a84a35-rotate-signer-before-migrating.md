---
id: ulandheroesdapp-80a84a35-rotate-signer-before-migrating
format: 2
title: 'ULANDHeroesDapp: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x80a84a3508aa58521344311c428d88e6d0baabef'
  name: ULANDHeroesDapp
  code: verified
  code_url: https://etherscan.io/address/0x80a84a3508aa58521344311c428d88e6d0baabef#code
  copies: 1
  upgradeable: 'no'
  admin: '0x5d021314a6748f96cd32c7f7ee32d6461e2dcd40'
value:
  usd: 2887
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x80a84a3508aa58521344311c428d88e6d0baabef'
  file: contracts/ULANDHeroesDapp.sol
  line: 107
  has: signerAddress == hash.toEthSignedMessageHash().recover(signature);
  says: matchSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x80a84a3508aa58521344311c428d88e6d0baabef'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x80a84a3508aa58521344311c428d88e6d0baabef'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x80a84a3508aa58521344311c428d88e6d0baabef'
  file: contracts/ULANDHeroesDapp.sol
  line: 139
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x80a84a3508aa58521344311c428d88e6d0baabef'
  fn: signerAddress()(address)
  is: '0x0a6873044d724e7445cd5a49f991e56029ba61cf'
  says: The signer it keeps in storage is 0x0a6873044d724e7445cd5a49f991e56029ba61cf at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x0a6873044d724e7445cd5a49f991e56029ba61cf'
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

ULANDHeroesDapp checks an ECDSA signature in matchSigner and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [matchSigner](https://etherscan.io/address/0x80a84a3508aa58521344311c428d88e6d0baabef#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x80a84a3508aa58521344311c428d88e6d0baabef#code) changes the signer; only the owner can call it.
- The signer at the block is [0x0a68…61cf](https://etherscan.io/address/0x0a6873044d724e7445cd5a49f991e56029ba61cf), an account without code.

## Reviewer notes

### Mechanism

matchSigner (contracts/ULANDHeroesDapp.sol, line 101) recovers a signer on line 107 and tests it on line 107 against the signer it keeps in storage (signerAddress() returns 0x0a6873044d724e7445cd5a49f991e56029ba61cf). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/ULANDHeroesDapp.sol, line 139) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-02-02, recovering 0x0a68…61cf; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
