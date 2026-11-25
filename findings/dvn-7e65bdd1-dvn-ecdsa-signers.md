---
id: dvn-7e65bdd1-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums a quantum attacker could forge
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
  address: '0x7e65bdd15c8db8995f80abf0d6593b57dc8be437'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x7e65bdd15c8db8995f80abf0d6593b57dc8be437#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 100
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x7e65bdd15c8db8995f80abf0d6593b57dc8be437'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is recovered with ECDSA.tryRecover in verifySignatures.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x7e65bdd15c8db8995f80abf0d6593b57dc8be437'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A recovery error rejects the signature set.
  for:
  - what
- id: c3
  source: '0x7e65bdd15c8db8995f80abf0d6593b57dc8be437'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x7e65bdd15c8db8995f80abf0d6593b57dc8be437'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signer changes are onlySelf and take an address.
  for:
  - action
  - evidence-3
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

This LayerZero DVN performs a call only when a quorum of signatures recovers, via ECDSA, to addresses in its signer set. A quantum attacker who derives a quorum of signer keys can sign a fabricated verification of a cross-chain message for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x7e65bdd15c8db8995f80abf0d6593b57dc8be437#code) recovers each 65-byte signature with ECDSA.tryRecover.
- [tryRecover](https://etherscan.io/address/0x7e65bdd15c8db8995f80abf0d6593b57dc8be437#code) obtains the signer from the ecrecover precompile.
- [setSigner](https://etherscan.io/address/0x7e65bdd15c8db8995f80abf0d6593b57dc8be437#code) is onlySelf and sets signer addresses, which are ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 81-99) requires signatures.length == quorum*65, hashes with the EIP-191 prefix, then for each slice calls ECDSA.tryRecover (line 91), which calls ecrecover (ECDSA.sol line 139). It rejects recovery errors (line 93), requires ascending signers and membership in signers (lines 94-95). Per kev, DVN.execute calls this check before forwarding calls such as ReceiveUln302.verify, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 99) is onlySelf and only rotates to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable
- Ruled out: Contract holds no funds itself

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
