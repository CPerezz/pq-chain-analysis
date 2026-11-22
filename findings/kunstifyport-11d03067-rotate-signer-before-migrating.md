---
id: kunstifyport-11d03067-rotate-signer-before-migrating
format: 2
title: 'KunstifyPort: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x11d030674d6c0c81ae7568aa476172a6a507fae0'
  name: KunstifyPort
  code: verified
  code_url: https://etherscan.io/address/0x11d030674d6c0c81ae7568aa476172a6a507fae0#code
  copies: 2
  family: e6365a22cf637dfb1a988188877e51cb
  upgradeable: 'no'
  admin: '0x84f1e166d7f0c4884cbff06a35600442c80ecd76'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: liveness
action: Replace the signer with setBackendSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x11d030674d6c0c81ae7568aa476172a6a507fae0'
  file: contracts/kunstrifyPort.sol
  line: 94
  has: return ECDSA.recover(ethHash, signature) == backendSigner;
  says: verifyOrderSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x11d030674d6c0c81ae7568aa476172a6a507fae0'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x11d030674d6c0c81ae7568aa476172a6a507fae0'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x11d030674d6c0c81ae7568aa476172a6a507fae0'
  file: contracts/kunstrifyPort.sol
  line: 80
  has: function setBackendSigner
  says: setBackendSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x11d030674d6c0c81ae7568aa476172a6a507fae0'
  fn: backendSigner()(address)
  is: '0x06cd2a24a126c3dc0fbe8798d43049c8b03a2a0c'
  says: The signer it keeps in storage is 0x06cd2a24a126c3dc0fbe8798d43049c8b03a2a0c at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x06cd2a24a126c3dc0fbe8798d43049c8b03a2a0c'
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

KunstifyPort checks an ECDSA signature in verifyOrderSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setBackendSigner changes the signer.

## Evidence

- [verifyOrderSignature](https://etherscan.io/address/0x11d030674d6c0c81ae7568aa476172a6a507fae0#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setBackendSigner](https://etherscan.io/address/0x11d030674d6c0c81ae7568aa476172a6a507fae0#code) changes the signer; only the owner can call it.
- The signer at the block is [0x06cd…2a0c](https://etherscan.io/address/0x06cd2a24a126c3dc0fbe8798d43049c8b03a2a0c), an account without code.

## Reviewer notes

### Mechanism

verifyOrderSignature (contracts/kunstrifyPort.sol, line 91) recovers a signer on line 94 and tests it on line 94 against the signer it keeps in storage (backendSigner() returns 0x06cd2a24a126c3dc0fbe8798d43049c8b03a2a0c). Neither isValidSignature selector is in the code, so that account is never asked. setBackendSigner (contracts/kunstrifyPort.sol, line 80) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 1 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
