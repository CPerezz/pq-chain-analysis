---
id: fisclaim-5804cd0f-rotate-signer-before-migrating
format: 2
title: 'FISClaim: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5804cd0fda51b6686712a041dc3db86e6a3b39ae'
  name: FISClaim
  code: verified
  code_url: https://etherscan.io/address/0xcb0161f9f5aadd8f90408e8f75bdad861ead15aa#code
  proxy_of: '0xcb0161f9f5aadd8f90408e8f75bdad861ead15aa'
  copies: 2
  family: e35eb3b737af17dab48d5cb3566acb3f
  upgradeable: 'yes'
  admin: '0x2a421750033ed3bd41fb0f25592a22452d3cc64c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Replace the signer with updateRelayer before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xcb0161f9f5aadd8f90408e8f75bdad861ead15aa'
  file: src/FISClaim.sol
  line: 106
  has: address signer = ECDSA.recover(digest, sig);
  says: _verifyRelayerSig recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xcb0161f9f5aadd8f90408e8f75bdad861ead15aa'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xcb0161f9f5aadd8f90408e8f75bdad861ead15aa'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xcb0161f9f5aadd8f90408e8f75bdad861ead15aa'
  file: src/FISClaim.sol
  line: 107
  has: require(signer == relayer, "Invalid relayer signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xcb0161f9f5aadd8f90408e8f75bdad861ead15aa'
  file: src/FISClaim.sol
  line: 54
  has: function updateRelayer
  says: updateRelayer changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x5804cd0fda51b6686712a041dc3db86e6a3b39ae'
  fn: relayer()(address)
  is: '0x496281338c12bcb3686c27d1733636ab0a06092e'
  says: The signer it keeps in storage is 0x496281338c12bcb3686c27d1733636ab0a06092e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x496281338c12bcb3686c27d1733636ab0a06092e'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xbece009f3fc3c9808683cdd04db2b700d2acece9517497e2910f2c6b57bebc79'
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

FISClaim checks an ECDSA signature in _verifyRelayerSig and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateRelayer changes the signer.

## Evidence

- [_verifyRelayerSig](https://etherscan.io/address/0xcb0161f9f5aadd8f90408e8f75bdad861ead15aa#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateRelayer](https://etherscan.io/address/0xcb0161f9f5aadd8f90408e8f75bdad861ead15aa#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4962…092e](https://etherscan.io/address/0x496281338c12bcb3686c27d1733636ab0a06092e), an account without code.

## Reviewer notes

### Mechanism

_verifyRelayerSig (src/FISClaim.sol, line 98) recovers a signer on line 106 and tests it on line 107 against the signer it keeps in storage (relayer() returns 0x496281338c12bcb3686c27d1733636ab0a06092e). Neither isValidSignature selector is in the code, so that account is never asked. updateRelayer (src/FISClaim.sol, line 54) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-09-01, recovering 0x4962…092e; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
