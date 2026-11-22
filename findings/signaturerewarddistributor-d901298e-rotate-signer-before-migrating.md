---
id: signaturerewarddistributor-d901298e-rotate-signer-before-migrating
format: 2
title: 'This contract: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd901298e6855a909831d76ddfe69f8dcf2bd3828'
  name: SignatureRewardDistributor
  code: verified
  code_url: https://etherscan.io/address/0xeee50e5c54b04f24d10e0efe46926d4c7c23d819#code
  proxy_of: '0xeee50e5c54b04f24d10e0efe46926d4c7c23d819'
  copies: 6
  family: 90e8756f3240fca884985485d9e68f30
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 22
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xeee50e5c54b04f24d10e0efe46926d4c7c23d819'
  file: contracts/claim/SignatureRewardDistributor.sol
  line: 484
  has: address recovered = ECDSA.recover(digest, signature);
  says: _processClaim recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xeee50e5c54b04f24d10e0efe46926d4c7c23d819'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xeee50e5c54b04f24d10e0efe46926d4c7c23d819'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xeee50e5c54b04f24d10e0efe46926d4c7c23d819'
  file: contracts/claim/SignatureRewardDistributor.sol
  line: 485
  has: if (!hasRole(SIGNER_ROLE, recovered)) {
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0xeee50e5c54b04f24d10e0efe46926d4c7c23d819'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xa39e3a8878930dd4b2c82ec64d4fbc8aaeb26bb5'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xa8dd7bf5e6300b9083bcee901f57a5f998b606086a947a776ec33826a684402b'
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

This contract checks an ECDSA signature in _processClaim and accepts only a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [_processClaim](https://etherscan.io/address/0xeee50e5c54b04f24d10e0efe46926d4c7c23d819#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0xeee50e5c54b04f24d10e0efe46926d4c7c23d819#code) changes who may sign.
- Its latest signed [transaction](https://etherscan.io/tx/0xa8dd7bf5e6300b9083bcee901f57a5f998b606086a947a776ec33826a684402b) on record recovered [0xa39e…6bb5](https://etherscan.io/address/0xa39e3a8878930dd4b2c82ec64d4fbc8aaeb26bb5), an account without code.

## Reviewer notes

### Mechanism

_processClaim (contracts/claim/SignatureRewardDistributor.sol, line 446) recovers a signer on line 484 and tests it on line 485 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 6 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-15, recovering 0xa39e…6bb5; 22 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
