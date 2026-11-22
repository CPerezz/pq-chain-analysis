---
id: dvn-06559ee3-dvn-ecdsa-signers
format: 2
title: LayerZero P2P DVN accepts ECDSA signer quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorums let fake messages verify; operator must deploy a post-quantum DVN, configs
  repoint.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x06559ee34d85a88317bf0bfe307444116c631b67'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x06559ee34d85a88317bf0bfe307444116c631b67#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 20761
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApp configs point at it.
evidence_level: source
checks:
- id: c1
  source: '0x06559ee34d85a88317bf0bfe307444116c631b67'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: each signature is recovered with ECDSA.tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x06559ee34d85a88317bf0bfe307444116c631b67'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x06559ee34d85a88317bf0bfe307444116c631b67'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: signer changes are onlySelf and take an address
  for:
  - action
  - evidence-3
- id: sig-loop
  source: '0x06559ee34d85a88317bf0bfe307444116c631b67'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: exactly quorum 65-byte signatures are required
  for:
  - what
- id: committee
  source: '0x06559ee34d85a88317bf0bfe307444116c631b67'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: recovered signer must be in the committee
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

This DVN acts on a call only when a quorum of secp256k1 signatures recovers to addresses in its signer set. A quantum attacker who derives the signer keys can sign a quorum and have this DVN verify fabricated cross-chain messages for OApps that require it.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x06559ee34d85a88317bf0bfe307444116c631b67#code) recovers each 65-byte signature with ECDSA and requires the signer to be in the committee.
- [tryRecover](https://etherscan.io/address/0x06559ee34d85a88317bf0bfe307444116c631b67#code) calls ecrecover, the secp256k1 public-key recovery precompile.
- [setSigner](https://etherscan.io/address/0x06559ee34d85a88317bf0bfe307444116c631b67#code) is onlySelf and changes ECDSA signer addresses, not the signature scheme.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 81-99) requires _signatures.length == quorum*65 (line 82), wraps the hash as an Ethereum signed message (line 86), then for each slice calls ECDSA.tryRecover (line 91), which calls ecrecover (ECDSA.sol line 139). It rejects errors (93), non-ascending signers (94) and non-committee signers (95). DVN execute uses this check before making the target call, in practice ReceiveUln302.verify; once all required DVNs of an OApp verify, the payload can be committed to EndpointV2 and executed by lzReceive. setSigner (DVN.sol line 99) is onlySelf and rotates only to other ECDSA addresses. Per kev, this DVN has quorum 1 of 1, so one recovered key suffices for its share.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; the funds sit in the OApps that require it.
- Ruled out: Not upgradeable: no proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
