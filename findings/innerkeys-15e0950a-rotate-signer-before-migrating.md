---
id: innerkeys-15e0950a-rotate-signer-before-migrating
format: 2
title: 'InnerKeys: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8'
  name: InnerKeys
  code: verified
  code_url: https://etherscan.io/address/0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8#code
  copies: 1
  admin: '0xb64024365227e712a87bd2579fa2ac0286c98a1c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Replace the signer with setXAttester before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8'
  file: src/InnerKeys.sol
  line: 216
  has: (address signer, ECDSA.RecoverError err, ) = ECDSA.tryRecover(
  says: launch recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8'
  file: src/InnerKeys.sol
  line: 220
  has: if (err != ECDSA.RecoverError.NoError || signer != xAttester) revert BadXAttestation();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8'
  file: src/InnerKeys.sol
  line: 128
  has: function setXAttester
  says: setXAttester changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8'
  fn: xAttester()(address)
  is: '0x5d547b1bdaa27c1cefac3eb16a89499a26739045'
  says: The signer it keeps in storage is 0x5d547b1bdaa27c1cefac3eb16a89499a26739045 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x5d547b1bdaa27c1cefac3eb16a89499a26739045'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x4edd52bdf62b1dde1f486f5623be3ce6833a33291f5ce8ba52b343f775a7f867'
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

InnerKeys accepts a call to launch only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setXAttester changes the signer.

## Evidence

- [launch](https://etherscan.io/address/0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setXAttester](https://etherscan.io/address/0x15e0950ac0fd0cebfd63a9deac5e0bf44f10d1e8#code) changes the signer; only the owner can call it.
- The signer at the block is [0x5d54…9045](https://etherscan.io/address/0x5d547b1bdaa27c1cefac3eb16a89499a26739045), an account without code.

## Reviewer notes

### Mechanism

launch (src/InnerKeys.sol, line 210) recovers a signer on line 216 and tests it on line 220 against the signer it keeps in storage (xAttester() returns 0x5d547b1bdaa27c1cefac3eb16a89499a26739045). Neither isValidSignature selector is in the code, so that account is never asked. setXAttester (src/InnerKeys.sol, line 128) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-01, recovering 0x5d54…9045; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
