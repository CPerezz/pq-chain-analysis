---
id: fusingfeeescrow-58bf4846-rotate-signer-before-migrating
format: 2
title: 'FusingFeeEscrow: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x58bf4846d583f10b4ac62edc35fd8f5a931d2b74'
  name: FusingFeeEscrow
  code: verified
  code_url: https://etherscan.io/address/0x58bf4846d583f10b4ac62edc35fd8f5a931d2b74#code
  copies: 5
  family: 3912b5111bcee11620d155bef33510a1
  upgradeable: 'no'
  admin: '0x99f4fdc4c93d174f4a072386cfbd22d2d3d0336c'
value:
  usd: 2
  basis: held
activity:
  txs_90d: 9
impact: liveness
action: Replace the signer with setAttester before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x58bf4846d583f10b4ac62edc35fd8f5a931d2b74'
  file: src/v2/FusingFeeEscrow.sol
  line: 175
  has: if (_recover(digest, signature) != attester) revert BadAttestation();
  says: claimHandle recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x58bf4846d583f10b4ac62edc35fd8f5a931d2b74'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x58bf4846d583f10b4ac62edc35fd8f5a931d2b74'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x58bf4846d583f10b4ac62edc35fd8f5a931d2b74'
  file: src/v2/FusingFeeEscrow.sol
  line: 146
  has: function setAttester
  says: setAttester changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x58bf4846d583f10b4ac62edc35fd8f5a931d2b74'
  fn: attester()(address)
  is: '0x62b706be44cc47e4a392f815157a2f135911e383'
  says: The signer it keeps in storage is 0x62b706be44cc47e4a392f815157a2f135911e383 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x62b706be44cc47e4a392f815157a2f135911e383'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x68fd8bd6e6904b6d42fbdc94a562ec4c979dd4ee2fb9328965ed77f8cb389a6e'
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

FusingFeeEscrow accepts a call to claimHandle only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAttester changes the signer.

## Evidence

- [claimHandle](https://etherscan.io/address/0x58bf4846d583f10b4ac62edc35fd8f5a931d2b74#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAttester](https://etherscan.io/address/0x58bf4846d583f10b4ac62edc35fd8f5a931d2b74#code) changes the signer.
- The signer at the block is [0x62b7…e383](https://etherscan.io/address/0x62b706be44cc47e4a392f815157a2f135911e383), an account without code.

## Reviewer notes

### Mechanism

claimHandle (src/v2/FusingFeeEscrow.sol, line 167) recovers a signer on line 175 and tests it on line 175 against the signer it keeps in storage (attester() returns 0x62b706be44cc47e4a392f815157a2f135911e383). Neither isValidSignature selector is in the code, so that account is never asked. setAttester (src/v2/FusingFeeEscrow.sol, line 146) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-01, recovering 0x62b7…e383; 9 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
