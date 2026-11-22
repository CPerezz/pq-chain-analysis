---
id: kunagueroraffle-40eb4f15-rotate-signer-before-migrating
format: 2
title: 'KunAgueroRaffle: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x40eb4f159260a71c262446b10cc5c93d1c1d1d15'
  name: KunAgueroRaffle
  code: verified
  code_url: https://etherscan.io/address/0x8d966966fc0c1bd802c9c792a11cfb58e868cd00#code
  proxy_of: '0x8d966966fc0c1bd802c9c792a11cfb58e868cd00'
  copies: 2
  family: 7b24bf0c99b1a05c215c176ee1b17455
  upgradeable: 'yes'
  admin: '0x99f3de8ed4bbd592407a912282db74ba58389c88'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 58
impact: liveness
action: Replace the signer with setSignAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x8d966966fc0c1bd802c9c792a11cfb58e868cd00'
  file: contracts/GenericRaffle.sol
  line: 117
  has: checkSignature(_wallet, _signatureId, address(this), block.chainid, _signature) == signAddress,
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8d966966fc0c1bd802c9c792a11cfb58e868cd00'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8d966966fc0c1bd802c9c792a11cfb58e868cd00'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x8d966966fc0c1bd802c9c792a11cfb58e868cd00'
  file: contracts/GenericRaffle.sol
  line: 269
  has: function setSignAddress
  says: setSignAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x40eb4f159260a71c262446b10cc5c93d1c1d1d15'
  fn: signAddress()(address)
  is: '0xd07f9e2c929f9fd4b373ed6451fac2ce51ece28a'
  says: The signer it keeps in storage is 0xd07f9e2c929f9fd4b373ed6451fac2ce51ece28a at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xd07f9e2c929f9fd4b373ed6451fac2ce51ece28a'
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

KunAgueroRaffle accepts a call to mint only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSignAddress changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0x8d966966fc0c1bd802c9c792a11cfb58e868cd00#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSignAddress](https://etherscan.io/address/0x8d966966fc0c1bd802c9c792a11cfb58e868cd00#code) changes the signer; only the owner can call it.
- The signer at the block is [0xd07f…e28a](https://etherscan.io/address/0xd07f9e2c929f9fd4b373ed6451fac2ce51ece28a), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/GenericRaffle.sol, line 106) recovers a signer on line 117 and tests it on line 117 against the signer it keeps in storage (signAddress() returns 0xd07f9e2c929f9fd4b373ed6451fac2ce51ece28a). Neither isValidSignature selector is in the code, so that account is never asked. setSignAddress (contracts/GenericRaffle.sol, line 269) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-04-06, recovering 0xd07f…e28a; 58 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
