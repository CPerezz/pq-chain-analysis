---
id: drilltakeback-8d7af9d2-rotate-signer-before-migrating
format: 2
title: 'DrillTakeBack: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8d7af9d2310016712b8f269df266f957cb12a27b'
  name: DrillTakeBack
  code: verified
  code_url: https://etherscan.io/address/0x8d7af9d2310016712b8f269df266f957cb12a27b#code
  copies: 1
  upgradeable: 'no'
  admin: '0x506e387a005d2bcb65216d1f33efcfffa7167ef5'
value:
  usd: 40
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with changeSupervisor before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x8d7af9d2310016712b8f269df266f957cb12a27b'
  file: DrillTakeBack.sol
  line: 444
  has: supervisor == _verify(_hashmessage, _v, _r, _s),
  says: takeBack recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8d7af9d2310016712b8f269df266f957cb12a27b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8d7af9d2310016712b8f269df266f957cb12a27b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x8d7af9d2310016712b8f269df266f957cb12a27b'
  file: DrillTakeBack.sol
  line: 575
  has: function changeSupervisor
  says: changeSupervisor changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x8d7af9d2310016712b8f269df266f957cb12a27b'
  fn: supervisor()(address)
  is: '0x536deacedc6e972822b9e78571786b5a6dd10c8a'
  says: The signer it keeps in storage is 0x536deacedc6e972822b9e78571786b5a6dd10c8a at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x536deacedc6e972822b9e78571786b5a6dd10c8a'
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

DrillTakeBack accepts a call to takeBack only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. changeSupervisor changes the signer.

## Evidence

- [takeBack](https://etherscan.io/address/0x8d7af9d2310016712b8f269df266f957cb12a27b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [changeSupervisor](https://etherscan.io/address/0x8d7af9d2310016712b8f269df266f957cb12a27b#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x536d…0c8a](https://etherscan.io/address/0x536deacedc6e972822b9e78571786b5a6dd10c8a), an account without code.

## Reviewer notes

### Mechanism

takeBack (DrillTakeBack.sol, line 433) recovers a signer on line 444 and tests it on line 444 against the signer it keeps in storage (supervisor() returns 0x536deacedc6e972822b9e78571786b5a6dd10c8a). Neither isValidSignature selector is in the code, so that account is never asked. changeSupervisor (DrillTakeBack.sol, line 575) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-08-08, recovering 0x536d…0c8a; 0 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
