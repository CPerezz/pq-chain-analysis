---
id: keystoneforwarder-0b93082d-ocr-don-ecdsa-signers
format: 2
title: CRE forwarder trusts ECDSA quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Quorum keys are ECDSA, forgeable by a quantum attacker; the owner must move CRE to a new post-quantum
  forwarder.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0b93082d9b3c7c97facd250082899bacf3af3885'
  name: KeystoneForwarder
  project: chainlink
  code: verified
  code_url: https://etherscan.io/address/0x0b93082d9b3c7c97facd250082899bacf3af3885#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4044a864754760c37200e3a76d1953512ee18da8'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 44503
impact: funds-loss
action: Deploy a forwarder that verifies post-quantum DON attestations and move CRE receivers to it.
evidence_level: source
checks:
- id: c1
  source: '0x0b93082d9b3c7c97facd250082899bacf3af3885'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  line: 288
  has: address signer = ecrecover(
  says: report recovers each signer with ecrecover.
  for:
  - evidence-1
  - justification
  - what
- id: sig-count
  source: '0x0b93082d9b3c7c97facd250082899bacf3af3885'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  has: if (f + 1 != signatures.length) revert InvalidSignatureCount(f + 1, signatures.length);
  line: 280
  says: Report needs exactly f+1 signatures.
  for:
  - evidence-2
- id: sig-check
  source: '0x0b93082d9b3c7c97facd250082899bacf3af3885'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  has: if (index == 0) revert InvalidSigner(signer);
  line: 297
  says: Recovered signer must be in the configured DON set.
  for:
  - evidence-2
  - justification
  - what
- id: route-call
  source: '0x0b93082d9b3c7c97facd250082899bacf3af3885'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  has: bytes memory payload = abi.encodeCall(IReceiver.onReport, (metadata, validatedReport));
  line: 153
  says: Forwarder calls receiver onReport with the report.
  for:
  - evidence-3
  - what
- id: owner-config
  source: '0x0b93082d9b3c7c97facd250082899bacf3af3885'
  file: src/v0.8/keystone/KeystoneForwarder.sol
  has: function setConfig(uint32 donId, uint32 configVersion, uint8 f, address[] calldata signers) external onlyOwner
    {
  line: 224
  says: Only the owner sets the DON signer configuration.
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
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

KeystoneForwarder delivers CRE workflow reports to receiver contracts once f+1 distinct configured DON signers' ECDSA signatures recover. A quantum attacker who derives a quorum of signer keys can push forged reports to receivers.

## Evidence

- [report](https://etherscan.io/address/0x0b93082d9b3c7c97facd250082899bacf3af3885#code) recovers each signer with ecrecover over the report hash.
- [report](https://etherscan.io/address/0x0b93082d9b3c7c97facd250082899bacf3af3885#code) requires exactly f+1 signatures from configured signers.
- [route](https://etherscan.io/address/0x0b93082d9b3c7c97facd250082899bacf3af3885#code) calls the receiver's onReport with the report body.

## Reviewer notes

### Mechanism

report (lines 260-312 of src/v0.8/keystone/KeystoneForwarder.sol) reads the configId from rawReport metadata, requires f != 0 and signatures.length == f+1 (line 280), hashes keccak256(rawReport) with reportContext, and for each 65-byte signature calls ecrecover (line 288); the recovered address must hold a position in the owner-set config (line 297) and be unique. It then calls this.route (line 303), which calls receiver.onReport with metadata and report body (lines 153-159). setConfig (onlyOwner, line 224) can rotate signers but the ECDSA check is fixed code; the contract is not upgradeable.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself; losses depend on what receivers do with forged reports.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
