---
id: v4dognft-9d1c0529-rotate-signer-before-migrating
format: 2
title: 'V4DogNFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9d1c0529884a60a941074e541188a4564a500e6c'
  name: V4DogNFT
  code: verified
  code_url: https://etherscan.io/address/0x9d1c0529884a60a941074e541188a4564a500e6c#code
  copies: 1
  upgradeable: 'no'
  admin: '0x5894ee4289d29817cb35f37e7b55f431abcc333b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: liveness
action: Replace the signer with setMintSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x9d1c0529884a60a941074e541188a4564a500e6c'
  file: src/V4DogNFT.sol
  line: 191
  has: return digest.recover(signature) == mintSigner;
  says: _validMintPass recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x9d1c0529884a60a941074e541188a4564a500e6c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x9d1c0529884a60a941074e541188a4564a500e6c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x9d1c0529884a60a941074e541188a4564a500e6c'
  file: src/V4DogNFT.sol
  line: 119
  has: function setMintSigner
  says: setMintSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x9d1c0529884a60a941074e541188a4564a500e6c'
  fn: mintSigner()(address)
  is: '0x63e5e7292cd4b2a846e6171aa3bc333c3ee9fc00'
  says: The signer it keeps in storage is 0x63e5e7292cd4b2a846e6171aa3bc333c3ee9fc00 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x63e5e7292cd4b2a846e6171aa3bc333c3ee9fc00'
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

V4DogNFT checks an ECDSA signature in _validMintPass and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMintSigner changes the signer.

## Evidence

- [_validMintPass](https://etherscan.io/address/0x9d1c0529884a60a941074e541188a4564a500e6c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMintSigner](https://etherscan.io/address/0x9d1c0529884a60a941074e541188a4564a500e6c#code) changes the signer; only the owner can call it.
- The signer at the block is [0x63e5…fc00](https://etherscan.io/address/0x63e5e7292cd4b2a846e6171aa3bc333c3ee9fc00), an account without code.

## Reviewer notes

### Mechanism

_validMintPass (src/V4DogNFT.sol, line 182) recovers a signer on line 191 and tests it on line 191 against the signer it keeps in storage (mintSigner() returns 0x63e5e7292cd4b2a846e6171aa3bc333c3ee9fc00). Neither isValidSignature selector is in the code, so that account is never asked. setMintSigner (src/V4DogNFT.sol, line 119) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 4 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
