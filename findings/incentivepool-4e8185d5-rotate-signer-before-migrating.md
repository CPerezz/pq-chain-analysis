---
id: incentivepool-4e8185d5-rotate-signer-before-migrating
format: 2
title: 'IncentivePool: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4e8185d58821d92d535c215f964caf194687b76c'
  name: IncentivePool
  code: verified
  code_url: https://etherscan.io/address/0x4e8185d58821d92d535c215f964caf194687b76c#code
  copies: 2
  family: 15adea55b4ab75157ee9d9466490208c
  upgradeable: 'no'
  admin: '0x7192b7f440c00098ab3f8a4acde6bcbcde6f3b8c'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setRewardSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x4e8185d58821d92d535c215f964caf194687b76c'
  file: src/base/IncentivePool.sol
  line: 209
  has: (address recovered, ECDSA.RecoverError err,) = ECDSA.tryRecover(ethSignedHash, signature);
  says: _checkSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4e8185d58821d92d535c215f964caf194687b76c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4e8185d58821d92d535c215f964caf194687b76c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x4e8185d58821d92d535c215f964caf194687b76c'
  file: src/base/IncentivePool.sol
  line: 210
  has: if (err != ECDSA.RecoverError.NoError) return false;
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x4e8185d58821d92d535c215f964caf194687b76c'
  file: src/base/IncentivePool.sol
  line: 75
  has: function setRewardSigner
  says: setRewardSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x4e8185d58821d92d535c215f964caf194687b76c'
  fn: rewardSigner()(address)
  is: '0x68c9dc0f702fec5f4f2dd0f4b8de38bd1eacd377'
  says: The signer it keeps in storage is 0x68c9dc0f702fec5f4f2dd0f4b8de38bd1eacd377 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x68c9dc0f702fec5f4f2dd0f4b8de38bd1eacd377'
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

IncentivePool checks an ECDSA signature in _checkSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setRewardSigner changes the signer.

## Evidence

- [_checkSignature](https://etherscan.io/address/0x4e8185d58821d92d535c215f964caf194687b76c#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setRewardSigner](https://etherscan.io/address/0x4e8185d58821d92d535c215f964caf194687b76c#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x68c9…d377](https://etherscan.io/address/0x68c9dc0f702fec5f4f2dd0f4b8de38bd1eacd377), an account without code.

## Reviewer notes

### Mechanism

_checkSignature (src/base/IncentivePool.sol, line 193) recovers a signer on line 209 and tests it on line 210 against the signer it keeps in storage (rewardSigner() returns 0x68c9dc0f702fec5f4f2dd0f4b8de38bd1eacd377). Neither isValidSignature selector is in the code, so that account is never asked. setRewardSigner (src/base/IncentivePool.sol, line 75) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
