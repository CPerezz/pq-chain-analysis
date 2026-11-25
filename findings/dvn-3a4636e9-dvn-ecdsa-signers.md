---
id: dvn-3a4636e9-dvn-ecdsa-signers
format: 2
title: Nansen DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged ECDSA quorum verifies fake messages for OApps requiring this DVN; operator must deploy a post-quantum
  DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3a4636e9ab975d28d3af808b4e1c9fd936374e30'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x3a4636e9ab975d28d3af808b4e1c9fd936374e30#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6000
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs, and have OApps point their DVN configs at
  it.
evidence_level: source
checks:
- id: c1
  source: '0x3a4636e9ab975d28d3af808b4e1c9fd936374e30'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x3a4636e9ab975d28d3af808b4e1c9fd936374e30'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the secp256k1 ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x3a4636e9ab975d28d3af808b4e1c9fd936374e30'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and takes an ECDSA signer address.
  for:
  - action
  - evidence-3
- id: v1
  source: '0x3a4636e9ab975d28d3af808b4e1c9fd936374e30'
  file: contracts/uln/dvn/MultiSig.sol
  has: function verifySignatures(bytes32 _hash, bytes calldata _signatures) public view returns (bool, Errors) {
  line: 93
  says: The DVN's signature check takes a hash and a packed set of signatures.
  for:
  - what
- id: v2
  source: '0x3a4636e9ab975d28d3af808b4e1c9fd936374e30'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Each recovered address must be in the signer committee.
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

This DVN verifies LayerZero messages for OApps that require it, and it acts only on a quorum of secp256k1 signatures from its signer set. A quantum attacker who recovers a quorum of signer keys can sign fabricated packets that this DVN then verifies.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x3a4636e9ab975d28d3af808b4e1c9fd936374e30#code) recovers each 65-byte signature with ECDSA.tryRecover and checks the signer is in the committee.
- [tryRecover](https://etherscan.io/address/0x3a4636e9ab975d28d3af808b4e1c9fd936374e30#code) calls the ecrecover precompile on secp256k1 signatures.
- [setSigner](https://etherscan.io/address/0x3a4636e9ab975d28d3af808b4e1c9fd936374e30#code) is onlySelf and adds signer addresses, so rotation stays on ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires _signatures.length == quorum*65, wraps the hash as an EIP-191 message (line 98), then for each slice calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139). It requires ascending signer order (line 107) and committee membership via isSigner (line 108). DVN.execute uses this check before calling targets such as ReceiveUln302.verify; when all required DVNs of an OApp have verified, the payload hash is committed to EndpointV2 and lzReceive runs it. DVN.setSigner (line 104) is onlySelf and takes an address, so signers rotate only to other ECDSA keys. Kev's census reads quorum 1 of 1 for this DVN (operator Nansen).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN holds no funds; the value is in the OApps that require it.
- Ruled out: Not upgradeable: no proxy; only signers and quorum change.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
