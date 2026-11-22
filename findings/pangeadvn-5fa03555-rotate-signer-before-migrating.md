---
id: pangeadvn-5fa03555-rotate-signer-before-migrating
format: 2
title: 'PangeaDVN: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5fa03555f186e53a644405817e1beac894bd6562'
  name: PangeaDVN
  code: verified
  code_url: https://etherscan.io/address/0x5fa03555f186e53a644405817e1beac894bd6562#code
  copies: 1
  upgradeable: 'no'
  admin: '0x93620a4a7d45a770ff2e801eb84b03a7630ae8b6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13749
impact: liveness
action: Before a signer's account moves to real code, use setSigners so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x5fa03555f186e53a644405817e1beac894bd6562'
  file: src/dvn/PangeaDVN.sol
  line: 287
  has: (address signer, ECDSA.RecoverError err,) = ECDSA.tryRecover(signed, signatures[i * 65:(i + 1) * 65]);
  says: _quorumSigned recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x5fa03555f186e53a644405817e1beac894bd6562'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x5fa03555f186e53a644405817e1beac894bd6562'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x5fa03555f186e53a644405817e1beac894bd6562'
  file: src/dvn/PangeaDVN.sol
  line: 298
  has: function setSigners
  says: setSigners changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xe6a37e6537506a9ab0ab5e58d4e457227a68f035'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x339d68da8cd2f9aed17c5cb44351aa541d1d34173832ca244ccddc1b24b0b405'
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

PangeaDVN checks an ECDSA signature in _quorumSigned and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigners changes who may sign.

## Evidence

- [_quorumSigned](https://etherscan.io/address/0x5fa03555f186e53a644405817e1beac894bd6562#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setSigners](https://etherscan.io/address/0x5fa03555f186e53a644405817e1beac894bd6562#code) changes who may sign (through _setSigners); only a role holder can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0x339d68da8cd2f9aed17c5cb44351aa541d1d34173832ca244ccddc1b24b0b405) on record recovered [0xe6a3…f035](https://etherscan.io/address/0xe6a37e6537506a9ab0ab5e58d4e457227a68f035), an account without code.

## Reviewer notes

### Mechanism

_quorumSigned (src/dvn/PangeaDVN.sol, line 281) recovers a signer on line 287 and tests it on line 287 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. _setSigners (src/dvn/PangeaDVN.sol, line 306) writes it, called by setSigners. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0xe6a3…f035; 13,749 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
