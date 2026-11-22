---
id: cyberboxpass-0db8d95c-rotate-signer-before-migrating
format: 2
title: 'CyberBoxPass: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d'
  name: CyberBoxPass
  code: verified
  code_url: https://etherscan.io/address/0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d#code
  copies: 1
  upgradeable: 'no'
  admin: '0x85e0aafdb0d6516a007b3c16672b00731614d6ae'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setOperator before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d'
  file: contracts/CyberBoxPass.sol
  line: 63
  has: address signer = _verify(voucher);
  says: mintVoucher recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d'
  file: contracts/CyberBoxPass.sol
  line: 65
  has: require(signer == operator, "Signature invalid or unauthorized");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d'
  file: contracts/CyberBoxPass.sol
  line: 125
  has: function setOperator
  says: setOperator changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d'
  fn: operator()(address)
  is: '0xebcf015a188d2e81e950f67d7ddea27ea2735129'
  says: The signer it keeps in storage is 0xebcf015a188d2e81e950f67d7ddea27ea2735129 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xebcf015a188d2e81e950f67d7ddea27ea2735129'
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

CyberBoxPass accepts a call to mintVoucher only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOperator changes the signer.

## Evidence

- [mintVoucher](https://etherscan.io/address/0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOperator](https://etherscan.io/address/0x0db8d95c9d3624623af962c6a3a1e21d35d6e44d#code) changes the signer; only the owner can call it.
- The signer at the block is [0xebcf…5129](https://etherscan.io/address/0xebcf015a188d2e81e950f67d7ddea27ea2735129), an account without code.

## Reviewer notes

### Mechanism

mintVoucher (contracts/CyberBoxPass.sol, line 59) recovers a signer on line 63 and tests it on line 65 against the signer it keeps in storage (operator() returns 0xebcf015a188d2e81e950f67d7ddea27ea2735129). Neither isValidSignature selector is in the code, so that account is never asked. setOperator (contracts/CyberBoxPass.sol, line 125) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-05-07, recovering 0xebcf…5129; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
