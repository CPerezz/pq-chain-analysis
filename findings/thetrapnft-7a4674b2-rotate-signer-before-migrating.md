---
id: thetrapnft-7a4674b2-rotate-signer-before-migrating
format: 2
title: 'TheTrapNFT: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7a4674b24a649e85e4d031034c33169185f9d3cb'
  name: TheTrapNFT
  code: verified
  code_url: https://etherscan.io/address/0x81cca9eda3e52ca6a4cdb90ee1292abbefdd8f2a#code
  proxy_of: '0x81cca9eda3e52ca6a4cdb90ee1292abbefdd8f2a'
  copies: 2
  family: 2ca19efa524b90a06495e723b7bbdbc8
  upgradeable: 'yes'
  admin: '0x026a2db8214ca74ea8e3b535a31315dca6cc03c9'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Before a signer's account moves to real code, use grantRole so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0x81cca9eda3e52ca6a4cdb90ee1292abbefdd8f2a'
  file: contracts/TheTrapNFT.sol
  line: 196
  has: address signer = _verify(lzdatas);
  says: mint recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x81cca9eda3e52ca6a4cdb90ee1292abbefdd8f2a'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x81cca9eda3e52ca6a4cdb90ee1292abbefdd8f2a'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x81cca9eda3e52ca6a4cdb90ee1292abbefdd8f2a'
  file: contracts/TheTrapNFT.sol
  line: 199
  has: hasRole(MINTER_ROLE, signer),
  says: the recovered address must be a holder of its signing role
  for:
  - evidence-1
  - justification
  - what
- id: setter
  selector: '0x81cca9eda3e52ca6a4cdb90ee1292abbefdd8f2a'
  fn: grantRole(bytes32,address)
  says: the code has grantRole
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x42e7f0bca0bf3e0742bb44949b762b2d8a19e947'
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

TheTrapNFT accepts a call to mint only with an ECDSA signature of a holder of its signing role. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. grantRole changes who may sign.

## Evidence

- [mint](https://etherscan.io/address/0x81cca9eda3e52ca6a4cdb90ee1292abbefdd8f2a#code) recovers the signature with ECDSA and accepts only a holder of its signing role; the code never asks that account.
- [grantRole](https://etherscan.io/address/0x81cca9eda3e52ca6a4cdb90ee1292abbefdd8f2a#code) changes who may sign.
- The address recovered in its latest signature check on record is [0x42e7…e947](https://etherscan.io/address/0x42e7f0bca0bf3e0742bb44949b762b2d8a19e947), an account without code.

## Reviewer notes

### Mechanism

mint (contracts/TheTrapNFT.sol, line 191) recovers a signer on line 196 and tests it on line 199 against a holder of its signing role. Neither isValidSignature selector is in the code, so that account is never asked. grantRole is in the code. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-11-09, recovering 0x42e7…e947; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
