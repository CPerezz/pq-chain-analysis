---
id: mintmanager-1bf97928-rotate-signer-before-migrating
format: 2
title: 'MintManager: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1bf979282181f2b7a640d17ab5d2e25125f2de5e'
  name: MintManager
  code: verified
  code_url: https://etherscan.io/address/0xf97379eca4f9e58626ea108a88f50448bc0411db#code
  proxy_of: '0xf97379eca4f9e58626ea108a88f50448bc0411db'
  copies: 2
  family: e1a72854a911ed7d85194f26f46b324a
  upgradeable: 'yes'
  admin: '0xe637e568e1e12a45528aa4069fe200e4276c8ae5'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 409
impact: liveness
action: Before a signer's account moves to real code, use addOrDeprecatePlatformExecutor so that another key can
  sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xf97379eca4f9e58626ea108a88f50448bc0411db'
  file: contracts/mint/MintManager.sol
  line: 1166
  has: address signer = _claimSigner(claim, signature);
  says: verifyClaim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf97379eca4f9e58626ea108a88f50448bc0411db'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf97379eca4f9e58626ea108a88f50448bc0411db'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xf97379eca4f9e58626ea108a88f50448bc0411db'
  file: contracts/mint/MintManager.sol
  line: 1169
  has: _platformExecutors.contains(signer) &&
  says: the recovered address must be an address in the signer set it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xf97379eca4f9e58626ea108a88f50448bc0411db'
  file: contracts/mint/MintManager.sol
  line: 581
  has: function addOrDeprecatePlatformExecutor
  says: addOrDeprecatePlatformExecutor changes who may sign
  for:
  - action
  - evidence-2
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

MintManager checks an ECDSA signature in verifyClaim and accepts only an address in the signer set it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addOrDeprecatePlatformExecutor changes who may sign.

## Evidence

- [verifyClaim](https://etherscan.io/address/0xf97379eca4f9e58626ea108a88f50448bc0411db#code) recovers the signature with ECDSA and accepts only an address in the signer set it keeps; the code never asks that account.
- [addOrDeprecatePlatformExecutor](https://etherscan.io/address/0xf97379eca4f9e58626ea108a88f50448bc0411db#code) changes who may sign; only the owner can call it.

## Reviewer notes

### Mechanism

verifyClaim (contracts/mint/MintManager.sol, line 1161) recovers a signer on line 1166 and tests it on line 1169 against an address in the signer set it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addOrDeprecatePlatformExecutor (contracts/mint/MintManager.sol, line 581) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-19; 409 transactions called the address in the 90 days before the block. 42 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
