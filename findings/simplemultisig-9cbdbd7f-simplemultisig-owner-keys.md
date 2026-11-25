---
id: simplemultisig-9cbdbd7f-simplemultisig-owner-keys
format: 2
title: SimpleMultiSig wallet trusts owner ECDSA keys a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Fixed ECDSA owner set guards all funds; the operator must move them to a post-quantum wallet, so
  MEDIUM.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9cbdbd7fa768ad6e9546ff57238722fa9b925329'
  name: SimpleMultiSig
  code: verified
  code_url: https://etherscan.io/address/0x9cbdbd7fa768ad6e9546ff57238722fa9b925329#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 27998622
  basis: held
activity:
  txs_90d: 2986
impact: funds-loss
action: Deploy a post-quantum-capable wallet and have the owner quorum execute transfers of all ETH and tokens to
  it.
evidence_level: source
checks:
- id: c1
  source: '0x9cbdbd7fa768ad6e9546ff57238722fa9b925329'
  file: source/SimpleMultiSig-v2.0.1.sol
  line: 71
  has: address recovered = ecrecover(totalHash, sigV[i], sigR[i], sigS[i]);
  says: each signature is verified by ECDSA ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: exec-call
  source: '0x9cbdbd7fa768ad6e9546ff57238722fa9b925329'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: '(bool success,) = destination.call{value: value, gas: gasLimit}(data);'
  line: 119
  says: execute performs an arbitrary call with value after validation
  for:
  - action
  - evidence-2
  - what
- id: exec-threshold
  source: '0x9cbdbd7fa768ad6e9546ff57238722fa9b925329'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: if (sigR.length < threshold) {
  line: 92
  says: execute requires at least threshold signatures
  for:
  - what
- id: is-owner
  source: '0x9cbdbd7fa768ad6e9546ff57238722fa9b925329'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: if (!isOwner[recovered]) {
  line: 75
  says: recovered signer must be an owner
  for:
  - evidence-1
  - what
- id: ctor-owners
  source: '0x9cbdbd7fa768ad6e9546ff57238722fa9b925329'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: isOwner[owners_[i]] = true;
  line: 53
  says: owners are set in the constructor
  for:
  - action
  - evidence-3
  - justification
  - what
- id: ctor-threshold
  source: '0x9cbdbd7fa768ad6e9546ff57238722fa9b925329'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: threshold = threshold_;
  line: 57
  says: threshold is set in the constructor
  for:
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review18 (full Sourcify source, owner/threshold reads, deployer's 3,146 creations grouped by code hash)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This multisig wallet runs any call that carries enough owner signatures. Each signature is checked by ECDSA recovery against a fixed owner set, so a quantum attacker who derives enough owner keys can send the wallet's funds anywhere.

## Evidence

- [validateSignatures](https://etherscan.io/address/0x9cbdbd7fa768ad6e9546ff57238722fa9b925329#code) accepts a signature when ECDSA recovers an owner address.
- [execute](https://etherscan.io/address/0x9cbdbd7fa768ad6e9546ff57238722fa9b925329#code) calls any destination with any value and data after the signature check.
- Owners and threshold are written in the [constructor](https://etherscan.io/address/0x9cbdbd7fa768ad6e9546ff57238722fa9b925329#code) and marked immutable state.

## Reviewer notes

### Mechanism

execute (line 82) requires sigR.length >= threshold (line 92), allows executor == address(0) so anyone can submit (line 98), builds an EIP-712 totalHash over destination, value, data, nonce, executor, gasLimit (lines 103-114) and calls validateSignatures (line 116). validateSignatures runs ecrecover per signature (line 71), requires strictly increasing recovered addresses (line 72) that are isOwner (line 75). Then nonce++ and destination.call{value, gas}(data) (line 119). isOwner, ownersArr and threshold are set only in the constructor (lines 53, 56-57); no function changes them, so the owner set cannot be rotated to post-quantum keys and funds must move to a new deployment.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No upgrade path, module or ERC-1271 signer check in the code.
- Ruled out: No owner or threshold change function.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
