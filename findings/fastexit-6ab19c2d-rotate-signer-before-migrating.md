---
id: fastexit-6ab19c2d-rotate-signer-before-migrating
format: 2
title: 'FastExit: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6ab19c2d663d6ccdde65c8abc60d8218a859f0fe'
  name: FastExit
  code: verified
  code_url: https://etherscan.io/address/0x6ab19c2d663d6ccdde65c8abc60d8218a859f0fe#code
  copies: 1
  upgradeable: 'no'
  admin: '0x3ca327262119984d4e3687ea27e36c60741d2090'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with executeAttestor before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6ab19c2d663d6ccdde65c8abc60d8218a859f0fe'
  file: src/FastExit.sol
  line: 99
  has: if (ECDSA.recover(digest, sig) != attestor) revert BadSignature();
  says: onExitTransfer recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6ab19c2d663d6ccdde65c8abc60d8218a859f0fe'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6ab19c2d663d6ccdde65c8abc60d8218a859f0fe'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x6ab19c2d663d6ccdde65c8abc60d8218a859f0fe'
  file: src/FastExit.sol
  line: 154
  has: function executeAttestor
  says: executeAttestor changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x6ab19c2d663d6ccdde65c8abc60d8218a859f0fe'
  fn: attestor()(address)
  is: '0x4890a6d45f7bc639de49c4197f25b6f24b924105'
  says: The signer it keeps in storage is 0x4890a6d45f7bc639de49c4197f25b6f24b924105 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x4890a6d45f7bc639de49c4197f25b6f24b924105'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x1a70df0a8382eee0cd3fedbb3c2c47e116f83e64fc4fd73a2a2eef5ece27dfa4'
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

FastExit accepts a call to onExitTransfer only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. executeAttestor changes the signer.

## Evidence

- [onExitTransfer](https://etherscan.io/address/0x6ab19c2d663d6ccdde65c8abc60d8218a859f0fe#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [executeAttestor](https://etherscan.io/address/0x6ab19c2d663d6ccdde65c8abc60d8218a859f0fe#code) changes the signer; only the owner can call it.
- The signer at the block is [0x4890…4105](https://etherscan.io/address/0x4890a6d45f7bc639de49c4197f25b6f24b924105), an account without code.

## Reviewer notes

### Mechanism

onExitTransfer (src/FastExit.sol, line 89) recovers a signer on line 99 and tests it on line 99 against the signer it keeps in storage (attestor() returns 0x4890a6d45f7bc639de49c4197f25b6f24b924105). Neither isValidSignature selector is in the code, so that account is never asked. executeAttestor (src/FastExit.sol, line 154) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-08, recovering 0x4890…4105; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
