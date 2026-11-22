---
id: mongrelbreedingprogram-d027ef4d-rotate-signer-before-migrating
format: 2
title: 'MongrelBreedingProgram: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd027ef4d00d04758c866475c566ad10bfdc6bdcd'
  name: MongrelBreedingProgram
  code: verified
  code_url: https://etherscan.io/address/0xd027ef4d00d04758c866475c566ad10bfdc6bdcd#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8a966ae13626211c10b731c44b2d7d8271cf6397'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 7
impact: liveness
action: Replace the signer with setMintSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd027ef4d00d04758c866475c566ad10bfdc6bdcd'
  file: contracts/MongrelBreedingProgram.sol
  line: 118
  has: address signer = digest.recover(signature);
  says: allowlistMint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd027ef4d00d04758c866475c566ad10bfdc6bdcd'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd027ef4d00d04758c866475c566ad10bfdc6bdcd'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xd027ef4d00d04758c866475c566ad10bfdc6bdcd'
  file: contracts/MongrelBreedingProgram.sol
  line: 120
  has: if (signer == address(0) || signer != mintSigner) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xd027ef4d00d04758c866475c566ad10bfdc6bdcd'
  file: contracts/MongrelBreedingProgram.sol
  line: 153
  has: function setMintSigner
  says: setMintSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd027ef4d00d04758c866475c566ad10bfdc6bdcd'
  fn: mintSigner()(address)
  is: '0x4c3bc1c2e2eb977a44440a10fe21135c8b283b5d'
  says: The signer it keeps in storage is 0x4c3bc1c2e2eb977a44440a10fe21135c8b283b5d at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x4c3bc1c2e2eb977a44440a10fe21135c8b283b5d'
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

MongrelBreedingProgram accepts a call to allowlistMint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setMintSigner changes the signer.

## Evidence

- [allowlistMint](https://etherscan.io/address/0xd027ef4d00d04758c866475c566ad10bfdc6bdcd#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setMintSigner](https://etherscan.io/address/0xd027ef4d00d04758c866475c566ad10bfdc6bdcd#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4c3b…3b5d](https://etherscan.io/address/0x4c3bc1c2e2eb977a44440a10fe21135c8b283b5d), an account without code.

## Reviewer notes

### Mechanism

allowlistMint (contracts/MongrelBreedingProgram.sol, line 99) recovers a signer on line 118 and tests it on line 120 against the signer it keeps in storage (mintSigner() returns 0x4c3bc1c2e2eb977a44440a10fe21135c8b283b5d). Neither isValidSignature selector is in the code, so that account is never asked. setMintSigner (contracts/MongrelBreedingProgram.sol, line 153) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-12-16, recovering 0x4c3b…3b5d; 7 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
