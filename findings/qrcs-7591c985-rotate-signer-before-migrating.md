---
id: qrcs-7591c985-rotate-signer-before-migrating
format: 2
title: 'QRCs: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7591c9855cbd54fea59252f8ba6cdfde06afab36'
  name: QRCs
  code: verified
  code_url: https://etherscan.io/address/0xdda7cca35093cc4793c9dbec3aa29c3d83ac247d#code
  proxy_of: '0xdda7cca35093cc4793c9dbec3aa29c3d83ac247d'
  copies: 2
  family: eb5c95dd007ac250c8a61e09f96398ec
  upgradeable: 'yes'
  admin: '0x0a0a2b62f8d2bc0f3cc04591a062978516d18c51'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1226
impact: liveness
action: Replace the signer with setClaimSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xdda7cca35093cc4793c9dbec3aa29c3d83ac247d'
  file: src/QRCs.sol
  line: 251
  has: if (ECDSA.recover(messageHash, signature) != claimSigner) revert InvalidSignature();
  says: claimMonthly recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdda7cca35093cc4793c9dbec3aa29c3d83ac247d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdda7cca35093cc4793c9dbec3aa29c3d83ac247d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xdda7cca35093cc4793c9dbec3aa29c3d83ac247d'
  file: src/QRCs.sol
  line: 467
  has: function setClaimSigner
  says: setClaimSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x7591c9855cbd54fea59252f8ba6cdfde06afab36'
  fn: claimSigner()(address)
  is: '0x3e74852e08e8009363725ed418ee3bb1e8cb143c'
  says: The signer it keeps in storage is 0x3e74852e08e8009363725ed418ee3bb1e8cb143c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x3e74852e08e8009363725ed418ee3bb1e8cb143c'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x17141698b98c061d586050bd4029c7f158bdfe152c163ab3514c3f6bee144140'
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

QRCs accepts a call to claimMonthly only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setClaimSigner changes the signer.

## Evidence

- [claimMonthly](https://etherscan.io/address/0xdda7cca35093cc4793c9dbec3aa29c3d83ac247d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setClaimSigner](https://etherscan.io/address/0xdda7cca35093cc4793c9dbec3aa29c3d83ac247d#code) changes the signer; only the owner can call it.
- The signer at the block is [0x3e74…143c](https://etherscan.io/address/0x3e74852e08e8009363725ed418ee3bb1e8cb143c), an account without code.

## Reviewer notes

### Mechanism

claimMonthly (src/QRCs.sol, line 241) recovers a signer on line 251 and tests it on line 251 against the signer it keeps in storage (claimSigner() returns 0x3e74852e08e8009363725ed418ee3bb1e8cb143c). Neither isValidSignature selector is in the code, so that account is never asked. setClaimSigner (src/QRCs.sol, line 467) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-09, recovering 0x3e74…143c; 1,226 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
