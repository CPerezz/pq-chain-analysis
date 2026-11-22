---
id: tokilcpclientzkdcap-ee50fafc-lcp-enclave-keys
format: 2
title: TOKI LCP client trusts ECDSA enclave keys that a quantum attacker could recover
status: confirmed
severity: MEDIUM
justification: Enclave signatures use ECDSA; the admin Safe can upgrade the client to a post-quantum scheme, so
  MEDIUM.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xee50fafc11baad66d1898d712409866844a8f644'
  name: TokiLCPClientZKDCAP
  project: datachain
  code: verified
  code_url: https://etherscan.io/address/0x1a8f920a3504a2707b49172a9a59ae4c503f30dc#code
  proxy_of: '0x1a8f920a3504a2707b49172a9a59ae4c503f30dc'
  copies: 1
  upgradeable: 'yes'
  admin: '0x0c12a2f19c3e40b4098b389bd4e74baf049456f3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade the client proxy to verify post-quantum enclave signatures, through the owner Safe.
evidence_level: source
checks:
- id: c1
  source: '0x1a8f920a3504a2707b49172a9a59ae4c503f30dc'
  file: '@datachainlab/lcp-solidity/contracts/LCPClientBase.sol'
  line: 499
  has: return ECDSA.recover(commitment, signature);
  says: verifyECDSASignature recovers the signer with ECDSA.recover.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x1a8f920a3504a2707b49172a9a59ae4c503f30dc'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover uses the ecrecover precompile.
  for:
  - what
- id: c3
  source: '0x1a8f920a3504a2707b49172a9a59ae4c503f30dc'
  file: '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol'
  line: 102
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: Ownership changes are restricted to the owner.
  for:
  - action
  - justification
- id: c4
  source: '0x1a8f920a3504a2707b49172a9a59ae4c503f30dc'
  file: '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol'
  line: 92
  has: function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy
    {
  says: The implementation is UUPS-upgradeable via upgradeToAndCall.
  for:
  - action
  - justification
- id: verify-proofs
  source: '0x1a8f920a3504a2707b49172a9a59ae4c503f30dc'
  file: '@datachainlab/lcp-solidity/contracts/LCPClientBase.sol'
  has: verifySignatures(clientStorage, commitment, commitmentProofs.signatures);
  line: 534
  says: Packet commitment proofs are checked with verifySignatures.
  for:
  - evidence-2
  - what
- id: ensure-active
  source: '0x1a8f920a3504a2707b49172a9a59ae4c503f30dc'
  file: '@datachainlab/lcp-solidity/contracts/LCPClientBase.sol'
  has: function ensureActiveKey(ClientStorage storage clientStorage, address ekAddr) internal view {
  line: 472
  says: Recovered signer addresses are checked against registered enclave keys.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

This IBC light client accepts state updates and packet proofs signed by enclave keys, checked with ECDSA recovery. A quantum attacker who recovers an active enclave key from its published signatures can sign a false counterparty state and prove packets the bridge acts on.

## Evidence

- [verifyECDSASignature](https://etherscan.io/address/0x1a8f920a3504a2707b49172a9a59ae4c503f30dc#code) returns the signer from ECDSA.recover over the commitment.
- [verifyCommitmentProofs](https://etherscan.io/address/0x1a8f920a3504a2707b49172a9a59ae4c503f30dc#code) hashes the message and passes it to verifySignatures.
- [ensureActiveKey](https://etherscan.io/address/0x1a8f920a3504a2707b49172a9a59ae4c503f30dc#code) accepts a recovered key that is registered and not expired.

## Reviewer notes

### Mechanism

LCPClientBase.updateClient calls verifySignatures(clientStorage, keccak256(proxy_message), signatures); verifyMembership uses verifyCommitmentProofs (lines 529-535), which hashes the message and calls verifySignatures. Each signature goes through verifyECDSASignature (lines 495-500), which normalises v and returns ECDSA.recover, i.e. ecrecover (ECDSA.sol line 148). The recovered address must be an active enclave key (ensureActiveKey, lines 472-481, or the operator variant ending line 470), and ensureSufficientValidSignatures (lines 483-493) applies the operator threshold. Recovering an active enclave key's secp256k1 private key from on-chain signatures lets an attacker sign arbitrary proxy messages. The IBC handler then routes forged recvPacket proofs to the TOKI Bridge, which releases pool tokens. The implementation is UUPS (upgradeToAndCall, onlyProxy plus _authorizeUpgrade onlyOwner), so the owner can replace the verification. updateOperators only rotates to other ECDSA keys.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Operator rotation does not help: new operators are ECDSA keys too.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
