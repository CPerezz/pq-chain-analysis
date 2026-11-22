---
id: carouter-534b95e0-rotate-signer-before-migrating
format: 2
title: 'CARouter: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x534b95e0780b434026c8a9bfcefa7a9a4df846cc'
  name: CARouter
  code: verified
  code_url: https://etherscan.io/address/0x536694bd72aea43efe991bdaa78819e628edc742#code
  proxy_of: '0x536694bd72aea43efe991bdaa78819e628edc742'
  copies: 2
  family: bb3a978109cbf311f8a034e79c78ef39
  upgradeable: 'yes'
  admin: '0xdf81edd09d8f1bf6be73cdea65d3e8f68397120e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Before a signer's account moves to real code, use setApiSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x536694bd72aea43efe991bdaa78819e628edc742'
  file: src/CARouter.sol
  line: 301
  has: address apiSigner = ECDSA.recover(digest, apiSig);
  says: _verifyApiApproval recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x536694bd72aea43efe991bdaa78819e628edc742'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x536694bd72aea43efe991bdaa78819e628edc742'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x536694bd72aea43efe991bdaa78819e628edc742'
  file: src/CARouter.sol
  line: 302
  has: require(approvedApiSigners[apiSigner], "Bad API signature");
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x536694bd72aea43efe991bdaa78819e628edc742'
  file: src/CARouter.sol
  line: 367
  has: function setApiSigner
  says: setApiSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x2327d4eb3c4e27c1d774e97d5d7d05669bae1972'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xb90ccc7f125ce66873105bd301a162b24cd18a3c0f128b717d7732c183b69e3a'
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

CARouter checks an ECDSA signature in _verifyApiApproval and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setApiSigner changes who may sign.

## Evidence

- [_verifyApiApproval](https://etherscan.io/address/0x536694bd72aea43efe991bdaa78819e628edc742#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setApiSigner](https://etherscan.io/address/0x536694bd72aea43efe991bdaa78819e628edc742#code) changes who may sign; only the owner can call it.
- Its latest signed [transaction](https://etherscan.io/tx/0xb90ccc7f125ce66873105bd301a162b24cd18a3c0f128b717d7732c183b69e3a) on record recovered [0x2327…1972](https://etherscan.io/address/0x2327d4eb3c4e27c1d774e97d5d7d05669bae1972), an account without code.

## Reviewer notes

### Mechanism

_verifyApiApproval (src/CARouter.sol, line 277) recovers a signer on line 301 and tests it on line 302 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setApiSigner (src/CARouter.sol, line 367) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x2327…1972; 1 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
