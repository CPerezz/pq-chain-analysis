---
id: simplemultisig-c82abe4d-simplemultisig-owner-keys
format: 2
title: Multisig owners' ECDSA keys let a quantum attacker drain funds
status: confirmed
severity: MEDIUM
justification: Fixed ECDSA owner set guards all funds; the operator must fix it by moving funds to a post-quantum
  wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc82abe4dfa94b9b5453d31274fb7500459a0d12d'
  name: SimpleMultiSig
  code: verified
  code_url: https://etherscan.io/address/0xc82abe4dfa94b9b5453d31274fb7500459a0d12d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 17597756
  basis: held
activity:
  txs_90d: 13
impact: funds-loss
action: Deploy a post-quantum wallet and have the owner quorum sign execute calls moving all ETH and tokens there.
evidence_level: source
checks:
- id: c1
  source: '0xc82abe4dfa94b9b5453d31274fb7500459a0d12d'
  file: source/SimpleMultiSig-v2.0.1.sol
  line: 71
  has: address recovered = ecrecover(totalHash, sigV[i], sigR[i], sigS[i]);
  says: signatures are verified with ECDSA ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: thr
  source: '0xc82abe4dfa94b9b5453d31274fb7500459a0d12d'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: if (sigR.length < threshold) {
  line: 92
  says: execute requires at least threshold signatures
  for:
  - what
- id: call
  source: '0xc82abe4dfa94b9b5453d31274fb7500459a0d12d'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: '(bool success,) = destination.call{value: value, gas: gasLimit}(data);'
  line: 119
  says: execute performs an arbitrary call with value
  for:
  - action
  - evidence-2
  - what
- id: exec-any
  source: '0xc82abe4dfa94b9b5453d31274fb7500459a0d12d'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: if (executor != msg.sender && executor != address(0)) {
  line: 98
  says: executor zero lets anyone submit signed calls
  for:
  - what
- id: isown
  source: '0xc82abe4dfa94b9b5453d31274fb7500459a0d12d'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: if (!isOwner[recovered]) {
  line: 75
  says: recovered signer must be an owner
  for:
  - evidence-1
- id: own-set
  source: '0xc82abe4dfa94b9b5453d31274fb7500459a0d12d'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: isOwner[owners_[i]] = true;
  line: 53
  says: owners are set in the constructor
  for:
  - evidence-3
  - justification
- id: own-imm
  source: '0xc82abe4dfa94b9b5453d31274fb7500459a0d12d'
  file: source/SimpleMultiSig-v2.0.1.sol
  has: mapping(address => bool) public isOwner; // immutable state
  line: 22
  says: owner mapping is declared immutable state, never rewritten
  for:
  - action
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

This multisig executes any call once enough signatures recover, via ECDSA, to its fixed owners. A quantum attacker who derives a quorum of owner keys can sign an execute that sends out all its ETH and tokens.

## Evidence

- [validateSignatures](https://etherscan.io/address/0xc82abe4dfa94b9b5453d31274fb7500459a0d12d#code) accepts a signer only if ecrecover returns an owner address.
- [execute](https://etherscan.io/address/0xc82abe4dfa94b9b5453d31274fb7500459a0d12d#code) calls any destination with any value and data after signature checks pass.
- [The constructor](https://etherscan.io/address/0xc82abe4dfa94b9b5453d31274fb7500459a0d12d#code) sets owners and threshold, and the contract has no function to change them.

## Reviewer notes

### Mechanism

execute (lines 82-124) checks sigR.length >= threshold (line 92), allows executor == address(0) so anyone may submit (line 98), builds an EIP-712 hash over destination, value, data, nonce, executor and gasLimit (lines 103-114), then calls validateSignatures (line 116). There, each signature is ecrecover'd (line 71), must be strictly increasing (line 72) and isOwner (line 75). On success it calls destination.call{value, gas}(data) (line 119). isOwner, ownersArr and threshold are written only in the constructor (lines 53, 56-57); no other function writes them and there is no ERC-1271 or module path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No upgrade path: the contract is not a proxy.
- Ruled out: Owner set cannot be rotated in place.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
