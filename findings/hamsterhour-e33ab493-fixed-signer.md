---
id: hamsterhour-e33ab493-fixed-signer
format: 2
title: 'HamsterHour: its signer cannot be replaced and must not take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a signer's account takes real code; the signer is fixed, so a new contract is then
  needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe33ab493249a2df0d8c4a71ac54f46d1f7778367'
  name: HamsterHour
  code: verified
  code_url: https://etherscan.io/address/0xe33ab493249a2df0d8c4a71ac54f46d1f7778367#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1084
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0xe33ab493249a2df0d8c4a71ac54f46d1f7778367'
  file: src/HamsterHour.sol
  line: 541
  has: if (OracleAttestation.recover(attestationDigest(a), signature) != ATTESTER) revert BadSignature();
  says: _recordResult recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xe33ab493249a2df0d8c4a71ac54f46d1f7778367'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xe33ab493249a2df0d8c4a71ac54f46d1f7778367'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: written
  source: '0xe33ab493249a2df0d8c4a71ac54f46d1f7778367'
  file: src/HamsterHour.sol
  line: 257
  has: ATTESTER = attester_;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xe33ab493249a2df0d8c4a71ac54f46d1f7778367'
  fn: ATTESTER()(address)
  is: '0x5598aa9146215bc13eb26f2c692ad1461fd32982'
  says: A signer fixed at deployment is 0x5598aa9146215bc13eb26f2c692ad1461fd32982 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x5598aa9146215bc13eb26f2c692ad1461fd32982'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x2cfb62935b4d56f9c71db8e1f4337a6618e32c41692bc261d2668ebecf14bb2a'
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
  rating: HIGH
reviews: []
related: []
---

## What happens

HamsterHour checks an ECDSA signature in _recordResult and accepts only a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [_recordResult](https://etherscan.io/address/0xe33ab493249a2df0d8c4a71ac54f46d1f7778367#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0xe33ab493249a2df0d8c4a71ac54f46d1f7778367#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x5598…2982](https://etherscan.io/address/0x5598aa9146215bc13eb26f2c692ad1461fd32982), an account without code.

## Reviewer notes

### Mechanism

_recordResult (src/HamsterHour.sol, line 521) recovers a signer on line 541 and tests it on line 541 against a signer fixed at deployment (ATTESTER() returns 0x5598aa9146215bc13eb26f2c692ad1461fd32982). Neither isValidSignature selector is in the code, so that account is never asked. ATTESTER is written on line 257 of src/HamsterHour.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-09, recovering 0x5598…2982; 1,084 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
