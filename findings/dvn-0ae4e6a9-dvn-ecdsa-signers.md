---
id: dvn-0ae4e6a9-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps requiring this DVN; operator fixes by deploying
  a post-quantum DVN
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and move OApp configs to it
evidence_level: source
checks:
- id: c1
  source: '0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: each signature slice is recovered with ECDSA.tryRecover
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile
  for:
  - action
  - justification
  - what
- id: c4
  source: '0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is callable only by the DVN itself
  for:
  - evidence-3
- id: q1
  source: '0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: signatures must be exactly quorum 65-byte signatures
  for:
  - evidence-1
  - what
- id: s1
  source: '0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: recovered signer must be in the committee
  for:
  - evidence-2
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

This DVN accepts a call only with a quorum of signatures, each recovered with ECDSA and checked against its signer set. A quantum attacker who derives the signer keys can sign a quorum for a fabricated packet and help verify it for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d#code) requires exactly quorum × 65 bytes of signatures.
- [verifySignatures](https://etherscan.io/address/0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d#code) recovers each signer with ECDSA and requires it to be in the committee.
- [setSigner](https://etherscan.io/address/0x0ae4e6a9a8b01ee22c6a49af22b674a4e033a23d#code) is onlySelf: signers rotate to other ECDSA addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 81-99) requires _signatures.length == quorum*65 (line 82), wraps the hash as an Ethereum signed message (line 86), and for each 65-byte slice calls ECDSA.tryRecover (line 91), which uses ecrecover (ECDSA.sol line 139). The recovered signer must be ascending (line 94) and in signers (line 95). DVN.execute uses this check before calling targets such as ReceiveUln302.verify; once every required DVN of an OApp has verified, the payload can be committed to EndpointV2 and executed via lzReceive. setSigner (DVN.sol line 99) is onlySelf and only adds or removes ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN holds about $0 itself; funds at stake sit in the OApps that require it.
- Ruled out: Not upgradeable; no admin read.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
