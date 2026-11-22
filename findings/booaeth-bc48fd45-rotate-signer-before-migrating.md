---
id: booaeth-bc48fd45-rotate-signer-before-migrating
format: 2
title: 'BOOAEth: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbc48fd45aaaf6549293056606397d351a100b222'
  name: BOOAEth
  code: verified
  code_url: https://etherscan.io/address/0xbc48fd45aaaf6549293056606397d351a100b222#code
  copies: 1
  upgradeable: 'no'
  admin: '0xba7682862fbfbc9e5215462c00a48e486142a77e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1160
impact: liveness
action: Replace the signer with setOperatorSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xbc48fd45aaaf6549293056606397d351a100b222'
  file: contracts/v2-eth/BOOAEth.sol
  line: 122
  has: address signer = digest.recover(signatures[i]);
  says: claim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbc48fd45aaaf6549293056606397d351a100b222'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbc48fd45aaaf6549293056606397d351a100b222'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xbc48fd45aaaf6549293056606397d351a100b222'
  file: contracts/v2-eth/BOOAEth.sol
  line: 137
  has: function setOperatorSigner
  says: setOperatorSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xbc48fd45aaaf6549293056606397d351a100b222'
  fn: operatorSigner()(address)
  is: '0x374999d6ea5c5ab64fe86b0b9400f3a6bc33f2ad'
  says: The signer it keeps in storage is 0x374999d6ea5c5ab64fe86b0b9400f3a6bc33f2ad at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x374999d6ea5c5ab64fe86b0b9400f3a6bc33f2ad'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x99409af6274a8869f2d3f4c73605b73453e6ef18b5a5c7b7da8abde1c94b88b9'
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

BOOAEth accepts a call to claim only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOperatorSigner changes the signer.

## Evidence

- [claim](https://etherscan.io/address/0xbc48fd45aaaf6549293056606397d351a100b222#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOperatorSigner](https://etherscan.io/address/0xbc48fd45aaaf6549293056606397d351a100b222#code) changes the signer; only the owner can call it.
- The signer at the block is [0x3749…f2ad](https://etherscan.io/address/0x374999d6ea5c5ab64fe86b0b9400f3a6bc33f2ad), an account without code.

## Reviewer notes

### Mechanism

claim (contracts/v2-eth/BOOAEth.sol, line 110) recovers a signer on line 122 and tests it on line 122 against the signer it keeps in storage (operatorSigner() returns 0x374999d6ea5c5ab64fe86b0b9400f3a6bc33f2ad). Neither isValidSignature selector is in the code, so that account is never asked. setOperatorSigner (contracts/v2-eth/BOOAEth.sol, line 137) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-10, recovering 0x3749…f2ad; 1,160 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
