---
id: artcollectionfactory-7b06a97c-rotate-signer-before-migrating
format: 2
title: 'ArtCollectionFactory: no signer is set at the block'
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
  address: '0x7b06a97c980076feb6d9cd54e1cc0707bd5b4b2c'
  name: ArtCollectionFactory
  code: verified
  code_url: https://etherscan.io/address/0xbad9767fa6e830f89adfe3da7a44314d549b7c59#code
  proxy_of: '0xbad9767fa6e830f89adfe3da7a44314d549b7c59'
  copies: 2
  family: 6c50655c8b72ed99c9fc41399cd3a48f
  upgradeable: 'yes'
  admin: '0x7a9375e6888e2cb94921493868e3fcd07ef59371'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: If a signer is set again, replace it with setVoucherSigner before its account moves to real code.
evidence_level: source
checks:
- id: recover
  source: '0xbad9767fa6e830f89adfe3da7a44314d549b7c59'
  file: src/ArtCollectionFactory.sol
  line: 164
  has: address signer = ECDSA.recover(_hashTypedDataV4(structHash), signature);
  says: createCollectionWithVoucher recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xbad9767fa6e830f89adfe3da7a44314d549b7c59'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xbad9767fa6e830f89adfe3da7a44314d549b7c59'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xbad9767fa6e830f89adfe3da7a44314d549b7c59'
  file: src/ArtCollectionFactory.sol
  line: 165
  has: if (signer == address(0) || signer != voucherSigner) revert InvalidVoucherSigner();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xbad9767fa6e830f89adfe3da7a44314d549b7c59'
  file: src/ArtCollectionFactory.sol
  line: 236
  has: function setVoucherSigner
  says: setVoucherSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x7b06a97c980076feb6d9cd54e1cc0707bd5b4b2c'
  fn: voucherSigner()(address)
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

ArtCollectionFactory accepts a call to createCollectionWithVoucher only with an ECDSA signature of the signer it keeps in storage. No signer is set at the block; setVoucherSigner sets one. A signer set later is refused once its account takes real code; an EIP-7702 delegation keeps working.

## Evidence

- [createCollectionWithVoucher](https://etherscan.io/address/0xbad9767fa6e830f89adfe3da7a44314d549b7c59#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVoucherSigner](https://etherscan.io/address/0xbad9767fa6e830f89adfe3da7a44314d549b7c59#code) sets the signer; only a role holder can call it.
- No signer is set at the block: [voucherSigner()](https://etherscan.io/address/0x7b06a97c980076feb6d9cd54e1cc0707bd5b4b2c#readContract) returns the zero address.

## Reviewer notes

### Mechanism

createCollectionWithVoucher (src/ArtCollectionFactory.sol, line 152) recovers a signer on line 164 and tests it on line 165 against the signer it keeps in storage (voucherSigner() returns 0x0000000000000000000000000000000000000000). Neither isValidSignature selector is in the code, so that account is never asked. setVoucherSigner (src/ArtCollectionFactory.sol, line 236) writes it. No signer is set at the block. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
