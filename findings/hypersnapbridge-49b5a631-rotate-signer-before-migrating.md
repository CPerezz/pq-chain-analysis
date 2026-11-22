---
id: hypersnapbridge-49b5a631-rotate-signer-before-migrating
format: 2
title: 'HypersnapBridge: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x49b5a631f54927c0007232844f06fe18cbf69786'
  name: HypersnapBridge
  code: verified
  code_url: https://etherscan.io/address/0xe9a747d64790d3ed0b647455b2f7503636f5e98a#code
  proxy_of: '0xe9a747d64790d3ed0b647455b2f7503636f5e98a'
  copies: 2
  family: 5fe4b0da0d53f256e93e305a83b3813e
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 16799
impact: liveness
action: Replace the signer with rotateOwner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xe9a747d64790d3ed0b647455b2f7503636f5e98a'
  file: src/HypersnapBridge.sol
  line: 194
  has: if (digest.recover(ownerSig) != ownerAddress) revert BadOwnerSignature();
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe9a747d64790d3ed0b647455b2f7503636f5e98a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe9a747d64790d3ed0b647455b2f7503636f5e98a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xe9a747d64790d3ed0b647455b2f7503636f5e98a'
  file: src/HypersnapBridge.sol
  line: 229
  has: function rotateOwner
  says: rotateOwner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x49b5a631f54927c0007232844f06fe18cbf69786'
  fn: ownerAddress()(address)
  is: '0x32d1550efcf63edd8f570b8418ac7c21fc6785e8'
  says: The signer it keeps in storage is 0x32d1550efcf63edd8f570b8418ac7c21fc6785e8 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x32d1550efcf63edd8f570b8418ac7c21fc6785e8'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xfe64bd03e1f5b9fe0d1491ce4a2ec19c325c2a8f1feeacb27646411dc5d0e82a'
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

HypersnapBridge accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. rotateOwner changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0xe9a747d64790d3ed0b647455b2f7503636f5e98a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [rotateOwner](https://etherscan.io/address/0xe9a747d64790d3ed0b647455b2f7503636f5e98a#code) changes the signer.
- The signer at the block is [0x32d1…85e8](https://etherscan.io/address/0x32d1550efcf63edd8f570b8418ac7c21fc6785e8), an account without code.

## Reviewer notes

### Mechanism

claim (src/HypersnapBridge.sol, line 173) recovers a signer on line 194 and tests it on line 194 against the signer it keeps in storage (ownerAddress() returns 0x32d1550efcf63edd8f570b8418ac7c21fc6785e8). Neither isValidSignature selector is in the code, so that account is never asked. rotateOwner (src/HypersnapBridge.sol, line 229) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x32d1…85e8; 16,799 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
