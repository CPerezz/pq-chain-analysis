---
id: cybertinocanvasv0-39027705-rotate-signer-before-migrating
format: 2
title: 'CybertinoCanvasV0: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x39027705247cc03c7e7bba9361d0f5cd1c63add6'
  name: CybertinoCanvasV0
  code: verified
  code_url: https://etherscan.io/address/0xf9849f6d4e00ad734e8bfcc8a046658ec612d76a#code
  proxy_of: '0xf9849f6d4e00ad734e8bfcc8a046658ec612d76a'
  copies: 2
  family: a5ddf3e838885e7eb69736cdbd251110
  upgradeable: 'yes'
  admin: '0xf657cf4f3fd674df92bc938413e28b9bb45d7ed0'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: liveness
action: Replace the signer with CybertinoCanvas_init_unchained before moving the current signer's account to real
  code.
evidence_level: source
checks:
- id: recover
  source: '0xf9849f6d4e00ad734e8bfcc8a046658ec612d76a'
  file: contracts/CybertinoCanvas/CybertinoCanvasV0.sol
  line: 261
  has: return ethSignedMessageHash.recover(signature) == signer;
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf9849f6d4e00ad734e8bfcc8a046658ec612d76a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf9849f6d4e00ad734e8bfcc8a046658ec612d76a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xf9849f6d4e00ad734e8bfcc8a046658ec612d76a'
  file: contracts/CybertinoCanvas/CybertinoCanvasV0.sol
  line: 36
  has: function CybertinoCanvas_init_unchained
  says: CybertinoCanvas_init_unchained changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x39027705247cc03c7e7bba9361d0f5cd1c63add6'
  fn: signer()(address)
  is: '0xc044d55e0b7bd3740fd1747491a0b3c0e5387e4b'
  says: The signer it keeps in storage is 0xc044d55e0b7bd3740fd1747491a0b3c0e5387e4b at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xc044d55e0b7bd3740fd1747491a0b3c0e5387e4b'
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

CybertinoCanvasV0 checks an ECDSA signature in _verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. CybertinoCanvas_init_unchained changes the signer.

## Evidence

- [_verify](https://etherscan.io/address/0xf9849f6d4e00ad734e8bfcc8a046658ec612d76a#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [CybertinoCanvas_init_unchained](https://etherscan.io/address/0xf9849f6d4e00ad734e8bfcc8a046658ec612d76a#code) changes the signer.
- The signer at the block is [0xc044…7e4b](https://etherscan.io/address/0xc044d55e0b7bd3740fd1747491a0b3c0e5387e4b), an account without code.

## Reviewer notes

### Mechanism

_verify (contracts/CybertinoCanvas/CybertinoCanvasV0.sol, line 255) recovers a signer on line 261 and tests it on line 261 against the signer it keeps in storage (signer() returns 0xc044d55e0b7bd3740fd1747491a0b3c0e5387e4b). Neither isValidSignature selector is in the code, so that account is never asked. CybertinoCanvas_init_unchained (contracts/CybertinoCanvas/CybertinoCanvasV0.sol, line 36) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-08-17; 3 transactions called the address in the 90 days before the block. 6 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
