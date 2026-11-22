---
id: raregotchitoy-4682e7bd-rotate-signer-before-migrating
format: 2
title: 'RaregotchiToy: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3'
  name: RaregotchiToy
  code: verified
  code_url: https://etherscan.io/address/0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6ac7b8996c2df87cf65775465d5df1e6fcce8435'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setSignerAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3'
  file: contracts/RaregotchiToy.sol
  line: 138
  has: address recoveredWallet = ECDSA.recover(messageHash, _signature);
  says: open recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3'
  file: contracts/RaregotchiToy.sol
  line: 140
  has: recoveredWallet == signerAddress,
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3'
  file: contracts/RaregotchiToy.sol
  line: 105
  has: function setSignerAddress
  says: setSignerAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3'
  fn: signerAddress()(address)
  is: '0x620d373ab386446b36cbe2b5be55a89b6d5b7525'
  says: The signer it keeps in storage is 0x620d373ab386446b36cbe2b5be55a89b6d5b7525 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x620d373ab386446b36cbe2b5be55a89b6d5b7525'
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

RaregotchiToy accepts a call to open only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignerAddress changes the signer.

## Evidence

- [open](https://etherscan.io/address/0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignerAddress](https://etherscan.io/address/0x4682e7bd37be5f35bf2189f16abedc7e12abe9a3#code) changes the signer; only the owner can call it.
- The signer at the block is [0x620d…7525](https://etherscan.io/address/0x620d373ab386446b36cbe2b5be55a89b6d5b7525), an account without code.

## Reviewer notes

### Mechanism

open (contracts/RaregotchiToy.sol, line 122) recovers a signer on line 138 and tests it on line 140 against the signer it keeps in storage (signerAddress() returns 0x620d373ab386446b36cbe2b5be55a89b6d5b7525). Neither isValidSignature selector is in the code, so that account is never asked. setSignerAddress (contracts/RaregotchiToy.sol, line 105) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-01-29, recovering 0x620d…7525; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
