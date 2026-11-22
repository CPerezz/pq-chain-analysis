---
id: ed1core-2031606c-rotate-signer-before-migrating
format: 2
title: 'ED1Core: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2031606c9d068301636aa58d5f0f2b3b04772024'
  name: ED1Core
  code: verified
  code_url: https://etherscan.io/address/0x2031606c9d068301636aa58d5f0f2b3b04772024#code
  copies: 6
  family: 152eda4f495b9da9d2fdb0d313eb8ee8
  upgradeable: 'no'
  admin: '0xfce4d31a28f1545cea73d8dcec8f787bc1c1634e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 30
impact: liveness
action: Replace the signer with setAttester before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x2031606c9d068301636aa58d5f0f2b3b04772024'
  file: ED1Core.sol
  line: 422
  has: address signer = ECDSA.recover(_attestationDigest(op), attestationSignature);
  says: mintWithOperation recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x2031606c9d068301636aa58d5f0f2b3b04772024'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x2031606c9d068301636aa58d5f0f2b3b04772024'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x2031606c9d068301636aa58d5f0f2b3b04772024'
  file: ED1Core.sol
  line: 423
  has: if (signer != attester) revert InvalidAttestation();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x2031606c9d068301636aa58d5f0f2b3b04772024'
  file: ED1Core.sol
  line: 741
  has: function setAttester
  says: setAttester changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x2031606c9d068301636aa58d5f0f2b3b04772024'
  fn: attester()(address)
  is: '0xf8b4f42d2a5ee0ae30ef6d7ccfc6ccb23e8c3665'
  says: The signer it keeps in storage is 0xf8b4f42d2a5ee0ae30ef6d7ccfc6ccb23e8c3665 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xf8b4f42d2a5ee0ae30ef6d7ccfc6ccb23e8c3665'
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

ED1Core accepts a call to mintWithOperation only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAttester changes the signer.

## Evidence

- [mintWithOperation](https://etherscan.io/address/0x2031606c9d068301636aa58d5f0f2b3b04772024#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAttester](https://etherscan.io/address/0x2031606c9d068301636aa58d5f0f2b3b04772024#code) changes the signer; only a role holder can call it.
- The signer at the block is [0xf8b4…3665](https://etherscan.io/address/0xf8b4f42d2a5ee0ae30ef6d7ccfc6ccb23e8c3665), an account without code.

## Reviewer notes

### Mechanism

mintWithOperation (ED1Core.sol, line 394) recovers a signer on line 422 and tests it on line 423 against the signer it keeps in storage (attester() returns 0xf8b4f42d2a5ee0ae30ef6d7ccfc6ccb23e8c3665). Neither isValidSignature selector is in the code, so that account is never asked. setAttester (ED1Core.sol, line 741) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 6 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 30 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
