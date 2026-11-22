---
id: alphahq-d803b435-rotate-signer-before-migrating
format: 2
title: 'AlphaHQ: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd803b4357b3749b2fccdcdf427bbbe18112a4a71'
  name: AlphaHQ
  code: verified
  code_url: https://etherscan.io/address/0xd803b4357b3749b2fccdcdf427bbbe18112a4a71#code
  copies: 1
  upgradeable: 'no'
  admin: '0xfa6e4e9acdabce2a33af76654e6a0fb3656f20d8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 12
impact: liveness
action: Replace the signer with setAlphaHQSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd803b4357b3749b2fccdcdf427bbbe18112a4a71'
  file: contracts/AlphaHQ.sol
  line: 132
  has: return ALPHA_SIGNER != address(0) && ALPHA_SIGNER == _recoverSigner(_hash, _signature);
  says: _isSignedByAlphaSigner recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd803b4357b3749b2fccdcdf427bbbe18112a4a71'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd803b4357b3749b2fccdcdf427bbbe18112a4a71'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd803b4357b3749b2fccdcdf427bbbe18112a4a71'
  file: contracts/AlphaHQ.sol
  line: 77
  has: function setAlphaHQSigner
  says: setAlphaHQSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd803b4357b3749b2fccdcdf427bbbe18112a4a71'
  fn: ALPHA_SIGNER()(address)
  is: '0xe3d168493a3701ddf5c7190527e312b190578cec'
  says: The signer it keeps in storage is 0xe3d168493a3701ddf5c7190527e312b190578cec at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xe3d168493a3701ddf5c7190527e312b190578cec'
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

AlphaHQ checks an ECDSA signature in _isSignedByAlphaSigner and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAlphaHQSigner changes the signer.

## Evidence

- [_isSignedByAlphaSigner](https://etherscan.io/address/0xd803b4357b3749b2fccdcdf427bbbe18112a4a71#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAlphaHQSigner](https://etherscan.io/address/0xd803b4357b3749b2fccdcdf427bbbe18112a4a71#code) changes the signer; only the owner can call it.
- The signer at the block is [0xe3d1…8cec](https://etherscan.io/address/0xe3d168493a3701ddf5c7190527e312b190578cec), an account without code.

## Reviewer notes

### Mechanism

_isSignedByAlphaSigner (contracts/AlphaHQ.sol, line 131) recovers a signer on line 132 and tests it on line 132 against the signer it keeps in storage (ALPHA_SIGNER() returns 0xe3d168493a3701ddf5c7190527e312b190578cec). Neither isValidSignature selector is in the code, so that account is never asked. setAlphaHQSigner (contracts/AlphaHQ.sol, line 77) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-07-02, recovering 0xe3d1…8cec; 12 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
