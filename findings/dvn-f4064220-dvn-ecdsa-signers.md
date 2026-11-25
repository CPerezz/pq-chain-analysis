---
id: dvn-f4064220-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps; operators fix it with post-quantum DVNs, no
  protocol change
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf4064220871e3b94ca6ab3b0cee8e29178bf47de'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xf4064220871e3b94ca6ab3b0cee8e29178bf47de#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps and default configs point at
  it
evidence_level: source
checks:
- id: c1
  source: '0xf4064220871e3b94ca6ab3b0cee8e29178bf47de'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signer with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xf4064220871e3b94ca6ab3b0cee8e29178bf47de'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xf4064220871e3b94ca6ab3b0cee8e29178bf47de'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and takes an address (ECDSA key).
  for:
  - evidence-3
- id: nc-len
  source: '0xf4064220871e3b94ca6ab3b0cee8e29178bf47de'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signatures must be exactly quorum 65-byte ECDSA signatures.
  for:
  - what
- id: nc-committee
  source: '0xf4064220871e3b94ca6ab3b0cee8e29178bf47de'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Each recovered signer must be in the signer set.
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

This DVN verifies LayerZero messages for OApps when a quorum of its signers signs; each signature is checked with ECDSA recovery. A quantum attacker who recovers a quorum of signer keys can sign fabricated verifications that OApps relying on this DVN act on.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xf4064220871e3b94ca6ab3b0cee8e29178bf47de#code) recovers each 65-byte signature with ECDSA.tryRecover and requires the signer in the committee.
- [tryRecover](https://etherscan.io/address/0xf4064220871e3b94ca6ab3b0cee8e29178bf47de#code) calls ecrecover to get the signer address.
- [setSigner](https://etherscan.io/address/0xf4064220871e3b94ca6ab3b0cee8e29178bf47de#code) is onlySelf and swaps signer addresses, which are ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 93-112) requires _signatures.length == quorum * 65, prefixes the hash with the Ethereum signed-message header, then for each 65-byte slice calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139); recovered signers must be strictly ascending and in signerSet (line 108). In the DVN, execute uses this check before calling targets such as ReceiveUln302.verify, so a quorum of recovered secp256k1 keys suffices to verify a fabricated packet header and payload hash. setSigner (DVN.sol line 104) is onlySelf and only rotates to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; holds about no funds itself

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
