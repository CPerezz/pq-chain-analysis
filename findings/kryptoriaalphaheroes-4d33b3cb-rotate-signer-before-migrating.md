---
id: kryptoriaalphaheroes-4d33b3cb-rotate-signer-before-migrating
format: 2
title: 'KryptoriaAlphaHeroes: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4d33b3cbd5c8971a67d8f555c73a7ca740c498bd'
  name: KryptoriaAlphaHeroes
  code: verified
  code_url: https://etherscan.io/address/0x71455652c9641bb4f9dba27491b745988c064da3#code
  proxy_of: '0x71455652c9641bb4f9dba27491b745988c064da3'
  copies: 2
  family: b78b7907546cd728ea0cfc0d032fd21c
  upgradeable: 'yes'
  admin: '0x98bf8269d5f80ba862320ea0204257723bcc3c2a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setPlatformAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x71455652c9641bb4f9dba27491b745988c064da3'
  file: KryptoriaAlphaHeroes.sol
  line: 3700
  has: return (recoverSigner(message, sig) == _platformAddress);
  says: isValidURI recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x71455652c9641bb4f9dba27491b745988c064da3'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x71455652c9641bb4f9dba27491b745988c064da3'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0x71455652c9641bb4f9dba27491b745988c064da3'
  file: KryptoriaAlphaHeroes.sol
  line: 3517
  has: function setPlatformAddress
  says: setPlatformAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x4d33b3cbd5c8971a67d8f555c73a7ca740c498bd'
  fn: _platformAddress()(address)
  is: '0x55bf8ba0eca5e367f86db3def773aed95e9ee861'
  says: The signer it keeps in storage is 0x55bf8ba0eca5e367f86db3def773aed95e9ee861 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x55bf8ba0eca5e367f86db3def773aed95e9ee861'
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

KryptoriaAlphaHeroes checks an ECDSA signature in isValidURI and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setPlatformAddress changes the signer.

## Evidence

- [isValidURI](https://etherscan.io/address/0x71455652c9641bb4f9dba27491b745988c064da3#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setPlatformAddress](https://etherscan.io/address/0x71455652c9641bb4f9dba27491b745988c064da3#code) changes the signer; only the owner can call it.
- The signer at the block is [0x55bf…e861](https://etherscan.io/address/0x55bf8ba0eca5e367f86db3def773aed95e9ee861), an account without code.

## Reviewer notes

### Mechanism

isValidURI (KryptoriaAlphaHeroes.sol, line 3694) recovers a signer on line 3700 and tests it on line 3700 against the signer it keeps in storage (_platformAddress() returns 0x55bf8ba0eca5e367f86db3def773aed95e9ee861). Neither isValidSignature selector is in the code, so that account is never asked. setPlatformAddress (KryptoriaAlphaHeroes.sol, line 3517) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). No signature recovery by this address is on record; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
