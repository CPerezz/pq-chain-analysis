---
id: dvn-53af943a-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps requiring this DVN; operator must deploy a
  post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x53af943a880b93eb53c8e39def519ae4dcaab0ef'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x53af943a880b93eb53c8e39def519ae4dcaab0ef#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 8
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApp configs point at it.
evidence_level: source
checks:
- id: c1
  source: '0x53af943a880b93eb53c8e39def519ae4dcaab0ef'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is checked with ECDSA.tryRecover.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x53af943a880b93eb53c8e39def519ae4dcaab0ef'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses ecrecover (secp256k1).
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x53af943a880b93eb53c8e39def519ae4dcaab0ef'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf, rotating signer addresses.
  for:
  - evidence-3
- id: vs-len
  source: '0x53af943a880b93eb53c8e39def519ae4dcaab0ef'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signatures must be exactly quorum 65-byte slices.
  for:
  - evidence-1
  - what
- id: c8
  source: '0x53af943a880b93eb53c8e39def519ae4dcaab0ef'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Recovered address must be in the signer set.
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
reviews: []
related: []
---

## What happens

This DVN verifies LayerZero messages and accepts a call only when a quorum of signatures recovers, via ECDSA, to addresses in its signer set. A quantum attacker who derives the signer keys can sign a quorum and verify fabricated packets for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x53af943a880b93eb53c8e39def519ae4dcaab0ef#code) requires exactly quorum × 65 bytes of signatures.
- [verifySignatures](https://etherscan.io/address/0x53af943a880b93eb53c8e39def519ae4dcaab0ef#code) recovers each signer with ECDSA and accepts it if it is in the committee.
- [setSigner](https://etherscan.io/address/0x53af943a880b93eb53c8e39def519ae4dcaab0ef#code) is self-called and rotates signers to other ECDSA addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 93-112) requires _signatures.length == quorum*65, wraps the hash with the Ethereum signed-message prefix, then for each 65-byte slice calls ECDSA.tryRecover (line 104, ecrecover at ECDSA.sol line 139), requires ascending signer order (line 107) and membership in signerSet (line 108). Per kev's finding, DVN.execute checks this before calling ReceiveUln302.verify, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone; once all required DVNs of an OApp verify a packet it can be committed and executed by lzReceive. setSigner (DVN.sol line 104) is onlySelf and only rotates to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself; funds sit in the OApps that require it.
- Ruled out: Not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
