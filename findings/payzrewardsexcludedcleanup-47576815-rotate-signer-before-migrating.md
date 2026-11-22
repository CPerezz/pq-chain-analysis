---
id: payzrewardsexcludedcleanup-47576815-rotate-signer-before-migrating
format: 2
title: 'This contract: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x47576815ac8744fb421e154e2b872d21c52a0229'
  name: PayzRewardsExcludedCleanup
  code: verified
  code_url: https://etherscan.io/address/0xb82dab2c8f8a70e04496f1da2a1332e4ed7e900d#code
  proxy_of: '0xb82dab2c8f8a70e04496f1da2a1332e4ed7e900d'
  copies: 2
  family: 983b47bc833f650f2b4525355f44bd43
  upgradeable: 'yes'
  admin: '0x18f4939f0e7b8a39faa0afdb205ceb21fa7060c5'
value:
  usd: 2
  basis: held
activity:
  txs_90d: 133
impact: liveness
action: Replace the signer with transferOwnership before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb82dab2c8f8a70e04496f1da2a1332e4ed7e900d'
  file: contracts/PayzRewardsUpgradeable.sol
  line: 171
  has: if (_recover(digest, signature) != owner()) revert InvalidRedemptionAuthorization();
  says: redeem recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb82dab2c8f8a70e04496f1da2a1332e4ed7e900d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb82dab2c8f8a70e04496f1da2a1332e4ed7e900d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  selector: '0xb82dab2c8f8a70e04496f1da2a1332e4ed7e900d'
  fn: transferOwnership(address)
  says: the code has transferOwnership
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x47576815ac8744fb421e154e2b872d21c52a0229'
  fn: owner()(address)
  is: '0x18f4939f0e7b8a39faa0afdb205ceb21fa7060c5'
  says: Its owner is 0x18f4939f0e7b8a39faa0afdb205ceb21fa7060c5 at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0x18f4939f0e7b8a39faa0afdb205ceb21fa7060c5'
  is: delegation
  target: '0x69007702764179f14f51cdce752f4f775d74e139'
  says: 'the signer''s account holds an EIP-7702 delegation: an ECDSA key still controls it'
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

This contract accepts a call to redeem only with an ECDSA signature of its owner. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. transferOwnership changes the signer.

## Evidence

- [redeem](https://etherscan.io/address/0xb82dab2c8f8a70e04496f1da2a1332e4ed7e900d#code) recovers the signature with ECDSA and accepts only its owner; the code never asks that account.
- [transferOwnership](https://etherscan.io/address/0xb82dab2c8f8a70e04496f1da2a1332e4ed7e900d#code) changes the signer; only the owner can call it.
- The signer at the block is [0x18f4…60c5](https://etherscan.io/address/0x18f4939f0e7b8a39faa0afdb205ceb21fa7060c5), an account with an EIP-7702 delegation, which keeps working.

## Reviewer notes

### Mechanism

redeem (contracts/PayzRewardsUpgradeable.sol, line 158) recovers a signer on line 171 and tests it on line 171 against its owner (owner() returns 0x18f4939f0e7b8a39faa0afdb205ceb21fa7060c5). Neither isValidSignature selector is in the code, so that account is never asked. transferOwnership is in the code. The signer's account holds an EIP-7702 delegation to 0x69007702764179f14f51cdce752f4f775d74e139. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 133 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 items 33 and 40): the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
