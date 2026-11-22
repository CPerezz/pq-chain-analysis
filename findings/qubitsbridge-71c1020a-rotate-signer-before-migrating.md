---
id: qubitsbridge-71c1020a-rotate-signer-before-migrating
format: 2
title: 'QubitsBridge: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x71c1020abf460342a3d5b6a96c719b95d1dfee40'
  name: QubitsBridge
  code: verified
  code_url: https://etherscan.io/address/0x71c1020abf460342a3d5b6a96c719b95d1dfee40#code
  copies: 1
  upgradeable: 'no'
  admin: '0x5cc95f47da9606bdd023adaf821b72262bf98942'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 41
impact: liveness
action: Before a signer's account moves to real code, use setAttesters so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x71c1020abf460342a3d5b6a96c719b95d1dfee40'
  file: src/QubitsBridge.sol
  line: 88
  has: address signer = ECDSA.recover(hash, signatures[i]);
  says: release recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x71c1020abf460342a3d5b6a96c719b95d1dfee40'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x71c1020abf460342a3d5b6a96c719b95d1dfee40'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x71c1020abf460342a3d5b6a96c719b95d1dfee40'
  file: src/QubitsBridge.sol
  line: 124
  has: function setAttesters
  says: setAttesters changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xfdb9457bcc217bea695ec65322bb94d759042a22'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xce83230891c40028f8c6c7e0507dddb8768cf58109fcc5a4af7f468ff721c730'
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

QubitsBridge accepts a call to release only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAttesters changes who may sign.

## Evidence

- [release](https://etherscan.io/address/0x71c1020abf460342a3d5b6a96c719b95d1dfee40#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setAttesters](https://etherscan.io/address/0x71c1020abf460342a3d5b6a96c719b95d1dfee40#code) changes who may sign (through _setAttesters); only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0xce83230891c40028f8c6c7e0507dddb8768cf58109fcc5a4af7f468ff721c730) on record recovered [0xfdb9…2a22](https://etherscan.io/address/0xfdb9457bcc217bea695ec65322bb94d759042a22), an account without code.

## Reviewer notes

### Mechanism

release (src/QubitsBridge.sol, line 83) recovers a signer on line 88 and tests it on line 88 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. _setAttesters (src/QubitsBridge.sol, line 157) writes it, called by setAttesters. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-16, recovering 0xfdb9…2a22; 41 transactions called the address in the 90 days before the block. 2 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
