---
id: commitstore-e4167750-ocr-don-ecdsa-signers
format: 2
title: Chainlink CCIP CommitStore accepts commit reports a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Merkle roots are accepted on f+1 ECDSA signer signatures; Chainlink must deploy a post-quantum replacement.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe41677500b425999cb4133950ca3ab79ea7470a6'
  name: CommitStore
  project: chainlink
  code: verified
  code_url: https://etherscan.io/address/0xe41677500b425999cb4133950ca3ab79ea7470a6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x44835bbba9d40deda9b64858095ecfb2693c9449'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1620
impact: funds-loss
action: Deploy a CommitStore replacement that verifies a post-quantum attestation and repoint the Router's off-ramps.
evidence_level: source
checks:
- id: c1
  source: '0xe41677500b425999cb4133950ca3ab79ea7470a6'
  file: src/v0.8/ccip/ocr/OCR2Base.sol
  line: 256
  has: address signer = ecrecover(h, uint8(rawVs[i]) + 27, rs[i], ss[i]);
  says: Each report signature is recovered with ecrecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: f1
  source: '0xe41677500b425999cb4133950ca3ab79ea7470a6'
  file: src/v0.8/ccip/ocr/OCR2Base.sol
  has: expectedNumSignatures = configInfo.f + 1;
  line: 228
  says: f+1 signatures are required.
  for:
  - evidence-2
  - justification
  - what
- id: s-signer
  source: '0xe41677500b425999cb4133950ca3ab79ea7470a6'
  file: src/v0.8/ccip/ocr/OCR2Base.sol
  has: if (oracle.role != Role.Signer) revert UnauthorizedSigner();
  line: 260
  says: Recovered signers must hold the Signer role.
  for:
  - evidence-2
  - what
- id: s-root
  source: '0xe41677500b425999cb4133950ca3ab79ea7470a6'
  file: src/v0.8/ccip/CommitStore.sol
  has: s_roots[report.merkleRoot] = block.timestamp;
  line: 231
  says: Accepted reports store a Merkle root.
  for:
  - evidence-3
  - what
- id: s-price
  source: '0xe41677500b425999cb4133950ca3ab79ea7470a6'
  file: src/v0.8/ccip/CommitStore.sol
  has: IPriceRegistry(s_dynamicConfig.priceRegistry).updatePrices(report.priceUpdates);
  line: 207
  says: Accepted reports update prices.
  for:
  - what
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

This CommitStore records cross-chain message Merkle roots and price updates from commit reports. It accepts a report once f+1 distinct configured signers' ECDSA signatures recover, so a quantum attacker who derives those keys can commit forged roots.

## Evidence

- [transmit](https://etherscan.io/address/0xe41677500b425999cb4133950ca3ab79ea7470a6#code) uses ecrecover to recover each signer of the report.
- [transmit](https://etherscan.io/address/0xe41677500b425999cb4133950ca3ab79ea7470a6#code) requires f+1 signatures from addresses holding the Signer role.
- [_report](https://etherscan.io/address/0xe41677500b425999cb4133950ca3ab79ea7470a6#code) stores the report's Merkle root with a timestamp.

## Reviewer notes

### Mechanism

OCR2Base.transmit (line 192) calls _report, then checks the config digest, an authorized transmitter, and exactly f+1 signatures (constructor sets uniqueReports=false; line 228). Each signature is recovered with ecrecover (line 256) and must map to a distinct Signer role (lines 259-262). CommitStore._report (line 195) checks the RMN curse and sequence interval, then stores s_roots[merkleRoot] = block.timestamp (line 231) and may push price updates to the price registry (line 207). verify (line 171) returns the root timestamp if the root is blessed; the EVM2EVMOffRamp 1.5.0 executes messages against these roots. setOCR2Config only rotates signer addresses; the scheme stays ECDSA.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The transmitter check is not a barrier on its own; kev's trigger is committee-key recovery.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
