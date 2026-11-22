---
id: redliongazettemanager-3c624544-rotate-signer-before-migrating
format: 2
title: 'RedlionGazetteManager: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3c6245446c100818d2a9d1e4942bb5716df87925'
  name: RedlionGazetteManager
  code: verified
  code_url: https://etherscan.io/address/0xa5bdca10d2a8f82a0f5bcc3473fbded781dc5415#code
  proxy_of: '0xa5bdca10d2a8f82a0f5bcc3473fbded781dc5415'
  copies: 2
  family: a8492730eff72943bb61d5e56ba4d0ea
  upgradeable: 'yes'
  admin: '0x96d00d0d6de5d862b9a3412cc8cf072eb5872a2c'
value:
  usd: 27
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace the signer with setSIGNER before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa5bdca10d2a8f82a0f5bcc3473fbded781dc5415'
  file: contracts/gazette/RedlionGazetteManager.sol
  line: 430
  has: return msgHash.toEthSignedMessageHash().recover(signature) == SIGNER;
  says: _validSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa5bdca10d2a8f82a0f5bcc3473fbded781dc5415'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa5bdca10d2a8f82a0f5bcc3473fbded781dc5415'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xa5bdca10d2a8f82a0f5bcc3473fbded781dc5415'
  file: contracts/gazette/RedlionGazetteManager.sol
  line: 381
  has: function setSIGNER
  says: setSIGNER changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xb033b2d78645a4372db71d0a43118bed60f48ab6'
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

RedlionGazetteManager checks an ECDSA signature in _validSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setSIGNER changes the signer.

## Evidence

- [_validSignature](https://etherscan.io/address/0xa5bdca10d2a8f82a0f5bcc3473fbded781dc5415#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setSIGNER](https://etherscan.io/address/0xa5bdca10d2a8f82a0f5bcc3473fbded781dc5415#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xb033…8ab6](https://etherscan.io/address/0xb033b2d78645a4372db71d0a43118bed60f48ab6), an account without code.

## Reviewer notes

### Mechanism

_validSignature (contracts/gazette/RedlionGazetteManager.sol, line 426) recovers a signer on line 430 and tests it on line 430 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setSIGNER (contracts/gazette/RedlionGazetteManager.sol, line 381) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-07-04, recovering 0xb033…8ab6; 0 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
