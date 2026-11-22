---
id: distributor-96c67b14-distributor-signer
format: 2
title: Rayls airdrop Distributor trusts an ECDSA signer a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A recovered signer key releases allocations early; the admin can pause and redeploy without ECDSA,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  name: Distributor
  project: rayls
  code: verified
  code_url: https://etherscan.io/address/0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af#code
  copies: 1
  upgradeable: 'no'
  admin: '0xfdacab3de84fc1ac6518cced5afc008b16a9c1ff'
value:
  usd: 121
  basis: held
activity:
  txs_90d: 14
impact: funds-loss
action: Pause this distributor and redeploy with Merkle-only or post-quantum signed claims; have the vault revoke
  its allowance.
evidence_level: source
checks:
- id: c1
  source: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  file: src/sub/BaseDistributor.sol
  line: 343
  has: address recoveredSigner = ECDSA.recoverCalldata(prefixedHash, _signature);
  says: the claim signature is checked with ECDSA recovery
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  file: src/sub/BaseDistributor.sol
  line: 132
  has: function setSigner(address _signer) external onlyRoles(PROJECT_ADMIN) {
  says: admin can only replace the signer address
  for:
  - evidence-3
- id: c3
  source: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  file: src/sub/BaseDistributor.sol
  line: 159
  has: function pause() external onlyRoles(PROJECT_ADMIN) {
  says: admin can pause claims
  for:
  - action
  - evidence-3
  - justification
- id: s-root
  source: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  file: src/sub/BaseDistributor.sol
  has: (bytes32 _root,) = _rootCheck(_proof, _amount, _handler);
  line: 259
  says: claim checks the Merkle proof of the allocation
  for:
  - what
- id: s-exec
  source: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  file: src/sub/BaseDistributor.sol
  has: _execute(vault, _onBehalfOf, _root, _claimableAmount, _extra);
  line: 286
  says: claim pays from the vault to the recipient
  for:
  - evidence-2
  - what
- id: s-rel
  source: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  file: src/sub/BaseDistributor.sol
  has: if (_amount < _released) {
  line: 272
  says: released amount is capped by the allocation
  for:
  - what
- id: s-handler
  source: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  file: src/sub/BaseDistributor.sol
  has: if (_handler != keccak256(abi.encodePacked(_onBehalfOf))) {
  line: 254
  says: recipient is bound to the allocation's handler
  for:
  - what
- id: s-cmp
  source: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  file: src/sub/BaseDistributor.sol
  has: if (recoveredSigner != _signer) revert InvalidSignature();
  line: 345
  says: claim reverts unless the recovered address is the signer
  for:
  - evidence-1
  - what
- id: s-claimable
  source: '0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af'
  file: src/sub/BaseDistributor.sol
  has: uint256 _claimableAmount = _released - claimedAmount_;
  line: 284
  says: payout is the signed released amount minus prior claims
  for:
  - evidence-2
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (Sourcify source and on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract pays Rayls airdrop allocations from a vault when a claim carries a Merkle proof and an ECDSA signature from one signer key. A quantum attacker who recovers that key can sign any released amount up to the allocation and release it ahead of schedule to the allocation's recipient.

## Evidence

- [_signatureCheck](https://etherscan.io/address/0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af#code) reverts unless ECDSA recovers the stored signer.
- [claim](https://etherscan.io/address/0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af#code) pays the signed released amount minus what was claimed, pulled from the vault.
- [pause](https://etherscan.io/address/0x96c67b143000a60d9162f25c29fa0cf5b8d0e5af#code) and setSigner are admin-only; setSigner swaps the key, not the scheme.

## Reviewer notes

### Mechanism

claim (BaseDistributor.sol 244-288) requires _handler == keccak256(_onBehalfOf) when dynamicRecipient is false (253-256), resolves the Merkle leaf (handler, amount) to a configured root in _rootCheck (308-316), requires _released <= _amount (272), then calls _signatureCheck (282). _signatureCheck (326-346) hashes (handler, onBehalfOf, amount, released, root, this, chainid, extra), applies the eth-signed prefix, and requires ECDSA.recoverCalldata to equal signer (343-345). It then pays _released - claimedAmount to _onBehalfOf from vault via _execute (284-286). The signer alone sets how much of an allocation is released; a forged signature can release the full allocation at once, but the Merkle root caps the amount and fixes the recipient. setSigner (132) only rotates the ECDSA key.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Paying more than a Merkle allocation is blocked by _amount < _released check and the root check.
- Ruled out: Paying to a different address is blocked by the handler check while dynamicRecipient is false.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
