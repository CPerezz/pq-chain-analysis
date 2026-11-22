---
id: mintcontroller-0d006d9e-rotate-signer-before-migrating
format: 2
title: 'MintController: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0d006d9e862b362180eb602e5973fd1fdb6f78dd'
  name: MintController
  code: verified
  code_url: https://etherscan.io/address/0x0d006d9e862b362180eb602e5973fd1fdb6f78dd#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 178
impact: liveness
action: Before a signer's account moves to real code, use addValidator so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x0d006d9e862b362180eb602e5973fd1fdb6f78dd'
  file: src/MintController.sol
  line: 196
  has: currentSigner = ECDSA.recover(digest, _signatures[i]);
  says: _verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0d006d9e862b362180eb602e5973fd1fdb6f78dd'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0d006d9e862b362180eb602e5973fd1fdb6f78dd'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x0d006d9e862b362180eb602e5973fd1fdb6f78dd'
  file: src/MintController.sol
  line: 91
  has: function addValidator
  says: addValidator changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x754ffd7817e391a16c8d141029823a18e025404c'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xf90de576935dc2923e8b2f2c043534795b62c39c6572c31047ab3f97ed93ff9c'
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

MintController checks an ECDSA signature in _verify and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addValidator changes who may sign.

## Evidence

- [_verify](https://etherscan.io/address/0x0d006d9e862b362180eb602e5973fd1fdb6f78dd#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addValidator](https://etherscan.io/address/0x0d006d9e862b362180eb602e5973fd1fdb6f78dd#code) changes who may sign; only a role holder can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0xf90de576935dc2923e8b2f2c043534795b62c39c6572c31047ab3f97ed93ff9c) on record recovered [0x754f…404c](https://etherscan.io/address/0x754ffd7817e391a16c8d141029823a18e025404c), an account without code.

## Reviewer notes

### Mechanism

_verify (src/MintController.sol, line 177) recovers a signer on line 196 and tests it on line 196 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. addValidator (src/MintController.sol, line 91) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x754f…404c; 178 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
