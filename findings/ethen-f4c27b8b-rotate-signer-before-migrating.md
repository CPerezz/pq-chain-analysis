---
id: ethen-f4c27b8b-rotate-signer-before-migrating
format: 2
title: 'Ethen: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d'
  name: Ethen
  code: verified
  code_url: https://etherscan.io/address/0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8a1ff1f8a84c78d89cbc3d2fd4e6442e68af4a9b'
value:
  usd: 78359
  basis: held
activity:
  txs_90d: 9
impact: liveness
action: Replace the signer with Ethen before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d'
  file: Ethen.sol
  line: 342
  has: require(ecrecover(hash, _v, _r, _s) == signer);
  says: setCoeff recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d'
  file: Ethen.sol
  line: 257
  has: function Ethen
  says: Ethen changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d'
  fn: signer()(address)
  is: '0xf2c24291897fbe28fed3c65cf6cf5a1c1b4e484e'
  says: The signer it keeps in storage is 0xf2c24291897fbe28fed3c65cf6cf5a1c1b4e484e at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xf2c24291897fbe28fed3c65cf6cf5a1c1b4e484e'
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

Ethen accepts a call to setCoeff only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. Ethen changes the signer.

## Evidence

- [setCoeff](https://etherscan.io/address/0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [Ethen](https://etherscan.io/address/0xf4c27b8b002389864ac214cb13bfeef4cc5c4e8d#code) changes the signer.
- The signer at the block is [0xf2c2…484e](https://etherscan.io/address/0xf2c24291897fbe28fed3c65cf6cf5a1c1b4e484e), an account without code.

## Reviewer notes

### Mechanism

setCoeff (Ethen.sol, line 338) recovers a signer on line 342 and tests it on line 342 against the signer it keeps in storage (signer() returns 0xf2c24291897fbe28fed3c65cf6cf5a1c1b4e484e). Neither isValidSignature selector is in the code, so that account is never asked. Ethen (Ethen.sol, line 257) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2019-10-13; 9 transactions called the address in the 90 days before the block. 277 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
