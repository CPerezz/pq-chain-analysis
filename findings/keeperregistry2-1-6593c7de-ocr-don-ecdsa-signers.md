---
id: keeperregistry2-1-6593c7de-ocr-don-ecdsa-signers
format: 2
title: Chainlink KeeperRegistry 2.1 accepts DON reports a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Forged quorum signatures spend upkeep balances; Chainlink can fix it with a post-quantum registry.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6593c7de001fc8542bb1703532ee1e5aa0d458fd'
  name: KeeperRegistry2_1
  project: chainlink
  code: verified
  code_url: https://etherscan.io/address/0x6593c7de001fc8542bb1703532ee1e5aa0d458fd#code
  copies: 1
  admin: '0xcc4b5b07316be81ed6edb44ca61e4cab28a1950d'
value:
  usd: 172653
  basis: held
activity:
  txs_90d: 37
impact: funds-loss
action: Deploy a registry that verifies post-quantum attestations and migrate upkeeps to it.
evidence_level: source
checks:
- id: c1
  source: '0x6593c7de001fc8542bb1703532ee1e5aa0d458fd'
  file: src/v0.8/automation/v2_1/KeeperRegistryBase2_1.sol
  line: 831
  has: signerAddress = ecrecover(h, uint8(rawVs[i]) + 27, rs[i], ss[i]);
  says: Report signatures are verified with secp256k1 ecrecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x6593c7de001fc8542bb1703532ee1e5aa0d458fd'
  file: src/v0.8/automation/v2_1/KeeperRegistryLogicB2_1.sol
  line: 233
  has: function pause() external onlyOwner {
  says: The owner can pause the registry.
  for:
  - justification
- id: sig-active
  source: '0x6593c7de001fc8542bb1703532ee1e5aa0d458fd'
  file: src/v0.8/automation/v2_1/KeeperRegistryBase2_1.sol
  has: if (!signer.active) revert OnlyActiveSigners();
  line: 833
  says: Recovered signer must be an active configured signer.
  for:
  - evidence-2
  - what
- id: sig-dup
  source: '0x6593c7de001fc8542bb1703532ee1e5aa0d458fd'
  file: src/v0.8/automation/v2_1/KeeperRegistryBase2_1.sol
  has: revert DuplicateSigners();
  line: 839
  says: Duplicate signers are rejected.
  for:
  - evidence-2
  - what
- id: perform
  source: '0x6593c7de001fc8542bb1703532ee1e5aa0d458fd'
  file: src/v0.8/automation/v2_1/KeeperRegistryBase2_1.sol
  has: return forwarder.forward(performGas, performData);
  line: 865
  says: Report performData is forwarded to the upkeep.
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

KeeperRegistry 2.1 runs upkeeps from DON reports and accepts a report when ecrecover maps each signature to an active, distinct signer. A quantum attacker who recovers enough signer keys forges reports and triggers upkeeps with chosen data.

## Evidence

- [_verifyReportSignature](https://etherscan.io/address/0x6593c7de001fc8542bb1703532ee1e5aa0d458fd#code) recovers each report signer with ecrecover.
- [_verifyReportSignature](https://etherscan.io/address/0x6593c7de001fc8542bb1703532ee1e5aa0d458fd#code) rejects signers that are not active and duplicate signers.
- [_performUpkeep](https://etherscan.io/address/0x6593c7de001fc8542bb1703532ee1e5aa0d458fd#code) forwards the report's performData to the upkeep target.

## Reviewer notes

### Mechanism

transmit (lines 67-185 per kev) calls _verifyReportSignature (KeeperRegistryBase2_1.sol line 817). Line 824 hashes the report with reportContext, line 831 ecrecovers each (r,s,v), line 833 requires s_signers[addr].active, and line 839 rejects duplicate signers. Kev reports that transmit requires an active transmitter and f+1 signatures. It then runs each upkeep through _performUpkeep (line 859), which forwards the report's performData, and pays msg.sender from upkeep balances at the report's gas price. Rotating signers through setConfig keeps ECDSA. Secp256k1 signer keys are visible from past signatures, so a quantum attacker can forge a quorum.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verification code is fixed; rotating signers does not remove ECDSA.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
