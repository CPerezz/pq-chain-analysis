---
id: acedice-70d28b8d-rotate-signer-before-migrating
format: 2
title: 'AceDice: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x70d28b8d6c19f3074a3edf3033f0defa7a4ce4df'
  name: AceDice
  code: verified
  code_url: https://etherscan.io/address/0x70d28b8d6c19f3074a3edf3033f0defa7a4ce4df#code
  copies: 2
  family: 3986c8d0c6e6a181586a85f1f6ef6472
  upgradeable: 'no'
  admin: '0xae113b2fa9df869e45f9578ea8b02e0bc30ed7ac'
value:
  usd: 545
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSecretSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x70d28b8d6c19f3074a3edf3033f0defa7a4ce4df'
  file: AceDice.sol
  line: 217
  has: require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
  says: verifyCommit recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x70d28b8d6c19f3074a3edf3033f0defa7a4ce4df'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x70d28b8d6c19f3074a3edf3033f0defa7a4ce4df'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x70d28b8d6c19f3074a3edf3033f0defa7a4ce4df'
  file: AceDice.sol
  line: 166
  has: function setSecretSigner
  says: setSecretSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x70d28b8d6c19f3074a3edf3033f0defa7a4ce4df'
  fn: secretSigner()(address)
  is: '0xae113b2fa9df869e45f9578ea8b02e0bc30ed7ac'
  says: The signer it keeps in storage is 0xae113b2fa9df869e45f9578ea8b02e0bc30ed7ac at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xae113b2fa9df869e45f9578ea8b02e0bc30ed7ac'
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

AceDice checks an ECDSA signature in verifyCommit and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSecretSigner changes the signer.

## Evidence

- [verifyCommit](https://etherscan.io/address/0x70d28b8d6c19f3074a3edf3033f0defa7a4ce4df#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSecretSigner](https://etherscan.io/address/0x70d28b8d6c19f3074a3edf3033f0defa7a4ce4df#code) changes the signer; only the owner can call it.
- The signer at the block is [0xae11…d7ac](https://etherscan.io/address/0xae113b2fa9df869e45f9578ea8b02e0bc30ed7ac), an account without code.

## Reviewer notes

### Mechanism

verifyCommit (AceDice.sol, line 210) recovers a signer on line 217 and tests it on line 217 against the signer it keeps in storage (secretSigner() returns 0xae113b2fa9df869e45f9578ea8b02e0bc30ed7ac). Neither isValidSignature selector is in the code, so that account is never asked. setSecretSigner (AceDice.sol, line 166) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2019-06-30, recovering 0xae11…d7ac; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
