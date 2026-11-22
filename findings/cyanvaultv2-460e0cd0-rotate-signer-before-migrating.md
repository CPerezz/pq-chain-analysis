---
id: cyanvaultv2-460e0cd0-rotate-signer-before-migrating
format: 2
title: 'CyanVaultV2: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x460e0cd087033a73e1bc5c071711f1f27884968a'
  name: CyanVaultV2
  code: verified
  code_url: https://etherscan.io/address/0xd8dfc66f21149dda5b6904b9c9bcf3c62db303cd#code
  proxy_of: '0xd8dfc66f21149dda5b6904b9c9bcf3c62db303cd'
  copies: 10
  family: dc6228849d2f53d6f3cb270f42355a36
  upgradeable: 'yes'
  admin: '0x891222addfaf54ab043152e651d7908433941374'
value:
  usd: 117344
  basis: held
activity:
  txs_90d: 121
impact: liveness
action: Replace the signer with updateCyanSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xd8dfc66f21149dda5b6904b9c9bcf3c62db303cd'
  file: contracts/main/CyanVaultV2.sol
  line: 530
  has: require(signedHash.recover(info.signature) == cyanSigner, "Invalid Signature");
  says: verifyAutoLiquidationSignature recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xd8dfc66f21149dda5b6904b9c9bcf3c62db303cd'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xd8dfc66f21149dda5b6904b9c9bcf3c62db303cd'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xd8dfc66f21149dda5b6904b9c9bcf3c62db303cd'
  file: contracts/main/CyanVaultV2.sol
  line: 511
  has: function updateCyanSigner
  says: updateCyanSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x4477332adc9545c48a4e5a10e1a202cf224fae93'
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

CyanVaultV2 checks an ECDSA signature in verifyAutoLiquidationSignature and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateCyanSigner changes the signer.

## Evidence

- [verifyAutoLiquidationSignature](https://etherscan.io/address/0xd8dfc66f21149dda5b6904b9c9bcf3c62db303cd#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateCyanSigner](https://etherscan.io/address/0xd8dfc66f21149dda5b6904b9c9bcf3c62db303cd#code) changes the signer; only a role holder can call it.
- The address recovered in its latest signature check on record is [0x4477…ae93](https://etherscan.io/address/0x4477332adc9545c48a4e5a10e1a202cf224fae93), an account without code.

## Reviewer notes

### Mechanism

verifyAutoLiquidationSignature (contracts/main/CyanVaultV2.sol, line 517) recovers a signer on line 530 and tests it on line 530 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. updateCyanSigner (contracts/main/CyanVaultV2.sol, line 511) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 10 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2025-05-25, recovering 0x4477…ae93; 121 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
