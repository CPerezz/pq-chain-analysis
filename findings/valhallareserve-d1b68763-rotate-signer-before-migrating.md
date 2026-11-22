---
id: valhallareserve-d1b68763-rotate-signer-before-migrating
format: 2
title: 'ValhallaReserve: no signer is set; replace a later one before it takes real code'
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
  address: '0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17'
  name: ValhallaReserve
  code: verified
  code_url: https://etherscan.io/address/0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17#code
  copies: 1
  upgradeable: 'no'
  admin: '0xff59b4b3d52728f78020414c720164a17c08f499'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 76
impact: liveness
action: If a signer is set again, replace it with setSigner before its account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17'
  file: contracts/Armory.sol
  line: 342
  has: if (hash.recover(sig) != signer) revert InvalidSignature();
  says: mintSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17'
  file: contracts/Armory.sol
  line: 281
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17'
  fn: signer()(address)
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

ValhallaReserve accepts a call to mintSignature only with an ECDSA signature of the signer it keeps in storage. No signer is set at the block; setSigner sets one. A signer set later is refused once its account takes real code; an EIP-7702 delegation keeps working.

## Evidence

- [mintSignature](https://etherscan.io/address/0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17#code) sets the signer; only the owner can call it.
- No signer is set at the block: [signer()](https://etherscan.io/address/0xd1b68763c7170b963ac6ca6b1c2ea25796a18a17#readContract) returns the zero address.

## Reviewer notes

### Mechanism

mintSignature (contracts/Armory.sol, line 308) recovers a signer on line 342 and tests it on line 342 against the signer it keeps in storage (signer() returns 0x0000000000000000000000000000000000000000). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/Armory.sol, line 281) writes it. No signer is set at the block. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 76 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
