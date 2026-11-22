---
id: multichainnft-2020d8b8-rotate-signer-before-migrating
format: 2
title: 'MultiChainNFT: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2020d8b8f4ab500beaffe5e53f02f59fe0e4f137'
  name: MultiChainNFT
  code: verified
  code_url: https://etherscan.io/address/0x7fa2bfc41eccbc4d5d0b19e64aac44b8e59d3d7d#code
  proxy_of: '0x7fa2bfc41eccbc4d5d0b19e64aac44b8e59d3d7d'
  copies: 2
  family: be23c196fb579128e5ff785b51fb01a6
  upgradeable: 'yes'
  admin: '0x6803f083211a00bfe5062042485c469dae6f3cec'
value:
  usd: 172
  basis: held
activity:
  txs_90d: 12
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x7fa2bfc41eccbc4d5d0b19e64aac44b8e59d3d7d'
  file: contracts/MultiChainNFT.sol
  line: 87
  has: bool verified = ecrecover(keccak256(
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x7fa2bfc41eccbc4d5d0b19e64aac44b8e59d3d7d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x7fa2bfc41eccbc4d5d0b19e64aac44b8e59d3d7d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x7fa2bfc41eccbc4d5d0b19e64aac44b8e59d3d7d'
  file: contracts/MultiChainNFT.sol
  line: 91
  has: )), params.v, params.r, params.s) == owner();
  says: the recovered address must be its owner
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x7fa2bfc41eccbc4d5d0b19e64aac44b8e59d3d7d'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2020d8b8f4ab500beaffe5e53f02f59fe0e4f137'
  fn: owner()(address)
  is: '0x6803f083211a00bfe5062042485c469dae6f3cec'
  says: Its owner is 0x6803f083211a00bfe5062042485c469dae6f3cec at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x6803f083211a00bfe5062042485c469dae6f3cec'
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

MultiChainNFT accepts a call to mint only with an ECDSA signature of its owner. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [mint](https://etherscan.io/address/0x7fa2bfc41eccbc4d5d0b19e64aac44b8e59d3d7d#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0x7fa2bfc41eccbc4d5d0b19e64aac44b8e59d3d7d#code) changes the signer.
- The signer at the block is [0x6803…3cec](https://etherscan.io/address/0x6803f083211a00bfe5062042485c469dae6f3cec), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/MultiChainNFT.sol, line 72) recovers a signer on line 87 and tests it on line 91 against its owner (owner() returns 0x6803f083211a00bfe5062042485c469dae6f3cec). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-03-28, recovering 0x6803…3cec; 12 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
