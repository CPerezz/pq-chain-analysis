---
id: splsplgatewayv3-49f743c2-rotate-signer-before-migrating
format: 2
title: 'SPLSPLGatewayV3: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6'
  name: SPLSPLGatewayV3
  code: verified
  code_url: https://etherscan.io/address/0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6#code
  copies: 2
  family: 2abb07726de3d8f83951e175fe281e4a
  upgradeable: 'no'
  admin: '0x0df49ec6f01db7f287df8312d2fd05fe1f0a6c2e'
value:
  usd: 13573
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setValidater before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6'
  file: contracts2/SPLSPLGatewayV3.sol
  line: 284
  has: address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(_message), _signature);
  says: validateSig recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6'
  file: contracts2/SPLSPLGatewayV3.sol
  line: 285
  has: return (signer == validater);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6'
  file: contracts2/SPLSPLGatewayV3.sol
  line: 102
  has: function setValidater
  says: setValidater changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6'
  fn: validater()(address)
  is: '0xaf1d50904a05ebe26ecb17333161be2971eb4a69'
  says: The signer it keeps in storage is 0xaf1d50904a05ebe26ecb17333161be2971eb4a69 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xaf1d50904a05ebe26ecb17333161be2971eb4a69'
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

SPLSPLGatewayV3 checks an ECDSA signature in validateSig and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setValidater changes the signer.

## Evidence

- [validateSig](https://etherscan.io/address/0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setValidater](https://etherscan.io/address/0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6#code) changes the signer; only the owner can call it.
- The signer at the block is [0xaf1d…4a69](https://etherscan.io/address/0xaf1d50904a05ebe26ecb17333161be2971eb4a69), an account without code.

## Reviewer notes

### Mechanism

validateSig (contracts2/SPLSPLGatewayV3.sol, line 282) recovers a signer on line 284 and tests it on line 285 against the signer it keeps in storage (validater() returns 0xaf1d50904a05ebe26ecb17333161be2971eb4a69). Neither isValidSignature selector is in the code, so that account is never asked. setValidater (contracts2/SPLSPLGatewayV3.sol, line 102) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-12-12, recovering 0xaf1d…4a69; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
