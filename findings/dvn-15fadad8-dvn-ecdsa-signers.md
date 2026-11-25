---
id: dvn-15fadad8-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: DVN trusts secp256k1 signer quorums; operator must deploy a post-quantum DVN and OApps repoint configs.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 499
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps and default configs point at
  it.
evidence_level: source
checks:
- id: c1
  source: '0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d'
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
  source: '0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile (secp256k1).
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is callable only by the DVN itself.
  for:
  - evidence-3
  - justification
- id: vs-len
  source: '0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signatures must number exactly quorum 65-byte ECDSA signatures.
  for:
  - what
- id: vs-signer
  source: '0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d'
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

This DVN attests cross-chain messages for LayerZero OApps after checking a quorum of ECDSA signatures from its signer set. A quantum attacker who recovers enough signer keys can pass this check and help verify fabricated messages that release OApp funds.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d#code) recovers each 65-byte signature with ECDSA and requires it to be a committee signer.
- [tryRecover](https://etherscan.io/address/0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d#code) calls ecrecover on secp256k1 signatures.
- [setSigner](https://etherscan.io/address/0x15fadad87913c3bb95f8f9f2e2b287e71ba7817d#code) is onlySelf, so the signer set rotates only to other ECDSA signer addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 93-112) requires _signatures.length == quorum*65 (line 94), prefixes the hash as an Ethereum signed message (line 98), then for each slice calls ECDSA.tryRecover (line 104, ecrecover at ECDSA.sol line 139), requires ascending signer order (line 107) and isSigner (line 108). In the DVN, execute uses this check before making target calls such as ReceiveUln302.verify; once all required DVNs of an OApp have verified, the packet can be committed to EndpointV2 and executed via lzReceive. setSigner (DVN.sol line 104) is onlySelf, so rotation only swaps ECDSA addresses. The DVN itself holds about nothing; the funds at stake sit in the OApps that require it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN contract itself holds no meaningful funds.
- Ruled out: Not upgradeable; no proxy admin read.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
