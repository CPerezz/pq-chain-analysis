---
id: multisigwalletproxy-139cfd93-rotate-signer-before-migrating
format: 2
title: 'MultiSigWalletProxy: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3'
  name: MultiSigWalletProxy
  code: verified
  code_url: https://etherscan.io/address/0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3#code
  copies: 32
  family: ac6dda8cbb1f6e19498534e48949fcd8
value:
  usd: 4222860
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Before a signer's account moves to real code, use addOwner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3'
  file: MultiSigWalletImplementation.sol
  line: 485
  has: address currentOwner = ecrecover(digest, v, r, s);
  says: batchSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3'
  file: MultiSigWalletImplementation.sol
  line: 488
  has: require(currentOwner > lastOwner && isOwner[currentOwner] && signer == currentOwner, "error-sig");
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3'
  file: MultiSigWalletImplementation.sol
  line: 156
  has: function addOwner
  says: addOwner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x3b5e729537a607480f64e97658e678df03aab4be'
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

MultiSigWalletProxy accepts a call to batchSignature only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addOwner changes who may sign.

## Evidence

- [batchSignature](https://etherscan.io/address/0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addOwner](https://etherscan.io/address/0x139cfd93dbaf2682b2ceae7aef2465470cfb9ee3#code) changes who may sign.
- The address recovered in its latest signature check on record is [0x3b5e…b4be](https://etherscan.io/address/0x3b5e729537a607480f64e97658e678df03aab4be), an account without code.

## Reviewer notes

### Mechanism

batchSignature (MultiSigWalletImplementation.sol, line 464) recovers a signer on line 485 and tests it on line 488 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addOwner (MultiSigWalletImplementation.sol, line 156) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 32 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-04-05, recovering 0x3b5e…b4be; 2 transactions called the address in the 90 days before the block. 5 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
