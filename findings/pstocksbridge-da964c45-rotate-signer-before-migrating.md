---
id: pstocksbridge-da964c45-rotate-signer-before-migrating
format: 2
title: 'PStocksBridge: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xda964c450c94b2920d0e0321d77056ef36f9667e'
  name: PStocksBridge
  code: verified
  code_url: https://etherscan.io/address/0xda964c450c94b2920d0e0321d77056ef36f9667e#code
  copies: 1
  upgradeable: 'no'
  admin: '0x315f93b9037ccfbbc5f35d92e930f6560713e9df'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: liveness
action: Before a signer's account moves to real code, use setValidator so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xda964c450c94b2920d0e0321d77056ef36f9667e'
  file: src/PStocksBridge.sol
  line: 168
  has: address signer = ECDSA.recover(digest, sigs[i]);
  says: _checkSignatures recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xda964c450c94b2920d0e0321d77056ef36f9667e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xda964c450c94b2920d0e0321d77056ef36f9667e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xda964c450c94b2920d0e0321d77056ef36f9667e'
  file: src/PStocksBridge.sol
  line: 92
  has: function setValidator
  says: setValidator changes who may sign
  for:
  - action
  - evidence-2
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

PStocksBridge checks an ECDSA signature in _checkSignatures and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setValidator changes who may sign.

## Evidence

- [_checkSignatures](https://etherscan.io/address/0xda964c450c94b2920d0e0321d77056ef36f9667e#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setValidator](https://etherscan.io/address/0xda964c450c94b2920d0e0321d77056ef36f9667e#code) changes who may sign (through _setValidator); only the owner can call it.

## Reviewer notes

### Mechanism

_checkSignatures (src/PStocksBridge.sol, line 163) recovers a signer on line 168 and tests it on line 168 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. _setValidator (src/PStocksBridge.sol, line 177) writes it, called by setValidator. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 2 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
