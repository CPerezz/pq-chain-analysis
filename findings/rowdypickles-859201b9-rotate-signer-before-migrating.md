---
id: rowdypickles-859201b9-rotate-signer-before-migrating
format: 2
title: 'ROWDYPICKLES: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x859201b9229cd22211f08fcfbd554830d54e8193'
  name: ROWDYPICKLES
  code: verified
  code_url: https://etherscan.io/address/0x859201b9229cd22211f08fcfbd554830d54e8193#code
  copies: 2
  family: 46b1cf6010086e86025bb7c02d307bfb
  upgradeable: 'no'
  admin: '0x383d79da46a14e50156eb3650ee34b1d7ed4dc27'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x859201b9229cd22211f08fcfbd554830d54e8193'
  file: RowdyPickles.sol
  line: 1933
  has: return (recoverSigner(message, sig) == signerAddress);
  says: isValidData recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x859201b9229cd22211f08fcfbd554830d54e8193'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x859201b9229cd22211f08fcfbd554830d54e8193'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x859201b9229cd22211f08fcfbd554830d54e8193'
  file: RowdyPickles.sol
  line: 1969
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x859201b9229cd22211f08fcfbd554830d54e8193'
  fn: signerAddress()(address)
  is: '0xa5f3ba12bc80a0bc6184b07e97cc8dfea75d958e'
  says: The signer it keeps in storage is 0xa5f3ba12bc80a0bc6184b07e97cc8dfea75d958e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xa5f3ba12bc80a0bc6184b07e97cc8dfea75d958e'
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

ROWDYPICKLES checks an ECDSA signature in isValidData and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [isValidData](https://etherscan.io/address/0x859201b9229cd22211f08fcfbd554830d54e8193#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x859201b9229cd22211f08fcfbd554830d54e8193#code) changes the signer; only the owner can call it.
- The signer at the block is [0xa5f3…958e](https://etherscan.io/address/0xa5f3ba12bc80a0bc6184b07e97cc8dfea75d958e), an account without code.

## Reviewer notes

### Mechanism

isValidData (RowdyPickles.sol, line 1931) recovers a signer on line 1933 and tests it on line 1933 against the signer it keeps in storage (signerAddress() returns 0xa5f3ba12bc80a0bc6184b07e97cc8dfea75d958e). Neither isValidSignature selector is in the code, so that account is never asked. setSigner (RowdyPickles.sol, line 1969) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-03-10, recovering 0xa5f3…958e; 3 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
