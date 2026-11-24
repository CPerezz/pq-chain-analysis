---
id: contract-642c9b39-rotate-signer-before-migrating
format: 2
title: WalletCore account needs another validator before it takes real code
status: candidate
severity: INFORMATIONAL
justification: Nothing breaks while the account keeps its EIP-7702 delegation; it can add a validator first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x642c9b393c3754d3618b88e16d6c96c13a467627'
  code: verified
  code_url: https://etherscan.io/address/0x69e6bd1c4082403fc7917a61f6216552fc1a541d#code
  copies: 106596
  family: fd63c340035522dc3c96e96e6f47946a
value:
  usd: 566572
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Add a validator holding another key through addValidator, or keep the EIP-7702 delegation, before taking
  real code.
evidence_level: source
checks:
- id: deleg
  code: '0x642c9b393c3754d3618b88e16d6c96c13a467627'
  is: delegation
  target: '0x69e6bd1c4082403fc7917a61f6216552fc1a541d'
  says: the account's code is an EIP-7702 delegation to WalletCore
  for:
  - justification
  - what
  - whose
- id: bal
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x642c9b393c3754d3618b88e16d6c96c13a467627'
  is: '312304683655964519335'
  says: the account holds 312.30 ETH
  for:
  - what
- id: owner
  call: '0x827dd5126becfd6d662d332bb748d9c0a28bc792'
  fn: getOwner()(address)
  is: '0x642c9b393c3754d3618b88e16d6c96c13a467627'
  says: the account's storage clone is initialized and owned by the account itself
  for:
  - whose
- id: sent
  nonce: '0x642c9b393c3754d3618b88e16d6c96c13a467627'
  is: 140
  says: the account's own key has sent 140 transactions
  for:
  - whose
- id: selfroute
  source: '0x69e6bd1c4082403fc7917a61f6216552fc1a541d'
  file: src/lib/WalletCoreLib.sol
  line: 57
  has: if (validator == SELF_VALIDATION_ADDRESS) {
  says: validator address(1) selects the account's own ECDSA key
  for:
  - evidence-1
  - what
- id: self
  source: '0x69e6bd1c4082403fc7917a61f6216552fc1a541d'
  file: src/lib/WalletCoreLib.sol
  line: 80
  has: return recoveredSigner == address(this);
  says: the recovered signer must be the account's own address
  for:
  - evidence-1
  - justification
  - what
- id: valpath
  source: '0x69e6bd1c4082403fc7917a61f6216552fc1a541d'
  file: src/lib/WalletCoreLib.sol
  line: 60
  has: try IValidator(validator).validate(typedDataHash, validationData) {
  says: any other validator address is asked to validate the call
  for:
  - what
- id: erc1271
  source: '0x69e6bd1c4082403fc7917a61f6216552fc1a541d'
  file: src/WalletCore.sol
  line: 171
  has: if (recovered == address(this)) return MAGIC_VALUE;
  says: ERC-1271 accepts a 65-byte signature that recovers the account itself
  for:
  - evidence-2
  - what
- id: vcheck
  source: '0x69e6bd1c4082403fc7917a61f6216552fc1a541d'
  file: src/ValidationLogic.sol
  line: 81
  has: try getMainStorage().validateValidator(validator) {} catch {
  says: the ERC-1271 validator path requires a validator registered in the account's storage
  for:
  - evidence-2
- id: onlyself
  source: '0x69e6bd1c4082403fc7917a61f6216552fc1a541d'
  file: src/WalletCore.sol
  line: 57
  has: if (msg.sender != address(this)) revert Errors.NotFromSelf();
  says: direct calls and addValidator must come from the account itself
  for:
  - evidence-3
  - what
- id: addval
  source: '0x69e6bd1c4082403fc7917a61f6216552fc1a541d'
  file: src/WalletCore.sol
  lines:
  - 147
  - 151
  has: ) external onlySelf {
  says: addValidator is callable by the account itself
  for:
  - action
  - evidence-3
  - justification
- id: register
  source: '0x69e6bd1c4082403fc7917a61f6216552fc1a541d'
  file: src/ValidationLogic.sol
  line: 58
  has: getMainStorage().setValidatorStatus(createdAddress, true);
  says: addValidator registers the cloned validator in the account's storage
  for:
  - action
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-642c9b39, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL candidate (PQ-17): a WalletCore EIP-7702 account (312 ETH) whose signatures recover
    against the account itself, with addValidator (self-only) to register another validator first; an account that
    takes real code without one loses its own signatures and, by EIP-3607, its sending. This card carries the account''s
    notice: PQ-20''s detection needs no stored key or validator path beside the own-key check, and WalletCore has
    one, so the 7702-own-key-only row is covered by this card. Refuter agrees; Claude read the sheet.'
related: []
---

## What happens

This account runs WalletCore through an EIP-7702 delegation and holds 312 ETH. Its signed calls and its ERC-1271 answers accept the account's own ECDSA key or a validator contract. If it takes this logic as real code, its own key stops counting; a direct call must come from the account itself.

## Evidence

- [_validateSelf](https://etherscan.io/address/0x69e6bd1c4082403fc7917a61f6216552fc1a541d#code) accepts an ECDSA signature only when it recovers the account's own address.
- [isValidSignature](https://etherscan.io/address/0x69e6bd1c4082403fc7917a61f6216552fc1a541d#code) accepts a 65-byte signature from the account's own key, or else asks a registered validator.
- [addValidator](https://etherscan.io/address/0x69e6bd1c4082403fc7917a61f6216552fc1a541d#code) is callable only by the account itself and registers a new validator.

## Reviewer notes

### Mechanism

The account's code is an EIP-7702 delegation to WalletCore (0x69e6...). executeWithValidator and executeFromExecutor (session) call WalletCoreLib.validate: with validator == address(1) it runs _validateSelf, which recovers the EIP-712 hash with ECDSA.tryRecover and requires recoveredSigner == address(this) (WalletCoreLib.sol line 80); any other validator address is called through IValidator.validate (line 60). isValidSignature (ERC-1271, WalletCore.sol 163-184) returns the magic value for a 65-byte signature that recovers address(this), otherwise treats the first 20 bytes as a validator that must pass storage.validateValidator (ValidationLogic.sol 81). executeFromSelf and addValidator are onlySelf (msg.sender == address(this)). addValidator clones a validator implementation and sets its status in the per-account storage clone 0x827d..., whose getOwner() is this account. Under EIP-8151 a delegated account still recovers, so nothing changes today. If the account took this logic as real code, every address(1) path and the 65-byte ERC-1271 path would fail, and it could no longer send transactions itself; only a registered validator (or a session signed through one) would still authorise calls.

### Checks

- Header facts: this address alone, at block 26,438,999; 106,596 addresses run this code.
- Ruled out: 7702-own-key-only: the recovered address is compared with address(this), but a validator path stands beside it (WalletCoreLib.sol line 60, ValidationLogic.sol line 81) and addValidator adds one, so the holder can switch keys before migrating; filed as rotate-before-migrating.
- Ruled out: unused-implementation / wrong-code: this address is an account with its own delegation to WalletCore, has sent 140 transactions and has an initialized storage clone owned by itself; not implementation code.
- Ruled out: breaks-by-itself: no recovery here gives the precompile a fixed gas amount (tryRecover forwards all gas). The family replay 0x9f2b80e0... that fails under EIP-8151 alone is a USDC permit (tx to 0xa0b86991...) with a tight sender gas limit of 82,894; it belongs to USDC's row, not this account.
- Ruled out: erc1271: a signer with real code is not asked through ERC-1271 on the address(1) path; _validateSelf compares the recovered address only.

### Questions

- Has this account registered any validator? That needs ValidatorAdded / ValidatorStatusUpdated logs of the account and its storage clone 0x827dd5126becfd6d662d332bb748d9c0a28bc792; if one is registered with a non-ECDSA or other key, the account already has a path that survives real code.
- Does the storage clone's readAndUpdateNonce require the named validator to be registered? Its implementation 0x31a7a07d27a8faf008b53034529fa5523273a9ec is not in the dossier's sources.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
