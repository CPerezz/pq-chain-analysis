---
id: mutantbatz-e3bf8660-rotate-signer-before-migrating
format: 2
title: 'MutantBatz: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe3bf8660426becbcbc66bf3b6d255aae6203d5be'
  name: MutantBatz
  code: verified
  code_url: https://etherscan.io/address/0xe3bf8660426becbcbc66bf3b6d255aae6203d5be#code
  copies: 1
  upgradeable: 'no'
  admin: '0xb7776fa6df9000570d64b050eab370fde6b31ce1'
value:
  usd: 74
  basis: held
activity:
  txs_90d: 71
impact: liveness
action: Replace the signer with setMintSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe3bf8660426becbcbc66bf3b6d255aae6203d5be'
  file: contracts/MutantBatz.sol
  line: 137
  has: address signer = digest.recover(signature);
  says: bite recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe3bf8660426becbcbc66bf3b6d255aae6203d5be'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe3bf8660426becbcbc66bf3b6d255aae6203d5be'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xe3bf8660426becbcbc66bf3b6d255aae6203d5be'
  file: contracts/MutantBatz.sol
  line: 138
  has: require(signer != address(0) && signer == mintSigner, "Invalid signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xe3bf8660426becbcbc66bf3b6d255aae6203d5be'
  file: contracts/MutantBatz.sol
  line: 281
  has: function setMintSigner
  says: setMintSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xe3bf8660426becbcbc66bf3b6d255aae6203d5be'
  fn: mintSigner()(address)
  is: '0xc5906749a5427186f834ed44c8810a717cb2a9ab'
  says: The signer it keeps in storage is 0xc5906749a5427186f834ed44c8810a717cb2a9ab at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc5906749a5427186f834ed44c8810a717cb2a9ab'
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

MutantBatz accepts a call to bite only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMintSigner changes the signer.

## Evidence

- [bite](https://etherscan.io/address/0xe3bf8660426becbcbc66bf3b6d255aae6203d5be#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMintSigner](https://etherscan.io/address/0xe3bf8660426becbcbc66bf3b6d255aae6203d5be#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc590…a9ab](https://etherscan.io/address/0xc5906749a5427186f834ed44c8810a717cb2a9ab), an account without code.

## Reviewer notes

### Mechanism

bite (contracts/MutantBatz.sol, line 106) recovers a signer on line 137 and tests it on line 138 against the signer it keeps in storage (mintSigner() returns 0xc5906749a5427186f834ed44c8810a717cb2a9ab). Neither isValidSignature selector is in the code, so that account is never asked. setMintSigner (contracts/MutantBatz.sol, line 281) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-03-17, recovering 0xc590…a9ab; 71 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
