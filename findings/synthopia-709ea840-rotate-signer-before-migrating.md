---
id: synthopia-709ea840-rotate-signer-before-migrating
format: 2
title: 'Synthopia: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x709ea840f66fb32a762908afae673610e169bf5a'
  name: Synthopia
  code: verified
  code_url: https://etherscan.io/address/0x709ea840f66fb32a762908afae673610e169bf5a#code
  copies: 1
  upgradeable: 'no'
  admin: '0xc70084445c4d24809c72b91e62b1168c727508ca'
value:
  usd: 16
  basis: held
activity:
  txs_90d: 28
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x709ea840f66fb32a762908afae673610e169bf5a'
  file: contracts/Synthopia.sol
  line: 159
  has: hash.toEthSignedMessageHash().recover(signature) == SIGNER,
  says: mintWithSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x709ea840f66fb32a762908afae673610e169bf5a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x709ea840f66fb32a762908afae673610e169bf5a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x709ea840f66fb32a762908afae673610e169bf5a'
  file: contracts/Synthopia.sol
  line: 111
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xf3f1d9f79e8f0f5e71ad7eb70535f7417c0a3ff3'
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

Synthopia accepts a call to mintWithSignature only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [mintWithSignature](https://etherscan.io/address/0x709ea840f66fb32a762908afae673610e169bf5a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x709ea840f66fb32a762908afae673610e169bf5a#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xf3f1…3ff3](https://etherscan.io/address/0xf3f1d9f79e8f0f5e71ad7eb70535f7417c0a3ff3), an account without code.

## Reviewer notes

### Mechanism

mintWithSignature (contracts/Synthopia.sol, line 151) recovers a signer on line 159 and tests it on line 159 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (contracts/Synthopia.sol, line 111) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-01-25, recovering 0xf3f1…3ff3; 28 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
