---
id: ecdsavalidator-845adb2c-ecdsa-validator
format: 2
title: ZeroDev ECDSA validator lets a quantum attacker take over Kernel accounts
status: confirmed
severity: MEDIUM
justification: One ECDSA owner key controls each account; MEDIUM as owners can switch validators in place once a
  PQ module exists.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x845adb2c711129d4f3966735ed98a9f09fc4ce57'
  name: ECDSAValidator
  project: zerodev
  code: verified
  code_url: https://etherscan.io/address/0x845adb2c711129d4f3966735ed98a9f09fc4ce57#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 22269
impact: funds-loss
action: Ship a post-quantum validator module so Kernel owners can change their root validator and uninstall this
  one.
evidence_level: source
checks:
- id: c1
  source: '0x845adb2c711129d4f3966735ed98a9f09fc4ce57'
  file: src/validator/ECDSAValidator.sol
  line: 58
  has: if (owner == ECDSA.recover(userOpHash, sig)) {
  says: validateUserOp succeeds when ECDSA recovers the owner from the raw hash
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x845adb2c711129d4f3966735ed98a9f09fc4ce57'
  file: src/validator/ECDSAValidator.sol
  line: 62
  has: address recovered = ECDSA.recover(ethHash, sig);
  says: validateUserOp also tries ECDSA recovery on the eth-signed hash
  for:
  - evidence-1
  - what
- id: c3
  source: '0x845adb2c711129d4f3966735ed98a9f09fc4ce57'
  file: src/validator/ECDSAValidator.sol
  line: 76
  has: if (owner == ECDSA.recover(hash, sig)) {
  says: isValidSignatureWithSender accepts when ECDSA recovers the owner
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x845adb2c711129d4f3966735ed98a9f09fc4ce57'
  file: src/validator/ECDSAValidator.sol
  line: 80
  has: address recovered = ECDSA.recover(ethHash, sig);
  says: isValidSignatureWithSender also recovers from the eth-signed hash
  for:
  - evidence-2
- id: s-install
  source: '0x845adb2c711129d4f3966735ed98a9f09fc4ce57'
  file: src/validator/ECDSAValidator.sol
  has: ecdsaValidatorStorage[msg.sender].owner = owner;
  line: 29
  says: onInstall sets a per-account owner address
  for:
  - evidence-3
  - justification
  - what
- id: s-uninstall
  source: '0x845adb2c711129d4f3966735ed98a9f09fc4ce57'
  file: src/validator/ECDSAValidator.sol
  has: delete ecdsaValidatorStorage[msg.sender];
  line: 35
  says: onUninstall removes the account's owner, allowing uninstall
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review08 (verified validator and Kernel sources)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This module authorises user operations and ERC-1271 signatures for each Kernel account that installs it, using one ECDSA owner key set at install. A quantum attacker who recovers that owner key signs user operations and moves everything the account holds.

## Evidence

- [validateUserOp](https://etherscan.io/address/0x845adb2c711129d4f3966735ed98a9f09fc4ce57#code) returns success when ECDSA recovers the stored owner from the user-op hash.
- [isValidSignatureWithSender](https://etherscan.io/address/0x845adb2c711129d4f3966735ed98a9f09fc4ce57#code) returns the ERC-1271 magic value on the same ECDSA owner check.
- [onInstall](https://etherscan.io/address/0x845adb2c711129d4f3966735ed98a9f09fc4ce57#code) stores the owner address for the calling account.

## Reviewer notes

### Mechanism

onInstall (line 29) stores ecdsaValidatorStorage[msg.sender].owner from the first 20 bytes of install data. validateUserOp (lines 56-66) loads that owner and returns SIG_VALIDATION_SUCCESS_UINT if ECDSA.recover(userOpHash, sig) (line 58) or ECDSA.recover on the eth-signed hash (line 62) equals it. isValidSignatureWithSender (lines 75-84) does the same for ERC-1271. The Kernel account executes any user op this validator approves, so whoever holds or derives the secp256k1 owner key controls the account. onUninstall (line 35) deletes the owner, so the account can remove this module after switching its root validator.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The module holds no funds itself.
- Ruled out: The module is not a proxy and has no admin.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
