---
id: digitalmediacore-2963ba47-rotate-signer-before-migrating
format: 2
title: 'DigitalMediaCore: no signer is set at the block'
status: confirmed
severity: INFORMATIONAL
justification: Nothing can break while no signer is set; one set later can be replaced before its account moves
  to real code.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2963ba471e265e5f51cafafca78310fe87f8e6d1'
  name: DigitalMediaCore
  code: verified
  code_url: https://etherscan.io/address/0x2963ba471e265e5f51cafafca78310fe87f8e6d1#code
  copies: 2
  family: cdaac043f1cd0308ba25e09afd6a6207
  upgradeable: 'no'
  admin: '0xc03fa0fae82b7076b45c7179b3f08a9b5d2ba806'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 120
impact: liveness
action: If a signer is set again, replace it with setSignerAddress before its account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0x2963ba471e265e5f51cafafca78310fe87f8e6d1'
  file: DigitalMediaCore.sol
  line: 2269
  has: address addressWhoSigned = encodedRequest.recover(signature);
  says: _verifyReleaseRequestSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2963ba471e265e5f51cafafca78310fe87f8e6d1'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2963ba471e265e5f51cafafca78310fe87f8e6d1'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x2963ba471e265e5f51cafafca78310fe87f8e6d1'
  file: DigitalMediaCore.sol
  line: 2270
  has: require(addressWhoSigned == signerAddress, "sig error");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x2963ba471e265e5f51cafafca78310fe87f8e6d1'
  file: DigitalMediaCore.sol
  line: 1665
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2963ba471e265e5f51cafafca78310fe87f8e6d1'
  fn: signerAddress()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: no signer is set at the block
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

DigitalMediaCore checks an ECDSA signature in _verifyReleaseRequestSignature and accepts only the signer it keeps in storage. No signer is set at the block; setSignerAddress sets one. A signer set later is refused once its account takes real code; an EIP-7702 delegation keeps working.

## Evidence

- [_verifyReleaseRequestSignature](https://etherscan.io/address/0x2963ba471e265e5f51cafafca78310fe87f8e6d1#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x2963ba471e265e5f51cafafca78310fe87f8e6d1#code) sets the signer.
- No signer is set at the block: [signerAddress()](https://etherscan.io/address/0x2963ba471e265e5f51cafafca78310fe87f8e6d1#readContract) returns the zero address.

## Reviewer notes

### Mechanism

_verifyReleaseRequestSignature (DigitalMediaCore.sol, line 2264) recovers a signer on line 2269 and tests it on line 2270 against the signer it keeps in storage (signerAddress() returns 0x0000000000000000000000000000000000000000). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (DigitalMediaCore.sol, line 1665) writes it. No signer is set at the block. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 120 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
