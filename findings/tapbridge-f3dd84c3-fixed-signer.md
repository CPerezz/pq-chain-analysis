---
id: tapbridge-f3dd84c3-fixed-signer
format: 2
title: 'TapBridge: its signer cannot be replaced and must not take real code'
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a signer's account takes real code; the signer is fixed, so a new contract is then
  needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf3dd84c3b47c16d2258e9fec6296885974f1a448'
  name: TapBridge
  code: verified
  code_url: https://etherscan.io/address/0xf3dd84c3b47c16d2258e9fec6296885974f1a448#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 158
  basis: held
activity:
  txs_90d: 312
impact: liveness
action: Keep the signer's account free of real code, or deploy a replacement with a new signer first.
evidence_level: source
checks:
- id: recover
  source: '0xf3dd84c3b47c16d2258e9fec6296885974f1a448'
  file: bridge-final/TapBridge.sol
  line: 55
  has: address signer = ECDSA.recover(messageHash, signature);
  says: bridgeIn recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf3dd84c3b47c16d2258e9fec6296885974f1a448'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf3dd84c3b47c16d2258e9fec6296885974f1a448'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xf3dd84c3b47c16d2258e9fec6296885974f1a448'
  file: bridge-final/TapBridge.sol
  line: 56
  has: if (signer != canister) revert Errors.AddressMismatch(canister, signer);
  says: the recovered address must be a signer fixed at deployment
  for:
  - evidence-1
  - justification
  - what
- id: written
  source: '0xf3dd84c3b47c16d2258e9fec6296885974f1a448'
  file: bridge-final/TapBridge.sol
  line: 28
  has: canister = canister_;
  says: the signer is written here, at deployment
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xf3dd84c3b47c16d2258e9fec6296885974f1a448'
  fn: canister()(address)
  is: '0xe815aa9f156ca4b03aa0bcaeae0332b92aa1ae7d'
  says: A signer fixed at deployment is 0xe815aa9f156ca4b03aa0bcaeae0332b92aa1ae7d at the block
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xe815aa9f156ca4b03aa0bcaeae0332b92aa1ae7d'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x21e3d411c46332bb33fd4afde67f05e8703882a7a7f4c1a1fbbd12c0b8bb9a46'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
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

TapBridge accepts a call to bridgeIn only with an ECDSA signature of a signer fixed at deployment. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. The verified source has no function that replaces the signer.

## Evidence

- [bridgeIn](https://etherscan.io/address/0xf3dd84c3b47c16d2258e9fec6296885974f1a448#code) recovers the signature with ECDSA and accepts only a signer fixed at deployment; the code never asks that account.
- The signer is written [at deployment](https://etherscan.io/address/0xf3dd84c3b47c16d2258e9fec6296885974f1a448#code); the verified source has no function that writes it afterwards.
- The signer at the block is [0xe815…ae7d](https://etherscan.io/address/0xe815aa9f156ca4b03aa0bcaeae0332b92aa1ae7d), an account without code.

## Reviewer notes

### Mechanism

bridgeIn (bridge-final/TapBridge.sol, line 37) recovers a signer on line 55 and tests it on line 56 against a signer fixed at deployment (canister() returns 0xe815aa9f156ca4b03aa0bcaeae0332b92aa1ae7d). Neither isValidSignature selector is in the code, so that account is never asked. canister is written on line 28 of bridge-final/TapBridge.sol (at deployment); a search of every source file, libraries and constructors included, finds no other write, and the contract's own functions use no sstore and no delegatecall. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-16, recovering 0xe815…ae7d; 312 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer or the line that fixes it, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
