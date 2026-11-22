---
id: k1meevalidator-00000000-ecdsa-validator
format: 2
title: Biconomy K1MeeValidator lets a quantum attacker sign as Nexus account owners
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys validate account actions; each owner can swap in a post-quantum validator in place,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x00000000d12897ddadc2044614a9677b191a2d95'
  name: K1MeeValidator
  project: biconomy
  code: verified
  code_url: https://etherscan.io/address/0x00000000d12897ddadc2044614a9677b191a2d95#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 380
impact: funds-loss
action: Ship a post-quantum validator so Nexus owners can install it and uninstall K1MeeValidator.
evidence_level: source
checks:
- id: c1
  source: '0x00000000d12897ddadc2044614a9677b191a2d95'
  file: contracts/lib/util/EcdsaLib.sol
  line: 19
  has: if (hash.tryRecover(signature) == expectedSigner) return true;
  says: ECDSA recovery must equal the expected signer
  for:
  - evidence-2
  - justification
  - what
- id: c2
  source: '0x00000000d12897ddadc2044614a9677b191a2d95'
  file: contracts/lib/util/EcdsaLib.sol
  line: 20
  has: if (hash.toEthSignedMessageHash().tryRecover(signature) == expectedSigner) return true;
  says: eth_sign form recovery is also accepted
  for:
  - evidence-2
  - what
- id: c3
  source: '0x00000000d12897ddadc2044614a9677b191a2d95'
  file: contracts/validators/K1MeeValidator.sol
  line: 108
  has: function transferOwnership(address newOwner) external {
  says: transferOwnership is the owner-change entry point
  for:
  - evidence-3
- id: v-userop
  source: '0x00000000d12897ddadc2044614a9677b191a2d95'
  file: contracts/validators/K1MeeValidator.sol
  has: address owner = getOwner(userOp.sender);
  line: 165
  says: validateUserOp validates against the account's owner
  for:
  - evidence-1
  - justification
  - what
- id: v-getowner
  source: '0x00000000d12897ddadc2044614a9677b191a2d95'
  file: contracts/validators/K1MeeValidator.sol
  has: 'return owner == address(0) ? smartAccount : owner;'
  line: 231
  says: owner is the stored key, or the account itself
  for:
  - justification
  - what
- id: v-nocontract
  source: '0x00000000d12897ddadc2044614a9677b191a2d95'
  file: contracts/validators/K1MeeValidator.sol
  has: require(!_isContract(newOwner), NewOwnerIsContract());
  line: 110
  says: new owner cannot be a contract
  for:
  - evidence-3
- id: v-uninstall
  source: '0x00000000d12897ddadc2044614a9677b191a2d95'
  file: contracts/validators/K1MeeValidator.sol
  has: delete smartAccountOwners[msg.sender];
  line: 102
  says: uninstalling removes the account's owner key
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
  who: review (Review22)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: eip-8151-impact
  who: Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

K1MeeValidator lets one secp256k1 owner key authorize user operations and ERC-1271 signatures for a Nexus smart account. A quantum attacker who recovers that key signs as the account and takes what it holds.

## Evidence

- [validateUserOp](https://etherscan.io/address/0x00000000d12897ddadc2044614a9677b191a2d95#code) checks the signature against the account's stored owner.
- [isValidSignature](https://etherscan.io/address/0x00000000d12897ddadc2044614a9677b191a2d95#code) accepts a signature when ECDSA recovery returns the expected owner.
- [transferOwnership](https://etherscan.io/address/0x00000000d12897ddadc2044614a9677b191a2d95#code) rejects a contract as new owner, so ownership cannot move to a contract signer.

## Reviewer notes

### Mechanism

validateUserOp (lines 159-177) reads getOwner(userOp.sender) and routes by the 4-byte signature type to SimpleValidatorLib, TxValidatorLib, PermitValidatorLib or NoMeeFlowLib; these end in EcdsaLib.isValidSignature, which accepts if Solady tryRecover of the hash or its eth_sign form equals the owner (EcdsaLib lines 19-20). isValidSignatureWithSender (190-209) and validateSignatureWithData (215-222) use _validateSignatureForOwner, and the 7739 path uses _erc1271IsValidSignatureNowCalldata (321) with the same EcdsaLib check. onInstall (91) and transferOwnership (110) revert with NewOwnerIsContract, so the owner cannot be a contract signer. getOwner (229-232) falls back to the account itself when no owner is stored (EIP-7702 case). onUninstall (101-104) deletes the owner, so uninstalling after installing a post-quantum validator removes the ECDSA path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin.
- Ruled out: The validator itself holds no funds; value sits in the accounts.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
