---
id: beastitemdrop-21273b83-rotate-signer-before-migrating
format: 2
title: 'BeastItemDrop: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x21273b83b8009165a6c2c58bb493843022d581a2'
  name: BeastItemDrop
  code: verified
  code_url: https://etherscan.io/address/0x21273b83b8009165a6c2c58bb493843022d581a2#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8a332ae28897374d04d80c9617dd99e46e8fea5a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setRewardSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x21273b83b8009165a6c2c58bb493843022d581a2'
  file: project/contracts/BeastItemDrop.sol
  line: 53
  has: if (ECDSA.recover(digest, signature) != rewardSigner) revert InvalidSignature();
  says: claimDrop recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x21273b83b8009165a6c2c58bb493843022d581a2'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x21273b83b8009165a6c2c58bb493843022d581a2'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x21273b83b8009165a6c2c58bb493843022d581a2'
  file: project/contracts/BeastItemDrop.sol
  line: 60
  has: function setRewardSigner
  says: setRewardSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x21273b83b8009165a6c2c58bb493843022d581a2'
  fn: rewardSigner()(address)
  is: '0x8a332ae28897374d04d80c9617dd99e46e8fea5a'
  says: The signer it keeps in storage is 0x8a332ae28897374d04d80c9617dd99e46e8fea5a at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x8a332ae28897374d04d80c9617dd99e46e8fea5a'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x2b55203ea7d0d9c1642afb4f8d534bdb86afbfe0483262909aedb772cdc556bf'
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

BeastItemDrop accepts a call to claimDrop only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setRewardSigner changes the signer.

## Evidence

- [claimDrop](https://etherscan.io/address/0x21273b83b8009165a6c2c58bb493843022d581a2#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setRewardSigner](https://etherscan.io/address/0x21273b83b8009165a6c2c58bb493843022d581a2#code) changes the signer; only the owner can call it.
- The signer at the block is [0x8a33…ea5a](https://etherscan.io/address/0x8a332ae28897374d04d80c9617dd99e46e8fea5a), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

claimDrop (project/contracts/BeastItemDrop.sol, line 38) recovers a signer on line 53 and tests it on line 53 against the signer it keeps in storage (rewardSigner() returns 0x8a332ae28897374d04d80c9617dd99e46e8fea5a). Neither isValidSignature selector is in the code, so that account is never asked. setRewardSigner (project/contracts/BeastItemDrop.sol, line 60) writes it. The signer's account holds an EIP-7702 delegation to 0x63c0c19a282a1b52b07dd5a65b58948a07dae32b. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-09, recovering 0x8a33…ea5a; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
