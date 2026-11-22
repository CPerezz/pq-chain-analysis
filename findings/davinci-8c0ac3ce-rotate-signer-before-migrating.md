---
id: davinci-8c0ac3ce-rotate-signer-before-migrating
format: 2
title: 'DaVinci: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8c0ac3ce98dced91810f7b3c5b50791c8874c551'
  name: DaVinci
  code: verified
  code_url: https://etherscan.io/address/0x8c0ac3ce98dced91810f7b3c5b50791c8874c551#code
  copies: 1
  upgradeable: 'no'
  admin: '0x9df38fdc712b934962f9ee13a0bd0fb206b709be'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 34
impact: liveness
action: Replace the signer with setSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x8c0ac3ce98dced91810f7b3c5b50791c8874c551'
  file: contracts/DaVinci.sol
  line: 138
  has: require(ECDSA.recover(_msg, sig) == _signer, "Invalid Signature");
  says: verifySignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8c0ac3ce98dced91810f7b3c5b50791c8874c551'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x8c0ac3ce98dced91810f7b3c5b50791c8874c551'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x8c0ac3ce98dced91810f7b3c5b50791c8874c551'
  file: contracts/DaVinci.sol
  line: 175
  has: function setSigner
  says: setSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xd9a151b9375a5e65f5e9895f6113a327a02420f8'
  is: empty
  says: the address recovered in the latest signature check on record has no code
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

DaVinci checks an ECDSA signature in verifySignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes the signer.

## Evidence

- [verifySignature](https://etherscan.io/address/0x8c0ac3ce98dced91810f7b3c5b50791c8874c551#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSigner](https://etherscan.io/address/0x8c0ac3ce98dced91810f7b3c5b50791c8874c551#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xd9a1…20f8](https://etherscan.io/address/0xd9a151b9375a5e65f5e9895f6113a327a02420f8), an account without code.

## Reviewer notes

### Mechanism

verifySignature (contracts/DaVinci.sol, line 130) recovers a signer on line 138 and tests it on line 138 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (contracts/DaVinci.sol, line 175) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-02-27, recovering 0xd9a1…20f8; 34 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
