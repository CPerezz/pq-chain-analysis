---
id: peach-b0dd2cf1-rotate-signer-before-migrating
format: 2
title: 'Peach: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb0dd2cf11d0787146520ab39fbdc382f78dabb16'
  name: Peach
  code: verified
  code_url: https://etherscan.io/address/0xb0dd2cf11d0787146520ab39fbdc382f78dabb16#code
  copies: 1
  upgradeable: 'no'
  admin: '0xa602e91afce5cecb43ae6e3f7051e1c95957046f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 9
impact: liveness
action: Replace the signer with setAuthSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xb0dd2cf11d0787146520ab39fbdc382f78dabb16'
  file: contracts/Peach.sol
  line: 154
  has: require(recoverSigner(keccak256(b), sig) == authSigner, "Invalid sig");
  says: stake recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xb0dd2cf11d0787146520ab39fbdc382f78dabb16'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xb0dd2cf11d0787146520ab39fbdc382f78dabb16'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xb0dd2cf11d0787146520ab39fbdc382f78dabb16'
  file: contracts/Peach.sol
  line: 66
  has: function setAuthSigner
  says: setAuthSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xb0dd2cf11d0787146520ab39fbdc382f78dabb16'
  fn: authSigner()(address)
  is: '0x802612b1c3cb78b0e5e12c98ac6d071e0186eb3a'
  says: The signer it keeps in storage is 0x802612b1c3cb78b0e5e12c98ac6d071e0186eb3a at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x802612b1c3cb78b0e5e12c98ac6d071e0186eb3a'
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

Peach accepts a call to stake only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthSigner changes the signer.

## Evidence

- [stake](https://etherscan.io/address/0xb0dd2cf11d0787146520ab39fbdc382f78dabb16#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAuthSigner](https://etherscan.io/address/0xb0dd2cf11d0787146520ab39fbdc382f78dabb16#code) changes the signer; only the owner can call it.
- The signer at the block is [0x8026…eb3a](https://etherscan.io/address/0x802612b1c3cb78b0e5e12c98ac6d071e0186eb3a), an account without code.

## Reviewer notes

### Mechanism

stake (contracts/Peach.sol, line 148) recovers a signer on line 154 and tests it on line 154 against the signer it keeps in storage (authSigner() returns 0x802612b1c3cb78b0e5e12c98ac6d071e0186eb3a). Neither isValidSignature selector is in the code, so that account is never asked. setAuthSigner (contracts/Peach.sol, line 66) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-07-22, recovering 0x8026…eb3a; 9 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
