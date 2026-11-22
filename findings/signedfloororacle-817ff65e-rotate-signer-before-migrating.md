---
id: signedfloororacle-817ff65e-rotate-signer-before-migrating
format: 2
title: 'SignedFloorOracle: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x817ff65e805ae0ea840684e5816fd259b9fa5828'
  name: SignedFloorOracle
  code: verified
  code_url: https://etherscan.io/address/0x817ff65e805ae0ea840684e5816fd259b9fa5828#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4681bc290803b49f79fe7f7acbdc5a7452a32070'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13
impact: liveness
action: Before a signer's account moves to real code, use setSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x817ff65e805ae0ea840684e5816fd259b9fa5828'
  file: src/SignedFloorOracle.sol
  line: 81
  has: address recovered = ECDSA.recover(digest, signature);
  says: postFloor recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x817ff65e805ae0ea840684e5816fd259b9fa5828'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x817ff65e805ae0ea840684e5816fd259b9fa5828'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x817ff65e805ae0ea840684e5816fd259b9fa5828'
  file: src/SignedFloorOracle.sol
  line: 82
  has: if (!isSigner[recovered]) revert BadSigner(recovered);
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x817ff65e805ae0ea840684e5816fd259b9fa5828'
  file: src/SignedFloorOracle.sol
  line: 59
  has: function setSigner
  says: setSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x0db68fc67bf730f54e3e795a3589b05ea6a6bdf9'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x5c15f11002f56193ac3acc80a450802880839b80e1b7e35a9c7603969c4980b3'
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

SignedFloorOracle accepts a call to postFloor only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes who may sign.

## Evidence

- [postFloor](https://etherscan.io/address/0x817ff65e805ae0ea840684e5816fd259b9fa5828#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x817ff65e805ae0ea840684e5816fd259b9fa5828#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x5c15f11002f56193ac3acc80a450802880839b80e1b7e35a9c7603969c4980b3) on record recovered [0x0db6…bdf9](https://etherscan.io/address/0x0db68fc67bf730f54e3e795a3589b05ea6a6bdf9), an account without code.

## Reviewer notes

### Mechanism

postFloor (src/SignedFloorOracle.sol, line 66) recovers a signer on line 81 and tests it on line 82 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/SignedFloorOracle.sol, line 59) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-30, recovering 0x0db6…bdf9; 13 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
