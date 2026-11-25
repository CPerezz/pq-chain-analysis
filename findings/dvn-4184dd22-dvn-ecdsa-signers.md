---
id: dvn-4184dd22-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorums verify fake messages; the DVN operator fixes it by deploying a post-quantum
  DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and move OApp configs to it.
evidence_level: source
checks:
- id: c1
  source: '0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signature with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and manages ECDSA signer addresses.
  for:
  - evidence-3
  - justification
  - what
- id: s-len
  source: '0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signature bundle must be exactly quorum 65-byte signatures.
  for:
  - what
- id: s-member
  source: '0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Each recovered address must be in the signer set.
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This DVN accepts an action when a quorum of signatures recovers, via ECDSA, to addresses in its signer set. A quantum attacker who derives the signers' private keys from their public keys can produce a quorum the DVN accepts. Signers rotate only to other ECDSA keys.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108#code) recovers each 65-byte signature with ECDSA.tryRecover and requires it to be in the signer set.
- [tryRecover](https://etherscan.io/address/0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108#code) calls the ecrecover precompile (secp256k1).
- [setSigner](https://etherscan.io/address/0x4184dd22692c8b50d8d7ee0d7b6028e45dbf8108#code) is onlySelf and changes the set of ECDSA signer addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures(hash, signatures) requires signatures.length == quorum * 65 (line 94). It wraps the hash as an Ethereum signed message (line 98). For each 65-byte slice it calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139). Signers must appear in ascending order (line 107) and be members of signerSet (line 108). DVN.execute uses this check before making target calls such as ReceiveUln302.verify. Per kev's finding, quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner and setQuorum are onlySelf (DVN.sol line 104), so signer rotation stays within ECDSA addresses. With signer keys recovered by a quantum computer, an attacker can verify fabricated packets for OApps that require this DVN.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable; it holds about $0 itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
