---
id: enstoolsmarketplace-3a2082ae-rotate-signer-before-migrating
format: 2
title: 'EnstoolsMarketplace: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3a2082ae869ea0d65cc85d6eb434007f186cdd6a'
  name: EnstoolsMarketplace
  code: verified
  code_url: https://etherscan.io/address/0x6cc74f9259a0431d14d3d2369f476ebf5d4403ed#code
  proxy_of: '0x6cc74f9259a0431d14d3d2369f476ebf5d4403ed'
  copies: 2
  family: 6d8f0f2e079d50ee987baa936f202d55
  upgradeable: 'yes'
  admin: '0xcc4c2314a68ab3d03fa480b93bb9d5f0b90994ce'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6cc74f9259a0431d14d3d2369f476ebf5d4403ed'
  file: contracts/EnstoolsMarketplace.sol
  line: 325
  has: return recoverSigner(ethSignedMessageHash, _signature) == signer;
  says: verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6cc74f9259a0431d14d3d2369f476ebf5d4403ed'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6cc74f9259a0431d14d3d2369f476ebf5d4403ed'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x6cc74f9259a0431d14d3d2369f476ebf5d4403ed'
  file: contracts/EnstoolsMarketplace.sol
  line: 393
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x3a2082ae869ea0d65cc85d6eb434007f186cdd6a'
  fn: getSigner()(address)
  is: '0x7ac6508b6b9aff83bcbbe0472aed8a47a876f3d5'
  says: The signer it keeps in storage is 0x7ac6508b6b9aff83bcbbe0472aed8a47a876f3d5 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x7ac6508b6b9aff83bcbbe0472aed8a47a876f3d5'
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

EnstoolsMarketplace checks an ECDSA signature in verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [verify](https://etherscan.io/address/0x6cc74f9259a0431d14d3d2369f476ebf5d4403ed#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x6cc74f9259a0431d14d3d2369f476ebf5d4403ed#code) changes the signer.
- The signer at the block is [0x7ac6…f3d5](https://etherscan.io/address/0x7ac6508b6b9aff83bcbbe0472aed8a47a876f3d5), an account without code.

## Reviewer notes

### Mechanism

verify (contracts/EnstoolsMarketplace.sol, line 318) recovers a signer on line 325 and tests it on line 325 against the signer it keeps in storage (getSigner() returns 0x7ac6508b6b9aff83bcbbe0472aed8a47a876f3d5). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (contracts/EnstoolsMarketplace.sol, line 393) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-01-23, recovering 0x7ac6…f3d5; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
