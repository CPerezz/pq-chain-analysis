---
id: vastegaharips-07d75603-rotate-signer-before-migrating
format: 2
title: 'VastegaHarips: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x07d756032e27b29bcd607aaad44b51a8475853b5'
  name: VastegaHarips
  code: verified
  code_url: https://etherscan.io/address/0x07d756032e27b29bcd607aaad44b51a8475853b5#code
  copies: 1
  upgradeable: 'no'
  admin: '0x415d6d13d38f0fc8f4c532b44e3192707d1b56e4'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 18
impact: liveness
action: Replace the signer with setOperator before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x07d756032e27b29bcd607aaad44b51a8475853b5'
  file: VastegaHarips/contracts/VastegaHarips.sol
  line: 131
  has: require(ecrecover(hash, v, r, s) == operator, "INVALID_SIGNER");
  says: _verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x07d756032e27b29bcd607aaad44b51a8475853b5'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x07d756032e27b29bcd607aaad44b51a8475853b5'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x07d756032e27b29bcd607aaad44b51a8475853b5'
  file: VastegaHarips/contracts/VastegaHarips.sol
  line: 85
  has: function setOperator
  says: setOperator changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x07d756032e27b29bcd607aaad44b51a8475853b5'
  fn: operator()(address)
  is: '0xc4215f9292cf36bee6d126e16628620c57141ccf'
  says: The signer it keeps in storage is 0xc4215f9292cf36bee6d126e16628620c57141ccf at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc4215f9292cf36bee6d126e16628620c57141ccf'
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

VastegaHarips checks an ECDSA signature in _verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOperator changes the signer.

## Evidence

- [_verifySignature](https://etherscan.io/address/0x07d756032e27b29bcd607aaad44b51a8475853b5#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOperator](https://etherscan.io/address/0x07d756032e27b29bcd607aaad44b51a8475853b5#code) changes the signer; only the owner can call it.
- The signer at the block is [0xc421…1ccf](https://etherscan.io/address/0xc4215f9292cf36bee6d126e16628620c57141ccf), an account without code.

## Reviewer notes

### Mechanism

_verifySignature (VastegaHarips/contracts/VastegaHarips.sol, line 112) recovers a signer on line 131 and tests it on line 131 against the signer it keeps in storage (operator() returns 0xc4215f9292cf36bee6d126e16628620c57141ccf). Neither isValidSignature selector is in the code, so that account is never asked. setOperator (VastegaHarips/contracts/VastegaHarips.sol, line 85) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-11-22, recovering 0xc421…1ccf; 18 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
