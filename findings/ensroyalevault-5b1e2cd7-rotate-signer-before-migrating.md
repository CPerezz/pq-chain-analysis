---
id: ensroyalevault-5b1e2cd7-rotate-signer-before-migrating
format: 2
title: 'ENSRoyaleVault: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5b1e2cd71a495c4c53f19135b22462c92acdaae9'
  name: ENSRoyaleVault
  code: verified
  code_url: https://etherscan.io/address/0x5b1e2cd71a495c4c53f19135b22462c92acdaae9#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8004f955c7ed19b465f1f30ad7d04c6d2edc4e81'
value:
  usd: 4
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x5b1e2cd71a495c4c53f19135b22462c92acdaae9'
  file: src/ENSRoyaleVault.sol
  line: 137
  has: address recoveredSigner = digest.recover(signature);
  says: withdraw recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5b1e2cd71a495c4c53f19135b22462c92acdaae9'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5b1e2cd71a495c4c53f19135b22462c92acdaae9'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x5b1e2cd71a495c4c53f19135b22462c92acdaae9'
  file: src/ENSRoyaleVault.sol
  line: 139
  has: if (recoveredSigner != signer) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x5b1e2cd71a495c4c53f19135b22462c92acdaae9'
  file: src/ENSRoyaleVault.sol
  line: 174
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x5b1e2cd71a495c4c53f19135b22462c92acdaae9'
  fn: signer()(address)
  is: '0x18cc22a6999ae2280445c7f2ad130c3967ea5e8d'
  says: The signer it keeps in storage is 0x18cc22a6999ae2280445c7f2ad130c3967ea5e8d at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x18cc22a6999ae2280445c7f2ad130c3967ea5e8d'
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

ENSRoyaleVault accepts a call to withdraw only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [withdraw](https://etherscan.io/address/0x5b1e2cd71a495c4c53f19135b22462c92acdaae9#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x5b1e2cd71a495c4c53f19135b22462c92acdaae9#code) changes the signer; only the owner can call it.
- The signer at the block is [0x18cc…5e8d](https://etherscan.io/address/0x18cc22a6999ae2280445c7f2ad130c3967ea5e8d), an account without code.

## Reviewer notes

### Mechanism

withdraw (src/ENSRoyaleVault.sol, line 124) recovers a signer on line 137 and tests it on line 139 against the signer it keeps in storage (signer() returns 0x18cc22a6999ae2280445c7f2ad130c3967ea5e8d). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (src/ENSRoyaleVault.sol, line 174) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
