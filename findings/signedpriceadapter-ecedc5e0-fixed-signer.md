---
id: signedpriceadapter-ecedc5e0-fixed-signer
format: 2
title: 'SignedPriceAdapter: its signer cannot be replaced and must not take real code'
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
  address: '0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c'
  name: SignedPriceAdapter
  code: verified
  code_url: https://etherscan.io/address/0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c#code
  copies: 90
  family: 5317f1d06e22de0f1c9f575cd66b87fe
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 286
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c'
  file: src/adapters/SignedPriceAdapter.sol
  line: 76
  has: address recovered = ecrecover(digest, v, r, s);
  says: post recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c'
  file: src/adapters/SignedPriceAdapter.sol
  line: 77
  has: if (recovered == address(0) || recovered != signer) revert BadSignature();
  says: the recovered address must be a signer fixed at deployment
  for:
  - evidence-1
  - justification
  - what
- id: written
  source: '0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c'
  file: src/adapters/SignedPriceAdapter.sol
  line: 42
  has: signer = _signer;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c'
  fn: signer()(address)
  is: '0x2f30f7911f5d53c6284e380f3df8fd40b1cca35f'
  says: A signer fixed at deployment is 0x2f30f7911f5d53c6284e380f3df8fd40b1cca35f at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x2f30f7911f5d53c6284e380f3df8fd40b1cca35f'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xc61e01cd60fddaf8bb6fa266cdde156afc0cff6f23c9bff1d06d1c73dc5f42fc'
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

SignedPriceAdapter accepts a call to post only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [post](https://etherscan.io/address/0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0x2f30…a35f](https://etherscan.io/address/0x2f30f7911f5d53c6284e380f3df8fd40b1cca35f), an account without code.

## Reviewer notes

### Mechanism

post (src/adapters/SignedPriceAdapter.sol, line 61) recovers a signer on line 76 and tests it on line 77 against a signer fixed at deployment (signer() returns 0x2f30f7911f5d53c6284e380f3df8fd40b1cca35f). Neither isValidSignature selector is in the code, so that account is never asked. signer is written on line 42 of src/adapters/SignedPriceAdapter.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 90 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0x2f30…a35f; 286 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
