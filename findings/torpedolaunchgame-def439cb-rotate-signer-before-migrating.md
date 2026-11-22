---
id: torpedolaunchgame-def439cb-rotate-signer-before-migrating
format: 2
title: 'TorpedoLaunchGame: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdef439cb500cfba0b66d29592776cb2df40c1cf1'
  name: TorpedoLaunchGame
  code: verified
  code_url: https://etherscan.io/address/0xdef439cb500cfba0b66d29592776cb2df40c1cf1#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8f7c64c3068c95b26cc9472771cb108bfa45b7fb'
value:
  usd: 347
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with changeSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xdef439cb500cfba0b66d29592776cb2df40c1cf1'
  file: TorpedoLaunchGame.sol
  line: 723
  has: if (block.number>=_PlayerGameRound.torpedoBatchBlockTimeout || (ecrecover(keccak256(abi.encodePacked( gamevar.
  says: coreValidTorpedoScore recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdef439cb500cfba0b66d29592776cb2df40c1cf1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdef439cb500cfba0b66d29592776cb2df40c1cf1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xdef439cb500cfba0b66d29592776cb2df40c1cf1'
  file: TorpedoLaunchGame.sol
  line: 231
  has: function changeSigner
  says: changeSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xdef439cb500cfba0b66d29592776cb2df40c1cf1'
  fn: signerAuthority()(address)
  is: '0xf77444ce64f3f46ba6b63f6b9411df9c589e3319'
  says: The signer it keeps in storage is 0xf77444ce64f3f46ba6b63f6b9411df9c589e3319 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xf77444ce64f3f46ba6b63f6b9411df9c589e3319'
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

TorpedoLaunchGame checks an ECDSA signature in coreValidTorpedoScore and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeSigner changes the signer.

## Evidence

- [coreValidTorpedoScore](https://etherscan.io/address/0xdef439cb500cfba0b66d29592776cb2df40c1cf1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeSigner](https://etherscan.io/address/0xdef439cb500cfba0b66d29592776cb2df40c1cf1#code) changes the signer; only the owner can call it.
- The signer at the block is [0xf774…3319](https://etherscan.io/address/0xf77444ce64f3f46ba6b63f6b9411df9c589e3319), an account without code.

## Reviewer notes

### Mechanism

coreValidTorpedoScore (TorpedoLaunchGame.sol, line 702) recovers a signer on line 723 and tests it on line 723 against the signer it keeps in storage (signerAuthority() returns 0xf77444ce64f3f46ba6b63f6b9411df9c589e3319). Neither isValidSignature selector is in the code, so that account is never asked. changeSigner (TorpedoLaunchGame.sol, line 231) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2019-07-11, recovering 0xf774…3319; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
