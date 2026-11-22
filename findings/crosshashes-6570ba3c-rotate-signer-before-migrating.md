---
id: crosshashes-6570ba3c-rotate-signer-before-migrating
format: 2
title: 'CROSSHASHES: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6570ba3cb863dd2e634f4d0ce1cbe9f8957b347f'
  name: CROSSHASHES
  code: verified
  code_url: https://etherscan.io/address/0x6570ba3cb863dd2e634f4d0ce1cbe9f8957b347f#code
  copies: 1
  admin: '0x248794046ad0cbae7344f15efd61db9b11a59f63'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setSolutionSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x6570ba3cb863dd2e634f4d0ce1cbe9f8957b347f'
  file: contracts/CROSSHASHES.sol
  line: 188
  has: if (ECDSA.recover(ethHash, signature) != solutionSigner) revert BadSignature();
  says: solve recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x6570ba3cb863dd2e634f4d0ce1cbe9f8957b347f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x6570ba3cb863dd2e634f4d0ce1cbe9f8957b347f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x6570ba3cb863dd2e634f4d0ce1cbe9f8957b347f'
  file: contracts/CROSSHASHES.sol
  line: 140
  has: function setSolutionSigner
  says: setSolutionSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x6570ba3cb863dd2e634f4d0ce1cbe9f8957b347f'
  fn: solutionSigner()(address)
  is: '0x1bce21e40308d8d241e7ad254f681ef653b684d3'
  says: The signer it keeps in storage is 0x1bce21e40308d8d241e7ad254f681ef653b684d3 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x1bce21e40308d8d241e7ad254f681ef653b684d3'
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

CROSSHASHES accepts a call to solve only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSolutionSigner changes the signer.

## Evidence

- [solve](https://etherscan.io/address/0x6570ba3cb863dd2e634f4d0ce1cbe9f8957b347f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSolutionSigner](https://etherscan.io/address/0x6570ba3cb863dd2e634f4d0ce1cbe9f8957b347f#code) changes the signer; only the owner can call it.
- The signer at the block is [0x1bce…84d3](https://etherscan.io/address/0x1bce21e40308d8d241e7ad254f681ef653b684d3), an account without code.

## Reviewer notes

### Mechanism

solve (contracts/CROSSHASHES.sol, line 182) recovers a signer on line 188 and tests it on line 188 against the signer it keeps in storage (solutionSigner() returns 0x1bce21e40308d8d241e7ad254f681ef653b684d3). Neither isValidSignature selector is in the code, so that account is never asked. setSolutionSigner (contracts/CROSSHASHES.sol, line 140) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
