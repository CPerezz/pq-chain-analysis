---
id: kusdtvault-fa986998-rotate-signer-before-migrating
format: 2
title: 'KusdtVault: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfa9869982542fb20bad929789b252b7b06eee10e'
  name: KusdtVault
  code: verified
  code_url: https://etherscan.io/address/0xfa9869982542fb20bad929789b252b7b06eee10e#code
  copies: 1
  upgradeable: 'no'
  admin: '0xdd55cfaf862ad64259b41a96b47927a3c2f8e2db'
value:
  usd: 6044
  basis: held
activity:
  txs_90d: 13
impact: liveness
action: Before a signer's account moves to real code, use setSigners so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xfa9869982542fb20bad929789b252b7b06eee10e'
  file: contracts/KusdtVault.sol
  line: 649
  has: address s = ECDSA.recover(digest, signatures[i]);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfa9869982542fb20bad929789b252b7b06eee10e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfa9869982542fb20bad929789b252b7b06eee10e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xfa9869982542fb20bad929789b252b7b06eee10e'
  file: contracts/KusdtVault.sol
  line: 548
  has: function setSigners
  says: setSigners changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x5499fccbda44b5e48ae0227c878cfda933e62e6a'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x729d312ef096b57c93e9ae201a9568966aad77e4b956f6592157acebae613522'
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

KusdtVault checks an ECDSA signature in _verify and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigners changes who may sign.

## Evidence

- [_verify](https://etherscan.io/address/0xfa9869982542fb20bad929789b252b7b06eee10e#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setSigners](https://etherscan.io/address/0xfa9869982542fb20bad929789b252b7b06eee10e#code) changes who may sign (through _setSigners); only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x729d312ef096b57c93e9ae201a9568966aad77e4b956f6592157acebae613522) on record recovered [0x5499…2e6a](https://etherscan.io/address/0x5499fccbda44b5e48ae0227c878cfda933e62e6a), an account without code.

## Reviewer notes

### Mechanism

_verify (contracts/KusdtVault.sol, line 645) recovers a signer on line 649 and tests it on line 649 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. _setSigners (contracts/KusdtVault.sol, line 691) writes it, called by setSigners. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-16, recovering 0x5499…2e6a; 13 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
