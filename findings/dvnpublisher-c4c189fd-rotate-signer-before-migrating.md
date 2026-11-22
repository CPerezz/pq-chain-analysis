---
id: dvnpublisher-c4c189fd-rotate-signer-before-migrating
format: 2
title: 'DVNPublisher: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc4c189fd5792197994c4acd9fad5244b6a16e056'
  name: DVNPublisher
  code: verified
  code_url: https://etherscan.io/address/0xffd1aef95e7f58441b368a54b4a48fcbb4d959cd#code
  proxy_of: '0xffd1aef95e7f58441b368a54b4a48fcbb4d959cd'
  copies: 8
  family: 632c9e7b134c424a7072338f943ff7a4
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 116
impact: liveness
action: Before a signer's account moves to real code, use setSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xffd1aef95e7f58441b368a54b4a48fcbb4d959cd'
  file: src/publisher/DVNPublisher.sol
  line: 269
  has: address signer = ECDSA.recover(structHash, signature);
  says: publish recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xffd1aef95e7f58441b368a54b4a48fcbb4d959cd'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xffd1aef95e7f58441b368a54b4a48fcbb4d959cd'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xffd1aef95e7f58441b368a54b4a48fcbb4d959cd'
  file: src/publisher/DVNPublisher.sol
  line: 271
  has: if (signer != request.signer || !signers[signer]) revert InvalidSigner();
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xffd1aef95e7f58441b368a54b4a48fcbb4d959cd'
  file: src/publisher/DVNPublisher.sol
  line: 140
  has: function setSigner
  says: setSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x7314d1b723c8e54039f659564ff95fadbbce0fb8'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x0bd89dd5285c1459879f26c0e4df208552a05738fd407d943df55fda144ef78e'
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

DVNPublisher accepts a call to publish only with an ECDSA signature of an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSigner changes who may sign.

## Evidence

- [publish](https://etherscan.io/address/0xffd1aef95e7f58441b368a54b4a48fcbb4d959cd#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [setSigner](https://etherscan.io/address/0xffd1aef95e7f58441b368a54b4a48fcbb4d959cd#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0x0bd89dd5285c1459879f26c0e4df208552a05738fd407d943df55fda144ef78e) on record recovered [0x7314…0fb8](https://etherscan.io/address/0x7314d1b723c8e54039f659564ff95fadbbce0fb8), an account without code.

## Reviewer notes

### Mechanism

publish (src/publisher/DVNPublisher.sol, line 263) recovers a signer on line 269 and tests it on line 271 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. setSigner (src/publisher/DVNPublisher.sol, line 140) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 8 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x7314…0fb8; 116 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
