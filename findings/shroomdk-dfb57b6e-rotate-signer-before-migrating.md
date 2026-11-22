---
id: shroomdk-dfb57b6e-rotate-signer-before-migrating
format: 2
title: 'ShroomDK: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdfb57b6e16ddb97aeb8847386989f4dca7202146'
  name: ShroomDK
  code: verified
  code_url: https://etherscan.io/address/0xdfb57b6e16ddb97aeb8847386989f4dca7202146#code
  copies: 1
  upgradeable: 'no'
  admin: '0x3c8d28cffb24f431988af14b812138e3d3dee1bb'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: liveness
action: Replace the signer with setVerifiedSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xdfb57b6e16ddb97aeb8847386989f4dca7202146'
  file: contracts/ShroomDK/ShroomDK.sol
  line: 62
  has: address signer = recoverSignerAddress(hashed, signature);
  says: verify recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xdfb57b6e16ddb97aeb8847386989f4dca7202146'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xdfb57b6e16ddb97aeb8847386989f4dca7202146'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xdfb57b6e16ddb97aeb8847386989f4dca7202146'
  file: contracts/ShroomDK/ShroomDK.sol
  line: 64
  has: return (signer == _verifiedSigner);
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xdfb57b6e16ddb97aeb8847386989f4dca7202146'
  file: contracts/ShroomDK/ShroomDK.sol
  line: 99
  has: function setVerifiedSigner
  says: setVerifiedSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xc8d92c65c56783a44873f7041371455e48212342'
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

ShroomDK checks an ECDSA signature in verify and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setVerifiedSigner changes the signer.

## Evidence

- [verify](https://etherscan.io/address/0xdfb57b6e16ddb97aeb8847386989f4dca7202146#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setVerifiedSigner](https://etherscan.io/address/0xdfb57b6e16ddb97aeb8847386989f4dca7202146#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xc8d9…2342](https://etherscan.io/address/0xc8d92c65c56783a44873f7041371455e48212342), an account without code.

## Reviewer notes

### Mechanism

verify (contracts/ShroomDK/ShroomDK.sol, line 60) recovers a signer on line 62 and tests it on line 64 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setVerifiedSigner (contracts/ShroomDK/ShroomDK.sol, line 99) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2024-07-11, recovering 0xc8d9…2342; 6 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
