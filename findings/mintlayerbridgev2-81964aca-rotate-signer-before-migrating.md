---
id: mintlayerbridgev2-81964aca-rotate-signer-before-migrating
format: 2
title: 'MintlayerBridgeV2: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x81964aca18bc56a4494a9203fb8eed9fa44d9330'
  name: MintlayerBridgeV2
  code: verified
  code_url: https://etherscan.io/address/0x81964aca18bc56a4494a9203fb8eed9fa44d9330#code
  copies: 1
  admin: '0xfe50faddda6f2ff3a06e6fe7067867ec8d02f265'
value:
  usd: 38
  basis: held
activity:
  txs_90d: 43
impact: liveness
action: Before a signer's account moves to real code, use executeValidatorChange so that another key can sign in
  its place.
evidence_level: source
checks:
- id: recover
  source: '0x81964aca18bc56a4494a9203fb8eed9fa44d9330'
  file: contracts/MintlayerBridgeV2.sol
  line: 227
  has: address signer = ECDSA.recover(digest, sigs[i]);
  says: _verifyQuorum recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x81964aca18bc56a4494a9203fb8eed9fa44d9330'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x81964aca18bc56a4494a9203fb8eed9fa44d9330'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x81964aca18bc56a4494a9203fb8eed9fa44d9330'
  file: contracts/MintlayerBridgeV2.sol
  line: 334
  has: function executeValidatorChange
  says: executeValidatorChange changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x985f5297ad9e3ad641aa71e35e7fdde34ae9c7d5'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x28029177672f17cc50fd6df5061bdd3ea95810b1e9fa785575e7baff7e57fb19'
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

MintlayerBridgeV2 checks an ECDSA signature in _verifyQuorum and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. executeValidatorChange changes who may sign.

## Evidence

- [_verifyQuorum](https://etherscan.io/address/0x81964aca18bc56a4494a9203fb8eed9fa44d9330#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [executeValidatorChange](https://etherscan.io/address/0x81964aca18bc56a4494a9203fb8eed9fa44d9330#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x28029177672f17cc50fd6df5061bdd3ea95810b1e9fa785575e7baff7e57fb19) on record recovered [0x985f…c7d5](https://etherscan.io/address/0x985f5297ad9e3ad641aa71e35e7fdde34ae9c7d5), an account without code.

## Reviewer notes

### Mechanism

_verifyQuorum (contracts/MintlayerBridgeV2.sol, line 223) recovers a signer on line 227 and tests it on line 227 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. executeValidatorChange (contracts/MintlayerBridgeV2.sol, line 334) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-11, recovering 0x985f…c7d5; 43 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
