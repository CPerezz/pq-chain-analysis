---
id: keystoneforwarder-a68a99c6-ocr-don-ecdsa-signers
format: 2
title: Chainlink KeystoneForwarder accepts ECDSA DON reports a quantum attacker forges
status: confirmed
severity: MEDIUM
justification: A forged signer quorum pushes reports to receivers; the owner can fix it by deploying a post-quantum
  forwarder.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96'
  name: KeystoneForwarder
  project: chainlink
  code: verified
  code_url: https://etherscan.io/address/0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96#code
  copies: 1
  upgradeable: 'no'
  admin: '0xf99aa0a78d1eeb619f0e548465f6d67debcecc98'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a forwarder that verifies a post-quantum DON attestation and have receivers trust it.
evidence_level: source
checks:
- id: c1
  source: '0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  line: 288
  has: address signer = ecrecover(
  says: report recovers each signer with ecrecover.
  for:
  - evidence-1
  - justification
  - what
- id: chk-count
  source: '0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  has: if (f + 1 != signatures.length) revert InvalidSignatureCount(f + 1, signatures.length);
  line: 280
  says: report requires exactly f+1 signatures.
  for:
  - evidence-2
  - what
- id: chk-positions
  source: '0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  has: if (index == 0) revert InvalidSigner(signer);
  line: 297
  says: Recovered signer must be a configured DON signer.
  for:
  - evidence-2
  - what
- id: chk-route-call
  source: '0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  has: abi.encodeCall(IReceiver.onReport, (metadata, validatedReport))
  line: 153
  says: route builds an onReport call to the receiver.
  for:
  - evidence-3
  - what
- id: chk-onlyowner-setconfig
  source: '0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  has: function setConfig(uint32 donId, uint32 configVersion, uint8 f, address[] calldata signers) external onlyOwner
    {
  line: 224
  says: Only the owner sets the ECDSA signer config.
  for:
  - action
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This forwarder delivers workflow reports to receiver contracts once f+1 configured DON signers' ECDSA signatures recover. A quantum attacker who derives a quorum of signer keys can push forged reports to any receiver through it.

## Evidence

- [report](https://etherscan.io/address/0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96#code) recovers each signature with ecrecover over the report hash.
- [report](https://etherscan.io/address/0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96#code) requires exactly f+1 signatures from distinct configured signers.
- [route](https://etherscan.io/address/0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96#code) then calls the receiver's onReport with the report data.

## Reviewer notes

### Mechanism

report (KeystoneForwarder.sol lines 260-312) reads configId from the raw report metadata, requires f != 0 and signatures.length == f+1 (line 280), hashes keccak256(keccak256(rawReport), reportContext), and for each 65-byte signature runs ecrecover (line 288), requiring the signer to have a nonzero position in the config and to be unique (lines 296-298). It then calls this.route, which checks ERC165 support and calls receiver.onReport(metadata, report) (lines 153-159). setConfig (onlyOwner, line 224) only rotates secp256k1 signer addresses; the verification scheme is fixed in the code.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable; signer rotation keeps ECDSA.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
