---
id: chilltuna-0735a296-rotate-signer-before-migrating
format: 2
title: 'ChillTuna: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0735a2961eb2b18b28daa72b593dfbaa7f9d1929'
  name: ChillTuna
  code: verified
  code_url: https://etherscan.io/address/0xb80ed4068e4e208a31e088ce66bc89ec85b602c9#code
  proxy_of: '0xb80ed4068e4e208a31e088ce66bc89ec85b602c9'
  copies: 3
  family: 9dee1740e9733aaf452107ff34b6f20b
  upgradeable: 'yes'
  admin: '0x0da48e97958a785b5d8972beef5fe7d7b180ebcd'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 28
impact: liveness
action: Replace the signer with updateSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb80ed4068e4e208a31e088ce66bc89ec85b602c9'
  file: contracts/ChillTuna.sol
  line: 206
  has: .recover(signature) == signerAddress;
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb80ed4068e4e208a31e088ce66bc89ec85b602c9'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb80ed4068e4e208a31e088ce66bc89ec85b602c9'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb80ed4068e4e208a31e088ce66bc89ec85b602c9'
  file: contracts/ChillTuna.sol
  line: 199
  has: function updateSignerAddress
  says: updateSignerAddress changes the signer
  for:
  - action
  - evidence-2
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

ChillTuna checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSignerAddress changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0xb80ed4068e4e208a31e088ce66bc89ec85b602c9#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSignerAddress](https://etherscan.io/address/0xb80ed4068e4e208a31e088ce66bc89ec85b602c9#code) changes the signer; only the owner can call it.

## Reviewer notes

### Mechanism

_verify (contracts/ChillTuna.sol, line 203) recovers a signer on line 206 and tests it on line 206 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. updateSignerAddress (contracts/ChillTuna.sol, line 199) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 28 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
