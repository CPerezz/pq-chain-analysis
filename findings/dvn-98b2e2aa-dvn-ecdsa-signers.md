---
id: dvn-98b2e2aa-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged quorum verifies fake messages for OApps relying on this DVN; operators fix by deploying post-quantum
  DVNs.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is checked with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signers are changed only by the contract itself via setSigner.
  for:
  - evidence-3
- id: v93
  source: '0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200'
  file: contracts/uln/dvn/MultiSig.sol
  has: function verifySignatures(bytes32 _hash, bytes calldata _signatures) public view returns (bool, Errors) {
  line: 93
  says: The DVN verifies a quorum of signatures over a hash.
  for:
  - what
- id: v108
  source: '0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Recovered address must be in the signer set.
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

This DVN verifies cross-chain messages for LayerZero OApps once a quorum of its signers has signed. Each signature is checked with ECDSA recovery against the signer set, so a quantum attacker who derives signer keys can forge a quorum and verify fake messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200#code) recovers each 65-byte signature with ECDSA.tryRecover.
- [tryRecover](https://etherscan.io/address/0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200#code) relies on the ecrecover precompile (secp256k1).
- [setSigner](https://etherscan.io/address/0x98b2e2aa4694680ed610d4f0a9bb78e8f7f1f200#code) rotates signers to other addresses checked by the same ECDSA logic.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 93-112) requires signatures.length == quorum*65, then for each slice calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139); the recovered address must be ascending and in signerSet (line 108). Per kev's finding, DVN.execute uses this check before calling ReceiveUln302.verify, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 104) is onlySelf and only swaps in other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds about $0 itself; funds at stake sit in the OApps that require this DVN.
- Ruled out: Not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
