---
id: neighborheadznft-67ae5bb2-rotate-signer-before-migrating
format: 2
title: 'NeighborheadzNFT: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x67ae5bb2039e0402ad9193908c77315c0c377ea9'
  name: NeighborheadzNFT
  code: verified
  code_url: https://etherscan.io/address/0x67ae5bb2039e0402ad9193908c77315c0c377ea9#code
  copies: 1
  upgradeable: 'no'
  admin: '0x82cafddb166d6c2a627b1b5e62a06ca09465c745'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Before a signer's account moves to real code, use setVerifier so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x67ae5bb2039e0402ad9193908c77315c0c377ea9'
  file: contracts/NeighborheadzNFT.sol
  line: 201
  has: 'require(_verifiers[_verifiedHash.toEthSignedMessageHash().recover(sig)], "NBHZ: Unauthorized");'
  says: _mintNFT recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x67ae5bb2039e0402ad9193908c77315c0c377ea9'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x67ae5bb2039e0402ad9193908c77315c0c377ea9'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x67ae5bb2039e0402ad9193908c77315c0c377ea9'
  file: contracts/NeighborheadzNFT.sol
  line: 112
  has: function setVerifier
  says: setVerifier changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x2f85bb03806c5b9e254645acc3c5d9bea2acc8f9'
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

NeighborheadzNFT checks an ECDSA signature in _mintNFT and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVerifier changes who may sign.

## Evidence

- [_mintNFT](https://etherscan.io/address/0x67ae5bb2039e0402ad9193908c77315c0c377ea9#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setVerifier](https://etherscan.io/address/0x67ae5bb2039e0402ad9193908c77315c0c377ea9#code) changes who may sign; only a role holder can call it.
- The address recovered in its latest signature check on record is [0x2f85…c8f9](https://etherscan.io/address/0x2f85bb03806c5b9e254645acc3c5d9bea2acc8f9), an account without code.

## Reviewer notes

### Mechanism

_mintNFT (contracts/NeighborheadzNFT.sol, line 195) recovers a signer on line 201 and tests it on line 201 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setVerifier (contracts/NeighborheadzNFT.sol, line 112) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-10-17, recovering 0x2f85…c8f9; 2 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
