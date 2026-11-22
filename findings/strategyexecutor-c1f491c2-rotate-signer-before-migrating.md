---
id: strategyexecutor-c1f491c2-rotate-signer-before-migrating
format: 2
title: 'StrategyExecutor: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc1f491c2520b8789e21df10cb790cc4367a40f6f'
  name: StrategyExecutor
  code: verified
  code_url: https://etherscan.io/address/0xc1f491c2520b8789e21df10cb790cc4367a40f6f#code
  copies: 1
  admin: '0x28852645b87445e103c62d41b0b6420fba047488'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setPlanSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xc1f491c2520b8789e21df10cb790cc4367a40f6f'
  file: src/StrategyExecutor.sol
  line: 248
  has: if (_recoverSigner(planDigest(plan), authorization) != planSigner) revert InvalidPlanSignature();
  says: _beginPlan recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc1f491c2520b8789e21df10cb790cc4367a40f6f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc1f491c2520b8789e21df10cb790cc4367a40f6f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xc1f491c2520b8789e21df10cb790cc4367a40f6f'
  file: src/StrategyExecutor.sol
  line: 171
  has: function setPlanSigner
  says: setPlanSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xc1f491c2520b8789e21df10cb790cc4367a40f6f'
  fn: planSigner()(address)
  is: '0x2f3dc6a371bf204027fbfb1a4e94d5244a3766f7'
  says: The signer it keeps in storage is 0x2f3dc6a371bf204027fbfb1a4e94d5244a3766f7 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x2f3dc6a371bf204027fbfb1a4e94d5244a3766f7'
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

StrategyExecutor checks an ECDSA signature in _beginPlan and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPlanSigner changes the signer.

## Evidence

- [_beginPlan](https://etherscan.io/address/0xc1f491c2520b8789e21df10cb790cc4367a40f6f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPlanSigner](https://etherscan.io/address/0xc1f491c2520b8789e21df10cb790cc4367a40f6f#code) changes the signer; only the owner can call it.
- The signer at the block is [0x2f3d…66f7](https://etherscan.io/address/0x2f3dc6a371bf204027fbfb1a4e94d5244a3766f7), an account without code.

## Reviewer notes

### Mechanism

_beginPlan (src/StrategyExecutor.sol, line 241) recovers a signer on line 248 and tests it on line 248 against the signer it keeps in storage (planSigner() returns 0x2f3dc6a371bf204027fbfb1a4e94d5244a3766f7). Neither isValidSignature selector is in the code, so that account is never asked. setPlanSigner (src/StrategyExecutor.sol, line 171) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
