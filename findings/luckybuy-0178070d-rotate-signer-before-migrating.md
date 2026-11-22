---
id: luckybuy-0178070d-rotate-signer-before-migrating
format: 2
title: 'LuckyBuy: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0178070d088c235e1dc2696d257f90b3ded475a3'
  name: LuckyBuy
  code: verified
  code_url: https://etherscan.io/address/0x0178070d088c235e1dc2696d257f90b3ded475a3#code
  copies: 11
  family: b91632b2e1554f14d109252fab5c80ac
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Before a signer's account moves to real code, use addCosigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x0178070d088c235e1dc2696d257f90b3ded475a3'
  file: src/LuckyBuy.sol
  line: 399
  has: address cosigner = _verifyDigest(digest, signature_);
  says: _fulfill recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0178070d088c235e1dc2696d257f90b3ded475a3'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0178070d088c235e1dc2696d257f90b3ded475a3'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x0178070d088c235e1dc2696d257f90b3ded475a3'
  file: src/LuckyBuy.sol
  line: 400
  has: if (cosigner != commitData.cosigner) revert InvalidCosigner();
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x0178070d088c235e1dc2696d257f90b3ded475a3'
  file: src/LuckyBuy.sol
  line: 737
  has: function addCosigner
  says: addCosigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x993f64e049f95d246dc7b0d196cb5dc419d4e1f1'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

LuckyBuy checks an ECDSA signature in _fulfill and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addCosigner changes who may sign.

## Evidence

- [_fulfill](https://etherscan.io/address/0x0178070d088c235e1dc2696d257f90b3ded475a3#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addCosigner](https://etherscan.io/address/0x0178070d088c235e1dc2696d257f90b3ded475a3#code) changes who may sign; only a role holder can call it.
- The address recovered in its latest signature check on record is [0x993f…e1f1](https://etherscan.io/address/0x993f64e049f95d246dc7b0d196cb5dc419d4e1f1), an account without code.

## Reviewer notes

### Mechanism

_fulfill (src/LuckyBuy.sol, line 366) recovers a signer on line 399 and tests it on line 400 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addCosigner (src/LuckyBuy.sol, line 737) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 11 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-09-10, recovering 0x993f…e1f1; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
