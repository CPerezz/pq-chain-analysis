---
id: receiverimplementationhalf-3a2dd09b-wormhole-receiver
format: 2
title: Pyth receiver trusts ECDSA guardian quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged guardian quorums pass as valid VAAs; Pyth governance can upgrade or repoint the receiver,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3a2dd09b4739d905183d503d594c8fb3e3d41820'
  name: ReceiverImplementationHalf
  project: pyth
  code: verified
  code_url: https://etherscan.io/address/0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8#code
  proxy_of: '0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8'
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 12996
impact: funds-loss
action: Upgrade or repoint Pyth's receiver through governance to one that verifies post-quantum guardian signatures.
evidence_level: source
checks:
- id: c1
  source: '0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8'
  file: contracts/wormhole-receiver/ReceiverMessages.sol
  line: 124
  has: (signatureValid, invalidReason) = verifySignature(
  says: parseAndVerifyVM checks each VAA signature with verifySignature.
  for:
  - what
- id: c3
  source: '0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8'
  file: contracts/wormhole-receiver/ReceiverMessages.sol
  line: 267
  has: if (ecrecover(hash, v, r, s) != guardianSetKey) {
  says: A signature is accepted only if ecrecover returns the guardian's key.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: q-half
  source: '0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8'
  file: contracts/wormhole-receiver/ReceiverImplementationHalf.sol
  has: return numGuardians / 2 + 1;
  line: 16
  says: Quorum is half the guardians plus one.
  for:
  - evidence-3
  - what
- id: q-check
  source: '0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8'
  file: contracts/wormhole-receiver/ReceiverMessages.sol
  has: if (quorumThreshold(guardianSet.keys.length) > signersLen) {
  line: 148
  says: A VAA is rejected unless it carries the quorum of signatures.
  for:
  - evidence-2
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x74f09cb3
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (PythLazer source, bytecode selectors, on-chain reads, Blockscout internal calls)
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

This receiver verifies Wormhole-style VAAs for Pyth by checking ECDSA guardian signatures against its guardian set. A VAA passes once a majority of guardian keys sign, so a quantum attacker who recovers that many keys forges accepted messages.

## Evidence

- [verifySignature](https://etherscan.io/address/0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8#code) rejects a signature unless ecrecover returns the guardian key at that index.
- [parseAndVerifyVM](https://etherscan.io/address/0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8#code) returns "no quorum" when fewer signatures than the threshold are given.
- [quorumThreshold](https://etherscan.io/address/0x8d289cdd60e7f73f352f42c8524a06ef1ad746f8#code) is overridden to half the guardians plus one.

## Reviewer notes

### Mechanism

parseAndVerifyVM (ReceiverMessages.sol 32-192) loads the guardian set for the VAA's index, hashes the body, and for each signature calls verifySignature (line 124). verifySignature (252-271) compares ecrecover(hash, v, r, s) with guardianSet.keys[guardianIndex] (line 267). Line 148 requires quorumThreshold(keys.length) signatures. ReceiverImplementationHalf overrides quorumThreshold to numGuardians / 2 + 1 (line 16). Recovering that many guardian private keys from their public keys lets an attacker build VAAs this receiver reports as valid. Pyth then accepts them as price updates or as governance instructions.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Quorum is a 1/2 + 1 majority in this implementation, not the default 2/3 + 1.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
