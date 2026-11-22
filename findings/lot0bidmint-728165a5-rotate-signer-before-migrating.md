---
id: lot0bidmint-728165a5-rotate-signer-before-migrating
format: 2
title: 'LOT0BidMint: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x728165a5c727c5823f48f9b7ee0fe519796f6071'
  name: LOT0BidMint
  code: verified
  code_url: https://etherscan.io/address/0x728165a5c727c5823f48f9b7ee0fe519796f6071#code
  copies: 1
  upgradeable: 'no'
  admin: '0xfc40194f7cef68b333a30d4ce2d48bff0503455e'
value:
  usd: 18
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with updateFloorSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x728165a5c727c5823f48f9b7ee0fe519796f6071'
  file: src/LOT0BidMint.sol
  line: 196
  has: if (_recover(hashBidFloor(floorPrice, deadline), signature) != floorSigner) {
  says: bid recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x728165a5c727c5823f48f9b7ee0fe519796f6071'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x728165a5c727c5823f48f9b7ee0fe519796f6071'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x728165a5c727c5823f48f9b7ee0fe519796f6071'
  file: src/LOT0BidMint.sol
  line: 119
  has: function updateFloorSigner
  says: updateFloorSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x728165a5c727c5823f48f9b7ee0fe519796f6071'
  fn: floorSigner()(address)
  is: '0xef7810afb847792e69010d82e8c3dc599686066e'
  says: The signer it keeps in storage is 0xef7810afb847792e69010d82e8c3dc599686066e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xef7810afb847792e69010d82e8c3dc599686066e'
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

LOT0BidMint accepts a call to bid only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateFloorSigner changes the signer.

## Evidence

- [bid](https://etherscan.io/address/0x728165a5c727c5823f48f9b7ee0fe519796f6071#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateFloorSigner](https://etherscan.io/address/0x728165a5c727c5823f48f9b7ee0fe519796f6071#code) changes the signer; only the owner can call it.
- The signer at the block is [0xef78…066e](https://etherscan.io/address/0xef7810afb847792e69010d82e8c3dc599686066e), an account without code.

## Reviewer notes

### Mechanism

bid (src/LOT0BidMint.sol, line 184) recovers a signer on line 196 and tests it on line 196 against the signer it keeps in storage (floorSigner() returns 0xef7810afb847792e69010d82e8c3dc599686066e). Neither isValidSignature selector is in the code, so that account is never asked. updateFloorSigner (src/LOT0BidMint.sol, line 119) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
